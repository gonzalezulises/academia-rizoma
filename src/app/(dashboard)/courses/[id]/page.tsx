import { createClient } from '@/lib/supabase/server'
import { notFound, redirect } from 'next/navigation'
import { revalidatePath } from 'next/cache'
import Link from 'next/link'
import Navbar from '@/components/Navbar'
import CourseMap from '@/components/course/CourseMap'
import CourseHero from '@/components/course/CourseHero'
import type { Lesson } from '@/types'

interface CoursePageProps {
  params: Promise<{ id: string }>
}

export default async function CoursePage({ params }: CoursePageProps) {
  const { id } = await params
  const supabase = await createClient()

  // Get current user
  const { data: { user } } = await supabase.auth.getUser()

  // Get course with instructor
  const { data: course, error: courseError } = await supabase
    .from('courses')
    .select(`
      *,
      instructor:profiles!courses_instructor_id_fkey(id, full_name, avatar_url)
    `)
    .eq('id', id)
    .single()

  if (courseError || !course) {
    notFound()
  }

  // Check if course is published or user is the instructor
  const isInstructor = user?.id === course.instructor_id
  if (!course.is_published && !isInstructor) {
    notFound()
  }

  // Get modules with lessons
  const { data: modules } = await supabase
    .from('modules')
    .select(`
      *,
      lessons(*)
    `)
    .eq('course_id', id)
    .order('order_index', { ascending: true })

  // Get lessons that don't belong to any module
  const { data: orphanLessons } = await supabase
    .from('lessons')
    .select('*')
    .eq('course_id', id)
    .is('module_id', null)
    .order('order_index', { ascending: true })

  // Get user progress if logged in
  const userProgress = new Map<string, boolean>()
  let enrollment = null

  if (user) {
    // Check enrollment
    const { data: enrollmentData } = await supabase
      .from('enrollments')
      .select('*')
      .eq('user_id', user.id)
      .eq('course_id', id)
      .single()

    enrollment = enrollmentData

    // Get progress
    const { data: progressData } = await supabase
      .from('progress')
      .select('lesson_id, completed')
      .eq('user_id', user.id)

    if (progressData) {
      progressData.forEach((p: { lesson_id: string; completed: boolean }) => {
        userProgress.set(p.lesson_id, p.completed)
      })
    }
  }

  // Enroll handler - done via server action
  const handleEnroll = async () => {
    'use server'
    const supabase = await createClient()
    const { data: { user } } = await supabase.auth.getUser()

    if (!user) {
      redirect('/auth')
    }

    await supabase.from('enrollments').insert({
      user_id: user.id,
      course_id: id
    })

    revalidatePath(`/courses/${id}`)
  }

  // Format modules with lessons for the CourseMap
  const formattedModules = (modules || []).map(module => ({
    ...module,
    lessons: (module.lessons || []).map((lesson: Lesson) => ({
      ...lesson,
      lesson_type: lesson.lesson_type || 'video',
      is_required: lesson.is_required ?? true,
      progress: userProgress.has(lesson.id)
        ? { id: '', user_id: user?.id || '', lesson_id: lesson.id, completed: userProgress.get(lesson.id) || false, completed_at: null }
        : null
    })).sort((a: Lesson, b: Lesson) => a.order_index - b.order_index)
  }))

  // Create a "General" module for orphan lessons if they exist
  if (orphanLessons && orphanLessons.length > 0) {
    formattedModules.unshift({
      id: 'general',
      course_id: id,
      title: 'Lecciones Generales',
      description: 'Lecciones sin modulo asignado',
      order_index: -1,
      is_locked: false,
      unlock_after_module: null,
      created_at: new Date().toISOString(),
      lessons: orphanLessons.map((lesson: Lesson) => ({
        ...lesson,
        lesson_type: lesson.lesson_type || 'video',
        is_required: lesson.is_required ?? true,
        progress: userProgress.has(lesson.id)
          ? { id: '', user_id: user?.id || '', lesson_id: lesson.id, completed: userProgress.get(lesson.id) || false, completed_at: null }
          : null
      }))
    })
  }

  // Calculate total lessons and completed
  const totalLessons = formattedModules.reduce((acc, m) => acc + (m.lessons?.length || 0), 0)
  const completedLessons = Array.from(userProgress.values()).filter(Boolean).length
  const progressPercent = totalLessons > 0 ? Math.round((completedLessons / totalLessons) * 100) : 0

  return (
    <div className="min-h-screen bg-gray-50 dark:bg-gray-900">
      <Navbar />

      {/* Course Header */}
      <div className="relative text-white">
        {course.thumbnail_url ? (
          <>
            {/* eslint-disable-next-line @next/next/no-img-element */}
            <img
              src={`${process.env.NEXT_PUBLIC_BASE_PATH || ''}${course.thumbnail_url}`}
              alt=""
              className="absolute inset-0 w-full h-full object-cover"
            />
            <div className="absolute inset-0 bg-black/50" />
          </>
        ) : (
          <CourseHero title={course.title} slug={course.slug ?? undefined} size="detail" className="!h-auto absolute inset-0" />
        )}
        <div className="relative z-10 max-w-7xl mx-auto px-4 sm:px-6 lg:px-8 py-12">
          <Link
            href="/courses"
            className="inline-flex items-center text-white/80 hover:text-white mb-6"
          >
            <span className="mr-2">&larr;</span> Volver a cursos
          </Link>

          <div className="flex flex-col lg:flex-row gap-8">
            {/* Course info */}
            <div className="flex-1">
              <h1 className="text-3xl lg:text-4xl font-bold mb-4">
                {course.title}
              </h1>
              {course.description && (
                <p className="text-lg text-white/90 mb-6">
                  {course.description}
                </p>
              )}

              {/* Instructor */}
              {course.instructor && (
                <div className="flex items-center gap-3 mb-6">
                  <div className="w-12 h-12 rounded-full bg-white/20 flex items-center justify-center">
                    {course.instructor.avatar_url ? (
                      // eslint-disable-next-line @next/next/no-img-element
                      <img
                        src={course.instructor.avatar_url}
                        alt={course.instructor.full_name || ''}
                        className="w-12 h-12 rounded-full"
                      />
                    ) : (
                      <span className="text-xl font-bold">
                        {course.instructor.full_name?.charAt(0) || 'I'}
                      </span>
                    )}
                  </div>
                  <div>
                    <p className="text-sm text-white/70">Instructor</p>
                    <p className="font-medium">
                      {course.instructor.full_name || 'Instructor'}
                    </p>
                  </div>
                </div>
              )}

              {/* Stats */}
              <div className="flex flex-wrap gap-6 text-sm">
                <div>
                  <span className="text-white/70">Modulos</span>
                  <p className="font-semibold text-lg">{modules?.length || 0}</p>
                </div>
                <div>
                  <span className="text-white/70">Lecciones</span>
                  <p className="font-semibold text-lg">{totalLessons}</p>
                </div>
                {user && enrollment && (
                  <div>
                    <span className="text-white/70">Tu progreso</span>
                    <p className="font-semibold text-lg">{progressPercent}%</p>
                  </div>
                )}
              </div>

              {/* Course links for enrolled users */}
              {user && enrollment && (
                <div className="flex items-center gap-3 mt-6">
                  <Link
                    href={`/courses/${id}/forum`}
                    className="inline-flex items-center gap-2 px-4 py-2 bg-white/10 hover:bg-white/20 rounded-lg transition-colors"
                  >
                    <svg className="w-5 h-5" fill="none" viewBox="0 0 24 24" stroke="currentColor">
                      <path strokeLinecap="round" strokeLinejoin="round" strokeWidth={2} d="M8 12h.01M12 12h.01M16 12h.01M21 12c0 4.418-4.03 8-9 8a9.863 9.863 0 01-4.255-.949L3 20l1.395-3.72C3.512 15.042 3 13.574 3 12c0-4.418 4.03-8 9-8s9 3.582 9 8z" />
                    </svg>
                    <span>Foro</span>
                  </Link>
                  <Link
                    href={`/courses/${id}/announcements`}
                    className="inline-flex items-center gap-2 px-4 py-2 bg-white/10 hover:bg-white/20 rounded-lg transition-colors"
                  >
                    <svg className="w-5 h-5" fill="none" viewBox="0 0 24 24" stroke="currentColor">
                      <path strokeLinecap="round" strokeLinejoin="round" strokeWidth={2} d="M11 5.882V19.24a1.76 1.76 0 01-3.417.592l-2.147-6.15M18 13a3 3 0 100-6M5.436 13.683A4.001 4.001 0 017 6h1.832c4.1 0 7.625-1.234 9.168-3v14c-1.543-1.766-5.067-3-9.168-3H7a3.988 3.988 0 01-1.564-.317z" />
                    </svg>
                    <span>Anuncios</span>
                  </Link>
                </div>
              )}
            </div>

            {/* Thumbnail / CTA */}
            <div className="lg:w-80">
              <div className="bg-white dark:bg-gray-800 rounded-xl shadow-xl overflow-hidden">
                {course.thumbnail_url ? (
                  // eslint-disable-next-line @next/next/no-img-element
                  <img
                    src={`${process.env.NEXT_PUBLIC_BASE_PATH || ''}${course.thumbnail_url}`}
                    alt={course.title}
                    className="w-full h-44 object-cover"
                  />
                ) : (
                  <CourseHero title={course.title} slug={course.slug ?? undefined} size="card" className="!h-44" />
                )}
                <div className="p-6">
                  {user ? (
                    enrollment ? (
                      <div>
                        {/* Progress bar */}
                        <div className="mb-4">
                          <div className="flex justify-between text-sm mb-2">
                            <span className="text-gray-600 dark:text-gray-400">Progreso</span>
                            <span className="text-gray-900 dark:text-white font-medium">{progressPercent}%</span>
                          </div>
                          <div className="w-full bg-gray-200 dark:bg-gray-700 rounded-full h-2">
                            <div
                              className="bg-green-500 h-2 rounded-full transition-all duration-300"
                              style={{ width: `${progressPercent}%` }}
                            />
                          </div>
                        </div>
                        <Link
                          href={`/courses/${id}/lessons/${formattedModules[0]?.lessons?.[0]?.id || ''}`}
                          className="block w-full py-3 bg-green-600 text-white text-center rounded-lg font-medium hover:bg-green-700 transition-colors"
                        >
                          {progressPercent > 0 ? 'Continuar curso' : 'Comenzar curso'}
                        </Link>
                      </div>
                    ) : (
                      <form action={handleEnroll}>
                        <button
                          type="submit"
                          className="w-full py-3 bg-rizoma-green text-white rounded-lg font-medium hover:bg-rizoma-green-dark transition-colors"
                        >
                          Inscribirme al curso
                        </button>
                      </form>
                    )
                  ) : (
                    <Link
                      href="/auth"
                      className="block w-full py-3 bg-rizoma-green text-white text-center rounded-lg font-medium hover:bg-rizoma-green-dark transition-colors"
                    >
                      Inicia sesion para inscribirte
                    </Link>
                  )}
                </div>
              </div>
            </div>
          </div>
        </div>
      </div>

      {/* Course Content */}
      <div className="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8 py-12">
        {isInstructor && !course.is_published && (
          <div className="mb-6 p-4 bg-yellow-50 dark:bg-yellow-900/20 border border-yellow-200 dark:border-yellow-800 rounded-lg">
            <p className="text-yellow-800 dark:text-yellow-200">
              <strong>Nota:</strong> Este curso no esta publicado. Solo tu puedes verlo.
            </p>
          </div>
        )}

        <CourseMap
          modules={formattedModules}
          courseId={id}
          userProgress={userProgress}
        />
      </div>
    </div>
  )
}
