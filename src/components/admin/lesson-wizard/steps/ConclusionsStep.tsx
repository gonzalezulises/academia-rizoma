'use client'

import type { Dispatch } from 'react'
import type { LessonWizardState, WizardAction, WizardQuizQuestion } from '../types'
import QuizEditor from '../shared/QuizEditor'
import MarkdownEditor from '../shared/MarkdownEditor'
import AIGenerateButton from '../shared/AIGenerateButton'
import { useAIGeneration } from '../hooks/useAIGeneration'
import { assembleMarkdown } from '../hooks/useLessonWizard'

interface ConclusionsStepProps {
  state: LessonWizardState
  dispatch: Dispatch<WizardAction>
  courseName?: string
}

export default function ConclusionsStep({ state, dispatch, courseName }: ConclusionsStepProps) {
  const { conclusions, metadata } = state
  const ai = useAIGeneration<{
    questions: {
      id: string; question: string; type: string
      options: { id: string; text: string }[]
      correctAnswer: string | string[]
      explanation: string; points: number
    }[]
    connectForward: string
    estimatedMinutes: number
  }>()

  const handleGenerate = async () => {
    const existingContent = assembleMarkdown(state)
    const result = await ai.generate('quiz', {
      title: metadata.title,
      objectives: metadata.objectives.filter(o => o.trim()),
      bloomLevel: metadata.bloomLevel,
      courseName,
      existingContent,
    })
    if (result) {
      if (result.questions) {
        const questions: WizardQuizQuestion[] = result.questions.map(q => ({
          id: q.id || `q-${Date.now()}-${Math.random().toString(36).slice(2, 6)}`,
          question: q.question,
          type: (q.type as WizardQuizQuestion['type']) || 'mcq',
          options: q.options || [],
          correctAnswer: q.correctAnswer || '',
          explanation: q.explanation || '',
          points: q.points || 1,
        }))
        dispatch({ type: 'SET_QUIZ_QUESTIONS', questions })
      }
      if (result.connectForward) {
        dispatch({ type: 'SET_CONNECT_FORWARD', content: result.connectForward })
      }
    }
  }

  const addQuestion = () => {
    const newQuestion: WizardQuizQuestion = {
      id: `q-${Date.now()}`,
      question: '',
      type: 'mcq',
      options: [
        { id: 'opt-1', text: '' },
        { id: 'opt-2', text: '' },
        { id: 'opt-3', text: '' },
        { id: 'opt-4', text: '' },
      ],
      correctAnswer: '',
      explanation: '',
      points: 1,
    }
    dispatch({ type: 'ADD_QUIZ_QUESTION', question: newQuestion })
  }

  return (
    <div className="space-y-6">
      <div>
        <h2 className="text-xl font-semibold text-gray-900 dark:text-white mb-1">
          Conclusiones
        </h2>
        <p className="text-sm text-gray-500 dark:text-gray-400">
          Quiz de evaluacion y conexion con el siguiente tema. Minimo 5 preguntas.
        </p>
      </div>

      <AIGenerateButton
        onClick={handleGenerate}
        isGenerating={ai.isGenerating}
        error={ai.error}
        provider={ai.provider}
        label="Generar quiz y cierre"
      />

      {/* Quiz questions */}
      <div>
        <h3 className="text-sm font-semibold text-gray-700 dark:text-gray-300 uppercase tracking-wider mb-3">
          Preguntas del quiz ({conclusions.quizQuestions.length})
        </h3>
        <div className="space-y-3">
          {conclusions.quizQuestions.map((question, index) => (
            <QuizEditor
              key={question.id}
              question={question}
              index={index}
              onChange={(updates) => dispatch({ type: 'UPDATE_QUIZ_QUESTION', id: question.id, updates })}
              onRemove={() => dispatch({ type: 'REMOVE_QUIZ_QUESTION', id: question.id })}
            />
          ))}
        </div>

        {conclusions.quizQuestions.length === 0 && (
          <div className="text-center py-6 bg-gray-50 dark:bg-gray-800/50 rounded-lg border-2 border-dashed border-gray-300 dark:border-gray-700">
            <p className="text-gray-500 dark:text-gray-400">
              No hay preguntas. Genera con IA o agrega manualmente.
            </p>
          </div>
        )}

        <button
          type="button"
          onClick={addQuestion}
          className="mt-3 w-full py-2 border-2 border-dashed border-gray-300 dark:border-gray-700 rounded-lg text-gray-500 dark:text-gray-400 hover:border-rizoma-green hover:text-rizoma-green transition-colors text-sm"
        >
          + Agregar pregunta
        </button>
      </div>

      {/* Connect forward */}
      <div>
        <h3 className="text-sm font-semibold text-gray-700 dark:text-gray-300 uppercase tracking-wider mb-2">
          Conexion al siguiente tema
        </h3>
        <MarkdownEditor
          value={conclusions.connectForward}
          onChange={(content) => dispatch({ type: 'SET_CONNECT_FORWARD', content })}
          placeholder="Breve parrafo conectando con el siguiente tema..."
          minHeight="120px"
        />
      </div>
    </div>
  )
}
