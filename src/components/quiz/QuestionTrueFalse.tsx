'use client'

import type { QuizQuestion } from '@/types'

interface QuestionTrueFalseProps {
  question: QuizQuestion
  selectedAnswer: string | null
  onSelect: (answer: string) => void
  showResult?: boolean
  disabled?: boolean
}

export default function QuestionTrueFalse({
  question,
  selectedAnswer,
  onSelect,
  showResult = false,
  disabled = false
}: QuestionTrueFalseProps) {
  const correctAnswer = question.correct_answer?.toLowerCase()

  const getButtonStyle = (value: string) => {
    const isSelected = selectedAnswer === value
    const isCorrect = correctAnswer === value

    if (!showResult) {
      return isSelected
        ? value === 'true'
          ? 'border-green-500 bg-green-50 dark:bg-green-900/30'
          : 'border-red-500 bg-red-50 dark:bg-red-900/30'
        : 'border-gray-200 dark:border-gray-700 hover:border-gray-400 dark:hover:border-gray-500'
    }

    // Show results
    if (isCorrect) {
      return 'border-green-500 bg-green-50 dark:bg-green-900/30'
    }
    if (isSelected && !isCorrect) {
      return 'border-red-500 bg-red-50 dark:bg-red-900/30'
    }
    return 'border-gray-200 dark:border-gray-700 opacity-50'
  }

  return (
    <div className="flex gap-4">
      <button
        onClick={() => !disabled && onSelect('true')}
        disabled={disabled}
        className={`flex-1 p-6 rounded-lg border-2 transition-all ${getButtonStyle('true')} ${
          disabled ? 'cursor-default' : 'cursor-pointer'
        }`}
      >
        <div className="flex flex-col items-center gap-2">
          <span className="text-4xl">✓</span>
          <span className="font-medium text-gray-800 dark:text-gray-200">Verdadero</span>
          {showResult && correctAnswer === 'true' && (
            <span className="text-green-600 text-sm font-medium">Correcta</span>
          )}
        </div>
      </button>

      <button
        onClick={() => !disabled && onSelect('false')}
        disabled={disabled}
        className={`flex-1 p-6 rounded-lg border-2 transition-all ${getButtonStyle('false')} ${
          disabled ? 'cursor-default' : 'cursor-pointer'
        }`}
      >
        <div className="flex flex-col items-center gap-2">
          <span className="text-4xl">✗</span>
          <span className="font-medium text-gray-800 dark:text-gray-200">Falso</span>
          {showResult && correctAnswer === 'false' && (
            <span className="text-green-600 text-sm font-medium">Correcta</span>
          )}
        </div>
      </button>
    </div>
  )
}
