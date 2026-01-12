import { Metadata } from 'next'
import Link from 'next/link'
import { redirect } from 'next/navigation'
import { createClient } from '@/lib/supabase/server'
import { PostCard } from '@/components/forum'
import type { ForumPostWithAuthor, Forum } from '@/types'

export const metadata: Metadata = {
  title: 'Foro del Curso',
}

interface ForumPageProps {
  params: Promise<{ id: string }>
  searchParams: Promise<{ filter?: string }>
}

export default async function ForumPage({ params, searchParams }: ForumPageProps) {
  const { id: courseId } = await params
  const { filter } = await searchParams
  const supabase = await createClient()

  const { data: { user } } = await supabase.auth.getUser()
  if (!user) redirect('/login')

  // Get course info
  const { data: course } = await supabase
    .from('courses')
    .select('id, title, instructor_id')
    .eq('id', courseId)
    .single()

  if (!course) redirect('/courses')

  // Get forum for this course
  const { data: forum } = await supabase
    .from('forums')
    .select('*')
    .eq('course_id', courseId)
    .single() as { data: Forum | null }

  if (!forum) {
    return (
      <div className="max-w-4xl mx-auto px-4 py-8">
        <p className="text-gray-500 text-center">No hay foro disponible para este curso.</p>
      </div>
    )
  }

  // Build query for posts
  let postsQuery = supabase
    .from('forum_posts')
    .select(`
      *,
      author:profiles!forum_posts_user_id_fkey(id, full_name, avatar_url, role),
      last_reply_author:profiles!forum_posts_last_reply_by_fkey(id, full_name, avatar_url)
    `)
    .eq('forum_id', forum.id)

  // Apply filter
  if (filter === 'resolved') {
    postsQuery = postsQuery.eq('is_resolved', true)
  } else if (filter === 'unresolved') {
    postsQuery = postsQuery.eq('is_resolved', false)
  } else if (filter === 'pinned') {
    postsQuery = postsQuery.eq('is_pinned', true)
  }

  // Order: pinned first, then by last activity
  postsQuery = postsQuery
    .order('is_pinned', { ascending: false })
    .order('last_reply_at', { ascending: false, nullsFirst: false })
    .order('created_at', { ascending: false })

  const { data: posts } = await postsQuery

  const typedPosts = (posts || []) as unknown as ForumPostWithAuthor[]

  return (
    <div className="max-w-4xl mx-auto px-4 py-8">
      {/* Header */}
      <div className="flex items-center justify-between mb-6">
        <div>
          <Link
            href={`/courses/${courseId}`}
            className="text-sm text-rizoma-green dark:text-rizoma-green-light hover:underline mb-2 inline-block"
          >
            &larr; Volver al curso
          </Link>
          <h1 className="text-2xl font-bold text-gray-900 dark:text-white">
            {forum.title}
          </h1>
          {forum.description && (
            <p className="text-gray-600 dark:text-gray-400 mt-1">
              {forum.description}
            </p>
          )}
        </div>
        {!forum.is_locked && (
          <Link
            href={`/courses/${courseId}/forum/new`}
            className="px-5 py-2 bg-rizoma-green text-white rounded-lg font-medium hover:bg-rizoma-green-dark transition-colors"
          >
            Nuevo Post
          </Link>
        )}
      </div>

      {/* Filters */}
      <div className="flex items-center gap-2 mb-6 flex-wrap">
        <Link
          href={`/courses/${courseId}/forum`}
          className={`px-4 py-2 rounded-lg text-sm font-medium transition-colors ${
            !filter
              ? 'bg-rizoma-green/10 dark:bg-rizoma-green-dark/30 text-rizoma-green-dark dark:text-rizoma-green-light'
              : 'bg-gray-100 dark:bg-gray-800 text-gray-600 dark:text-gray-400 hover:bg-gray-200 dark:hover:bg-gray-700'
          }`}
        >
          Todos ({forum.post_count})
        </Link>
        <Link
          href={`/courses/${courseId}/forum?filter=unresolved`}
          className={`px-4 py-2 rounded-lg text-sm font-medium transition-colors ${
            filter === 'unresolved'
              ? 'bg-yellow-100 dark:bg-yellow-900/30 text-yellow-700 dark:text-yellow-300'
              : 'bg-gray-100 dark:bg-gray-800 text-gray-600 dark:text-gray-400 hover:bg-gray-200 dark:hover:bg-gray-700'
          }`}
        >
          Sin resolver
        </Link>
        <Link
          href={`/courses/${courseId}/forum?filter=resolved`}
          className={`px-4 py-2 rounded-lg text-sm font-medium transition-colors ${
            filter === 'resolved'
              ? 'bg-green-100 dark:bg-green-900/30 text-green-700 dark:text-green-300'
              : 'bg-gray-100 dark:bg-gray-800 text-gray-600 dark:text-gray-400 hover:bg-gray-200 dark:hover:bg-gray-700'
          }`}
        >
          Resueltos
        </Link>
      </div>

      {/* Posts list */}
      {typedPosts.length > 0 ? (
        <div className="space-y-4">
          {typedPosts.map((post) => (
            <PostCard key={post.id} post={post} courseId={courseId} />
          ))}
        </div>
      ) : (
        <div className="text-center py-12 bg-gray-50 dark:bg-gray-800/50 rounded-xl">
          <span className="text-5xl block mb-4">💬</span>
          <h3 className="text-lg font-medium text-gray-900 dark:text-white mb-2">
            No hay posts todavia
          </h3>
          <p className="text-gray-600 dark:text-gray-400 mb-4">
            Se el primero en iniciar una discusion
          </p>
          {!forum.is_locked && (
            <Link
              href={`/courses/${courseId}/forum/new`}
              className="inline-block px-5 py-2 bg-rizoma-green text-white rounded-lg font-medium hover:bg-rizoma-green-dark"
            >
              Crear Post
            </Link>
          )}
        </div>
      )}
    </div>
  )
}
