'use client'

import type { Dispatch } from 'react'
import type { LessonWizardState, WizardAction, ConceptBlock, ConceptBlockType } from '../types'
import MarkdownEditor from '../shared/MarkdownEditor'
import AIGenerateButton from '../shared/AIGenerateButton'
import VideoSearch from '../shared/VideoSearch'
import BlockList from '../shared/BlockList'
import { useAIGeneration } from '../hooks/useAIGeneration'

interface ConceptsStepProps {
  state: LessonWizardState
  dispatch: Dispatch<WizardAction>
  courseName?: string
}

const BLOCK_TYPES: { value: ConceptBlockType; label: string }[] = [
  { value: 'explanation', label: 'Explicacion' },
  { value: 'example', label: 'Ejemplo' },
  { value: 'diagram', label: 'Diagrama' },
  { value: 'video', label: 'Video' },
]

export default function ConceptsStep({ state, dispatch, courseName }: ConceptsStepProps) {
  const { concepts, metadata } = state
  const ai = useAIGeneration<{ blocks: { id: string; title: string; type: ConceptBlockType; content: string; order: number }[]; estimatedMinutes: number }>()

  const handleGenerate = async () => {
    const result = await ai.generate('concepts', {
      title: metadata.title,
      objectives: metadata.objectives.filter(o => o.trim()),
      bloomLevel: metadata.bloomLevel,
      courseName,
    })
    if (result && result.blocks) {
      const newBlocks: ConceptBlock[] = result.blocks.map((b, i) => ({
        id: b.id || `block-${Date.now()}-${i}`,
        title: b.title,
        type: b.type || 'explanation',
        content: b.content,
        order: i,
      }))
      dispatch({ type: 'SET_CONCEPTS_BLOCKS', blocks: newBlocks })
    }
  }

  const addBlock = () => {
    const newBlock: ConceptBlock = {
      id: `block-${Date.now()}`,
      title: '',
      type: 'explanation',
      content: '',
      order: concepts.blocks.length,
    }
    dispatch({ type: 'ADD_CONCEPT_BLOCK', block: newBlock })
  }

  return (
    <div className="space-y-6">
      <div>
        <h2 className="text-xl font-semibold text-gray-900 dark:text-white mb-1">
          Conceptos
        </h2>
        <p className="text-sm text-gray-500 dark:text-gray-400">
          Estructura los conceptos clave en bloques. Arrastra para reordenar.
        </p>
      </div>

      <AIGenerateButton
        onClick={handleGenerate}
        isGenerating={ai.isGenerating}
        error={ai.error}
        provider={ai.provider}
        label="Generar conceptos"
      />

      {concepts.blocks.length > 0 ? (
        <BlockList
          items={concepts.blocks}
          onReorder={(blocks) => dispatch({ type: 'REORDER_CONCEPT_BLOCKS', blocks })}
          renderItem={(block, index) => (
            <ConceptBlockEditor
              key={block.id}
              block={block}
              index={index}
              state={state}
              dispatch={dispatch}
            />
          )}
        />
      ) : (
        <div className="text-center py-8 bg-gray-50 dark:bg-gray-800/50 rounded-lg border-2 border-dashed border-gray-300 dark:border-gray-700">
          <p className="text-gray-500 dark:text-gray-400 mb-3">
            No hay bloques de conceptos. Genera con IA o agrega manualmente.
          </p>
        </div>
      )}

      <button
        type="button"
        onClick={addBlock}
        className="w-full py-2 border-2 border-dashed border-gray-300 dark:border-gray-700 rounded-lg text-gray-500 dark:text-gray-400 hover:border-rizoma-green hover:text-rizoma-green transition-colors text-sm"
      >
        + Agregar bloque de concepto
      </button>
    </div>
  )
}

function ConceptBlockEditor({
  block,
  index,
  state,
  dispatch,
}: {
  block: ConceptBlock
  index: number
  state: LessonWizardState
  dispatch: Dispatch<WizardAction>
}) {
  return (
    <div className="border border-gray-200 dark:border-gray-700 rounded-lg overflow-hidden bg-white dark:bg-gray-800">
      <div className="p-3 bg-gray-50 dark:bg-gray-800 flex items-center justify-between">
        <div className="flex items-center gap-3">
          <span className="text-sm text-gray-400">#{index + 1}</span>
          <input
            type="text"
            value={block.title}
            onChange={(e) => dispatch({ type: 'UPDATE_CONCEPT_BLOCK', id: block.id, updates: { title: e.target.value } })}
            className="px-2 py-1 border border-gray-300 dark:border-gray-700 rounded dark:bg-gray-700 dark:text-white text-sm font-medium"
            placeholder="Titulo del bloque"
          />
          <select
            value={block.type}
            onChange={(e) => dispatch({ type: 'UPDATE_CONCEPT_BLOCK', id: block.id, updates: { type: e.target.value as ConceptBlockType } })}
            className="px-2 py-1 border border-gray-300 dark:border-gray-700 rounded dark:bg-gray-700 dark:text-white text-sm"
          >
            {BLOCK_TYPES.map(t => (
              <option key={t.value} value={t.value}>{t.label}</option>
            ))}
          </select>
        </div>
        <button
          type="button"
          onClick={() => dispatch({ type: 'REMOVE_CONCEPT_BLOCK', id: block.id })}
          className="text-red-400 hover:text-red-600 text-sm"
        >
          Eliminar
        </button>
      </div>

      <div className="p-4 space-y-3">
        <MarkdownEditor
          value={block.content}
          onChange={(content) => dispatch({ type: 'UPDATE_CONCEPT_BLOCK', id: block.id, updates: { content } })}
          minHeight="150px"
        />

        {block.type === 'video' && (
          <VideoSearch
            onSelect={(url) => dispatch({ type: 'UPDATE_CONCEPT_BLOCK', id: block.id, updates: { videoUrl: url } })}
            title={state.metadata.title}
            objectives={state.metadata.objectives}
            currentUrl={block.videoUrl || null}
          />
        )}
      </div>
    </div>
  )
}
