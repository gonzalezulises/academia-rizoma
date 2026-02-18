'use client'

import { useState } from 'react'
import type { ForumReplyWithAuthor, Profile } from '@/types'
import ReplyForm from './ReplyForm'

interface ReplyThreadProps {
  reply: ForumReplyWithAuthor
  postId: string
  currentUser?: Profile | null
  isPostAuthor: boolean
  onReplyAdded: (reply: ForumReplyWithAuthor) => void
  onMarkAsAnswer?: (replyId: string) => void
  depth?: number
}

export default function ReplyThread({
  reply,
  postId,
  currentUser,
  isPostAuthor,
  onReplyAdded,
  onMarkAsAnswer,
  depth = 0
}: ReplyThreadProps) {
  const [showReplyForm, setShowReplyForm] = useState(false)
  const maxDepth = 3

  const formatDate = (date: string) => {
    const d = new Date(date)
    const now = new Date()
    const diff = now.getTime() - d.getTime()
    const hours = Math.floor(diff / (1000 * 60 * 60))
    const days = Math.floor(hours / 24)

    if (hours < 1) return 'hace unos minutos'
    if (hours < 24) return `hace ${hours}h`
    if (days < 7) return `hace ${days}d`
    return d.toLocaleDateString('es-ES', { day: 'numeric', month: 'short', year: 'numeric' })
  }

  const handleReplySubmit = (newReply: ForumReplyWithAuthor) => {
    onReplyAdded(newReply)
    setShowReplyForm(false)
  }

  return (
    <div className={`${depth > 0 ? 'ml-6 pl-4 border-l-2 border-gray-200 dark:border-gray-700' : ''}`}>
      <div className={`bg-white dark:bg-gray-800 rounded-xl p-4 ${
        reply.is_answer
          ? 'ring-2 ring-green-500 dark:ring-green-400'
          : 'border border-gray-200 dark:border-gray-700'
      }`}>
        {/* Answer badge */}
        {reply.is_answer && (
          <div className="flex items-center gap-2 mb-3 text-green-600 dark:text-green-400">
            <svg className="w-5 h-5" fill="currentColor" viewBox="0 0 20 20">
              <path fillRule="evenodd" d="M10 18a8 8 0 100-16 8 8 0 000 16zm3.707-9.293a1 1 0 00-1.414-1.414L9 10.586 7.707 9.293a1 1 0 00-1.414 1.414l2 2a1 1 0 001.414 0l4-4z" clipRule="evenodd" />
            </svg>
            <span className="text-sm font-medium">Respuesta aceptada</span>
          </div>
        )}

        {/* Header */}
        <div className="flex items-center gap-3 mb-3">
          {reply.author.avatar_url ? (
            // eslint-disable-next-line @next/next/no-img-element
            <img
              src={reply.author.avatar_url}
              alt={reply.author.full_name || 'Usuario'}
              className="w-8 h-8 rounded-full object-cover"
            />
          ) : (
            <div className="w-8 h-8 rounded-full bg-rizoma-green/10 dark:bg-rizoma-green-dark/30 flex items-center justify-center">
              <span className="text-rizoma-green dark:text-rizoma-green-light font-medium text-sm">
                {(reply.author.full_name || 'U')[0].toUpperCase()}
              </span>
            </div>
          )}
          <div>
            <span className="font-medium text-gray-900 dark:text-white">
              {reply.author.full_name || 'Usuario'}
            </span>
            <span className="text-gray-500 dark:text-gray-400 text-sm ml-2">
              {formatDate(reply.created_at)}
            </span>
            {reply.is_edited && (
              <span className="text-gray-400 text-xs ml-2">(editado)</span>
            )}
          </div>
        </div>

        {/* Content */}
        <div className="prose dark:prose-invert prose-sm max-w-none text-gray-700 dark:text-gray-300">
          <p className="whitespace-pre-wrap">{reply.content}</p>
        </div>

        {/* Actions */}
        <div className="flex items-center gap-4 mt-4 pt-3 border-t border-gray-100 dark:border-gray-700">
          {currentUser && depth < maxDepth && (
            <button
              onClick={() => setShowReplyForm(!showReplyForm)}
              className="text-sm text-rizoma-green dark:text-rizoma-green-light hover:text-rizoma-green-dark dark:hover:text-rizoma-green-light"
            >
              Responder
            </button>
          )}

          {isPostAuthor && !reply.is_answer && onMarkAsAnswer && (
            <button
              onClick={() => onMarkAsAnswer(reply.id)}
              className="text-sm text-green-600 dark:text-green-400 hover:text-green-700 dark:hover:text-green-300"
            >
              Marcar como respuesta
            </button>
          )}

          {currentUser?.id === reply.user_id && (
            <button className="text-sm text-gray-500 hover:text-gray-700 dark:hover:text-gray-300">
              Editar
            </button>
          )}
        </div>
      </div>

      {/* Reply form */}
      {showReplyForm && currentUser && (
        <div className="mt-3 ml-6">
          <ReplyForm
            postId={postId}
            parentReplyId={reply.id}
            currentUser={currentUser}
            onSubmit={handleReplySubmit}
            onCancel={() => setShowReplyForm(false)}
          />
        </div>
      )}

      {/* Nested replies */}
      {reply.replies && reply.replies.length > 0 && (
        <div className="mt-3 space-y-3">
          {reply.replies.map((nestedReply) => (
            <ReplyThread
              key={nestedReply.id}
              reply={nestedReply}
              postId={postId}
              currentUser={currentUser}
              isPostAuthor={isPostAuthor}
              onReplyAdded={onReplyAdded}
              onMarkAsAnswer={onMarkAsAnswer}
              depth={depth + 1}
            />
          ))}
        </div>
      )}
    </div>
  )
}
