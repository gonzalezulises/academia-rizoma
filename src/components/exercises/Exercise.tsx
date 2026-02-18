'use client'

import { useEffect, useState } from 'react'
import { CodePlayground } from './CodePlayground'
import { SQLPlayground } from './SQLPlayground'
import { ColabLauncher } from './ColabLauncher'
import { QuizPlayground } from './QuizPlayground'
import { ExerciseErrorBoundary } from './ExerciseErrorBoundary'
import type {
  Exercise as ExerciseType,
  ExerciseProgress
} from '@/types/exercises'

interface ExerciseProps {
  exerciseId: string
  courseSlug?: string
  moduleId?: string
  exercise?: ExerciseType
  progress?: ExerciseProgress
  onProgressUpdate?: (progress: Partial<ExerciseProgress>) => void
  showSolution?: boolean
}

// Loading skeleton for exercise
function ExerciseSkeleton() {
  return (
    <div className="my-8 rounded-lg border border-gray-200 dark:border-gray-700 bg-white dark:bg-gray-800 overflow-hidden animate-pulse">
      <div className="bg-gray-50 dark:bg-gray-900 px-4 py-3 border-b border-gray-200 dark:border-gray-700">
        <div className="h-6 w-48 bg-gray-200 dark:bg-gray-700 rounded"></div>
      </div>
      <div className="p-4 space-y-4">
        <div className="h-4 w-full bg-gray-200 dark:bg-gray-700 rounded"></div>
        <div className="h-4 w-3/4 bg-gray-200 dark:bg-gray-700 rounded"></div>
        <div className="h-48 bg-gray-200 dark:bg-gray-700 rounded"></div>
      </div>
    </div>
  )
}

// Error display
function ExerciseError({ error, exerciseId, courseSlug, moduleId }: { error: string; exerciseId: string; courseSlug?: string; moduleId?: string }) {
  return (
    <div className="my-8 rounded-lg border border-red-200 dark:border-red-800 bg-red-50 dark:bg-red-900/20 p-4">
      <div className="flex items-center gap-2 text-red-700 dark:text-red-300">
        <svg className="w-5 h-5" fill="none" stroke="currentColor" viewBox="0 0 24 24">
          <path strokeLinecap="round" strokeLinejoin="round" strokeWidth={2} d="M12 9v2m0 4h.01m-6.938 4h13.856c1.54 0 2.502-1.667 1.732-3L13.732 4c-.77-1.333-2.694-1.333-3.464 0L3.34 16c-.77 1.333.192 3 1.732 3z" />
        </svg>
        <span className="font-medium">Error cargando ejercicio</span>
      </div>
      <p className="mt-2 text-sm text-red-600 dark:text-red-400">
        {error}
      </p>
      <p className="mt-1 text-xs text-red-500 dark:text-red-500">
        ID: {exerciseId} | Course: {courseSlug || 'undefined'} | Module: {moduleId || 'undefined'}
      </p>
    </div>
  )
}

