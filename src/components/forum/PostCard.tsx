'use client'

import Link from 'next/link'
import type { ForumPostWithAuthor } from '@/types'

interface PostCardProps {
  post: ForumPostWithAuthor
  courseId: string
}

export default function PostCard({ post, courseId }: PostCardProps) {
  const formatDate = (date: string) => {
    const d = new Date(date)
    const now = new Date()
    const diff = now.getTime() - d.getTime()
    const hours = Math.floor(diff / (1000 * 60 * 60))
    const days = Math.floor(hours / 24)

    if (hours < 1) return 'hace unos minutos'
    if (hours < 24) return `hace ${hours}h`
    if (days < 7) return `hace ${days}d`
    return d.toLocaleDateString('es-ES', { day: 'numeric', month: 'short' })
  }

  return (
    <Link
      href={`/courses/${courseId}/forum/${post.id}`}
      className="block bg-white dark:bg-gray-800 rounded-xl p-5 hover:shadow-md transition-shadow border border-gray-200 dark:border-gray-700"
    >
      <div className="flex items-start gap-4">
        {/* Avatar */}
        <div className="flex-shrink-0">
          {post.author.avatar_url ? (
            <img
              src={post.author.avatar_url}
              alt={post.author.full_name || 'Usuario'}
              className="w-10 h-10 rounded-full object-cover"
            />
          ) : (
            <div className="w-10 h-10 rounded-full bg-blue-100 dark:bg-blue-900/30 flex items-center justify-center">
              <span className="text-blue-600 dark:text-blue-400 font-medium">
                {(post.author.full_name || 'U')[0].toUpperCase()}
              </span>
            </div>
          )}
        </div>

        {/* Content */}
        <div className="flex-1 min-w-0">
          <div className="flex items-center gap-2 flex-wrap">
            {post.is_pinned && (
              <span className="text-xs px-2 py-0.5 bg-yellow-100 dark:bg-yellow-900/30 text-yellow-700 dark:text-yellow-400 rounded-full">
                Fijado
              </span>
            )}
            {post.is_resolved && (
              <span className="text-xs px-2 py-0.5 bg-green-100 dark:bg-green-900/30 text-green-700 dark:text-green-400 rounded-full">
                Resuelto
              </span>
            )}
            {post.is_locked && (
              <span className="text-xs px-2 py-0.5 bg-gray-100 dark:bg-gray-700 text-gray-600 dark:text-gray-400 rounded-full">
                Cerrado
              </span>
            )}
          </div>

          <h3 className="text-lg font-semibold text-gray-900 dark:text-white mt-1 truncate">
            {post.title}
          </h3>

          <p className="text-gray-600 dark:text-gray-400 text-sm mt-1 line-clamp-2">
            {post.content.replace(/<[^>]*>/g, '').substring(0, 150)}
            {post.content.length > 150 && '...'}
          </p>

          <div className="flex items-center gap-4 mt-3 text-sm text-gray-500 dark:text-gray-400">
            <span>{post.author.full_name || 'Usuario'}</span>
            <span>{formatDate(post.created_at)}</span>
            <span className="flex items-center gap-1">
              <svg className="w-4 h-4" fill="none" viewBox="0 0 24 24" stroke="currentColor">
                <path strokeLinecap="round" strokeLinejoin="round" strokeWidth={2} d="M8 12h.01M12 12h.01M16 12h.01M21 12c0 4.418-4.03 8-9 8a9.863 9.863 0 01-4.255-.949L3 20l1.395-3.72C3.512 15.042 3 13.574 3 12c0-4.418 4.03-8 9-8s9 3.582 9 8z" />
              </svg>
              {post.reply_count}
            </span>
            <span className="flex items-center gap-1">
              <svg className="w-4 h-4" fill="none" viewBox="0 0 24 24" stroke="currentColor">
                <path strokeLinecap="round" strokeLinejoin="round" strokeWidth={2} d="M15 12a3 3 0 11-6 0 3 3 0 016 0z" />
                <path strokeLinecap="round" strokeLinejoin="round" strokeWidth={2} d="M2.458 12C3.732 7.943 7.523 5 12 5c4.478 0 8.268 2.943 9.542 7-1.274 4.057-5.064 7-9.542 7-4.477 0-8.268-2.943-9.542-7z" />
              </svg>
              {post.views}
            </span>
          </div>

          {post.last_reply_at && (
            <div className="mt-2 pt-2 border-t border-gray-100 dark:border-gray-700 text-xs text-gray-500">
              Ultima respuesta {formatDate(post.last_reply_at)}
              {post.last_reply_author && ` por ${post.last_reply_author.full_name || 'Usuario'}`}
            </div>
          )}
        </div>
      </div>
    </Link>
  )
}
