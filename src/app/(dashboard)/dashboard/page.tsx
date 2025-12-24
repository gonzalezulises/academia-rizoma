import { createClient } from '@/lib/supabase/server'
import { redirect } from 'next/navigation'
import Link from 'next/link'
import Navbar from '@/components/Navbar'
import CourseProgressCard from '@/components/dashboard/CourseProgressCard'
import ProgressBar from '@/components/dashboard/ProgressBar'
import type { CourseProgressWithDetails } from '@/types'

export default async function DashboardPage() {
  const supabase = await createClient()

  const { data: { user } } = await supabase.auth.getUser()

  if (!user) {
    redirect('/login')
  }

  // Get user profile
  const { data: profile } = await supabase
    .from('profiles')
    .select('*')
    .eq('id', user.id)
    .single()

  // Get course progress with course details
  const { data: progressData } = await supabase
    .from('course_progress')
    .select(`
      *,
      course:courses(*),
      current_lesson:lessons(*)
    `)
    .eq('user_id', user.id)
    .order('last_accessed_at', { ascending: false })

  // Get enrollments without progress (just enrolled)
  const { data: enrollments } = await supabase
    .from('enrollments')
    .select(`
      *,
      course:courses(*)
    `)
    .eq('user_id', user.id)

  // Courses in progress
  const coursesInProgress = (progressData || []).filter(
    p => p.progress_percentage > 0 && p.progress_percentage < 100
  ) as CourseProgressWithDetails[]

  // Completed courses
  const completedCourses = (progressData || []).filter(
    p => p.progress_percentage >= 100 || p.completed_at
  ) as CourseProgressWithDetails[]

  // Recent course (for resume)
  const recentCourse = coursesInProgress[0]

  // Calculate overall stats
  const totalEnrolled = enrollments?.length || 0
  const totalCompleted = completedCourses.length
  const totalInProgress = coursesInProgress.length
  const totalTimeSpent = (progressData || []).reduce((acc, p) => acc + (p.total_time_spent || 0), 0)

  const formatDuration = (seconds: number) => {
    if (seconds < 60) return `${seconds}s`
    const mins = Math.floor(seconds / 60)
    if (mins < 60) return `${mins} min`
    const hours = Math.floor(mins / 60)
    return `${hours}h ${mins % 60}m`
  }

  return (
    <div className="min-h-screen bg-gray-50 dark:bg-gray-900">
      <Navbar />

      <div className="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8 py-8">
        {/* Header */}
        <div className="mb-8">
          <h1 className="text-3xl font-bold text-gray-900 dark:text-white">
            Hola, {profile?.full_name || 'Estudiante'}
          </h1>
          <p className="text-gray-600 dark:text-gray-400 mt-1">
            Continua tu aprendizaje donde lo dejaste
          </p>
        </div>

        {/* Stats */}
        <div className="grid grid-cols-2 md:grid-cols-4 gap-4 mb-8">
          <div className="bg-white dark:bg-gray-800 rounded-xl p-4 shadow-sm">
            <p className="text-sm text-gray-500 dark:text-gray-400">Cursos inscritos</p>
            <p className="text-2xl font-bold text-gray-900 dark:text-white">{totalEnrolled}</p>
          </div>
          <div className="bg-white dark:bg-gray-800 rounded-xl p-4 shadow-sm">
            <p className="text-sm text-gray-500 dark:text-gray-400">En progreso</p>
            <p className="text-2xl font-bold text-blue-600 dark:text-blue-400">{totalInProgress}</p>
          </div>
          <div className="bg-white dark:bg-gray-800 rounded-xl p-4 shadow-sm">
            <p className="text-sm text-gray-500 dark:text-gray-400">Completados</p>
            <p className="text-2xl font-bold text-green-600 dark:text-green-400">{totalCompleted}</p>
          </div>
          <div className="bg-white dark:bg-gray-800 rounded-xl p-4 shadow-sm">
            <p className="text-sm text-gray-500 dark:text-gray-400">Tiempo invertido</p>
            <p className="text-2xl font-bold text-purple-600 dark:text-purple-400">
              {formatDuration(totalTimeSpent)}
            </p>
          </div>
        </div>

        {/* Resume Section */}
        {recentCourse && (
          <div className="bg-gradient-to-r from-blue-600 to-purple-600 rounded-xl p-6 mb-8 text-white">
            <div className="flex flex-col md:flex-row md:items-center md:justify-between gap-4">
              <div className="flex-1">
                <p className="text-blue-100 text-sm mb-1">Continuar donde lo dejaste</p>
                <h2 className="text-xl font-bold mb-2">{recentCourse.course.title}</h2>
                {recentCourse.current_lesson && (
                  <p className="text-blue-100 text-sm">
                    Leccion actual: {recentCourse.current_lesson.title}
                  </p>
                )}
                <div className="mt-3 max-w-xs">
                  <ProgressBar
                    percentage={recentCourse.progress_percentage}
                    size="sm"
                    showLabel={false}
                    color="blue"
                  />
                  <p className="text-xs text-blue-100 mt-1">
                    {Math.round(recentCourse.progress_percentage)}% completado
                  </p>
                </div>
              </div>
              <Link
                href={
                  recentCourse.current_lesson
                    ? `/courses/${recentCourse.course.id}/lessons/${recentCourse.current_lesson.id}`
                    : `/courses/${recentCourse.course.id}`
                }
                className="px-6 py-3 bg-white text-blue-600 rounded-lg font-semibold hover:bg-blue-50 transition-colors text-center"
              >
                Retomar curso
              </Link>
            </div>
          </div>
        )}

        {/* Courses in Progress */}
        {coursesInProgress.length > 0 && (
          <section className="mb-8">
            <div className="flex items-center justify-between mb-4">
              <h2 className="text-xl font-semibold text-gray-900 dark:text-white">
                En progreso
              </h2>
              <span className="text-sm text-gray-500 dark:text-gray-400">
                {coursesInProgress.length} curso{coursesInProgress.length !== 1 ? 's' : ''}
              </span>
            </div>
            <div className="grid grid-cols-1 md:grid-cols-2 gap-4">
              {coursesInProgress.map((progress) => (
                <CourseProgressCard key={progress.id} progress={progress} />
              ))}
            </div>
          </section>
        )}

        {/* Completed Courses */}
        {completedCourses.length > 0 && (
          <section className="mb-8">
            <div className="flex items-center justify-between mb-4">
              <h2 className="text-xl font-semibold text-gray-900 dark:text-white">
                Completados
              </h2>
              <span className="text-sm text-gray-500 dark:text-gray-400">
                {completedCourses.length} curso{completedCourses.length !== 1 ? 's' : ''}
              </span>
            </div>
            <div className="grid grid-cols-1 md:grid-cols-2 gap-4">
              {completedCourses.map((progress) => (
                <CourseProgressCard key={progress.id} progress={progress} />
              ))}
            </div>
          </section>
        )}

        {/* Empty State */}
        {totalEnrolled === 0 && (
          <div className="text-center py-12 bg-white dark:bg-gray-800 rounded-xl">
            <div className="text-6xl mb-4">📚</div>
            <h3 className="text-xl font-medium text-gray-900 dark:text-white mb-2">
              Aun no tienes cursos
            </h3>
            <p className="text-gray-600 dark:text-gray-400 mb-6">
              Explora nuestro catalogo y comienza tu aprendizaje
            </p>
            <Link
              href="/courses"
              className="px-6 py-3 bg-blue-600 text-white rounded-lg font-medium hover:bg-blue-700"
            >
              Explorar cursos
            </Link>
          </div>
        )}

        {/* No courses in progress but enrolled */}
        {totalEnrolled > 0 && coursesInProgress.length === 0 && completedCourses.length === 0 && (
          <div className="text-center py-12 bg-white dark:bg-gray-800 rounded-xl">
            <div className="text-6xl mb-4">🚀</div>
            <h3 className="text-xl font-medium text-gray-900 dark:text-white mb-2">
              Listo para comenzar
            </h3>
            <p className="text-gray-600 dark:text-gray-400 mb-6">
              Tienes {totalEnrolled} curso{totalEnrolled !== 1 ? 's' : ''} esperandote
            </p>
            <Link
              href="/courses"
              className="px-6 py-3 bg-blue-600 text-white rounded-lg font-medium hover:bg-blue-700"
            >
              Ver mis cursos
            </Link>
          </div>
        )}
      </div>
    </div>
  )
}
