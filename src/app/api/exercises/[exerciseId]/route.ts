import { NextRequest, NextResponse } from 'next/server'
import { resolveExercise } from '@/lib/content/loaders'
import { loadExerciseFromDB } from '@/lib/content/db-loaders'
import { createClient } from '@/lib/supabase/server'
import { promises as fs } from 'fs'
import path from 'path'
import yaml from 'js-yaml'
import type { Exercise } from '@/types/exercises'

// Input validation patterns
const SAFE_SLUG = /^[a-z0-9][a-z0-9-]*[a-z0-9]$/
const SAFE_MODULE = /^module-\d{2}$/
const SAFE_EXERCISE = /^[a-z0-9][a-z0-9_-]*$/

// Direct path to exercises (without module structure)
const CONTENT_PATH = path.join(process.cwd(), 'content', 'courses')

async function loadExerciseDirectly(
  courseSlug: string,
  exerciseId: string
): Promise<Exercise | null> {
  // Try to find the exercise in the course's module exercises directories
  const coursePath = path.join(CONTENT_PATH, courseSlug)

  // Verify resolved path doesn't escape content directory
  const resolvedCoursePath = path.resolve(coursePath)
  if (!resolvedCoursePath.startsWith(path.resolve(CONTENT_PATH))) {
    return null
  }

  try {
    const entries = await fs.readdir(coursePath, { withFileTypes: true })
    const moduleDirs = entries.filter(e => e.isDirectory() && e.name.startsWith('module-'))

    for (const moduleDir of moduleDirs) {
      const exercisePath = path.join(coursePath, moduleDir.name, 'exercises', `${exerciseId}.yaml`)

      // Verify resolved path doesn't escape content directory
      const resolvedExercisePath = path.resolve(exercisePath)
      if (!resolvedExercisePath.startsWith(path.resolve(CONTENT_PATH))) {
        continue
      }

      try {
        const content = await fs.readFile(exercisePath, 'utf-8')
        return yaml.load(content, { schema: yaml.JSON_SCHEMA }) as Exercise
      } catch {
        // Exercise not in this module, continue searching
      }
    }
  } catch {
    // Course directory doesn't exist or can't be read
  }

  return null
}

export async function GET(
  request: NextRequest,
  { params }: { params: Promise<{ exerciseId: string }> }
) {
  // Auth check
  const supabase = await createClient()
  const { data: { user } } = await supabase.auth.getUser()
  if (!user) {
    return NextResponse.json({ error: 'Unauthorized' }, { status: 401 })
  }

  const { exerciseId } = await params
  const searchParams = request.nextUrl.searchParams
  const courseSlug = searchParams.get('course')
  const moduleId = searchParams.get('module')

  // Input validation
  if (!SAFE_EXERCISE.test(exerciseId)) {
    return NextResponse.json({ error: 'Invalid exercise ID' }, { status: 400 })
  }
  if (courseSlug && !SAFE_SLUG.test(courseSlug)) {
    return NextResponse.json({ error: 'Invalid course slug' }, { status: 400 })
  }
  if (moduleId && !SAFE_MODULE.test(moduleId)) {
    return NextResponse.json({ error: 'Invalid module ID' }, { status: 400 })
  }

  try {
    // Try DB first (AI-generated courses store exercises as JSONB)
    try {
      const dbResult = await loadExerciseFromDB(exerciseId)
      if (dbResult) {
        const { exercise } = dbResult
        return NextResponse.json({
          exercise: { ...exercise, solution_code: undefined, solution_query: undefined },
          datasets: {},
          schema: undefined,
        })
      }
    } catch {
      // DB lookup failed, continue to file-based loading
    }

    let exercise: Exercise | null = null
    let datasets = new Map<string, string>()
    let schema: string | undefined

    // File-based loading only if courseSlug is provided
    if (courseSlug) {
      // If module is provided, try to load with full resolver
      if (moduleId) {
        try {
          const resolved = await resolveExercise(courseSlug, moduleId, exerciseId)
          exercise = resolved.exercise
          datasets = resolved.datasets
          schema = resolved.schema
        } catch {
          // Fall back to direct loading
        }
      }

      // If no module or resolver failed, search all modules
      if (!exercise) {
        exercise = await loadExerciseDirectly(courseSlug, exerciseId)
      }
    }

    if (!exercise) {
      return NextResponse.json(
        { error: 'Exercise not found' },
        { status: 404 }
      )
    }

    // Remove solution code from response (don't expose to client)
    const exerciseForClient = {
      ...exercise,
      solution_code: undefined,
      solution_query: undefined,
    }

    return NextResponse.json({
      exercise: exerciseForClient,
      datasets: Object.fromEntries(datasets),
      schema
    })
  } catch (error) {
    console.error('Error loading exercise:', error)
    return NextResponse.json(
      { error: 'Failed to load exercise' },
      { status: 500 }
    )
  }
}
