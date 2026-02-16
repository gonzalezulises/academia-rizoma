'use client'

import type { LessonWizardState, ValidationResult } from '../types'
import ValidationChecklist from '../shared/ValidationChecklist'

interface ReviewStepProps {
  state: LessonWizardState
  validation: ValidationResult
  markdownPreview: string
  onSave: () => void
  onSaveDraft: () => void
  saving: boolean
}

export default function ReviewStep({
  state,
  validation,
  markdownPreview,
  onSave,
  onSaveDraft,
  saving,
}: ReviewStepProps) {
  return (
    <div className="space-y-6">
      <div>
        <h2 className="text-xl font-semibold text-gray-900 dark:text-white mb-1">
          Revision final
        </h2>
        <p className="text-sm text-gray-500 dark:text-gray-400">
          Revisa el checklist de calidad y la vista previa antes de guardar.
        </p>
      </div>

      {/* Summary */}
      <div className="grid grid-cols-2 md:grid-cols-4 gap-3">
        <SummaryCard label="Bloques conceptuales" value={state.concepts.blocks.length} />
        <SummaryCard label="Ejercicios" value={state.practice.exercises.length} />
        <SummaryCard label="Preguntas quiz" value={state.conclusions.quizQuestions.length} />
        <SummaryCard label="Duracion total" value={`${state.metadata.durationMinutes} min`} />
      </div>

      {/* Validation */}
      <ValidationChecklist validation={validation} />

      {/* Markdown preview */}
      <div>
        <h3 className="text-sm font-semibold text-gray-700 dark:text-gray-300 uppercase tracking-wider mb-2">
          Vista previa del contenido
        </h3>
        <div className="bg-white dark:bg-gray-800 border border-gray-200 dark:border-gray-700 rounded-lg p-6 max-h-96 overflow-y-auto">
          <pre className="whitespace-pre-wrap text-sm text-gray-800 dark:text-gray-200 font-mono">
            {markdownPreview || 'Sin contenido generado'}
          </pre>
        </div>
      </div>

      {/* Exercise details */}
      {state.practice.exercises.length > 0 && (
        <div>
          <h3 className="text-sm font-semibold text-gray-700 dark:text-gray-300 uppercase tracking-wider mb-2">
            Ejercicios a crear
          </h3>
          <div className="space-y-2">
            {state.practice.exercises.map((ex, i) => (
              <div key={ex.id} className="flex items-center gap-3 p-3 bg-gray-50 dark:bg-gray-800/50 rounded-lg">
                <span className="text-sm text-gray-400">#{i + 1}</span>
                <span className="font-medium text-gray-900 dark:text-white text-sm">{ex.title || 'Sin titulo'}</span>
                <span className="text-xs px-2 py-0.5 rounded-full bg-blue-100 dark:bg-blue-900/30 text-blue-700 dark:text-blue-400">
                  {ex.type}
                </span>
                <span className="text-xs text-gray-500 dark:text-gray-400">{ex.difficulty}</span>
                <span className="text-xs text-gray-500 dark:text-gray-400 ml-auto">{ex.estimatedMinutes} min</span>
              </div>
            ))}
          </div>
        </div>
      )}

      {/* Save actions */}
      <div className="flex gap-3 pt-4 border-t border-gray-200 dark:border-gray-700">
        <button
          type="button"
          onClick={onSave}
          disabled={saving || !validation.isValid}
          className="px-6 py-2.5 bg-rizoma-green text-white rounded-lg hover:bg-rizoma-green-dark disabled:opacity-50 disabled:cursor-not-allowed font-medium"
        >
          {saving ? 'Guardando...' : 'Crear leccion'}
        </button>
        <button
          type="button"
          onClick={onSaveDraft}
          disabled={saving}
          className="px-6 py-2.5 border border-gray-300 dark:border-gray-600 rounded-lg text-gray-700 dark:text-gray-300 hover:bg-gray-100 dark:hover:bg-gray-700"
        >
          Guardar borrador
        </button>
      </div>
    </div>
  )
}

function SummaryCard({ label, value }: { label: string; value: string | number }) {
  return (
    <div className="bg-gray-50 dark:bg-gray-800/50 rounded-lg p-3 text-center">
      <p className="text-2xl font-bold text-gray-900 dark:text-white">{value}</p>
      <p className="text-xs text-gray-500 dark:text-gray-400">{label}</p>
    </div>
  )
}
