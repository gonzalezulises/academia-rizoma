'use client'

import { useState } from 'react'
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
  const [downloading, setDownloading] = useState(false)
  const totalLessons = module.lessons?.length || 0
  const progressPercent = totalLessons > 0 ? (completedLessons / totalLessons) * 100 : 0
  const basePath = process.env.NEXT_PUBLIC_BASE_PATH || ''

  const getLessonIcon = (type: string) => {
    switch (type) {
      case 'video': return '🎬'
      case 'text': return '📄'
      case 'quiz': return '❓'
      case 'assignment': return '📝'
      default: return '📚'
    }
  }

  const handleDownloadSlides = async () => {
    setDownloading(true)
    try {
      const res = await fetch(`${basePath}/api/courses/${courseId}/modules/${module.id}/slides`)
      if (!res.ok) throw new Error('Download failed')
      const blob = await res.blob()
      const url = URL.createObjectURL(blob)
      const a = document.createElement('a')
      a.href = url
      a.download = res.headers.get('Content-Disposition')?.match(/filename="(.+)"/)?.[1] || 'presentacion.pptx'
      document.body.appendChild(a)
      a.click()
      a.remove()
      URL.revokeObjectURL(url)
    } catch (err) {
      console.error('Error downloading slides:', err)
    } finally {
      setDownloading(false)
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

        {/* Download presentation button */}
        {!isLocked && totalLessons > 0 && (
          <div className="border-t border-gray-200 dark:border-gray-700 mt-4 pt-4">
            <button
              onClick={handleDownloadSlides}
              disabled={downloading}
              className="flex items-center gap-2 text-sm text-gray-600 dark:text-gray-400 hover:text-green-600 dark:hover:text-green-400 transition-colors disabled:opacity-50 disabled:cursor-wait"
            >
              {downloading ? (
                <svg className="animate-spin h-4 w-4" viewBox="0 0 24 24" fill="none">
                  <circle className="opacity-25" cx="12" cy="12" r="10" stroke="currentColor" strokeWidth="4" />
                  <path className="opacity-75" fill="currentColor" d="M4 12a8 8 0 018-8V0C5.373 0 0 5.373 0 12h4z" />
                </svg>
              ) : (
                <svg className="h-4 w-4" fill="none" viewBox="0 0 24 24" strokeWidth={1.5} stroke="currentColor">
                  <path strokeLinecap="round" strokeLinejoin="round" d="M3 16.5v2.25A2.25 2.25 0 005.25 21h13.5A2.25 2.25 0 0021 18.75V16.5M16.5 12L12 16.5m0 0L7.5 12m4.5 4.5V3" />
                </svg>
              )}
              <span>{downloading ? 'Generando...' : 'Descargar presentacion'}</span>
            </button>
          </div>
        )}
      </div>
    </div>
  )
}
