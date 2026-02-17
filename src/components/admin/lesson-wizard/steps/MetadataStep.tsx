'use client'

import type { Dispatch } from 'react'
import type { LessonWizardState, WizardAction } from '../types'
import { BLOOM_LEVELS } from '../types'
import { useAIGeneration } from '../hooks/useAIGeneration'
import AIGenerateButton from '../shared/AIGenerateButton'

interface MetadataStepProps {
  state: LessonWizardState
  dispatch: Dispatch<WizardAction>
  modules: { id: string; title: string }[]
  courseName?: string
}

export default function MetadataStep({ state, dispatch, modules, courseName }: MetadataStepProps) {
  const { metadata } = state
  const ai = useAIGeneration<{ objectives: string[] }>()

  const updateObjective = (index: number, value: string) => {
    const newObjectives = [...metadata.objectives]
    newObjectives[index] = value
    dispatch({ type: 'SET_OBJECTIVES', objectives: newObjectives })
  }

  const addObjective = () => {
    if (metadata.objectives.length < 4) {
      dispatch({ type: 'SET_OBJECTIVES', objectives: [...metadata.objectives, ''] })
    }
  }

  const removeObjective = (index: number) => {
    if (metadata.objectives.length > 1) {
      dispatch({ type: 'SET_OBJECTIVES', objectives: metadata.objectives.filter((_, i) => i !== index) })
    }
  }

  const handleGenerateObjectives = async () => {
    const selectedModule = modules.find(m => m.id === metadata.moduleId)
    const result = await ai.generate('objectives', {
      title: metadata.title,
      objectives: [],
      bloomLevel: metadata.bloomLevel,
      courseName: courseName || '',
      moduleName: selectedModule?.title || '',
    })

    if (result?.objectives) {
      dispatch({ type: 'SET_OBJECTIVES', objectives: result.objectives.slice(0, 4) })
    }
  }

  return (
    <div className="space-y-6">
      <div>
        <h2 className="text-xl font-semibold text-gray-900 dark:text-white mb-1">
          Metadata de la leccion
        </h2>
        <p className="text-sm text-gray-500 dark:text-gray-400">
          Define el titulo, objetivos y nivel de la leccion.
        </p>
      </div>

      {/* Title */}
      <div>
        <label className="block text-sm font-medium text-gray-700 dark:text-gray-300 mb-1">
          Titulo de la leccion *
        </label>
        <input
          type="text"
          value={metadata.title}
          onChange={(e) => dispatch({ type: 'SET_METADATA', payload: { title: e.target.value } })}
          className="w-full px-3 py-2 border border-gray-300 dark:border-gray-700 rounded-lg dark:bg-gray-700 dark:text-white"
          placeholder="Ej: Introduccion a Pandas DataFrames"
        />
      </div>

      {/* Module */}
      <div>
        <label className="block text-sm font-medium text-gray-700 dark:text-gray-300 mb-1">
          Modulo
        </label>
        <select
          value={metadata.moduleId || ''}
          onChange={(e) => dispatch({ type: 'SET_METADATA', payload: { moduleId: e.target.value || null } })}
          className="w-full px-3 py-2 border border-gray-300 dark:border-gray-700 rounded-lg dark:bg-gray-700 dark:text-white"
        >
          <option value="">Sin modulo</option>
          {modules.map(m => (
            <option key={m.id} value={m.id}>{m.title}</option>
          ))}
        </select>
      </div>

      {/* Duration and Bloom */}
      <div className="grid grid-cols-1 md:grid-cols-2 gap-4">
        <div>
          <label className="block text-sm font-medium text-gray-700 dark:text-gray-300 mb-1">
            Duracion estimada (minutos)
          </label>
          <input
            type="number"
            min={5}
            max={120}
            value={metadata.durationMinutes}
            onChange={(e) => dispatch({ type: 'SET_METADATA', payload: { durationMinutes: parseInt(e.target.value) || 30 } })}
            className="w-full px-3 py-2 border border-gray-300 dark:border-gray-700 rounded-lg dark:bg-gray-700 dark:text-white"
          />
        </div>
        <div>
          <label className="block text-sm font-medium text-gray-700 dark:text-gray-300 mb-1">
            Nivel de Bloom
          </label>
          <select
            value={metadata.bloomLevel}
            onChange={(e) => dispatch({ type: 'SET_METADATA', payload: { bloomLevel: e.target.value as typeof metadata.bloomLevel } })}
            className="w-full px-3 py-2 border border-gray-300 dark:border-gray-700 rounded-lg dark:bg-gray-700 dark:text-white"
          >
            {BLOOM_LEVELS.map(b => (
              <option key={b.value} value={b.value}>{b.label}</option>
            ))}
          </select>
        </div>
      </div>

      {/* Learning Objectives */}
      <div>
        <div className="flex items-center justify-between mb-2">
          <label className="block text-sm font-medium text-gray-700 dark:text-gray-300">
            Objetivos de aprendizaje (2-4)
          </label>
          <AIGenerateButton
            onClick={handleGenerateObjectives}
            isGenerating={ai.isGenerating}
            error={ai.error}
            provider={ai.provider}
            label="Sugerir objetivos"
            disabled={!metadata.title.trim()}
          />
        </div>
        <div className="space-y-2">
          {metadata.objectives.map((obj, index) => (
            <div key={index} className="flex gap-2">
              <span className="flex-shrink-0 mt-2 text-sm text-gray-400">{index + 1}.</span>
              <input
                type="text"
                value={obj}
                onChange={(e) => updateObjective(index, e.target.value)}
                className="flex-1 px-3 py-2 border border-gray-300 dark:border-gray-700 rounded-lg dark:bg-gray-700 dark:text-white"
                placeholder={`Objetivo ${index + 1}: El estudiante sera capaz de...`}
              />
              {metadata.objectives.length > 1 && (
                <button
                  type="button"
                  onClick={() => removeObjective(index)}
                  className="flex-shrink-0 text-red-400 hover:text-red-600 px-2"
                >
                  x
                </button>
              )}
            </div>
          ))}
        </div>
        {metadata.objectives.length < 4 && (
          <button
            type="button"
            onClick={addObjective}
            className="mt-2 text-sm text-rizoma-green hover:underline"
          >
            + Agregar objetivo
          </button>
        )}
      </div>
    </div>
  )
}
