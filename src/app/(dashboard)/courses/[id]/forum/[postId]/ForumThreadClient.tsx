'use client'

import { useState } from 'react'
import Link from 'next/link'
import { createClient } from '@/lib/supabase/client'
import { ReplyThread, ReplyForm } from '@/components/forum'
import type { ForumPostFull, ForumReplyWithAuthor, Profile } from '@/types'

interface ForumThreadClientProps {
  post: ForumPostFull
  courseId: string
  currentUser: Profile | null
  isInstructor: boolean
  isAuthor: boolean
}

export default function ForumThreadClient({
  post: initialPost,
  courseId,
  currentUser,
  isInstructor,
  isAuthor
}: ForumThreadClientProps) {
  const [post, setPost] = useState(initialPost)
  const [replies, setReplies] = useState(initialPost.replies)
  const supabase = createClient()

  const formatDate = (date: string) => {
    return new Date(date).toLocaleDateString('es-ES', {
      day: 'numeric',
      month: 'long',
      year: 'numeric',
      hour: '2-digit',
      minute: '2-digit'
    })
  }

  const handleReplyAdded = (newReply: ForumReplyWithAuthor) => {
    if (newReply.parent_reply_id) {
      // Add to nested structure
      const addToNested = (replies: ForumReplyWithAuthor[]): ForumReplyWithAuthor[] => {
        return replies.map((r) => {
          if (r.id === newReply.parent_reply_id) {
            return { ...r, replies: [...(r.replies || []), newReply] }
          }
          if (r.replies && r.replies.length > 0) {
            return { ...r, replies: addToNested(r.replies) }
          }
          return r
        })
      }
      setReplies(addToNested(replies))
    } else {
      // Add to root level
      setReplies([...replies, newReply])
    }
  }

  const handleMarkAsAnswer = async (replyId: string) => {
    // Clear previous answer
    await supabase
      .from('forum_replies')
      .update({ is_answer: false })
      .eq('post_id', post.id)

    // Mark new answer
    const { error } = await supabase
      .from('forum_replies')
      .update({ is_answer: true })
      .eq('id', replyId)

    if (!error) {
      // Mark post as resolved
      await supabase
        .from('forum_posts')
        .update({ is_resolved: true })
        .eq('id', post.id)

      setPost({ ...post, is_resolved: true })

      // Update local state
      const updateAnswer = (replies: ForumReplyWithAuthor[]): ForumReplyWithAuthor[] => {
        return replies.map((r) => ({
          ...r,
          is_answer: r.id === replyId,
          replies: r.replies ? updateAnswer(r.replies) : []
        }))
      }
      setReplies(updateAnswer(replies))
    }
  }

  const handleToggleLock = async () => {
    const { error } = await supabase
      .from('forum_posts')
      .update({ is_locked: !post.is_locked })
      .eq('id', post.id)

    if (!error) {
      setPost({ ...post, is_locked: !post.is_locked })
    }
  }

  const handleTogglePin = async () => {
    const { error } = await supabase
      .from('forum_posts')
      .update({ is_pinned: !post.is_pinned })
      .eq('id', post.id)

    if (!error) {
      setPost({ ...post, is_pinned: !post.is_pinned })
    }
  }

  return (
    <div className="max-w-4xl mx-auto px-4 py-8">
      {/* Back link */}
      <Link
        href={`/courses/${courseId}/forum`}
        className="text-sm text-rizoma-green dark:text-rizoma-green-light hover:underline mb-6 inline-block"
      >
        &larr; Volver al foro
      </Link>

      {/* Post */}
      <article className="bg-white dark:bg-gray-800 rounded-xl p-6 shadow-sm mb-6">
        {/* Badges */}
        <div className="flex items-center gap-2 flex-wrap mb-4">
          {post.is_pinned && (
            <span className="text-xs px-2 py-1 bg-yellow-100 dark:bg-yellow-900/30 text-yellow-700 dark:text-yellow-400 rounded-full">
              Fijado
            </span>
          )}
          {post.is_resolved && (
            <span className="text-xs px-2 py-1 bg-green-100 dark:bg-green-900/30 text-green-700 dark:text-green-400 rounded-full">
              Resuelto
            </span>
          )}
          {post.is_locked && (
            <span className="text-xs px-2 py-1 bg-gray-100 dark:bg-gray-700 text-gray-600 dark:text-gray-400 rounded-full">
              Cerrado
            </span>
          )}
        </div>

        {/* Title */}
        <h1 className="text-2xl font-bold text-gray-900 dark:text-white mb-4">
          {post.title}
        </h1>

        {/* Author info */}
        <div className="flex items-center gap-3 mb-6 pb-4 border-b border-gray-200 dark:border-gray-700">
          {post.author.avatar_url ? (
            <img
              src={post.author.avatar_url}
              alt={post.author.full_name || 'Usuario'}
              className="w-10 h-10 rounded-full object-cover"
            />
          ) : (
            <div className="w-10 h-10 rounded-full bg-rizoma-green/10 dark:bg-rizoma-green-dark/30 flex items-center justify-center">
              <span className="text-rizoma-green dark:text-rizoma-green-light font-medium">
                {(post.author.full_name || 'U')[0].toUpperCase()}
              </span>
            </div>
          )}
          <div>
            <span className="font-medium text-gray-900 dark:text-white">
              {post.author.full_name || 'Usuario'}
            </span>
            <span className="text-gray-500 dark:text-gray-400 text-sm ml-2">
              {formatDate(post.created_at)}
            </span>
          </div>
        </div>

        {/* Content */}
        <div className="prose dark:prose-invert max-w-none text-gray-700 dark:text-gray-300">
          <p className="whitespace-pre-wrap">{post.content}</p>
        </div>

        {/* Stats */}
        <div className="flex items-center gap-4 mt-6 pt-4 border-t border-gray-200 dark:border-gray-700 text-sm text-gray-500 dark:text-gray-400">
          <span className="flex items-center gap-1">
            <svg className="w-4 h-4" fill="none" viewBox="0 0 24 24" stroke="currentColor">
              <path strokeLinecap="round" strokeLinejoin="round" strokeWidth={2} d="M15 12a3 3 0 11-6 0 3 3 0 016 0z" />
              <path strokeLinecap="round" strokeLinejoin="round" strokeWidth={2} d="M2.458 12C3.732 7.943 7.523 5 12 5c4.478 0 8.268 2.943 9.542 7-1.274 4.057-5.064 7-9.542 7-4.477 0-8.268-2.943-9.542-7z" />
            </svg>
            {post.views} vistas
          </span>
          <span className="flex items-center gap-1">
            <svg className="w-4 h-4" fill="none" viewBox="0 0 24 24" stroke="currentColor">
              <path strokeLinecap="round" strokeLinejoin="round" strokeWidth={2} d="M8 12h.01M12 12h.01M16 12h.01M21 12c0 4.418-4.03 8-9 8a9.863 9.863 0 01-4.255-.949L3 20l1.395-3.72C3.512 15.042 3 13.574 3 12c0-4.418 4.03-8 9-8s9 3.582 9 8z" />
            </svg>
            {post.reply_count} respuestas
          </span>
        </div>

        {/* Admin actions */}
        {(isInstructor || isAuthor) && (
          <div className="flex items-center gap-3 mt-4 pt-4 border-t border-gray-200 dark:border-gray-700">
            {isInstructor && (
              <>
                <button
                  onClick={handleTogglePin}
                  className="text-sm text-gray-600 dark:text-gray-400 hover:text-gray-800 dark:hover:text-gray-200"
                >
                  {post.is_pinned ? 'Desfijar' : 'Fijar'}
                </button>
                <button
                  onClick={handleToggleLock}
                  className="text-sm text-gray-600 dark:text-gray-400 hover:text-gray-800 dark:hover:text-gray-200"
                >
                  {post.is_locked ? 'Desbloquear' : 'Bloquear'}
                </button>
              </>
            )}
          </div>
        )}
      </article>

      {/* Replies section */}
      <section>
        <h2 className="text-lg font-semibold text-gray-900 dark:text-white mb-4">
          Respuestas ({post.reply_count})
        </h2>

        {replies.length > 0 ? (
          <div className="space-y-4">
            {replies.map((reply) => (
              <ReplyThread
                key={reply.id}
                reply={reply}
                postId={post.id}
                currentUser={currentUser}
                isPostAuthor={isAuthor}
                onReplyAdded={handleReplyAdded}
                onMarkAsAnswer={isAuthor ? handleMarkAsAnswer : undefined}
              />
            ))}
          </div>
        ) : (
          <p className="text-gray-500 dark:text-gray-400 text-center py-8">
            No hay respuestas todavia. Se el primero en responder.
          </p>
        )}

        {/* Reply form */}
        {currentUser && !post.is_locked && (
          <div className="mt-6">
            <h3 className="text-md font-medium text-gray-900 dark:text-white mb-3">
              Tu respuesta
            </h3>
            <ReplyForm
              postId={post.id}
              currentUser={currentUser}
              onSubmit={handleReplyAdded}
            />
          </div>
        )}

        {post.is_locked && (
          <div className="mt-6 p-4 bg-gray-100 dark:bg-gray-800 rounded-lg text-center text-gray-600 dark:text-gray-400">
            Este post esta cerrado y no acepta nuevas respuestas.
          </div>
        )}
      </section>
    </div>
  )
}
