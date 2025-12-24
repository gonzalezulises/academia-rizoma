import { Metadata } from 'next'
import { redirect } from 'next/navigation'
import Link from 'next/link'
import { createClient } from '@/lib/supabase/server'
import Navbar from '@/components/Navbar'
import AnnouncementsClient from './AnnouncementsClient'
import type { AnnouncementWithAuthor, Profile } from '@/types'

export const metadata: Metadata = {
  title: 'Anuncios del Curso',
}

interface AnnouncementsPageProps {
  params: Promise<{ id: string }>
}

export default async function AnnouncementsPage({ params }: AnnouncementsPageProps) {
  const { id: courseId } = await params
  const supabase = await createClient()

  const { data: { user } } = await supabase.auth.getUser()
  if (!user) redirect('/login')

  // Get user profile
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

  const isInstructor = course.instructor_id === user.id

  // Get announcements with authors
  const { data: announcements } = await supabase
    .from('announcements')
    .select(`
      *,
      author:profiles!announcements_user_id_fkey(id, full_name, avatar_url, role)
    `)
    .eq('course_id', courseId)
    .order('is_pinned', { ascending: false })
    .order('created_at', { ascending: false })

  return (
    <div className="min-h-screen bg-gray-50 dark:bg-gray-900">
      <Navbar />

      <div className="max-w-4xl mx-auto px-4 py-8">
        {/* Header */}
        <div className="flex items-center justify-between mb-6">
          <div>
            <Link
              href={`/courses/${courseId}`}
              className="text-sm text-blue-600 dark:text-blue-400 hover:underline mb-2 inline-block"
            >
              &larr; Volver al curso
            </Link>
            <h1 className="text-2xl font-bold text-gray-900 dark:text-white">
              Anuncios
            </h1>
            <p className="text-gray-600 dark:text-gray-400">
              {course.title}
            </p>
          </div>
        </div>

        <AnnouncementsClient
          courseId={courseId}
          userId={user.id}
          profile={profile}
          isInstructor={isInstructor}
          initialAnnouncements={(announcements || []) as unknown as AnnouncementWithAuthor[]}
        />
      </div>
    </div>
  )
}
