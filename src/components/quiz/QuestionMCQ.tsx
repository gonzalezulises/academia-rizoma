'use client'

import type { QuizQuestion, QuizOption } from '@/types'

interface QuestionMCQProps {
  question: QuizQuestion
  selectedAnswer: string | null
  onSelect: (answerId: string) => void
  showResult?: boolean
  disabled?: boolean
}

export default function QuestionMCQ({
  question,
  selectedAnswer,
  onSelect,
  showResult = false,
  disabled = false
}: QuestionMCQProps) {
  const options = question.options as QuizOption[]

  const getOptionStyle = (option: QuizOption) => {
    const isSelected = selectedAnswer === option.id

    if (!showResult) {
      return isSelected
        ? 'border-blue-500 bg-blue-50 dark:bg-blue-900/30'
        : 'border-gray-200 dark:border-gray-700 hover:border-blue-300 dark:hover:border-blue-600'
    }

    // Show results
    if (option.is_correct) {
      return 'border-green-500 bg-green-50 dark:bg-green-900/30'
    }
    if (isSelected && !option.is_correct) {
      return 'border-red-500 bg-red-50 dark:bg-red-900/30'
    }
    return 'border-gray-200 dark:border-gray-700 opacity-50'
  }

  return (
    <div className="space-y-3">
      {options.map((option) => (
        <button
          key={option.id}
          onClick={() => !disabled && onSelect(option.id)}
          disabled={disabled}
          className={`w-full p-4 rounded-lg border-2 text-left transition-all ${getOptionStyle(option)} ${
            disabled ? 'cursor-default' : 'cursor-pointer'
          }`}
        >
          <div className="flex items-start gap-3">
            <span className={`w-6 h-6 rounded-full border-2 flex items-center justify-center text-sm font-medium ${
              selectedAnswer === option.id
                ? 'border-blue-500 bg-blue-500 text-white'
                : 'border-gray-300 dark:border-gray-600 text-gray-500 dark:text-gray-400'
            }`}>
              {option.id.toUpperCase()}
            </span>
            <span className="flex-1 text-gray-800 dark:text-gray-200">
              {option.text}
            </span>
            {showResult && option.is_correct && (
              <span className="text-green-500 text-xl">✓</span>
            )}
            {showResult && selectedAnswer === option.id && !option.is_correct && (
              <span className="text-red-500 text-xl">✗</span>
            )}
          </div>
        </button>
      ))}
    </div>
  )
}
