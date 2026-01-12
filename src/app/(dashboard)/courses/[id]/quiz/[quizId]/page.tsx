import { createClient } from '@/lib/supabase/server'
import { notFound, redirect } from 'next/navigation'
import Link from 'next/link'
import Navbar from '@/components/Navbar'
import QuizPlayer from '@/components/quiz/QuizPlayer'
import type { QuizWithQuestions, QuizQuestion } from '@/types'

interface QuizPageProps {
  params: Promise<{ id: string; quizId: string }>
}

export default async function QuizPage({ params }: QuizPageProps) {
  const { id: courseId, quizId } = await params
  const supabase = await createClient()

  // Get current user
  const { data: { user } } = await supabase.auth.getUser()

  if (!user) {
    redirect('/login')
  }

  // Get quiz with questions
  const { data: quiz, error: quizError } = await supabase
    .from('quizzes')
    .select(`
      *,
      questions:quiz_questions(*)
    `)
    .eq('id', quizId)
    .single()

  if (quizError || !quiz) {
    notFound()
  }

  // Get lesson to verify course
  const { data: lesson } = await supabase
    .from('lessons')
    .select('*, course:courses(*)')
    .eq('id', quiz.lesson_id)
    .single()

  if (!lesson || lesson.course_id !== courseId) {
    notFound()
  }

  // Check enrollment
  const isInstructor = user.id === lesson.course?.instructor_id
  if (!isInstructor) {
    const { data: enrollment } = await supabase
      .from('enrollments')
      .select('id')
      .eq('user_id', user.id)
      .eq('course_id', courseId)
      .single()

    if (!enrollment) {
      redirect(`/courses/${courseId}`)
    }
  }

  // Check attempts
  const { data: attempts } = await supabase
    .from('quiz_attempts')
    .select('*')
    .eq('user_id', user.id)
    .eq('quiz_id', quizId)
    .order('started_at', { ascending: false })

  const completedAttempts = attempts?.filter(a => a.completed_at) || []
  const inProgressAttempt = attempts?.find(a => !a.completed_at)
  const bestScore = completedAttempts.length > 0
    ? Math.max(...completedAttempts.map(a => a.score || 0))
    : null
  const canAttempt = quiz.max_attempts === null || completedAttempts.length < quiz.max_attempts

  // Sort questions
  const questions = (quiz.questions as QuizQuestion[]).sort(
    (a, b) => a.order_index - b.order_index
  )

  const quizWithQuestions: QuizWithQuestions = {
    ...quiz,
    questions
  }

  return (
    <div className="min-h-screen bg-gray-50 dark:bg-gray-900">
      <Navbar />

      <div className="max-w-4xl mx-auto px-4 sm:px-6 lg:px-8 py-8">
        {/* Back link */}
        <Link
          href={`/courses/${courseId}/lessons/${lesson.id}`}
          className="text-sm text-rizoma-green dark:text-rizoma-green-light hover:underline flex items-center gap-1 mb-6"
        >
          <span>&larr;</span> Volver a la leccion
        </Link>

        {/* Quiz header */}
        <div className="bg-white dark:bg-gray-800 rounded-xl p-6 shadow-sm mb-8">
          <div className="flex items-start justify-between">
            <div>
              <span className="text-4xl mb-4 block">❓</span>
              <h1 className="text-2xl font-bold text-gray-900 dark:text-white mb-2">
                {quiz.title}
              </h1>
              {quiz.description && (
                <p className="text-gray-600 dark:text-gray-400 mb-4">
                  {quiz.description}
                </p>
              )}
            </div>
          </div>

          {/* Quiz info */}
          <div className="grid grid-cols-2 md:grid-cols-4 gap-4 mt-6 pt-6 border-t border-gray-200 dark:border-gray-700">
            <div>
              <p className="text-sm text-gray-500 dark:text-gray-400">Preguntas</p>
              <p className="text-lg font-semibold text-gray-900 dark:text-white">
                {questions.length}
              </p>
            </div>
            <div>
              <p className="text-sm text-gray-500 dark:text-gray-400">Puntaje minimo</p>
              <p className="text-lg font-semibold text-gray-900 dark:text-white">
                {quiz.passing_score}%
              </p>
            </div>
            <div>
              <p className="text-sm text-gray-500 dark:text-gray-400">Tiempo limite</p>
              <p className="text-lg font-semibold text-gray-900 dark:text-white">
                {quiz.time_limit ? `${quiz.time_limit} min` : 'Sin limite'}
              </p>
            </div>
            <div>
              <p className="text-sm text-gray-500 dark:text-gray-400">Intentos</p>
              <p className="text-lg font-semibold text-gray-900 dark:text-white">
                {completedAttempts.length}
                {quiz.max_attempts && ` / ${quiz.max_attempts}`}
              </p>
            </div>
          </div>

          {/* Best score */}
          {bestScore !== null && (
            <div className="mt-6 p-4 bg-gray-50 dark:bg-gray-700/50 rounded-lg">
              <div className="flex items-center justify-between">
                <span className="text-gray-600 dark:text-gray-400">
                  Tu mejor puntaje:
                </span>
                <span className={`text-xl font-bold ${
                  bestScore >= quiz.passing_score
                    ? 'text-green-600 dark:text-green-400'
                    : 'text-yellow-600 dark:text-yellow-400'
                }`}>
                  {Math.round(bestScore)}%
                  {bestScore >= quiz.passing_score && ' ✓'}
                </span>
              </div>
            </div>
          )}
        </div>

        {/* Quiz content */}
        {!canAttempt && !inProgressAttempt ? (
          <div className="bg-yellow-50 dark:bg-yellow-900/20 border border-yellow-200 dark:border-yellow-800 rounded-xl p-8 text-center">
            <span className="text-5xl block mb-4">🚫</span>
            <h3 className="text-xl font-semibold text-gray-900 dark:text-white mb-2">
              Has agotado tus intentos
            </h3>
            <p className="text-gray-600 dark:text-gray-400">
              Este quiz permite maximo {quiz.max_attempts} intento{quiz.max_attempts !== 1 ? 's' : ''}.
            </p>
            {bestScore !== null && bestScore >= quiz.passing_score && (
              <p className="text-green-600 dark:text-green-400 mt-4">
                Pero no te preocupes, ya aprobaste con {Math.round(bestScore)}%
              </p>
            )}
          </div>
        ) : (
          <QuizPlayer
            quiz={quizWithQuestions}
            userId={user.id}
            attemptId={inProgressAttempt?.id}
          />
        )}

        {/* Previous attempts */}
        {completedAttempts.length > 0 && (
          <div className="mt-8">
            <h3 className="text-lg font-semibold text-gray-900 dark:text-white mb-4">
              Intentos anteriores
            </h3>
            <div className="bg-white dark:bg-gray-800 rounded-xl overflow-hidden">
              <table className="w-full">
                <thead className="bg-gray-50 dark:bg-gray-700">
                  <tr>
                    <th className="px-4 py-3 text-left text-sm font-medium text-gray-500 dark:text-gray-400">
                      #
                    </th>
                    <th className="px-4 py-3 text-left text-sm font-medium text-gray-500 dark:text-gray-400">
                      Fecha
                    </th>
                    <th className="px-4 py-3 text-left text-sm font-medium text-gray-500 dark:text-gray-400">
                      Puntaje
                    </th>
                    <th className="px-4 py-3 text-left text-sm font-medium text-gray-500 dark:text-gray-400">
                      Tiempo
                    </th>
                    <th className="px-4 py-3 text-left text-sm font-medium text-gray-500 dark:text-gray-400">
                      Resultado
                    </th>
                  </tr>
                </thead>
                <tbody className="divide-y divide-gray-200 dark:divide-gray-700">
                  {completedAttempts.map((attempt, index) => (
                    <tr key={attempt.id}>
                      <td className="px-4 py-3 text-gray-900 dark:text-white">
                        {completedAttempts.length - index}
                      </td>
                      <td className="px-4 py-3 text-gray-600 dark:text-gray-400">
                        {new Date(attempt.completed_at).toLocaleDateString('es-ES', {
                          day: 'numeric',
                          month: 'short',
                          hour: '2-digit',
                          minute: '2-digit'
                        })}
                      </td>
                      <td className="px-4 py-3 text-gray-900 dark:text-white font-medium">
                        {Math.round(attempt.score || 0)}%
                      </td>
                      <td className="px-4 py-3 text-gray-600 dark:text-gray-400">
                        {attempt.time_taken
                          ? `${Math.floor(attempt.time_taken / 60)}:${(attempt.time_taken % 60).toString().padStart(2, '0')}`
                          : '-'}
                      </td>
                      <td className="px-4 py-3">
                        <span className={`inline-flex px-2 py-1 rounded-full text-xs font-medium ${
                          attempt.passed
                            ? 'bg-green-100 dark:bg-green-900/30 text-green-700 dark:text-green-400'
                            : 'bg-red-100 dark:bg-red-900/30 text-red-700 dark:text-red-400'
                        }`}>
                          {attempt.passed ? 'Aprobado' : 'No aprobado'}
                        </span>
                      </td>
                    </tr>
                  ))}
                </tbody>
              </table>
            </div>
          </div>
        )}
      </div>
    </div>
  )
}
