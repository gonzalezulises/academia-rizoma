'use client'

interface ProgressBarProps {
  percentage: number
  size?: 'sm' | 'md' | 'lg'
  showLabel?: boolean
  color?: 'green' | 'blue' | 'purple'
}

export default function ProgressBar({
  percentage,
  size = 'md',
  showLabel = true,
  color = 'green'
}: ProgressBarProps) {
  const heights = {
    sm: 'h-1.5',
    md: 'h-2.5',
    lg: 'h-4'
  }

  const colors = {
    green: 'bg-green-500',
    blue: 'bg-rizoma-green',
    purple: 'bg-purple-500'
  }

  const safePercentage = Math.min(100, Math.max(0, percentage))

  return (
    <div className="w-full">
      {showLabel && (
        <div className="flex justify-between mb-1">
          <span className="text-sm text-gray-600 dark:text-gray-400">Progreso</span>
          <span className="text-sm font-medium text-gray-900 dark:text-white">
            {Math.round(safePercentage)}%
          </span>
        </div>
      )}
      <div className={`w-full bg-gray-200 dark:bg-gray-700 rounded-full ${heights[size]}`}>
        <div
          className={`${colors[color]} ${heights[size]} rounded-full transition-all duration-500 ease-out`}
          style={{ width: `${safePercentage}%` }}
        />
      </div>
    </div>
  )
}
