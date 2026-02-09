import { createClient } from '@/lib/supabase/server'
import Link from 'next/link'
import Navbar from '@/components/Navbar'

const SQL_COURSE_ID = 'c1d2e3f4-a5b6-4c7d-8e9f-0a1b2c3d4e5f'

const upcomingCourses = [
  {
    id: 'upcoming-python',
    title: 'Introduccion a Python',
    description: 'Aprende Python desde cero con ejercicios practicos interactivos. Ideal para principiantes que quieren dar sus primeros pasos en programacion.',
    initial: 'P',
    gradientFrom: '#3b82f6',
    gradientTo: '#4f46e5',
  },
  {
    id: 'upcoming-human-analytics',
    title: 'Human Analytics',
    description: 'Aprende a tomar decisiones de talento basadas en datos. Metricas de engagement, rotacion, clima y desempeno con herramientas accesibles.',
    initial: 'H',
    gradientFrom: '#f59e0b',
    gradientTo: '#ea580c',
  },
  {
    id: 'upcoming-ona',
    title: 'Desarrollo de ONAs',
    description: 'Aprende a disenar y ejecutar un Analisis de Redes Organizacionales. Diagnostica silos, cuellos de botella y dependencias con casos reales de LATAM.',
    initial: 'O',
    gradientFrom: '#a855f7',
    gradientTo: '#7c3aed',
  },
  {
    id: 'upcoming-ia-proyectos',
    title: 'Practicas de Proyecto con IA',
    description: 'Integra herramientas de inteligencia artificial en la gestion de proyectos. Automatiza reportes, prioriza portafolios y acelera la toma de decisiones.',
    initial: 'I',
    gradientFrom: '#14b8a6',
    gradientTo: '#059669',
  },
  {
    id: 'upcoming-data-analytics',
    title: 'Data Analytics con Python',
    description: 'Curso completo de Data Analytics que cubre Analisis Descriptivo, Predictivo y Prescriptivo usando Python, Pandas y Scikit-Learn.',
    initial: 'D',
    gradientFrom: '#f43f5e',
    gradientTo: '#ec4899',
  },
]

export default async function CoursesPage() {
  const supabase = await createClient()

  const { data: sqlCourse } = await supabase
    .from('courses')
    .select(`
      *,
      instructor:profiles(full_name, avatar_url)
    `)
    .eq('id', SQL_COURSE_ID)
    .single()

  return (
    <div className="min-h-screen bg-gray-50 dark:bg-gray-900">
      <Navbar />
      <div className="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8 py-8">
        <div className="flex justify-between items-center mb-8">
          <h1 className="text-3xl font-bold text-gray-900 dark:text-white">
            Cursos disponibles
          </h1>
        </div>

        <div className="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 gap-6">
          {/* SQL Course - Active */}
          {sqlCourse && (
            <Link
              href={`/courses/${sqlCourse.id}`}
              className="bg-white dark:bg-gray-800 rounded-xl shadow-sm hover:shadow-md transition-shadow overflow-hidden"
            >
              {sqlCourse.thumbnail_url ? (
                <img
                  src={sqlCourse.thumbnail_url}
                  alt={sqlCourse.title}
                  className="w-full h-48 object-cover"
                />
              ) : (
                <div className="w-full h-48 bg-gradient-to-br from-rizoma-green to-rizoma-cyan flex items-center justify-center">
                  <span className="text-white text-4xl font-bold">
                    {sqlCourse.title.charAt(0)}
                  </span>
                </div>
              )}
              <div className="p-6">
                <h3 className="text-lg font-semibold text-gray-900 dark:text-white mb-2">
                  {sqlCourse.title}
                </h3>
                <p className="text-gray-600 dark:text-gray-400 text-sm line-clamp-2 mb-4">
                  {sqlCourse.description}
                </p>
                {sqlCourse.instructor && (
                  <div className="flex items-center">
                    <div className="w-8 h-8 rounded-full bg-gray-200 dark:bg-gray-700 flex items-center justify-center">
                      {sqlCourse.instructor.avatar_url ? (
                        <img
                          src={sqlCourse.instructor.avatar_url}
                          alt={sqlCourse.instructor.full_name}
                          className="w-8 h-8 rounded-full"
                        />
                      ) : (
                        <span className="text-sm font-medium text-gray-600 dark:text-gray-400">
                          {sqlCourse.instructor.full_name?.charAt(0) || 'I'}
                        </span>
                      )}
                    </div>
                    <span className="ml-2 text-sm text-gray-600 dark:text-gray-400">
                      {sqlCourse.instructor.full_name || 'Instructor'}
                    </span>
                  </div>
                )}
              </div>
            </Link>
          )}

          {/* Upcoming Courses - Not clickable */}
          {upcomingCourses.map((course) => (
            <div
              key={course.id}
              className="bg-white dark:bg-gray-800 rounded-xl shadow-sm overflow-hidden opacity-75 relative"
            >
              <div className="w-full h-48 flex items-center justify-center" style={{ background: `linear-gradient(to bottom right, ${course.gradientFrom}, ${course.gradientTo})` }}>
                <span className="text-white text-4xl font-bold">
                  {course.initial}
                </span>
              </div>
              <div className="p-6">
                <h3 className="text-lg font-semibold text-gray-900 dark:text-white mb-2">
                  {course.title}
                </h3>
                <p className="text-gray-600 dark:text-gray-400 text-sm line-clamp-2 mb-4">
                  {course.description}
                </p>
              </div>
              <div className="absolute top-3 right-3 bg-gray-900/70 text-white text-xs font-medium px-3 py-1 rounded-full">
                Proximamente
              </div>
            </div>
          ))}
        </div>
      </div>
    </div>
  )
}
