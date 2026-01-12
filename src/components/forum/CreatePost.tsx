'use client'

import { useState } from 'react'
import { useRouter } from 'next/navigation'
import { createClient } from '@/lib/supabase/client'
import type { Profile } from '@/types'

interface CreatePostProps {
  forumId: string
  courseId: string
  currentUser: Profile
}

export default function CreatePost({ forumId, courseId, currentUser }: CreatePostProps) {
  const [title, setTitle] = useState('')
  const [content, setContent] = useState('')
  const [loading, setLoading] = useState(false)
  const [error, setError] = useState<string | null>(null)
  const router = useRouter()
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

    const { data, error: submitError } = await supabase
      .from('forum_posts')
      .insert({
        forum_id: forumId,
        user_id: currentUser.id,
        title: title.trim(),
        content: content.trim()
      })
      .select('id')
      .single()

    if (submitError) {
      setError('Error al crear el post')
      setLoading(false)
      return
    }

    router.push(`/courses/${courseId}/forum/${data.id}`)
  }

  return (
    <form onSubmit={handleSubmit} className="bg-white dark:bg-gray-800 rounded-xl p-6 shadow-sm">
      <h2 className="text-xl font-semibold text-gray-900 dark:text-white mb-6">
        Nuevo post
      </h2>

      {error && (
        <div className="mb-4 p-4 bg-red-50 dark:bg-red-900/20 border border-red-200 dark:border-red-800 rounded-lg">
          <p className="text-sm text-red-600 dark:text-red-400">{error}</p>
        </div>
      )}

      <div className="space-y-4">
        <div>
          <label htmlFor="title" className="block text-sm font-medium text-gray-700 dark:text-gray-300 mb-1">
            Titulo
          </label>
          <input
            id="title"
            type="text"
            value={title}
            onChange={(e) => setTitle(e.target.value)}
            placeholder="Escribe un titulo descriptivo..."
            className="w-full px-4 py-3 border border-gray-200 dark:border-gray-600 rounded-lg bg-white dark:bg-gray-800 text-gray-900 dark:text-white placeholder-gray-500 focus:ring-2 focus:ring-rizoma-green focus:border-transparent"
          />
        </div>

        <div>
          <label htmlFor="content" className="block text-sm font-medium text-gray-700 dark:text-gray-300 mb-1">
            Contenido
          </label>
          <textarea
            id="content"
            value={content}
            onChange={(e) => setContent(e.target.value)}
            placeholder="Describe tu pregunta o tema en detalle..."
            rows={8}
            className="w-full px-4 py-3 border border-gray-200 dark:border-gray-600 rounded-lg bg-white dark:bg-gray-800 text-gray-900 dark:text-white placeholder-gray-500 focus:ring-2 focus:ring-rizoma-green focus:border-transparent resize-none"
          />
          <p className="mt-1 text-sm text-gray-500 dark:text-gray-400">
            Tip: Se especifico y proporciona contexto para obtener mejores respuestas.
          </p>
        </div>
      </div>

      <div className="flex items-center justify-end gap-3 mt-6 pt-4 border-t border-gray-200 dark:border-gray-700">
        <button
          type="button"
          onClick={() => router.back()}
          className="px-5 py-2 text-gray-600 dark:text-gray-400 hover:text-gray-800 dark:hover:text-gray-200"
        >
          Cancelar
        </button>
        <button
          type="submit"
          disabled={loading || !title.trim() || !content.trim()}
          className="px-6 py-2 bg-rizoma-green text-white rounded-lg font-medium hover:bg-rizoma-green-dark disabled:opacity-50 disabled:cursor-not-allowed transition-colors"
        >
          {loading ? 'Publicando...' : 'Publicar'}
        </button>
      </div>
    </form>
  )
}
