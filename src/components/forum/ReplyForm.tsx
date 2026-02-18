'use client'

import { useState } from 'react'
import { createClient } from '@/lib/supabase/client'
import type { Profile, ForumReplyWithAuthor } from '@/types'

interface ReplyFormProps {
  postId: string
  parentReplyId?: string
  currentUser: Profile
  onSubmit: (reply: ForumReplyWithAuthor) => void
  onCancel?: () => void
}

export default function ReplyForm({
  postId,
  parentReplyId,
  currentUser,
  onSubmit,
  onCancel
}: ReplyFormProps) {
  const [content, setContent] = useState('')
  const [loading, setLoading] = useState(false)
  const [error, setError] = useState<string | null>(null)
  const supabase = createClient()

  const handleSubmit = async (e: React.FormEvent) => {
    e.preventDefault()

    if (!content.trim()) {
      setError('El contenido no puede estar vacio')
      return
    }

    setLoading(true)
    setError(null)

    const { data, error: submitError } = await supabase
      .from('forum_replies')
      .insert({
        post_id: postId,
        user_id: currentUser.id,
        parent_reply_id: parentReplyId || null,
        content: content.trim()
      })
      .select('*')
      .single()

    if (submitError) {
      setError('Error al publicar la respuesta')
      setLoading(false)
      return
    }

    const newReply: ForumReplyWithAuthor = {
      ...data,
      author: currentUser,
      replies: []
    }

    onSubmit(newReply)
    setContent('')
    setLoading(false)
  }

  return (
    <form onSubmit={handleSubmit} className="bg-gray-50 dark:bg-gray-800/50 rounded-xl p-4">
      <div className="flex items-start gap-3">
        {currentUser.avatar_url ? (
          // eslint-disable-next-line @next/next/no-img-element
          <img
            src={currentUser.avatar_url}
            alt={currentUser.full_name || 'Usuario'}
            className="w-8 h-8 rounded-full object-cover flex-shrink-0"
          />
        ) : (
          <div className="w-8 h-8 rounded-full bg-rizoma-green/10 dark:bg-rizoma-green-dark/30 flex items-center justify-center flex-shrink-0">
            <span className="text-rizoma-green dark:text-rizoma-green-light font-medium text-sm">
              {(currentUser.full_name || 'U')[0].toUpperCase()}
            </span>
          </div>
        )}

        <div className="flex-1">
          <textarea
            value={content}
            onChange={(e) => setContent(e.target.value)}
            placeholder="Escribe tu respuesta..."
            rows={3}
            className="w-full px-4 py-3 border border-gray-200 dark:border-gray-600 rounded-lg bg-white dark:bg-gray-800 text-gray-900 dark:text-white placeholder-gray-500 focus:ring-2 focus:ring-rizoma-green focus:border-transparent resize-none"
          />

          {error && (
            <p className="mt-2 text-sm text-red-600 dark:text-red-400">{error}</p>
          )}

          <div className="flex items-center justify-end gap-3 mt-3">
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
              disabled={loading || !content.trim()}
              className="px-5 py-2 bg-rizoma-green text-white rounded-lg font-medium hover:bg-rizoma-green-dark disabled:opacity-50 disabled:cursor-not-allowed transition-colors"
            >
              {loading ? 'Publicando...' : 'Responder'}
            </button>
          </div>
        </div>
      </div>
    </form>
  )
}
