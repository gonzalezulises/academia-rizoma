import { createClient } from '@/lib/supabase/server'
import type { Exercise, ExerciseType, LoadedExercise, QuizExerciseQuestion } from '@/types/exercises'

// Simplified quiz question format stored in JSONB by database-first courses
interface DBQuizQuestion {
  question: string
  options: string[]
  correct: number
  explanation?: string
}

/**
 * Normalize a DB exercise_data JSONB into the canonical Exercise interface.
 * Database-first courses (content_source='database') store exercises with
 * `exercise_type` instead of `type` and use simplified quiz question format
 * (string[] options, integer correct index).
 */
function normalizeExercise(raw: Record<string, unknown>, exerciseType: string): Exercise | null {
  const type = (raw.type as string) || (raw.exercise_type as string) || exerciseType
  if (!raw.id || !type || !raw.title) return null

  const base = {
    id: raw.id as string,
    type: type as ExerciseType,
    title: raw.title as string,
    description: (raw.description as string) || '',
    instructions: (raw.instructions as string) || (raw.description as string) || '',
    difficulty: (raw.difficulty as 'beginner' | 'intermediate' | 'advanced') || 'beginner',
    estimated_time_minutes: (raw.estimated_duration_minutes as number) || (raw.estimated_time_minutes as number) || 10,
    points: (raw.points as number) || (raw.total_points as number) || 0,
  }

  if (type === 'quiz') {
    const rawQuestions = raw.questions as (DBQuizQuestion | QuizExerciseQuestion)[] | undefined
    if (!rawQuestions?.length) return null

    // Check if questions are already in canonical format (have .id and .options[].id)
    const firstQ = rawQuestions[0]
    const isCanonical = 'id' in firstQ && typeof firstQ.id === 'string'
      && Array.isArray(firstQ.options) && firstQ.options.length > 0
      && typeof firstQ.options[0] === 'object' && 'id' in firstQ.options[0]

    const questions: QuizExerciseQuestion[] = isCanonical
      ? rawQuestions as QuizExerciseQuestion[]
      : (rawQuestions as DBQuizQuestion[]).map((q, qi) => ({
          id: `q-${qi + 1}`,
          question: q.question,
          type: 'multiple_choice' as const,
          options: q.options.map((text, oi) => ({
            id: String(oi),
            text,
          })),
          correct: String(q.correct),
          points: base.points > 0
            ? Math.round(base.points / rawQuestions.length)
            : 10,
          feedback_incorrect: q.explanation,
          explanation: q.explanation,
        }))

    // Compute total points from questions
    const totalPoints = questions.reduce((sum, q) => sum + q.points, 0)

    return {
      ...base,
      type: 'quiz',
      points: totalPoints || base.points,
      questions,
      passing_score: (raw.passing_score as number) ?? 60,
      config: {
        passing_score: (raw.passing_score as number) ?? 60,
        show_feedback: true,
        allow_retry: true,
      },
    } as Exercise
  }

  if (type === 'reflection') {
    return {
      ...base,
      type: 'reflection',
      reflection_prompt: (raw.prompts as { question: string }[])?.[0]?.question || base.instructions,
    } as Exercise
  }

  if (type === 'case-study') {
    return {
      ...base,
      type: 'case-study',
      scenario_text: (raw.scenario as string) || base.instructions,
      analysis_questions: ((raw.questions as { question: string }[]) || []).map(q => q.question),
    } as Exercise
  }

  // For other types, just patch the type field
  return { ...base } as Exercise
}

/**
 * Load an exercise from the course_exercises table (AI-generated courses).
 * Returns null if not found — caller should fall back to file-based loading.
 */
export async function loadExerciseFromDB(exerciseId: string): Promise<LoadedExercise | null> {
  const supabase = await createClient()
  const { data } = await supabase
    .from('course_exercises')
    .select('exercise_data, exercise_type')
    .eq('exercise_id', exerciseId)
    .single()

  if (!data) return null

  const exercise = normalizeExercise(
    data.exercise_data as Record<string, unknown>,
    data.exercise_type
  )

  if (!exercise) return null

  return { exercise, datasets: new Map(), schema: undefined }
}
