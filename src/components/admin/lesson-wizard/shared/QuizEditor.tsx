'use client'

import { useState } from 'react'
import type { WizardQuizQuestion } from '../types'

interface QuizEditorProps {
  question: WizardQuizQuestion
  onChange: (updates: Partial<WizardQuizQuestion>) => void
  onRemove: () => void
  index: number
}

export default function QuizEditor({ question, onChange, onRemove, index }: QuizEditorProps) {
  const [expanded, setExpanded] = useState(true)

  const addOption = () => {
    const newId = `opt-${question.options.length + 1}`
    onChange({ options: [...question.options, { id: newId, text: '' }] })
  }

  const updateOption = (optionId: string, text: string) => {
    onChange({
      options: question.options.map(o =>
        o.id === optionId ? { ...o, text } : o
      ),
    })
  }

  const removeOption = (optionId: string) => {
    onChange({ options: question.options.filter(o => o.id !== optionId) })
  }

  return (
    <div className="border border-gray-200 dark:border-gray-700 rounded-lg overflow-hidden">
      <div
        className="flex items-center justify-between p-3 bg-gray-50 dark:bg-gray-800 cursor-pointer"
        onClick={() => setExpanded(!expanded)}
      >
        <span className="font-medium text-gray-900 dark:text-white text-sm">
          Pregunta {index + 1}: {question.question.slice(0, 50) || 'Sin pregunta'}
          {question.question.length > 50 ? '...' : ''}
        </span>
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
        <div className="p-4 space-y-3">
          {/* Question text */}
          <div>
            <label className="block text-sm font-medium text-gray-700 dark:text-gray-300 mb-1">
              Pregunta
            </label>
            <textarea
              value={question.question}
              onChange={(e) => onChange({ question: e.target.value })}
              rows={2}
              className="w-full px-3 py-2 border border-gray-300 dark:border-gray-700 rounded-lg dark:bg-gray-700 dark:text-white text-sm"
            />
          </div>

          {/* Type and Points */}
          <div className="grid grid-cols-2 gap-3">
            <div>
              <label className="block text-sm font-medium text-gray-700 dark:text-gray-300 mb-1">
                Tipo
              </label>
              <select
                value={question.type}
                onChange={(e) => onChange({ type: e.target.value as WizardQuizQuestion['type'] })}
                className="w-full px-3 py-2 border border-gray-300 dark:border-gray-700 rounded-lg dark:bg-gray-700 dark:text-white text-sm"
              >
                <option value="mcq">Opcion multiple</option>
                <option value="true_false">Verdadero/Falso</option>
                <option value="multiple_select">Seleccion multiple</option>
              </select>
            </div>
            <div>
              <label className="block text-sm font-medium text-gray-700 dark:text-gray-300 mb-1">
                Puntos
              </label>
              <input
                type="number"
                min={1}
                value={question.points}
                onChange={(e) => onChange({ points: parseInt(e.target.value) || 1 })}
                className="w-full px-3 py-2 border border-gray-300 dark:border-gray-700 rounded-lg dark:bg-gray-700 dark:text-white text-sm"
              />
            </div>
          </div>

          {/* Options */}
          <div>
            <label className="block text-sm font-medium text-gray-700 dark:text-gray-300 mb-1">
              Opciones
            </label>
            {question.options.map((option) => (
              <div key={option.id} className="flex items-center gap-2 mb-2">
                <input
                  type={question.type === 'multiple_select' ? 'checkbox' : 'radio'}
                  name={`correct-${question.id}`}
                  checked={
                    Array.isArray(question.correctAnswer)
                      ? question.correctAnswer.includes(option.id)
                      : question.correctAnswer === option.id
                  }
                  onChange={() => {
                    if (question.type === 'multiple_select') {
                      const current = Array.isArray(question.correctAnswer) ? question.correctAnswer : []
                      const newAnswer = current.includes(option.id)
                        ? current.filter(id => id !== option.id)
                        : [...current, option.id]
                      onChange({ correctAnswer: newAnswer })
                    } else {
                      onChange({ correctAnswer: option.id })
                    }
                  }}
                  className="flex-shrink-0"
                />
                <input
                  type="text"
                  value={option.text}
                  onChange={(e) => updateOption(option.id, e.target.value)}
                  className="flex-1 px-3 py-1.5 border border-gray-300 dark:border-gray-700 rounded-lg dark:bg-gray-700 dark:text-white text-sm"
                  placeholder="Texto de la opcion"
                />
                <button
                  type="button"
                  onClick={() => removeOption(option.id)}
                  className="text-red-400 hover:text-red-600 text-sm flex-shrink-0"
                >
                  x
                </button>
              </div>
            ))}
            {question.options.length < 6 && (
              <button
                type="button"
                onClick={addOption}
                className="text-sm text-purple-600 dark:text-purple-400 hover:underline"
              >
                + Agregar opcion
              </button>
            )}
          </div>

          {/* Explanation */}
          <div>
            <label className="block text-sm font-medium text-gray-700 dark:text-gray-300 mb-1">
              Explicacion (feedback incorrecto)
            </label>
            <textarea
              value={question.explanation}
              onChange={(e) => onChange({ explanation: e.target.value })}
              rows={2}
              className="w-full px-3 py-2 border border-gray-300 dark:border-gray-700 rounded-lg dark:bg-gray-700 dark:text-white text-sm"
              placeholder="Explicacion para cuando el estudiante responde incorrectamente"
            />
          </div>
        </div>
      )}
    </div>
  )
}
