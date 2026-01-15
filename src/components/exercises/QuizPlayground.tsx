'use client'

import { useState, useMemo } from 'react'
import type { QuizExercise, QuizExerciseQuestion, ExerciseProgress } from '@/types/exercises'
import { ExerciseShell } from './ExerciseShell'

interface QuizPlaygroundProps {
  exercise: QuizExercise
  progress?: ExerciseProgress
  onProgressUpdate?: (progress: Partial<ExerciseProgress>) => void
}

interface QuestionState {
  selectedOption: string | null
  isSubmitted: boolean
  isCorrect: boolean | null
}

// Componente para una pregunta individual
function QuestionCard({
  question,
  questionNumber,
  totalQuestions,
  state,
  onSelect,
  onSubmit,
  showFeedback
}: {
  question: QuizExerciseQuestion
  questionNumber: number
  totalQuestions: number
  state: QuestionState
  onSelect: (optionId: string) => void
  onSubmit: () => void
  showFeedback: boolean
}) {
  const correctOptionId = Array.isArray(question.correct) ? question.correct[0] : question.correct

  // Determinar color del nivel Bloom
  const bloomColors: Record<string, string> = {
    remember: 'bg-blue-100 text-blue-800 dark:bg-blue-900 dark:text-blue-200',
    understand: 'bg-green-100 text-green-800 dark:bg-green-900 dark:text-green-200',
    apply: 'bg-yellow-100 text-yellow-800 dark:bg-yellow-900 dark:text-yellow-200',
    analyze: 'bg-orange-100 text-orange-800 dark:bg-orange-900 dark:text-orange-200',
    evaluate: 'bg-red-100 text-red-800 dark:bg-red-900 dark:text-red-200',
    create: 'bg-purple-100 text-purple-800 dark:bg-purple-900 dark:text-purple-200',
  }

  const bloomLabels: Record<string, string> = {
    remember: 'Recordar',
    understand: 'Comprender',
    apply: 'Aplicar',
    analyze: 'Analizar',
    evaluate: 'Evaluar',
    create: 'Crear',
  }

  return (
    <div className="border border-gray-200 dark:border-gray-700 rounded-lg p-4 mb-4">
      {/* Header de pregunta */}
      <div className="flex items-center justify-between mb-3">
        <span className="text-sm font-medium text-gray-500 dark:text-gray-400">
          Pregunta {questionNumber} de {totalQuestions}
        </span>
        <div className="flex items-center gap-2">
          {question.bloom_level && (
            <span className={`px-2 py-0.5 text-xs font-medium rounded ${bloomColors[question.bloom_level] || 'bg-gray-100 text-gray-800'}`}>
              {bloomLabels[question.bloom_level] || question.bloom_level}
            </span>
          )}
          <span className="text-sm text-gray-500 dark:text-gray-400">
            {question.points} pts
          </span>
        </div>
      </div>

      {/* Texto de la pregunta */}
      <p className="text-gray-900 dark:text-white font-medium mb-4 whitespace-pre-line">
        {question.question}
      </p>

      {/* Opciones */}
      <div className="space-y-2">
        {question.options.map((option) => {
          const isSelected = state.selectedOption === option.id
          const isCorrectOption = option.id === correctOptionId
          const showResult = state.isSubmitted && showFeedback

          let optionClasses = 'w-full text-left p-3 rounded-lg border transition-all '

          if (showResult) {
            if (isCorrectOption) {
              optionClasses += 'border-green-500 bg-green-50 dark:bg-green-900/30 text-green-800 dark:text-green-200'
            } else if (isSelected && !isCorrectOption) {
              optionClasses += 'border-red-500 bg-red-50 dark:bg-red-900/30 text-red-800 dark:text-red-200'
            } else {
              optionClasses += 'border-gray-200 dark:border-gray-700 text-gray-600 dark:text-gray-400 opacity-50'
            }
          } else if (isSelected) {
            optionClasses += 'border-rizoma-green bg-rizoma-green/10 text-rizoma-green-dark dark:text-rizoma-green-light'
          } else {
            optionClasses += 'border-gray-200 dark:border-gray-700 hover:border-gray-300 dark:hover:border-gray-600 text-gray-700 dark:text-gray-300'
          }

          return (
            <button
              key={option.id}
              onClick={() => !state.isSubmitted && onSelect(option.id)}
              disabled={state.isSubmitted}
              className={optionClasses}
            >
              <div className="flex items-center gap-3">
                <span className={`flex-shrink-0 w-6 h-6 rounded-full border-2 flex items-center justify-center text-xs font-bold ${
                  isSelected
                    ? 'border-current bg-current text-white'
                    : 'border-gray-300 dark:border-gray-600'
                }`}>
                  {showResult && isCorrectOption ? (
                    <svg className="w-4 h-4 text-green-600" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                      <path strokeLinecap="round" strokeLinejoin="round" strokeWidth={3} d="M5 13l4 4L19 7" />
                    </svg>
                  ) : showResult && isSelected && !isCorrectOption ? (
                    <svg className="w-4 h-4 text-red-600" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                      <path strokeLinecap="round" strokeLinejoin="round" strokeWidth={3} d="M6 18L18 6M6 6l12 12" />
                    </svg>
                  ) : (
                    <span className={isSelected ? 'text-white' : 'text-gray-400'}>
                      {option.id.toUpperCase()}
                    </span>
                  )}
                </span>
                <span className="flex-1">{option.text}</span>
              </div>
            </button>
          )
        })}
      </div>

      {/* Botón de enviar */}
      {!state.isSubmitted && (
        <button
          onClick={onSubmit}
          disabled={!state.selectedOption}
          className={`mt-4 w-full py-2 px-4 rounded-lg font-medium transition-colors ${
            state.selectedOption
              ? 'bg-rizoma-green hover:bg-rizoma-green-dark text-white'
              : 'bg-gray-200 dark:bg-gray-700 text-gray-400 cursor-not-allowed'
          }`}
        >
          Verificar respuesta
        </button>
      )}

      {/* Feedback */}
      {state.isSubmitted && showFeedback && (
        <div className={`mt-4 p-3 rounded-lg ${
          state.isCorrect
            ? 'bg-green-50 dark:bg-green-900/20 border border-green-200 dark:border-green-800'
            : 'bg-red-50 dark:bg-red-900/20 border border-red-200 dark:border-red-800'
        }`}>
          <div className="flex items-start gap-2">
            {state.isCorrect ? (
              <svg className="w-5 h-5 text-green-600 dark:text-green-400 flex-shrink-0 mt-0.5" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                <path strokeLinecap="round" strokeLinejoin="round" strokeWidth={2} d="M9 12l2 2 4-4m6 2a9 9 0 11-18 0 9 9 0 0118 0z" />
              </svg>
            ) : (
              <svg className="w-5 h-5 text-red-600 dark:text-red-400 flex-shrink-0 mt-0.5" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                <path strokeLinecap="round" strokeLinejoin="round" strokeWidth={2} d="M10 14l2-2m0 0l2-2m-2 2l-2-2m2 2l2 2m7-2a9 9 0 11-18 0 9 9 0 0118 0z" />
              </svg>
            )}
            <div className="text-sm">
              <p className={`font-medium ${state.isCorrect ? 'text-green-800 dark:text-green-200' : 'text-red-800 dark:text-red-200'}`}>
                {state.isCorrect ? '¡Correcto!' : 'Incorrecto'}
              </p>
              <p className={`mt-1 whitespace-pre-line ${state.isCorrect ? 'text-green-700 dark:text-green-300' : 'text-red-700 dark:text-red-300'}`}>
                {state.isCorrect
                  ? (question.feedback_correct || 'Excelente respuesta.')
                  : (question.feedback_incorrect || question.explanation || 'Revisa el concepto e intenta de nuevo.')}
              </p>
            </div>
          </div>
        </div>
      )}
    </div>
  )
}

