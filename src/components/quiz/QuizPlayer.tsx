'use client'

import { useState, useEffect, useRef, useCallback, useMemo } from 'react'
import { createClient } from '@/lib/supabase/client'
import type { QuizWithQuestions, QuizQuestion, QuizAnswer } from '@/types'
import QuestionMCQ from './QuestionMCQ'
import QuestionTrueFalse from './QuestionTrueFalse'
import QuestionMultiSelect from './QuestionMultiSelect'

// Fisher-Yates shuffle - called once outside render
function shuffleArray<T>(array: T[]): T[] {
  const shuffled = [...array]
  for (let i = shuffled.length - 1; i > 0; i--) {
    const j = Math.floor(Math.random() * (i + 1));
    [shuffled[i], shuffled[j]] = [shuffled[j], shuffled[i]]
  }
  return shuffled
}

interface QuizPlayerProps {
  quiz: QuizWithQuestions
  userId: string
  attemptId?: string
  onComplete?: (score: number, passed: boolean) => void
}

type AnswerMap = Record<string, string | string[]>

export default function QuizPlayer({
  quiz,
  userId,
  attemptId: existingAttemptId,
  onComplete
}: QuizPlayerProps) {
  const [currentIndex, setCurrentIndex] = useState(0)
  const [answers, setAnswers] = useState<AnswerMap>({})
  const [showResults, setShowResults] = useState(false)
  const [score, setScore] = useState(0)
  const [maxScore, setMaxScore] = useState(0)
  const [passed, setPassed] = useState(false)
  const [loading, setLoading] = useState(false)
  const [attemptId, setAttemptId] = useState<string | null>(existingAttemptId || null)
  const [timeRemaining, setTimeRemaining] = useState<number | null>(
    quiz.time_limit ? quiz.time_limit * 60 : null
  )
  const startTimeRef = useRef<number>(0)
  const supabase = createClient()

  // Memoize questions to avoid re-shuffling on every render
  const questions = useMemo(() => {
    const sorted = [...quiz.questions].sort((a, b) => a.order_index - b.order_index)
    return quiz.shuffle_questions ? shuffleArray(sorted) : sorted
  // eslint-disable-next-line react-hooks/exhaustive-deps
  }, [quiz.id]) // Only recompute when quiz changes

  const currentQuestion = questions[currentIndex]

  // Initialize attempt
  useEffect(() => {
    const initAttempt = async () => {
      if (!existingAttemptId) {
        const { data, error } = await supabase
          .from('quiz_attempts')
          .insert({
            user_id: userId,
            quiz_id: quiz.id,
            started_at: new Date().toISOString()
          })
          .select('id')
          .single()

        if (!error && data) {
          setAttemptId(data.id)
        }
      }
      startTimeRef.current = Date.now()
    }

    initAttempt()
  }, [existingAttemptId, quiz.id, supabase, userId])

  // Ref to track if auto-submit happened
  const autoSubmittedRef = useRef(false)

  // Timer
  useEffect(() => {
    if (!quiz.time_limit || showResults) return

    const interval = setInterval(() => {
      setTimeRemaining((prev) => {
        if (prev === null) return null
        if (prev <= 1) {
          // Set flag and clear interval - submit will happen via separate effect
          autoSubmittedRef.current = true
          return 0
        }
        return prev - 1
      })
    }, 1000)

    return () => clearInterval(interval)
  }, [quiz.time_limit, showResults])

  // Auto-submit when time runs out
  useEffect(() => {
    if (timeRemaining === 0 && autoSubmittedRef.current && !showResults) {
      autoSubmittedRef.current = false
      handleSubmit()
    }
  // eslint-disable-next-line react-hooks/exhaustive-deps
  }, [timeRemaining, showResults])

  const handleAnswer = (questionId: string, answer: string | string[]) => {
    setAnswers((prev) => ({
      ...prev,
      [questionId]: answer
    }))
  }

  const handleMultiSelectToggle = (questionId: string, optionId: string) => {
    setAnswers((prev) => {
      const current = (prev[questionId] as string[]) || []
      const newAnswers = current.includes(optionId)
        ? current.filter((id) => id !== optionId)
        : [...current, optionId]
      return { ...prev, [questionId]: newAnswers }
    })
  }

  const calculateScore = useCallback(() => {
    let totalScore = 0
    let totalMax = 0

    const answerDetails: QuizAnswer[] = questions.map((q) => {
      const userAnswer = answers[q.id]
      let isCorrect = false
      let pointsEarned = 0

      totalMax += q.points

      if (q.question_type === 'mcq' || q.question_type === 'true_false') {
        if (q.question_type === 'mcq') {
          const correctOption = (q.options || []).find((o) => o.is_correct)
          isCorrect = userAnswer === correctOption?.id
        } else {
          isCorrect = userAnswer === q.correct_answer?.toLowerCase()
        }
        if (isCorrect) {
          pointsEarned = q.points
          totalScore += q.points
        }
      } else if (q.question_type === 'multiple_select') {
        const correctIds = (q.options || [])
          .filter((o) => o.is_correct)
          .map((o) => o.id)
        const userIds = (userAnswer as string[]) || []

        // Partial credit: correct selections minus incorrect selections
        const correctSelected = userIds.filter((id) => correctIds.includes(id)).length
        const incorrectSelected = userIds.filter((id) => !correctIds.includes(id)).length

        const partialScore = Math.max(
          0,
          ((correctSelected - incorrectSelected) / correctIds.length) * q.points
        )
        pointsEarned = Math.round(partialScore * 100) / 100
        totalScore += pointsEarned

        isCorrect = correctSelected === correctIds.length && incorrectSelected === 0
      }

      return {
        question_id: q.id,
        answer: userAnswer || '',
        is_correct: isCorrect,
        points_earned: pointsEarned
      }
    })

    return { totalScore, totalMax, answerDetails }
  }, [answers, questions])

  const handleSubmit = async () => {
    setLoading(true)

    const { totalScore, totalMax, answerDetails } = calculateScore()
    const percentage = totalMax > 0 ? (totalScore / totalMax) * 100 : 0
    const hasPassed = percentage >= quiz.passing_score
    const timeTaken = Math.floor((Date.now() - startTimeRef.current) / 1000)

    setScore(totalScore)
    setMaxScore(totalMax)
    setPassed(hasPassed)
    setShowResults(true)

    // Save to database
    if (attemptId) {
      await supabase
        .from('quiz_attempts')
        .update({
          score: percentage,
          max_score: totalMax,
          passed: hasPassed,
          answers: answerDetails,
          completed_at: new Date().toISOString(),
          time_taken: timeTaken
        })
        .eq('id', attemptId)
    }

    onComplete?.(percentage, hasPassed)
    setLoading(false)
  }

  const formatTime = (seconds: number) => {
    const mins = Math.floor(seconds / 60)
    const secs = seconds % 60
    return `${mins}:${secs.toString().padStart(2, '0')}`
  }

  const renderQuestion = (question: QuizQuestion) => {
    const answer = answers[question.id]

    switch (question.question_type) {
      case 'mcq':
        return (
          <QuestionMCQ
            question={question}
            selectedAnswer={answer as string}
            onSelect={(a) => handleAnswer(question.id, a)}
            showResult={showResults}
            disabled={showResults}
          />
        )
      case 'true_false':
        return (
          <QuestionTrueFalse
            question={question}
            selectedAnswer={answer as string}
            onSelect={(a) => handleAnswer(question.id, a)}
            showResult={showResults}
            disabled={showResults}
          />
        )
      case 'multiple_select':
        return (
          <QuestionMultiSelect
            question={question}
            selectedAnswers={(answer as string[]) || []}
            onToggle={(optionId) => handleMultiSelectToggle(question.id, optionId)}
            showResult={showResults}
            disabled={showResults}
          />
        )
      default:
        return null
    }
  }

  // Results view
  if (showResults) {
    const percentage = maxScore > 0 ? (score / maxScore) * 100 : 0

    return (
      <div className="max-w-2xl mx-auto">
        {/* Results header */}
        <div className={`text-center p-8 rounded-xl mb-8 ${
          passed
            ? 'bg-green-50 dark:bg-green-900/20 border border-green-200 dark:border-green-800'
            : 'bg-red-50 dark:bg-red-900/20 border border-red-200 dark:border-red-800'
        }`}>
          <span className="text-6xl block mb-4">
            {passed ? '🎉' : '😔'}
          </span>
          <h2 className={`text-2xl font-bold mb-2 ${
            passed ? 'text-green-700 dark:text-green-400' : 'text-red-700 dark:text-red-400'
          }`}>
            {passed ? '¡Felicidades!' : 'Sigue practicando'}
          </h2>
          <p className="text-gray-600 dark:text-gray-400 mb-4">
            {passed
              ? 'Has aprobado el quiz'
              : `Necesitas ${quiz.passing_score}% para aprobar`}
          </p>
          <div className="text-4xl font-bold text-gray-900 dark:text-white">
            {Math.round(percentage)}%
          </div>
          <p className="text-gray-500 dark:text-gray-400">
            {score} de {maxScore} puntos
          </p>
        </div>

        {/* Review answers */}
        {quiz.show_correct_answers && (
          <div className="space-y-6">
            <h3 className="text-lg font-semibold text-gray-900 dark:text-white">
              Revision de respuestas
            </h3>
            {questions.map((q, index) => (
              <div key={q.id} className="bg-white dark:bg-gray-800 rounded-xl p-6 shadow-sm">
                <div className="flex items-start gap-3 mb-4">
                  <span className="w-8 h-8 rounded-full bg-gray-100 dark:bg-gray-700 flex items-center justify-center text-sm font-medium text-gray-600 dark:text-gray-400">
                    {index + 1}
                  </span>
                  <div className="flex-1">
                    <p className="text-gray-900 dark:text-white font-medium">
                      {q.question}
                    </p>
                    <span className="text-sm text-gray-500">
                      {q.points} punto{q.points !== 1 ? 's' : ''}
                    </span>
                  </div>
                </div>
                {renderQuestion(q)}
                {q.explanation && (
                  <div className="mt-4 p-4 bg-blue-50 dark:bg-blue-900/20 rounded-lg">
                    <p className="text-sm text-blue-800 dark:text-blue-300">
                      <strong>Explicacion:</strong> {q.explanation}
                    </p>
                  </div>
                )}
              </div>
            ))}
          </div>
        )}
      </div>
    )
  }

  // Quiz in progress
  return (
    <div className="max-w-2xl mx-auto">
      {/* Header */}
      <div className="flex items-center justify-between mb-6">
        <div>
          <h2 className="text-xl font-semibold text-gray-900 dark:text-white">
            {quiz.title}
          </h2>
          <p className="text-gray-500 dark:text-gray-400">
            Pregunta {currentIndex + 1} de {questions.length}
          </p>
        </div>
        {timeRemaining !== null && (
          <div className={`text-lg font-mono px-4 py-2 rounded-lg ${
            timeRemaining < 60
              ? 'bg-red-100 dark:bg-red-900/30 text-red-700 dark:text-red-400'
              : 'bg-gray-100 dark:bg-gray-800 text-gray-700 dark:text-gray-300'
          }`}>
            {formatTime(timeRemaining)}
          </div>
        )}
      </div>

      {/* Progress bar */}
      <div className="h-2 bg-gray-200 dark:bg-gray-700 rounded-full mb-8">
        <div
          className="h-full bg-blue-500 rounded-full transition-all"
          style={{ width: `${((currentIndex + 1) / questions.length) * 100}%` }}
        />
      </div>

      {/* Question */}
      <div className="bg-white dark:bg-gray-800 rounded-xl p-6 shadow-sm mb-6">
        <div className="flex items-start gap-3 mb-6">
          <span className="w-10 h-10 rounded-full bg-blue-100 dark:bg-blue-900/30 flex items-center justify-center text-blue-600 dark:text-blue-400 font-bold">
            {currentIndex + 1}
          </span>
          <div className="flex-1">
            <p className="text-lg text-gray-900 dark:text-white font-medium">
              {currentQuestion.question}
            </p>
            <span className="text-sm text-gray-500 dark:text-gray-400">
              {currentQuestion.points} punto{currentQuestion.points !== 1 ? 's' : ''}
            </span>
          </div>
        </div>

        {renderQuestion(currentQuestion)}
      </div>

      {/* Navigation */}
      <div className="flex items-center justify-between">
        <button
          onClick={() => setCurrentIndex((i) => Math.max(0, i - 1))}
          disabled={currentIndex === 0}
          className="px-4 py-2 text-gray-600 dark:text-gray-400 hover:text-gray-900 dark:hover:text-white disabled:opacity-50 disabled:cursor-not-allowed"
        >
          &larr; Anterior
        </button>

        <div className="flex gap-2">
          {questions.map((_, i) => (
            <button
              key={i}
              onClick={() => setCurrentIndex(i)}
              className={`w-8 h-8 rounded-full text-sm font-medium transition-colors ${
                i === currentIndex
                  ? 'bg-blue-500 text-white'
                  : answers[questions[i].id]
                    ? 'bg-green-100 dark:bg-green-900/30 text-green-700 dark:text-green-400'
                    : 'bg-gray-100 dark:bg-gray-700 text-gray-600 dark:text-gray-400'
              }`}
            >
              {i + 1}
            </button>
          ))}
        </div>

        {currentIndex === questions.length - 1 ? (
          <button
            onClick={handleSubmit}
            disabled={loading}
            className="px-6 py-2 bg-green-600 text-white rounded-lg font-medium hover:bg-green-700 disabled:opacity-50"
          >
            {loading ? 'Enviando...' : 'Enviar respuestas'}
          </button>
        ) : (
          <button
            onClick={() => setCurrentIndex((i) => Math.min(questions.length - 1, i + 1))}
            className="px-4 py-2 text-blue-600 dark:text-blue-400 hover:text-blue-700 dark:hover:text-blue-300"
          >
            Siguiente &rarr;
          </button>
        )}
      </div>

      {/* Answered count */}
      <p className="text-center text-sm text-gray-500 dark:text-gray-400 mt-6">
        {Object.keys(answers).length} de {questions.length} preguntas respondidas
      </p>
    </div>
  )
}
