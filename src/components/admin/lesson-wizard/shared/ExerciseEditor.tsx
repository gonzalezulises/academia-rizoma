'use client'

import { useState } from 'react'
import dynamic from 'next/dynamic'
import type { ExerciseDefinition, WizardExerciseType } from '../types'

const MonacoEditor = dynamic(() => import('@monaco-editor/react'), { ssr: false })

interface ExerciseEditorProps {
  exercise: ExerciseDefinition
  onChange: (updates: Partial<ExerciseDefinition>) => void
  onRemove: () => void
  index: number
}

const EXERCISE_TYPES: { value: WizardExerciseType; label: string }[] = [
  { value: 'code-python', label: 'Python' },
  { value: 'sql', label: 'SQL' },
  { value: 'quiz', label: 'Quiz' },
]

const DIFFICULTIES = [
  { value: 'beginner', label: 'Principiante' },
  { value: 'intermediate', label: 'Intermedio' },
  { value: 'advanced', label: 'Avanzado' },
] as const

export default function ExerciseEditor({ exercise, onChange, onRemove, index }: ExerciseEditorProps) {
  const [expanded, setExpanded] = useState(true)

  const codeLanguage = exercise.type === 'sql' ? 'sql' : 'python'

  return (
    <div className="border border-gray-200 dark:border-gray-700 rounded-lg overflow-hidden">
      {/* Header */}
      <div
        className="flex items-center justify-between p-3 bg-gray-50 dark:bg-gray-800 cursor-pointer"
        onClick={() => setExpanded(!expanded)}
      >
        <div className="flex items-center gap-3">
          <span className="text-sm font-medium text-gray-500 dark:text-gray-400">
            #{index + 1}
          </span>
          <span className="font-medium text-gray-900 dark:text-white">
            {exercise.title || 'Sin titulo'}
          </span>
          <span className="text-xs px-2 py-0.5 rounded-full bg-blue-100 dark:bg-blue-900/30 text-blue-700 dark:text-blue-400">
            {exercise.type}
          </span>
        </div>
        <div className="flex items-center gap-2">
          <button
            type="button"
            onClick={(e) => { e.stopPropagation(); onRemove() }}
            className="text-red-500 hover:text-red-700 text-sm"
          >
            Eliminar
          </button>
          <span className="text-gray-400">{expanded ? '\u25B2' : '\u25BC'}</span>
        </div>
      </div>

      {expanded && (
        <div className="p-4 space-y-4">
          {/* Row 1: Title, Type, Difficulty, Duration */}
          <div className="grid grid-cols-1 md:grid-cols-4 gap-3">
            <div className="md:col-span-1">
              <label className="block text-sm font-medium text-gray-700 dark:text-gray-300 mb-1">
                Titulo
              </label>
              <input
                type="text"
                value={exercise.title}
                onChange={(e) => onChange({ title: e.target.value })}
                className="w-full px-3 py-2 border border-gray-300 dark:border-gray-700 rounded-lg dark:bg-gray-700 dark:text-white text-sm"
              />
            </div>
            <div>
              <label className="block text-sm font-medium text-gray-700 dark:text-gray-300 mb-1">
                Tipo
              </label>
              <select
                value={exercise.type}
                onChange={(e) => onChange({ type: e.target.value as WizardExerciseType })}
                className="w-full px-3 py-2 border border-gray-300 dark:border-gray-700 rounded-lg dark:bg-gray-700 dark:text-white text-sm"
              >
                {EXERCISE_TYPES.map(t => (
                  <option key={t.value} value={t.value}>{t.label}</option>
                ))}
              </select>
            </div>
            <div>
              <label className="block text-sm font-medium text-gray-700 dark:text-gray-300 mb-1">
                Dificultad
              </label>
              <select
                value={exercise.difficulty}
                onChange={(e) => onChange({ difficulty: e.target.value as ExerciseDefinition['difficulty'] })}
                className="w-full px-3 py-2 border border-gray-300 dark:border-gray-700 rounded-lg dark:bg-gray-700 dark:text-white text-sm"
              >
                {DIFFICULTIES.map(d => (
                  <option key={d.value} value={d.value}>{d.label}</option>
                ))}
              </select>
            </div>
            <div>
              <label className="block text-sm font-medium text-gray-700 dark:text-gray-300 mb-1">
                Minutos
              </label>
              <input
                type="number"
                min={1}
                value={exercise.estimatedMinutes}
                onChange={(e) => onChange({ estimatedMinutes: parseInt(e.target.value) || 5 })}
                className="w-full px-3 py-2 border border-gray-300 dark:border-gray-700 rounded-lg dark:bg-gray-700 dark:text-white text-sm"
              />
            </div>
          </div>

          {/* ID */}
          <div>
            <label className="block text-sm font-medium text-gray-700 dark:text-gray-300 mb-1">
              ID del ejercicio (kebab-case)
            </label>
            <input
              type="text"
              value={exercise.id}
              onChange={(e) => onChange({ id: e.target.value.toLowerCase().replace(/[^a-z0-9-]/g, '-') })}
              className="w-full px-3 py-2 border border-gray-300 dark:border-gray-700 rounded-lg dark:bg-gray-700 dark:text-white text-sm font-mono"
              placeholder="ej: ex-01-nombre"
            />
          </div>

          {/* Description */}
          <div>
            <label className="block text-sm font-medium text-gray-700 dark:text-gray-300 mb-1">
              Descripcion
            </label>
            <textarea
              value={exercise.description}
              onChange={(e) => onChange({ description: e.target.value })}
              rows={2}
              className="w-full px-3 py-2 border border-gray-300 dark:border-gray-700 rounded-lg dark:bg-gray-700 dark:text-white text-sm"
            />
          </div>

          {/* Instructions */}
          <div>
            <label className="block text-sm font-medium text-gray-700 dark:text-gray-300 mb-1">
              Instrucciones (Markdown)
            </label>
            <textarea
              value={exercise.instructions}
              onChange={(e) => onChange({ instructions: e.target.value })}
              rows={3}
              className="w-full px-3 py-2 border border-gray-300 dark:border-gray-700 rounded-lg dark:bg-gray-700 dark:text-white text-sm"
            />
          </div>

          {/* Starter Code */}
          {exercise.type !== 'quiz' && (
            <>
              <div>
                <label className="block text-sm font-medium text-gray-700 dark:text-gray-300 mb-1">
                  Codigo inicial
                </label>
                <div className="border border-gray-300 dark:border-gray-700 rounded-lg overflow-hidden">
                  <MonacoEditor
                    height="150px"
                    language={codeLanguage}
                    value={exercise.starterCode}
                    onChange={(v) => onChange({ starterCode: v || '' })}
                    theme="vs-dark"
                    options={{ minimap: { enabled: false }, scrollBeyondLastLine: false, fontSize: 13 }}
                  />
                </div>
              </div>

              {/* Solution Code */}
              <div>
                <label className="block text-sm font-medium text-gray-700 dark:text-gray-300 mb-1">
                  Solucion
                </label>
                <div className="border border-gray-300 dark:border-gray-700 rounded-lg overflow-hidden">
                  <MonacoEditor
                    height="150px"
                    language={codeLanguage}
                    value={exercise.solutionCode}
                    onChange={(v) => onChange({ solutionCode: v || '' })}
                    theme="vs-dark"
                    options={{ minimap: { enabled: false }, scrollBeyondLastLine: false, fontSize: 13 }}
                  />
                </div>
              </div>

              {/* Test Code */}
              <div>
                <label className="block text-sm font-medium text-gray-700 dark:text-gray-300 mb-1">
                  Tests de validacion
                </label>
                <div className="border border-gray-300 dark:border-gray-700 rounded-lg overflow-hidden">
                  <MonacoEditor
                    height="120px"
                    language={codeLanguage}
                    value={exercise.testCode}
                    onChange={(v) => onChange({ testCode: v || '' })}
                    theme="vs-dark"
                    options={{ minimap: { enabled: false }, scrollBeyondLastLine: false, fontSize: 13 }}
                  />
                </div>
              </div>
            </>
          )}

          {/* Hints */}
          <div>
            <label className="block text-sm font-medium text-gray-700 dark:text-gray-300 mb-1">
              Hints (3 progresivos)
            </label>
            {exercise.hints.map((hint, i) => (
              <input
                key={i}
                type="text"
                value={hint}
                onChange={(e) => {
                  const newHints = [...exercise.hints]
                  newHints[i] = e.target.value
                  onChange({ hints: newHints })
                }}
                className="w-full px-3 py-2 border border-gray-300 dark:border-gray-700 rounded-lg dark:bg-gray-700 dark:text-white text-sm mb-2"
                placeholder={`Hint ${i + 1}: ${i === 0 ? 'Que funcion usar' : i === 1 ? 'Sintaxis basica' : 'Solucion casi completa'}`}
              />
            ))}
            {exercise.hints.length < 3 && (
              <button
                type="button"
                onClick={() => onChange({ hints: [...exercise.hints, ''] })}
                className="text-sm text-purple-600 dark:text-purple-400 hover:underline"
              >
                + Agregar hint
              </button>
            )}
          </div>
        </div>
      )}
    </div>
  )
}
