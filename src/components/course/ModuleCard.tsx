'use client'

import Link from 'next/link'
import type { ModuleWithLessons } from '@/types'

interface ModuleCardProps {
  module: ModuleWithLessons
  courseId: string
  isLocked?: boolean
  completedLessons?: number
}

export default function ModuleCard({
  module,
  courseId,
  isLocked = false,
  completedLessons = 0
}: ModuleCardProps) {
  const totalLessons = module.lessons?.length || 0
  const progressPercent = totalLessons > 0 ? (completedLessons / totalLessons) * 100 : 0

  const getLessonIcon = (type: string) => {
    switch (type) {
      case 'video': return '🎬'
      case 'text': return '📄'
      case 'quiz': return '❓'
      case 'assignment': return '📝'
      default: return '📚'
    }
  }

  return (
    <div className={`bg-white dark:bg-gray-800 rounded-xl shadow-sm overflow-hidden ${isLocked ? 'opacity-60' : ''}`}>
      <div className="p-6">
        <div className="flex items-start justify-between mb-4">
          <div className="flex-1">
            <div className="flex items-center gap-2 mb-2">
              {isLocked && <span className="text-lg">🔒</span>}
              <h3 className="text-lg font-semibold text-gray-900 dark:text-white">
                {module.title}
              </h3>
            </div>
            {module.description && (
              <p className="text-gray-600 dark:text-gray-400 text-sm">
                {module.description}
              </p>
            )}
          </div>
          <div className="text-right">
            <span className="text-sm text-gray-500 dark:text-gray-400">
              {completedLessons}/{totalLessons} lecciones
            </span>
          </div>
        </div>

        {/* Progress bar */}
        <div className="w-full bg-gray-200 dark:bg-gray-700 rounded-full h-2 mb-4">
          <div
            className="bg-green-500 h-2 rounded-full transition-all duration-300"
            style={{ width: `${progressPercent}%` }}
          />
        </div>

        {/* Lessons list */}
        <div className="space-y-2">
          {module.lessons?.slice(0, 5).map((lesson, index) => {
            const isCompleted = lesson.progress?.completed
            return (
              <Link
                key={lesson.id}
                href={isLocked ? '#' : `/courses/${courseId}/lessons/${lesson.id}`}
                className={`flex items-center gap-3 p-3 rounded-lg transition-colors ${
                  isLocked
                    ? 'cursor-not-allowed bg-gray-50 dark:bg-gray-700/50'
                    : 'hover:bg-gray-50 dark:hover:bg-gray-700/50'
                }`}
              >
                <span className="text-lg">{getLessonIcon(lesson.lesson_type)}</span>
                <div className="flex-1 min-w-0">
                  <p className={`text-sm font-medium truncate ${
                    isCompleted
                      ? 'text-green-600 dark:text-green-400'
                      : 'text-gray-700 dark:text-gray-300'
                  }`}>
                    {index + 1}. {lesson.title}
                  </p>
                  {lesson.duration_minutes && (
                    <p className="text-xs text-gray-500 dark:text-gray-400">
                      {lesson.duration_minutes} min
                    </p>
                  )}
                </div>
                {isCompleted && (
                  <span className="text-green-500 text-lg">✓</span>
                )}
              </Link>
            )
          })}
          {totalLessons > 5 && (
            <p className="text-center text-sm text-gray-500 dark:text-gray-400 pt-2">
              +{totalLessons - 5} lecciones mas
            </p>
          )}
        </div>
      </div>
    </div>
  )
}
