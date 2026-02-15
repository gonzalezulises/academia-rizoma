import { createClient } from '@/lib/supabase/server'
import type { Exercise, LoadedExercise } from '@/types/exercises'

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

  const exercise = data.exercise_data as Exercise
  return { exercise, datasets: new Map(), schema: undefined }
}
