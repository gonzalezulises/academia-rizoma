import { Metadata } from 'next'
import { redirect } from 'next/navigation'
import { createClient } from '@/lib/supabase/server'
import ForumThreadClient from './ForumThreadClient'
import type { ForumPostFull, ForumReplyWithAuthor, Profile } from '@/types'

export const metadata: Metadata = {
  title: 'Discusion del Foro',
}

interface ForumThreadPageProps {
  params: Promise<{ id: string; postId: string }>
}

export default async function ForumThreadPage({ params }: ForumThreadPageProps) {
  const { id: courseId, postId } = await params
  const supabase = await createClient()

  const { data: { user } } = await supabase.auth.getUser()
  if (!user) redirect('/login')

  // Get current user profile
  const { data: profile } = await supabase
    .from('profiles')
    .select('*')
    .eq('id', user.id)
    .single() as { data: Profile | null }

  // Get course info
  const { data: course } = await supabase
    .from('courses')
    .select('id, title, instructor_id')
    .eq('id', courseId)
    .single()

  if (!course) redirect('/courses')

  // Get post with author
  const { data: post } = await supabase
    .from('forum_posts')
    .select(`
      *,
      author:profiles!forum_posts_user_id_fkey(id, full_name, avatar_url, role),
      forum:forums(id, title, course_id, is_locked)
    `)
    .eq('id', postId)
    .single()

  if (!post) redirect(`/courses/${courseId}/forum`)

  // Update view count
  await supabase
    .from('forum_posts')
    .update({ views: (post.views || 0) + 1 })
    .eq('id', postId)

  // Get replies with authors (nested structure)
  const { data: replies } = await supabase
    .from('forum_replies')
    .select(`
      *,
      author:profiles!forum_replies_user_id_fkey(id, full_name, avatar_url, role)
    `)
    .eq('post_id', postId)
    .order('created_at', { ascending: true })

  // Build nested reply structure
  const buildReplyTree = (replies: ForumReplyWithAuthor[]): ForumReplyWithAuthor[] => {
    const replyMap = new Map<string, ForumReplyWithAuthor>()
    const rootReplies: ForumReplyWithAuthor[] = []

    // First pass: create map
    replies.forEach((reply) => {
      replyMap.set(reply.id, { ...reply, replies: [] })
    })

    // Second pass: build tree
    replies.forEach((reply) => {
      const mappedReply = replyMap.get(reply.id)!
      if (reply.parent_reply_id) {
        const parent = replyMap.get(reply.parent_reply_id)
        if (parent) {
          parent.replies = parent.replies || []
          parent.replies.push(mappedReply)
        } else {
          rootReplies.push(mappedReply)
        }
      } else {
        rootReplies.push(mappedReply)
      }
    })

    return rootReplies
  }

  const nestedReplies = buildReplyTree((replies || []) as unknown as ForumReplyWithAuthor[])

  const fullPost: ForumPostFull = {
    ...(post as unknown as ForumPostFull),
    replies: nestedReplies
  }

  const isInstructor = course.instructor_id === user.id
  const isAuthor = post.user_id === user.id

  return (
    <ForumThreadClient
      post={fullPost}
      courseId={courseId}
      currentUser={profile}
      isInstructor={isInstructor}
      isAuthor={isAuthor}
    />
  )
}