export function Exercise({
  exerciseId,
  courseSlug,
  moduleId,
  exercise: providedExercise,
  progress,
  onProgressUpdate,
  showSolution = false
}: ExerciseProps) {
  const [exercise, setExercise] = useState<ExerciseType | null>(providedExercise || null)
  const [datasets, setDatasets] = useState<Map<string, string>>(new Map())
  const [schema, setSchema] = useState<string | undefined>(undefined)
  const [isLoading, setIsLoading] = useState(!exercise)
  const [error, setError] = useState<string | null>(null)

  // Load exercise data if not provided
  useEffect(() => {
    if (exercise) return

    async function loadExercise() {
      try {
        // Use basePath for API calls in production
        const basePath = process.env.NEXT_PUBLIC_BASE_PATH || ''
        const params = new URLSearchParams()
        if (courseSlug) params.set('course', courseSlug)
        if (moduleId) params.set('module', moduleId)
        const qs = params.toString() ? `?${params.toString()}` : ''
        const response = await fetch(`${basePath}/api/exercises/${exerciseId}${qs}`)

        if (!response.ok) {
          const errorData = await response.json().catch(() => ({}))
          throw new Error(errorData.details || errorData.error || `Failed to load exercise: ${response.statusText}`)
        }

        const data = await response.json()
        setExercise(data.exercise)
        setDatasets(new Map(Object.entries(data.datasets || {})))
        setSchema(data.schema)
      } catch (err) {
        setError(err instanceof Error ? err.message : 'Unknown error')
      } finally {
        setIsLoading(false)
      }
    }

    loadExercise()
  }, [exerciseId, courseSlug, moduleId, exercise])

  if (isLoading) {
    return <ExerciseSkeleton />
  }

  if (error || !exercise) {
    return <ExerciseError error={error || 'Exercise not found'} exerciseId={exerciseId} courseSlug={courseSlug} moduleId={moduleId} />
  }

  // Render the appropriate playground based on exercise type
  const playground = (() => {
    switch (exercise.type) {
      case 'code-python':
        return (
          <CodePlayground
            exercise={exercise}
            progress={progress}
            onProgressUpdate={onProgressUpdate}
            showSolution={showSolution}
          />
        )

      case 'sql':
        return (
          <SQLPlayground
            exercise={exercise}
            schema={schema}
            datasets={datasets}
            progress={progress}
            onProgressUpdate={onProgressUpdate}
            showSolution={showSolution}
          />
        )

      case 'colab':
        return (
          <ColabLauncher
            exercise={exercise}
            progress={progress}
            onProgressUpdate={onProgressUpdate}
          />
        )

      case 'quiz':
        return (
          <QuizPlayground
            exercise={exercise}
            progress={progress}
            onProgressUpdate={onProgressUpdate}
          />
        )

      case 'reflection':
        return (
          <div className="my-8 rounded-lg border border-purple-200 dark:border-purple-800 bg-purple-50 dark:bg-purple-900/20 overflow-hidden">
            <div className="bg-purple-100 dark:bg-purple-900/40 px-4 py-3 border-b border-purple-200 dark:border-purple-800">
              <h3 className="font-semibold text-purple-900 dark:text-purple-200">{exercise.title}</h3>
            </div>
            <div className="p-4 space-y-3">
              {exercise.description && <p className="text-sm text-gray-700 dark:text-gray-300">{exercise.description}</p>}
              <p className="text-gray-800 dark:text-gray-200 whitespace-pre-wrap">
                {(exercise as { reflection_prompt?: string }).reflection_prompt || exercise.instructions}
              </p>
              <textarea
                rows={5}
                placeholder="Escribe tu reflexion aqui..."
                className="w-full px-3 py-2 border border-purple-300 dark:border-purple-700 rounded-lg dark:bg-gray-800 dark:text-white resize-y"
              />
            </div>
          </div>
        )

      case 'case-study':
        return (
          <div className="my-8 rounded-lg border border-amber-200 dark:border-amber-800 bg-amber-50 dark:bg-amber-900/20 overflow-hidden">
            <div className="bg-amber-100 dark:bg-amber-900/40 px-4 py-3 border-b border-amber-200 dark:border-amber-800">
              <h3 className="font-semibold text-amber-900 dark:text-amber-200">{exercise.title}</h3>
            </div>
            <div className="p-4 space-y-4">
              {exercise.description && <p className="text-sm text-gray-700 dark:text-gray-300">{exercise.description}</p>}
              <div className="prose prose-sm dark:prose-invert max-w-none">
                <p className="whitespace-pre-wrap">{(exercise as { scenario_text?: string }).scenario_text || exercise.instructions}</p>
              </div>
              {(exercise as { analysis_questions?: string[] }).analysis_questions?.map((q: string, i: number) => (
                <div key={i} className="space-y-1">
                  <p className="text-sm font-medium text-gray-800 dark:text-gray-200">{i + 1}. {q}</p>
                  <textarea
                    rows={3}
                    placeholder="Tu respuesta..."
                    className="w-full px-3 py-2 text-sm border border-amber-300 dark:border-amber-700 rounded-lg dark:bg-gray-800 dark:text-white resize-y"
                  />
                </div>
              ))}
            </div>
          </div>
        )

      default:
        return (
          <ExerciseError
            error={`Unknown exercise type: ${(exercise as { type: string }).type}`}
            exerciseId={exerciseId}
            courseSlug={courseSlug}
            moduleId={moduleId}
          />
        )
    }
  })()

  return <ExerciseErrorBoundary>{playground}</ExerciseErrorBoundary>
}