export function QuizPlayground({
  exercise,
  progress,
  onProgressUpdate
}: QuizPlaygroundProps) {
  // Estado de cada pregunta
  const [questionStates, setQuestionStates] = useState<Record<string, QuestionState>>(() => {
    const initial: Record<string, QuestionState> = {}
    exercise.questions.forEach(q => {
      initial[q.id] = { selectedOption: null, isSubmitted: false, isCorrect: null }
    })
    return initial
  })

  const [isCompleted, setIsCompleted] = useState(false)
  const [showResults, setShowResults] = useState(false)

  // Configuración del quiz
  const config = exercise.config || {
    passing_score: exercise.passing_score || 70,
    show_feedback: true,
    allow_retry: true
  }

  // Calcular puntuación
  const { score, maxScore, percentage, passed } = useMemo(() => {
    let earned = 0
    let total = 0

    exercise.questions.forEach(q => {
      total += q.points
      const state = questionStates[q.id]
      if (state?.isSubmitted && state.isCorrect) {
        earned += q.points
      }
    })

    const pct = total > 0 ? Math.round((earned / total) * 100) : 0
    const passingScore = config.passing_score || 70

    return {
      score: earned,
      maxScore: total,
      percentage: pct,
      passed: pct >= passingScore
    }
  }, [questionStates, exercise.questions, config.passing_score])

  // Verificar si todas las preguntas están respondidas
  const allAnswered = useMemo(() => {
    return exercise.questions.every(q => questionStates[q.id]?.isSubmitted)
  }, [questionStates, exercise.questions])

  // Handlers
  const handleSelect = (questionId: string, optionId: string) => {
    setQuestionStates(prev => ({
      ...prev,
      [questionId]: { ...prev[questionId], selectedOption: optionId }
    }))
  }

  const handleSubmitQuestion = (questionId: string) => {
    const question = exercise.questions.find(q => q.id === questionId)
    if (!question) return

    const state = questionStates[questionId]
    if (!state.selectedOption) return

    const correctOptionId = Array.isArray(question.correct) ? question.correct[0] : question.correct
    const isCorrect = state.selectedOption === correctOptionId

    setQuestionStates(prev => ({
      ...prev,
      [questionId]: { ...prev[questionId], isSubmitted: true, isCorrect }
    }))
  }

  const handleShowResults = () => {
    setShowResults(true)
    setIsCompleted(true)

    // Notificar progreso
    if (onProgressUpdate) {
      onProgressUpdate({
        status: passed ? 'completed' : 'in_progress',
        score,
        max_score: maxScore,
        attempts: (progress?.attempts || 0) + 1,
        completed_at: passed ? new Date().toISOString() : null
      })
    }
  }

  const handleRetry = () => {
    const reset: Record<string, QuestionState> = {}
    exercise.questions.forEach(q => {
      reset[q.id] = { selectedOption: null, isSubmitted: false, isCorrect: null }
    })
    setQuestionStates(reset)
    setShowResults(false)
    setIsCompleted(false)
  }

  return (
    <ExerciseShell
      exercise={exercise}
      score={showResults ? score : undefined}
      maxScore={showResults ? maxScore : undefined}
      attempts={progress?.attempts}
    >
      <div className="p-4">
        {/* Preguntas */}
        {exercise.questions.map((question, index) => (
          <QuestionCard
            key={question.id}
            question={question}
            questionNumber={index + 1}
            totalQuestions={exercise.questions.length}
            state={questionStates[question.id]}
            onSelect={(optionId) => handleSelect(question.id, optionId)}
            onSubmit={() => handleSubmitQuestion(question.id)}
            showFeedback={config.show_feedback !== false}
          />
        ))}

        {/* Resultados finales */}
        {allAnswered && !showResults && (
          <div className="mt-6 text-center">
            <button
              onClick={handleShowResults}
              className="px-6 py-3 bg-rizoma-green hover:bg-rizoma-green-dark text-white font-medium rounded-lg transition-colors"
            >
              Ver resultados finales
            </button>
          </div>
        )}

        {showResults && (
          <div className={`mt-6 p-6 rounded-lg border-2 ${
            passed
              ? 'bg-green-50 dark:bg-green-900/20 border-green-500'
              : 'bg-yellow-50 dark:bg-yellow-900/20 border-yellow-500'
          }`}>
            <div className="text-center">
              {passed ? (
                <svg className="w-16 h-16 mx-auto text-green-500" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                  <path strokeLinecap="round" strokeLinejoin="round" strokeWidth={2} d="M9 12l2 2 4-4m6 2a9 9 0 11-18 0 9 9 0 0118 0z" />
                </svg>
              ) : (
                <svg className="w-16 h-16 mx-auto text-yellow-500" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                  <path strokeLinecap="round" strokeLinejoin="round" strokeWidth={2} d="M12 9v2m0 4h.01m-6.938 4h13.856c1.54 0 2.502-1.667 1.732-3L13.732 4c-.77-1.333-2.694-1.333-3.464 0L3.34 16c-.77 1.333.192 3 1.732 3z" />
                </svg>
              )}

              <h3 className={`mt-4 text-2xl font-bold ${passed ? 'text-green-800 dark:text-green-200' : 'text-yellow-800 dark:text-yellow-200'}`}>
                {passed ? '¡Felicitaciones!' : 'Sigue practicando'}
              </h3>

              <p className={`mt-2 text-lg ${passed ? 'text-green-700 dark:text-green-300' : 'text-yellow-700 dark:text-yellow-300'}`}>
                Obtuviste <strong>{score}</strong> de <strong>{maxScore}</strong> puntos ({percentage}%)
              </p>

              <p className={`mt-1 text-sm ${passed ? 'text-green-600 dark:text-green-400' : 'text-yellow-600 dark:text-yellow-400'}`}>
                {passed
                  ? 'Has superado el quiz exitosamente.'
                  : `Necesitas ${config.passing_score}% para aprobar. ${config.allow_retry ? 'Puedes intentarlo de nuevo.' : ''}`}
              </p>

              {config.allow_retry && !passed && (
                <button
                  onClick={handleRetry}
                  className="mt-4 px-6 py-2 bg-yellow-500 hover:bg-yellow-600 text-white font-medium rounded-lg transition-colors"
                >
                  Intentar de nuevo
                </button>
              )}
            </div>
          </div>
        )}
      </div>
    </ExerciseShell>
  )
}
