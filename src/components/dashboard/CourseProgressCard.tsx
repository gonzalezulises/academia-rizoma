'use client'

import Link from 'next/link'
import ProgressBar from './ProgressBar'
import type { CourseProgressWithDetails } from '@/types'

interface CourseProgressCardProps {
  progress: CourseProgressWithDetails
}

export default function CourseProgressCard({ progress }: CourseProgressCardProps) {
  const { course, current_lesson, progress_percentage, last_accessed_at, completed_at } = progress

  const formatTimeAgo = (dateString: string) => {
    const date = new Date(dateString)
    const now = new Date()
    const diffMs = now.getTime() - date.getTime()
    const diffMins = Math.floor(diffMs / 60000)
    const diffHours = Math.floor(diffMins / 60)
    const diffDays = Math.floor(diffHours / 24)

    if (diffMins < 1) return 'Ahora mismo'
    if (diffMins < 60) return `Hace ${diffMins} min`
    if (diffHours < 24) return `Hace ${diffHours}h`
    if (diffDays < 7) return `Hace ${diffDays} dias`
    return date.toLocaleDateString('es-ES', { day: 'numeric', month: 'short' })
  }

  const formatDuration = (seconds: number) => {
    if (seconds < 60) return `${seconds}s`
    const mins = Math.floor(seconds / 60)
    if (mins < 60) return `${mins} min`
    const hours = Math.floor(mins / 60)
    const remainMins = mins % 60
    return `${hours}h ${remainMins}m`
  }

  const isCompleted = completed_at !== null || progress_percentage >= 100

  return (
    <div className="bg-white dark:bg-gray-800 rounded-xl shadow-sm overflow-hidden hover:shadow-md transition-shadow">
      <div className="flex">
        {/* Thumbnail */}
        <div className="w-32 h-32 flex-shrink-0">
          {course.thumbnail_url ? (
            <img
              src={course.thumbnail_url}
              alt={course.title}
              className="w-full h-full object-cover"
            />
          ) : (
            <div className="w-full h-full bg-gradient-to-br from-blue-500 to-purple-600 flex items-center justify-center">
              <span className="text-white text-3xl font-bold">
                {course.title.charAt(0)}
              </span>
            </div>
          )}
        </div>

        {/* Content */}
        <div className="flex-1 p-4 flex flex-col justify-between">
          <div>
            <div className="flex items-start justify-between">
              <h3 className="font-semibold text-gray-900 dark:text-white line-clamp-1">
                {course.title}
              </h3>
              {isCompleted && (
                <span className="ml-2 px-2 py-0.5 bg-green-100 text-green-700 dark:bg-green-900/30 dark:text-green-400 text-xs rounded-full">
                  Completado
                </span>
              )}
            </div>
            <p className="text-sm text-gray-500 dark:text-gray-400 mt-1">
              Ultimo acceso: {formatTimeAgo(last_accessed_at)}
            </p>
          </div>

          <div className="mt-3">
            <ProgressBar percentage={progress_percentage} size="sm" showLabel={false} />
            <div className="flex items-center justify-between mt-2">
              <span className="text-sm text-gray-600 dark:text-gray-400">
                {Math.round(progress_percentage)}% completado
              </span>
              {progress.total_time_spent > 0 && (
                <span className="text-xs text-gray-500 dark:text-gray-500">
                  {formatDuration(progress.total_time_spent)} invertido
                </span>
              )}
            </div>
          </div>
        </div>
      </div>

      {/* Action */}
      <div className="px-4 pb-4">
        <Link
          href={
            current_lesson
              ? `/courses/${course.id}/lessons/${current_lesson.id}`
              : `/courses/${course.id}`
          }
          className={`block w-full py-2 text-center rounded-lg font-medium transition-colors ${
            isCompleted
              ? 'bg-gray-100 text-gray-700 hover:bg-gray-200 dark:bg-gray-700 dark:text-gray-300 dark:hover:bg-gray-600'
              : 'bg-blue-600 text-white hover:bg-blue-700'
          }`}
        >
          {isCompleted ? 'Revisar curso' : current_lesson ? 'Continuar' : 'Comenzar'}
        </Link>
      </div>
    </div>
  )
}
