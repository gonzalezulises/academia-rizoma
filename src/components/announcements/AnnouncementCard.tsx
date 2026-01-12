'use client'

import type { AnnouncementWithAuthor } from '@/types'

interface AnnouncementCardProps {
  announcement: AnnouncementWithAuthor
  onEdit?: () => void
  onDelete?: () => void
  isInstructor?: boolean
}

export default function AnnouncementCard({
  announcement,
  onEdit,
  onDelete,
  isInstructor
}: AnnouncementCardProps) {
  const formatDate = (date: string) => {
    const d = new Date(date)
    const now = new Date()
    const diff = now.getTime() - d.getTime()
    const hours = Math.floor(diff / (1000 * 60 * 60))
    const days = Math.floor(hours / 24)

    if (hours < 1) return 'hace unos minutos'
    if (hours < 24) return `hace ${hours}h`
    if (days < 7) return `hace ${days} dias`
    return d.toLocaleDateString('es-ES', { day: 'numeric', month: 'long', year: 'numeric' })
  }

  const getSegmentLabel = (segment: string) => {
    const labels: Record<string, string> = {
      all: 'Todos',
      not_started: 'No iniciados',
      in_progress: 'En progreso',
      completed: 'Completados'
    }
    return labels[segment] || segment
  }

  return (
    <div className={`bg-white dark:bg-gray-800 rounded-xl shadow-sm overflow-hidden ${
      announcement.is_pinned ? 'ring-2 ring-yellow-400 dark:ring-yellow-500' : 'border border-gray-200 dark:border-gray-700'
    }`}>
      {/* Header */}
      <div className="px-5 py-4 border-b border-gray-200 dark:border-gray-700 bg-gradient-to-r from-rizoma-green/5 to-rizoma-cyan/5 dark:from-rizoma-green-dark/20 dark:to-rizoma-cyan-dark/20">
        <div className="flex items-start justify-between">
          <div className="flex items-center gap-3">
            <span className="text-2xl">📢</span>
            <div>
              <div className="flex items-center gap-2">
                <h3 className="font-semibold text-gray-900 dark:text-white">
                  {announcement.title}
                </h3>
                {announcement.is_pinned && (
                  <span className="text-xs px-2 py-0.5 bg-yellow-100 dark:bg-yellow-900/30 text-yellow-700 dark:text-yellow-400 rounded-full">
                    Fijado
                  </span>
                )}
              </div>
              <div className="flex items-center gap-2 text-sm text-gray-500 dark:text-gray-400">
                <span>{announcement.author?.full_name || 'Instructor'}</span>
                <span>•</span>
                <span>{formatDate(announcement.created_at)}</span>
                {announcement.target_segment !== 'all' && (
                  <>
                    <span>•</span>
                    <span className="text-xs px-2 py-0.5 bg-gray-100 dark:bg-gray-700 rounded">
                      Para: {getSegmentLabel(announcement.target_segment)}
                    </span>
                  </>
                )}
              </div>
            </div>
          </div>

          {isInstructor && (
            <div className="flex items-center gap-2">
              {onEdit && (
                <button
                  onClick={onEdit}
                  className="p-2 text-gray-500 hover:text-gray-700 dark:hover:text-gray-300"
                  title="Editar"
                >
                  <svg className="w-4 h-4" fill="none" viewBox="0 0 24 24" stroke="currentColor">
                    <path strokeLinecap="round" strokeLinejoin="round" strokeWidth={2} d="M11 5H6a2 2 0 00-2 2v11a2 2 0 002 2h11a2 2 0 002-2v-5m-1.414-9.414a2 2 0 112.828 2.828L11.828 15H9v-2.828l8.586-8.586z" />
                  </svg>
                </button>
              )}
              {onDelete && (
                <button
                  onClick={onDelete}
                  className="p-2 text-red-500 hover:text-red-700"
                  title="Eliminar"
                >
                  <svg className="w-4 h-4" fill="none" viewBox="0 0 24 24" stroke="currentColor">
                    <path strokeLinecap="round" strokeLinejoin="round" strokeWidth={2} d="M19 7l-.867 12.142A2 2 0 0116.138 21H7.862a2 2 0 01-1.995-1.858L5 7m5 4v6m4-6v6m1-10V4a1 1 0 00-1-1h-4a1 1 0 00-1 1v3M4 7h16" />
                  </svg>
                </button>
              )}
            </div>
          )}
        </div>
      </div>

      {/* Content */}
      <div className="px-5 py-4">
        <div className="prose dark:prose-invert prose-sm max-w-none text-gray-700 dark:text-gray-300">
          <p className="whitespace-pre-wrap">{announcement.content}</p>
        </div>
      </div>
    </div>
  )
}
