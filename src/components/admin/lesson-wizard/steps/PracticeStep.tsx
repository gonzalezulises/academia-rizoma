'use client'

import type { Dispatch } from 'react'
import type { LessonWizardState, WizardAction, ExerciseDefinition } from '../types'
import ExerciseEditor from '../shared/ExerciseEditor'
import AIGenerateButton from '../shared/AIGenerateButton'
import { useAIGeneration } from '../hooks/useAIGeneration'

interface PracticeStepProps {
  state: LessonWizardState
  dispatch: Dispatch<WizardAction>
  courseName?: string
}

export default function PracticeStep({ state, dispatch, courseName }: PracticeStepProps) {
  const { practice, metadata } = state
  const ai = useAIGeneration<{
    exercises: {
      id: string; title: string; type: string; difficulty: string
      description: string; instructions: string
      starterCode: string; solutionCode: string; testCode: string
      hints: string[]; estimatedMinutes: number
    }[]
    estimatedMinutes: number
  }>()

  const handleGenerate = async () => {
    const result = await ai.generate('practice', {
      title: metadata.title,
      objectives: metadata.objectives.filter(o => o.trim()),
      bloomLevel: metadata.bloomLevel,
      courseName,
    })
    if (result && result.exercises) {
      const newExercises: ExerciseDefinition[] = result.exercises.map(ex => ({
        id: ex.id || `ex-${Date.now()}`,
        title: ex.title,
        type: (ex.type as ExerciseDefinition['type']) || 'code-python',
        difficulty: (ex.difficulty as ExerciseDefinition['difficulty']) || 'beginner',
        description: ex.description,
        instructions: ex.instructions,
        starterCode: ex.starterCode || '',
        solutionCode: ex.solutionCode || '',
        testCode: ex.testCode || '',
        hints: ex.hints || ['', '', ''],
        estimatedMinutes: ex.estimatedMinutes || 5,
      }))
      dispatch({ type: 'SET_EXERCISES', exercises: newExercises })
    }
  }

  const addExercise = () => {
    const newExercise: ExerciseDefinition = {
      id: `ex-${Date.now()}`,
      title: '',
      type: 'code-python',
      difficulty: 'beginner',
      description: '',
      instructions: '',
      starterCode: '# Tu codigo aqui\n',
      solutionCode: '',
      testCode: '',
      hints: ['', '', ''],
      estimatedMinutes: 5,
    }
    dispatch({ type: 'ADD_EXERCISE', exercise: newExercise })
  }

  const totalMinutes = practice.exercises.reduce((sum, ex) => sum + ex.estimatedMinutes, 0)
  const practiceRatio = metadata.durationMinutes > 0
    ? Math.round((totalMinutes / metadata.durationMinutes) * 100)
    : 0

  return (
    <div className="space-y-6">
      <div>
        <h2 className="text-xl font-semibold text-gray-900 dark:text-white mb-1">
          Practica concreta
        </h2>
        <p className="text-sm text-gray-500 dark:text-gray-400">
          Define ejercicios interactivos. Objetivo: 40-50% del tiempo total en practica.
        </p>
      </div>

      {/* Practice ratio indicator */}
      <div className="flex items-center gap-4 p-3 rounded-lg bg-gray-50 dark:bg-gray-800/50">
        <div className="flex-1">
          <div className="flex justify-between text-sm mb-1">
            <span className="text-gray-600 dark:text-gray-400">Tiempo en practica</span>
            <span className={`font-medium ${
              practiceRatio >= 35 && practiceRatio <= 55
                ? 'text-green-600 dark:text-green-400'
                : practiceRatio > 0
                  ? 'text-yellow-600 dark:text-yellow-400'
                  : 'text-gray-400'
            }`}>
              {totalMinutes} min / {metadata.durationMinutes} min ({practiceRatio}%)
            </span>
          </div>
          <div className="h-2 bg-gray-200 dark:bg-gray-700 rounded-full overflow-hidden">
            <div
              className={`h-full rounded-full transition-all ${
                practiceRatio >= 35 && practiceRatio <= 55
                  ? 'bg-green-500'
                  : practiceRatio > 55
                    ? 'bg-yellow-500'
                    : 'bg-blue-500'
              }`}
              style={{ width: `${Math.min(practiceRatio, 100)}%` }}
            />
          </div>
        </div>
      </div>

      <AIGenerateButton
        onClick={handleGenerate}
        isGenerating={ai.isGenerating}
        error={ai.error}
        provider={ai.provider}
        label="Generar ejercicios"
      />

      {/* Exercise list */}
      <div className="space-y-4">
        {practice.exercises.map((exercise, index) => (
          <ExerciseEditor
            key={exercise.id}
            exercise={exercise}
            index={index}
            onChange={(updates) => dispatch({ type: 'UPDATE_EXERCISE', id: exercise.id, updates })}
            onRemove={() => dispatch({ type: 'REMOVE_EXERCISE', id: exercise.id })}
          />
        ))}
      </div>

      {practice.exercises.length === 0 && (
        <div className="text-center py-8 bg-gray-50 dark:bg-gray-800/50 rounded-lg border-2 border-dashed border-gray-300 dark:border-gray-700">
          <p className="text-gray-500 dark:text-gray-400 mb-3">
            No hay ejercicios. Genera con IA o agrega manualmente.
          </p>
        </div>
      )}

      <button
        type="button"
        onClick={addExercise}
        className="w-full py-2 border-2 border-dashed border-gray-300 dark:border-gray-700 rounded-lg text-gray-500 dark:text-gray-400 hover:border-rizoma-green hover:text-rizoma-green transition-colors text-sm"
      >
        + Agregar ejercicio
      </button>
    </div>
  )
}
