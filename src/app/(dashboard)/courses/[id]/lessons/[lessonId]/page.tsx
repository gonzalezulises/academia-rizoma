import { createClient } from '@/lib/supabase/server'
import { notFound } from 'next/navigation'
import Link from 'next/link'
import Navbar from '@/components/Navbar'
import LessonPlayer from '@/components/course/LessonPlayer'
import LessonResources from './LessonResources'
import type { Lesson, Module, Quiz, Resource } from '@/types'
import { promises as fs } from 'fs'
import path from 'path'

// Helper to extract file path from content and read markdown
async function getMarkdownContent(content: string | null): Promise<string | null> {
  if (!content) return null

  // Check if content references a file path (e.g., "Ver archivo: content/courses/nextjs-14/module-01/lesson-01.md")
  const filePathMatch = content.match(/Ver archivo:\s*(.+\.md)$/i)

  if (filePathMatch) {
    const relativePath = filePathMatch[1].trim()
    const absolutePath = path.join(process.cwd(), relativePath)

    try {
      const markdownContent = await fs.readFile(absolutePath, 'utf-8')
      return markdownContent
    } catch (error) {
      console.error(`Error reading markdown file: ${absolutePath}`, error)
      return `Error: No se pudo cargar el contenido del archivo "${relativePath}"`
    }
  }

  // If not a file reference, return the content as-is
  return content
}

interface LessonPageProps {
  params: Promise<{ id: string; lessonId: string }>
}

