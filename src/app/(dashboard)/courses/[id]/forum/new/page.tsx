import { Metadata } from 'next'
import Link from 'next/link'
import { redirect } from 'next/navigation'
import { createClient } from '@/lib/supabase/server'
import Navbar from '@/components/Navbar'
import { CreatePost } from '@/components/forum'
import type { Profile, Forum } from '@/types'

export const metadata: Metadata = {
  title: 'Nuevo Post',
}

interface NewPostPageProps {
  params: Promise<{ id: string }>
}

export default async function NewPostPage({ params }: NewPostPageProps) {
  const { id: courseId } = await params
  const supabase = await createClient()

  const { data: { user } } = await supabase.auth.getUser()
  if (!user) redirect('/auth')

  // Get current user profile
  const { data: profile } = await supabase
    .from('profiles')
    .select('*')
    .eq('id', user.id)
    .single() as { data: Profile | null }

  if (!profile) redirect('/auth')

  // Get course info
  const { data: course } = await supabase
    .from('courses')
    .select('id, title')
    .eq('id', courseId)
    .single()

  if (!course) redirect('/courses')

  // Get forum for this course
  const { data: forum } = await supabase
    .from('forums')
    .select('*')
    .eq('course_id', courseId)
    .single() as { data: Forum | null }

  if (!forum || forum.is_locked) {
    redirect(`/courses/${courseId}/forum`)
  }

  return (
    <div className="min-h-screen bg-gray-50 dark:bg-gray-900">
      <Navbar />
    <div className="max-w-2xl mx-auto px-4 py-8">
      {/* Back link */}
      <Link
        href={`/courses/${courseId}/forum`}
        className="text-sm text-rizoma-green dark:text-rizoma-green-light hover:underline mb-6 inline-block"
      >
        &larr; Volver al foro
      </Link>

      <CreatePost
        forumId={forum.id}
        courseId={courseId}
        currentUser={profile}
      />
    </div>
    </div>
  )
}
