'use client'

import type { QuizQuestion, QuizOption } from '@/types'

interface QuestionMultiSelectProps {
  question: QuizQuestion
  selectedAnswers: string[]
  onToggle: (answerId: string) => void
  showResult?: boolean
  disabled?: boolean
}

export default function QuestionMultiSelect({
  question,
  selectedAnswers,
  onToggle,
  showResult = false,
  disabled = false
}: QuestionMultiSelectProps) {
  const options = question.options as QuizOption[]

  const getOptionStyle = (option: QuizOption) => {
    const isSelected = selectedAnswers.includes(option.id)

    if (!showResult) {
      return isSelected
        ? 'border-rizoma-green bg-rizoma-green/5 dark:bg-rizoma-green-dark/30'
        : 'border-gray-200 dark:border-gray-700 hover:border-rizoma-green/30 dark:hover:border-rizoma-green'
    }

    // Show results
    if (option.is_correct && isSelected) {
      return 'border-green-500 bg-green-50 dark:bg-green-900/30'
    }
    if (option.is_correct && !isSelected) {
      return 'border-yellow-500 bg-yellow-50 dark:bg-yellow-900/30'
    }
    if (!option.is_correct && isSelected) {
      return 'border-red-500 bg-red-50 dark:bg-red-900/30'
    }
    return 'border-gray-200 dark:border-gray-700 opacity-50'
  }

  return (
    <div className="space-y-3">
      <p className="text-sm text-gray-500 dark:text-gray-400 mb-4">
        Selecciona todas las respuestas correctas
      </p>
      {options.map((option) => {
        const isSelected = selectedAnswers.includes(option.id)

        return (
          <button
            key={option.id}
            onClick={() => !disabled && onToggle(option.id)}
            disabled={disabled}
            className={`w-full p-4 rounded-lg border-2 text-left transition-all ${getOptionStyle(option)} ${
              disabled ? 'cursor-default' : 'cursor-pointer'
            }`}
          >
            <div className="flex items-start gap-3">
              <span className={`w-6 h-6 rounded border-2 flex items-center justify-center text-sm ${
                isSelected
                  ? 'border-rizoma-green bg-rizoma-green text-white'
                  : 'border-gray-300 dark:border-gray-600'
              }`}>
                {isSelected && '✓'}
              </span>
              <span className="flex-1 text-gray-800 dark:text-gray-200">
                {option.text}
              </span>
              {showResult && option.is_correct && isSelected && (
                <span className="text-green-500 text-xl">✓</span>
              )}
              {showResult && option.is_correct && !isSelected && (
                <span className="text-yellow-500 text-sm">Faltante</span>
              )}
              {showResult && !option.is_correct && isSelected && (
                <span className="text-red-500 text-xl">✗</span>
              )}
            </div>
          </button>
        )
      })}
    </div>
  )
}