export default async function LessonPage({ params }: LessonPageProps) {
  const { id: courseId, lessonId } = await params
  const supabase = await createClient()

  // Get current user
  const { data: { user } } = await supabase.auth.getUser()

  // Get course info (including slug for exercise loading)
  const { data: course } = await supabase
    .from('courses')
    .select('*')
    .eq('id', courseId)
    .single()

  // Get lesson with module
  const { data: lesson, error: lessonError } = await supabase
    .from('lessons')
    .select(`
      *,
      module:modules(*)
    `)
    .eq('id', lessonId)
    .eq('course_id', courseId)
    .single()

  if (lessonError || !lesson || !course) {
    notFound()
  }

  // Attach course to lesson for compatibility
  const lessonWithCourse = { ...lesson, course }

  // Check access
  const isInstructor = user?.id === course.instructor_id
  if (!course.is_published && !isInstructor) {
    notFound()
  }

  // Check enrollment (for progress tracking, not access)
  let isEnrolled = false
  if (user && !isInstructor) {
    const { data: enrollment } = await supabase
      .from('enrollments')
      .select('id')
      .eq('user_id', user.id)
      .eq('course_id', courseId)
      .single()

    isEnrolled = !!enrollment
  } else if (isInstructor) {
    isEnrolled = true // Instructors always have access
  }

  // Get user progress for this lesson
  let isCompleted = false
  if (user) {
    const { data: progress } = await supabase
      .from('progress')
      .select('completed')
      .eq('user_id', user.id)
      .eq('lesson_id', lessonId)
      .single()

    isCompleted = progress?.completed || false
  }

  // Get quiz for this lesson (if any)
  let quiz: Quiz | null = null
  const { data: quizData } = await supabase
    .from('quizzes')
    .select('*')
    .eq('lesson_id', lessonId)
    .eq('is_published', true)
    .single()

  if (quizData) {
    quiz = quizData as Quiz
  }

  // Get resources for this lesson
  const { data: resources } = await supabase
    .from('resources')
    .select('*')
    .eq('lesson_id', lessonId)
    .order('created_at', { ascending: true })

  // Get all lessons for navigation
  const { data: allLessons } = await supabase
    .from('lessons')
    .select('id, title, order_index, module_id')
    .eq('course_id', courseId)
    .order('order_index', { ascending: true })

  // Get modules for sidebar
  const { data: modules } = await supabase
    .from('modules')
    .select(`
      *,
      lessons(id, title, order_index)
    `)
    .eq('course_id', courseId)
    .order('order_index', { ascending: true })

  // Find prev/next lessons
  const currentIndex = allLessons?.findIndex(l => l.id === lessonId) ?? -1
  const prevLesson = currentIndex > 0 ? allLessons?.[currentIndex - 1] : null
  const nextLesson = currentIndex < (allLessons?.length || 0) - 1 ? allLessons?.[currentIndex + 1] : null

  // Get progress for sidebar
  const progressMap = new Map<string, boolean>()
  if (user) {
    const { data: progressData } = await supabase
      .from('progress')
      .select('lesson_id, completed')
      .eq('user_id', user.id)

    progressData?.forEach(p => {
      progressMap.set(p.lesson_id, p.completed)
    })
  }

  // Read markdown content if lesson content references a file
  const markdownContent = await getMarkdownContent(lesson.content)

  const lessonWithType = {
    ...lesson,
    lesson_type: lesson.lesson_type || 'video',
    is_required: lesson.is_required ?? true,
    parsedContent: markdownContent
  }

  return (
    <div className="min-h-screen bg-gray-50 dark:bg-gray-900">
      <Navbar />

      <div className="flex">
        {/* Sidebar */}
        <aside className="hidden lg:block w-80 bg-white dark:bg-gray-800 border-r border-gray-200 dark:border-gray-700 min-h-[calc(100vh-64px)] overflow-y-auto">
          <div className="p-4 border-b border-gray-200 dark:border-gray-700">
            <Link
              href={`/courses/${courseId}`}
              className="text-sm text-rizoma-green dark:text-rizoma-green-light hover:underline flex items-center gap-1"
            >
              <span>&larr;</span> {course.title}
            </Link>
          </div>

          <nav className="p-4">
            {modules && modules.length > 0 ? (
              modules.map((module: Module & { lessons?: Lesson[] }) => (
                <div key={module.id} className="mb-6">
                  <h3 className="text-sm font-semibold text-gray-500 dark:text-gray-400 uppercase tracking-wider mb-2">
                    {module.title}
                  </h3>
                  <ul className="space-y-1">
                    {module.lessons?.sort((a, b) => a.order_index - b.order_index).map((l, index) => {
                      const isCurrent = l.id === lessonId
                      const isLessonCompleted = progressMap.get(l.id)

                      return (
                        <li key={l.id}>
                          <Link
                            href={`/courses/${courseId}/lessons/${l.id}`}
                            className={`flex items-center gap-2 px-3 py-2 rounded-lg text-sm transition-colors ${
                              isCurrent
                                ? 'bg-rizoma-green/5 dark:bg-rizoma-green-dark/30 text-rizoma-green dark:text-rizoma-green-light font-medium'
                                : 'text-gray-700 dark:text-gray-300 hover:bg-gray-100 dark:hover:bg-gray-700'
                            }`}
                          >
                            <span className={`w-5 h-5 rounded-full text-xs flex items-center justify-center ${
                              isLessonCompleted
                                ? 'bg-green-500 text-white'
                                : isCurrent
                                  ? 'bg-rizoma-green text-white'
                                  : 'bg-gray-200 dark:bg-gray-600 text-gray-600 dark:text-gray-300'
                            }`}>
                              {isLessonCompleted ? '✓' : index + 1}
                            </span>
                            <span className="truncate">{l.title}</span>
                          </Link>
                        </li>
                      )
                    })}
                  </ul>
                </div>
              ))
            ) : (
              <ul className="space-y-1">
                {allLessons?.map((l, index) => {
                  const isCurrent = l.id === lessonId
                  const isLessonCompleted = progressMap.get(l.id)

                  return (
                    <li key={l.id}>
                      <Link
                        href={`/courses/${courseId}/lessons/${l.id}`}
                        className={`flex items-center gap-2 px-3 py-2 rounded-lg text-sm transition-colors ${
                          isCurrent
                            ? 'bg-rizoma-green/5 dark:bg-rizoma-green-dark/30 text-rizoma-green dark:text-rizoma-green-light font-medium'
                            : 'text-gray-700 dark:text-gray-300 hover:bg-gray-100 dark:hover:bg-gray-700'
                        }`}
                      >
                        <span className={`w-5 h-5 rounded-full text-xs flex items-center justify-center ${
                          isLessonCompleted
                            ? 'bg-green-500 text-white'
                            : isCurrent
                              ? 'bg-rizoma-green text-white'
                              : 'bg-gray-200 dark:bg-gray-600 text-gray-600 dark:text-gray-300'
                        }`}>
                          {isLessonCompleted ? '✓' : index + 1}
                        </span>
                        <span className="truncate">{l.title}</span>
                      </Link>
                    </li>
                  )
                })}
              </ul>
            )}
          </nav>
        </aside>

        {/* Main content */}
        <main className="flex-1 min-w-0">
          <div className="max-w-4xl mx-auto px-4 sm:px-6 lg:px-8 py-8">
            {/* Mobile back link */}
            <div className="lg:hidden mb-6">
              <Link
                href={`/courses/${courseId}`}
                className="text-sm text-rizoma-green dark:text-rizoma-green-light hover:underline flex items-center gap-1"
              >
                <span>&larr;</span> Volver al curso
              </Link>
            </div>

            {/* Enrollment banner for non-enrolled users */}
            {user && !isEnrolled && (
              <div className="mb-6 p-4 bg-gradient-to-r from-rizoma-green/10 to-rizoma-cyan/10 border border-rizoma-green/20 rounded-lg">
                <div className="flex items-center justify-between flex-wrap gap-4">
                  <div>
                    <p className="font-medium text-gray-900 dark:text-white">
                      Estas en modo preview
                    </p>
                    <p className="text-sm text-gray-600 dark:text-gray-400">
                      Inscribete para guardar tu progreso y acceder a recursos adicionales.
                    </p>
                  </div>
                  <Link
                    href={`/courses/${courseId}`}
                    className="px-4 py-2 bg-rizoma-green text-white rounded-lg text-sm font-medium hover:bg-rizoma-green-dark transition-colors"
                  >
                    Inscribirme
                  </Link>
                </div>
              </div>
            )}

            {/* Login banner for anonymous users */}
            {!user && (
              <div className="mb-6 p-4 bg-gray-100 dark:bg-gray-800 border border-gray-200 dark:border-gray-700 rounded-lg">
                <div className="flex items-center justify-between flex-wrap gap-4">
                  <div>
                    <p className="font-medium text-gray-900 dark:text-white">
                      Estas en modo preview
                    </p>
                    <p className="text-sm text-gray-600 dark:text-gray-400">
                      Inicia sesion para guardar tu progreso.
                    </p>
                  </div>
                  <Link
                    href="/login"
                    className="px-4 py-2 bg-rizoma-green text-white rounded-lg text-sm font-medium hover:bg-rizoma-green-dark transition-colors"
                  >
                    Iniciar sesion
                  </Link>
                </div>
              </div>
            )}

            {/* Module breadcrumb */}
            {lesson.module && (
              <div className="mb-4">
                <span className="text-sm text-gray-500 dark:text-gray-400">
                  {lesson.module.title}
                </span>
              </div>
            )}

            {/* Lesson content */}
            <LessonPlayer
              lesson={lessonWithType}
              userId={user?.id}
              courseId={courseId}
              courseSlug={course.slug}
              moduleId={lesson.module?.order_index !== undefined
                ? `module-${String(lesson.module.order_index).padStart(2, '0')}`
                : undefined}
              isCompleted={isCompleted}
              isEnrolled={isEnrolled}
              quiz={quiz}
            />

            {/* Resources - only for enrolled users */}
            {user && isEnrolled && (
              <LessonResources
                lessonId={lessonId}
                userId={user.id}
                isInstructor={isInstructor}
                initialResources={(resources || []) as Resource[]}
              />
            )}

            {/* Navigation */}
            <div className="flex items-center justify-between mt-8 pt-8 border-t border-gray-200 dark:border-gray-700">
              {prevLesson ? (
                <Link
                  href={`/courses/${courseId}/lessons/${prevLesson.id}`}
                  className="flex items-center gap-2 text-gray-600 dark:text-gray-400 hover:text-gray-900 dark:hover:text-white"
                >
                  <span>&larr;</span>
                  <div className="text-left">
                    <span className="text-xs text-gray-500 dark:text-gray-500 block">Anterior</span>
                    <span className="text-sm font-medium">{prevLesson.title}</span>
                  </div>
                </Link>
              ) : (
                <div />
              )}

              {nextLesson ? (
                <Link
                  href={`/courses/${courseId}/lessons/${nextLesson.id}`}
                  className="flex items-center gap-2 text-gray-600 dark:text-gray-400 hover:text-gray-900 dark:hover:text-white"
                >
                  <div className="text-right">
                    <span className="text-xs text-gray-500 dark:text-gray-500 block">Siguiente</span>
                    <span className="text-sm font-medium">{nextLesson.title}</span>
                  </div>
                  <span>&rarr;</span>
                </Link>
              ) : (
                <Link
                  href={`/courses/${courseId}`}
                  className="px-4 py-2 bg-green-600 text-white rounded-lg text-sm font-medium hover:bg-green-700"
                >
                  Finalizar curso
                </Link>
              )}
            </div>
          </div>
        </main>
      </div>
    </div>
  )
}
