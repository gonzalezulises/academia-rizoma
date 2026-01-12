'use client'

import { useState } from 'react'
import { createClient } from '@/lib/supabase/client'
import type { Announcement, AnnouncementSegment } from '@/types'

interface CreateAnnouncementProps {
  courseId: string
  userId: string
  onCreated?: (announcement: Announcement) => void
  onCancel?: () => void
}

export default function CreateAnnouncement({
  courseId,
  userId,
  onCreated,
  onCancel
}: CreateAnnouncementProps) {
  const [title, setTitle] = useState('')
  const [content, setContent] = useState('')
  const [targetSegment, setTargetSegment] = useState<AnnouncementSegment>('all')
  const [isPinned, setIsPinned] = useState(false)
  const [loading, setLoading] = useState(false)
  const [error, setError] = useState<string | null>(null)
  const supabase = createClient()

  const handleSubmit = async (e: React.FormEvent) => {
    e.preventDefault()

    if (!title.trim()) {
      setError('El titulo es requerido')
      return
    }

    if (!content.trim()) {
      setError('El contenido es requerido')
      return
    }

    setLoading(true)
    setError(null)

    const { data, error: createError } = await supabase
      .from('announcements')
      .insert({
        course_id: courseId,
        user_id: userId,
        title: title.trim(),
        content: content.trim(),
        target_segment: targetSegment,
        is_pinned: isPinned
      })
      .select()
      .single()

    if (createError) {
      setError('Error al crear el anuncio')
      setLoading(false)
      return
    }

    onCreated?.(data as Announcement)
    setTitle('')
    setContent('')
    setTargetSegment('all')
    setIsPinned(false)
    setLoading(false)
  }

  return (
    <form onSubmit={handleSubmit} className="bg-white dark:bg-gray-800 rounded-xl p-6 shadow-sm">
      <h3 className="text-lg font-semibold text-gray-900 dark:text-white mb-4">
        Nuevo anuncio
      </h3>

      {error && (
        <div className="mb-4 p-3 bg-red-50 dark:bg-red-900/20 border border-red-200 dark:border-red-800 rounded-lg">
          <p className="text-sm text-red-600 dark:text-red-400">{error}</p>
        </div>
      )}

      <div className="space-y-4">
        {/* Title */}
        <div>
          <label htmlFor="title" className="block text-sm font-medium text-gray-700 dark:text-gray-300 mb-1">
            Titulo
          </label>
          <input
            id="title"
            type="text"
            value={title}
            onChange={(e) => setTitle(e.target.value)}
            placeholder="Ej: Recordatorio de entrega"
            className="w-full px-4 py-3 border border-gray-200 dark:border-gray-600 rounded-lg bg-white dark:bg-gray-800 text-gray-900 dark:text-white placeholder-gray-500 focus:ring-2 focus:ring-rizoma-green focus:border-transparent"
          />
        </div>

        {/* Content */}
        <div>
          <label htmlFor="content" className="block text-sm font-medium text-gray-700 dark:text-gray-300 mb-1">
            Contenido
          </label>
          <textarea
            id="content"
            value={content}
            onChange={(e) => setContent(e.target.value)}
            rows={5}
            placeholder="Escribe el contenido del anuncio..."
            className="w-full px-4 py-3 border border-gray-200 dark:border-gray-600 rounded-lg bg-white dark:bg-gray-800 text-gray-900 dark:text-white placeholder-gray-500 focus:ring-2 focus:ring-rizoma-green focus:border-transparent resize-none"
          />
        </div>

        {/* Options row */}
        <div className="grid grid-cols-2 gap-4">
          {/* Target segment */}
          <div>
            <label htmlFor="segment" className="block text-sm font-medium text-gray-700 dark:text-gray-300 mb-1">
              Destinatarios
            </label>
            <select
              id="segment"
              value={targetSegment}
              onChange={(e) => setTargetSegment(e.target.value as AnnouncementSegment)}
              className="w-full px-4 py-2 border border-gray-200 dark:border-gray-600 rounded-lg bg-white dark:bg-gray-800 text-gray-900 dark:text-white focus:ring-2 focus:ring-rizoma-green focus:border-transparent"
            >
              <option value="all">Todos los estudiantes</option>
              <option value="not_started">No han iniciado</option>
              <option value="in_progress">En progreso</option>
              <option value="completed">Han completado</option>
            </select>
          </div>

          {/* Pin option */}
          <div className="flex items-end">
            <label className="flex items-center gap-2 cursor-pointer">
              <input
                type="checkbox"
                checked={isPinned}
                onChange={(e) => setIsPinned(e.target.checked)}
                className="w-4 h-4 rounded border-gray-300 text-rizoma-green focus:ring-rizoma-green"
              />
              <span className="text-sm text-gray-700 dark:text-gray-300">
                Fijar anuncio
              </span>
            </label>
          </div>
        </div>
      </div>

      {/* Actions */}
      <div className="flex items-center justify-end gap-3 mt-6 pt-4 border-t border-gray-200 dark:border-gray-700">
        {onCancel && (
          <button
            type="button"
            onClick={onCancel}
            className="px-4 py-2 text-gray-600 dark:text-gray-400 hover:text-gray-800 dark:hover:text-gray-200"
          >
            Cancelar
          </button>
        )}
        <button
          type="submit"
          disabled={loading || !title.trim() || !content.trim()}
          className="px-6 py-2 bg-rizoma-green text-white rounded-lg font-medium hover:bg-rizoma-green-dark disabled:opacity-50 disabled:cursor-not-allowed transition-colors"
        >
          {loading ? 'Publicando...' : 'Publicar anuncio'}
        </button>
      </div>
    </form>
  )
}
