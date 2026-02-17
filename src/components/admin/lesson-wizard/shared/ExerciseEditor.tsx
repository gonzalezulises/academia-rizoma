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
  { value: 'colab', label: 'Colab' },
  { value: 'reflection', label: 'Reflexion' },
  { value: 'case-study', label: 'Caso de estudio' },
]

const DIFFICULTIES = [
  { value: 'beginner', label: 'Principiante' },
  { value: 'intermediate', label: 'Intermedio' },
  { value: 'advanced', label: 'Avanzado' },
] as const

const inputClass = 'w-full px-3 py-2 border border-gray-300 dark:border-gray-700 rounded-lg dark:bg-gray-700 dark:text-white text-sm'
const labelClass = 'block text-sm font-medium text-gray-700 dark:text-gray-300 mb-1'

export default function ExerciseEditor({ exercise, onChange, onRemove, index }: ExerciseEditorProps) {
  const [expanded, setExpanded] = useState(true)

  const codeLanguage = exercise.type === 'sql' ? 'sql' : 'python'

  const renderTypeFields = () => {
    switch (exercise.type) {
      case 'code-python':
      case 'sql':
        return (
          <>
            <div>
              <label className={labelClass}>Codigo inicial</label>
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
            <div>
              <label className={labelClass}>Solucion</label>
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
            <div>
              <label className={labelClass}>Tests de validacion</label>
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
            {/* Hints for code types */}
            <div>
              <label className={labelClass}>Hints (3 progresivos)</label>
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
                  className={`${inputClass} mb-2`}
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
          </>
        )

      case 'colab':
        return (
          <>
            <div>
              <label className={labelClass}>URL de Colab</label>
              <input
                type="url"
                value={exercise.colabUrl || ''}
                onChange={(e) => onChange({ colabUrl: e.target.value })}
                className={inputClass}
                placeholder="https://colab.research.google.com/..."
              />
            </div>
            <div>
              <label className={labelClass}>URL de GitHub (opcional)</label>
              <input
                type="url"
                value={exercise.githubUrl || ''}
                onChange={(e) => onChange({ githubUrl: e.target.value })}
                className={inputClass}
                placeholder="https://github.com/..."
              />
            </div>
            <div>
              <label className={labelClass}>Nombre del notebook</label>
              <input
                type="text"
                value={exercise.notebookName || ''}
                onChange={(e) => onChange({ notebookName: e.target.value })}
                className={inputClass}
                placeholder="ej: analisis_datos.ipynb"
              />
            </div>
            <div>
              <label className={labelClass}>Criterios de completitud</label>
              <textarea
                value={exercise.completionCriteria || ''}
                onChange={(e) => onChange({ completionCriteria: e.target.value })}
                rows={3}
                className={inputClass}
                placeholder="Describe que debe lograr el estudiante para completar este ejercicio..."
              />
            </div>
            <div className="flex items-center gap-2">
              <input
                type="checkbox"
                id={`manual-${exercise.id}`}
                checked={exercise.manualCompletion || false}
                onChange={(e) => onChange({ manualCompletion: e.target.checked })}
                className="rounded border-gray-300 dark:border-gray-600"
              />
              <label htmlFor={`manual-${exercise.id}`} className="text-sm text-gray-700 dark:text-gray-300">
                Completitud manual (el estudiante marca como completado)
              </label>
            </div>
          </>
        )

      case 'reflection':
        return (
          <div>
            <label className={labelClass}>Pregunta de reflexion</label>
            <textarea
              value={exercise.reflectionPrompt || ''}
              onChange={(e) => onChange({ reflectionPrompt: e.target.value })}
              rows={5}
              className={inputClass}
              placeholder="Escribe una pregunta abierta que invite al estudiante a reflexionar sobre lo aprendido..."
            />
          </div>
        )

      case 'case-study':
        return (
          <>
            <div>
              <label className={labelClass}>Escenario (Markdown)</label>
              <textarea
                value={exercise.scenarioText || ''}
                onChange={(e) => onChange({ scenarioText: e.target.value })}
                rows={6}
                className={inputClass}
                placeholder="Describe el escenario o caso de estudio en Markdown..."
              />
            </div>
            <div>
              <label className={labelClass}>Preguntas de analisis</label>
              {(exercise.analysisQuestions || []).map((q, i) => (
                <div key={i} className="flex gap-2 mb-2">
                  <input
                    type="text"
                    value={q}
                    onChange={(e) => {
                      const newQuestions = [...(exercise.analysisQuestions || [])]
                      newQuestions[i] = e.target.value
                      onChange({ analysisQuestions: newQuestions })
                    }}
                    className={`${inputClass} flex-1`}
                    placeholder={`Pregunta ${i + 1}`}
                  />
                  <button
                    type="button"
                    onClick={() => {
                      const newQuestions = (exercise.analysisQuestions || []).filter((_, j) => j !== i)
                      onChange({ analysisQuestions: newQuestions })
                    }}
                    className="text-red-500 hover:text-red-700 text-sm px-2"
                  >
                    x
                  </button>
                </div>
              ))}
              <button
                type="button"
                onClick={() => onChange({ analysisQuestions: [...(exercise.analysisQuestions || []), ''] })}
                className="text-sm text-purple-600 dark:text-purple-400 hover:underline"
              >
                + Agregar pregunta
              </button>
            </div>
          </>
        )
    }
  }

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
            {EXERCISE_TYPES.find(t => t.value === exercise.type)?.label || exercise.type}
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
              <label className={labelClass}>Titulo</label>
              <input
                type="text"
                value={exercise.title}
                onChange={(e) => onChange({ title: e.target.value })}
                className={inputClass}
              />
            </div>
            <div>
              <label className={labelClass}>Tipo</label>
              <select
                value={exercise.type}
                onChange={(e) => onChange({ type: e.target.value as WizardExerciseType })}
                className={inputClass}
              >
                {EXERCISE_TYPES.map(t => (
                  <option key={t.value} value={t.value}>{t.label}</option>
                ))}
              </select>
            </div>
            <div>
              <label className={labelClass}>Dificultad</label>
              <select
                value={exercise.difficulty}
                onChange={(e) => onChange({ difficulty: e.target.value as ExerciseDefinition['difficulty'] })}
                className={inputClass}
              >
                {DIFFICULTIES.map(d => (
                  <option key={d.value} value={d.value}>{d.label}</option>
                ))}
              </select>
            </div>
            <div>
              <label className={labelClass}>Minutos</label>
              <input
                type="number"
                min={1}
                value={exercise.estimatedMinutes}
                onChange={(e) => onChange({ estimatedMinutes: parseInt(e.target.value) || 5 })}
                className={inputClass}
              />
            </div>
          </div>

          {/* ID */}
          <div>
            <label className={labelClass}>ID del ejercicio (kebab-case)</label>
            <input
              type="text"
              value={exercise.id}
              onChange={(e) => onChange({ id: e.target.value.toLowerCase().replace(/[^a-z0-9-]/g, '-') })}
              className={`${inputClass} font-mono`}
              placeholder="ej: ex-01-nombre"
            />
          </div>

          {/* Description */}
          <div>
            <label className={labelClass}>Descripcion</label>
            <textarea
              value={exercise.description}
              onChange={(e) => onChange({ description: e.target.value })}
              rows={2}
              className={inputClass}
            />
          </div>

          {/* Instructions */}
          <div>
            <label className={labelClass}>Instrucciones (Markdown)</label>
            <textarea
              value={exercise.instructions}
              onChange={(e) => onChange({ instructions: e.target.value })}
              rows={3}
              className={inputClass}
            />
          </div>

          {/* Type-specific fields */}
          {renderTypeFields()}
        </div>
      )}
    </div>
  )
}
