'use client'

import type { Dispatch } from 'react'
import type { LessonWizardState, WizardAction, HookType } from '../types'
import { HOOK_TYPES } from '../types'
import MarkdownEditor from '../shared/MarkdownEditor'
import AIGenerateButton from '../shared/AIGenerateButton'
import { useAIGeneration } from '../hooks/useAIGeneration'

interface ConnectionStepProps {
  state: LessonWizardState
  dispatch: Dispatch<WizardAction>
  courseName?: string
  moduleName?: string
}

export default function ConnectionStep({ state, dispatch, courseName, moduleName }: ConnectionStepProps) {
  const { connection, metadata } = state
  const ai = useAIGeneration<{ hookContent: string; hookType: string; estimatedMinutes: number }>()

  const handleGenerate = async () => {
    const result = await ai.generate('connection', {
      title: metadata.title,
      objectives: metadata.objectives.filter(o => o.trim()),
      bloomLevel: metadata.bloomLevel,
      hookType: connection.hookType,
      courseName,
      moduleName,
    })
    if (result) {
      dispatch({
        type: 'SET_CONNECTION',
        payload: {
          content: result.hookContent,
          hookType: (result.hookType as HookType) || connection.hookType,
          estimatedMinutes: result.estimatedMinutes || 3,
        },
      })
    }
  }

  return (
    <div className="space-y-6">
      <div>
        <h2 className="text-xl font-semibold text-gray-900 dark:text-white mb-1">
          Conexion (Hook)
        </h2>
        <p className="text-sm text-gray-500 dark:text-gray-400">
          Capta la atencion del estudiante y conecta con conocimiento previo.
        </p>
      </div>

      {/* Hook type selector */}
      <div>
        <label className="block text-sm font-medium text-gray-700 dark:text-gray-300 mb-2">
          Tipo de hook
        </label>
        <div className="grid grid-cols-2 md:grid-cols-4 gap-2">
          {HOOK_TYPES.map(ht => (
            <button
              key={ht.value}
              type="button"
              onClick={() => dispatch({ type: 'SET_CONNECTION', payload: { hookType: ht.value } })}
              className={`p-3 rounded-lg border text-left transition-colors ${
                connection.hookType === ht.value
                  ? 'border-rizoma-green bg-green-50 dark:bg-green-900/20'
                  : 'border-gray-200 dark:border-gray-700 hover:border-gray-300 dark:hover:border-gray-600'
              }`}
            >
              <p className="font-medium text-sm text-gray-900 dark:text-white">{ht.label}</p>
              <p className="text-xs text-gray-500 dark:text-gray-400 mt-0.5">{ht.description}</p>
            </button>
          ))}
        </div>
      </div>

      {/* AI Generate */}
      <AIGenerateButton
        onClick={handleGenerate}
        isGenerating={ai.isGenerating}
        error={ai.error}
        provider={ai.provider}
        label="Generar hook"
      />

      {/* Content editor */}
      <div>
        <label className="block text-sm font-medium text-gray-700 dark:text-gray-300 mb-1">
          Contenido del hook (Markdown)
        </label>
        <MarkdownEditor
          value={connection.content}
          onChange={(content) => dispatch({ type: 'SET_CONNECTION', payload: { content } })}
          placeholder="Escribe el hook de conexion..."
          minHeight="200px"
        />
      </div>

      {/* Estimated minutes */}
      <div className="w-32">
        <label className="block text-sm font-medium text-gray-700 dark:text-gray-300 mb-1">
          Duracion (min)
        </label>
        <input
          type="number"
          min={1}
          max={10}
          value={connection.estimatedMinutes}
          onChange={(e) => dispatch({ type: 'SET_CONNECTION', payload: { estimatedMinutes: parseInt(e.target.value) || 3 } })}
          className="w-full px-3 py-2 border border-gray-300 dark:border-gray-700 rounded-lg dark:bg-gray-700 dark:text-white"
        />
      </div>
    </div>
  )
}
