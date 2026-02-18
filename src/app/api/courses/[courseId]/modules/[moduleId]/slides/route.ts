import { NextRequest, NextResponse } from 'next/server'
import { createClient } from '@/lib/supabase/server'
import { parseLesson } from '@/lib/slides/markdown-parser'
import { generatePptx } from '@/lib/slides/generator'
import { promises as fs } from 'fs'
import path from 'path'
import yaml from 'js-yaml'

interface RouteParams {
  params: Promise<{ courseId: string; moduleId: string }>
}

// Read markdown content, resolving file references if needed
async function resolveContent(content: string | null): Promise<string | null> {
  if (!content) return null

  const filePathMatch = content.match(/Ver archivo:\s*(.+\.md)$/i)
  if (filePathMatch) {
    const relativePath = filePathMatch[1].trim()
    const absolutePath = path.join(process.cwd(), relativePath)
    const resolvedPath = path.resolve(absolutePath)
    const contentDir = path.resolve(process.cwd(), 'content')

    if (!resolvedPath.startsWith(contentDir)) return null

    try {
      return await fs.readFile(resolvedPath, 'utf-8')
    } catch {
      return null
    }
  }

  return content
}

// Load quizzes from course_exercises (DB courses)
async function loadQuizzesFromDB(
  supabase: Awaited<ReturnType<typeof createClient>>,
  courseId: string,
  moduleId: string
) {
  const { data } = await supabase
    .from('course_exercises')
    .select('exercise_data, exercise_type')
    .eq('course_id', courseId)
    .eq('module_id', moduleId)
    .in('exercise_type', ['quiz'])

  if (!data) return []

  return data.flatMap(row => {
    const d = row.exercise_data as Record<string, unknown>
    const questions = d.questions as { question: string; options: string[] | { id: string; text: string }[]; correct: number | string; explanation?: string }[]
    if (!questions?.length) return []

    return questions.map(q => {
      // Handle both DB format (string[], integer correct) and canonical format ({id,text}[], string correct)
      const isCanonical = typeof q.options[0] === 'object' && 'id' in (q.options[0] as { id: string })
      const options = isCanonical
        ? (q.options as { id: string; text: string }[])
        : (q.options as string[]).map((text, i) => ({ id: String(i), text }))

      const correctId = typeof q.correct === 'number' ? String(q.correct) : q.correct

      return {
        question: q.question,
        options,
        correctId,
        explanation: q.explanation,
      }
    })
  })
}

// Load quizzes from filesystem YAML
async function loadQuizzesFromFilesystem(courseSlug: string, moduleDir: string) {
  const exercisesDir = path.join(process.cwd(), 'content', 'courses', courseSlug, moduleDir, 'exercises')
  const resolvedDir = path.resolve(exercisesDir)
  const contentRoot = path.resolve(process.cwd(), 'content')

  if (!resolvedDir.startsWith(contentRoot)) return []

  try {
    const entries = await fs.readdir(exercisesDir)
    const quizzes: { question: string; options: { id: string; text: string }[]; correctId: string; explanation?: string }[] = []

    for (const entry of entries) {
      if (!entry.endsWith('.yaml')) continue
      const filePath = path.join(exercisesDir, entry)
      try {
        const content = await fs.readFile(filePath, 'utf-8')
        const exercise = yaml.load(content, { schema: yaml.JSON_SCHEMA }) as Record<string, unknown>
        if (exercise.type !== 'quiz') continue

        const questions = exercise.questions as { id: string; question: string; options: { id: string; text: string }[]; correct: string; explanation?: string; feedback_incorrect?: string }[]
        if (!questions?.length) continue

        for (const q of questions) {
          quizzes.push({
            question: q.question,
            options: q.options,
            correctId: typeof q.correct === 'string' ? q.correct : String(q.correct),
            explanation: q.explanation || q.feedback_incorrect,
          })
        }
      } catch {
        // Skip unreadable files
      }
    }

    return quizzes
  } catch {
    return []
  }
}

// Resolve module directory name from module order_index
function moduleDir(orderIndex: number): string {
  return `module-${String(orderIndex).padStart(2, '0')}`
}

export async function GET(request: NextRequest, { params }: RouteParams) {
  const { courseId, moduleId } = await params

  // Auth check
  const supabase = await createClient()
  const { data: { user } } = await supabase.auth.getUser()
  if (!user) {
    return NextResponse.json({ error: 'Unauthorized' }, { status: 401 })
  }

  try {
    // Fetch course
    const { data: course } = await supabase
      .from('courses')
      .select('id, title, slug, content_source')
      .eq('id', courseId)
      .single()

    if (!course) {
      return NextResponse.json({ error: 'Course not found' }, { status: 404 })
    }

    // Fetch module
    const { data: module } = await supabase
      .from('modules')
      .select('id, title, order_index')
      .eq('id', moduleId)
      .eq('course_id', courseId)
      .single()

    if (!module) {
      return NextResponse.json({ error: 'Module not found' }, { status: 404 })
    }

    // Fetch lessons ordered
    const { data: lessons } = await supabase
      .from('lessons')
      .select('id, title, content, order_index')
      .eq('course_id', courseId)
      .eq('module_id', moduleId)
      .order('order_index', { ascending: true })

    if (!lessons || lessons.length === 0) {
      return NextResponse.json({ error: 'No lessons found' }, { status: 404 })
    }

    // Parse each lesson's markdown into slides
    const parsedLessons = []
    for (let i = 0; i < lessons.length; i++) {
      const lesson = lessons[i]
      const markdown = await resolveContent(lesson.content)
      if (!markdown) continue

      const parsed = parseLesson(markdown, i + 1, lesson.title)
      parsedLessons.push(parsed)
    }

    // Load quizzes
    const slug = course.slug || ''
    const modDir = moduleDir(module.order_index)
    const quizzes = course.content_source === 'database'
      ? await loadQuizzesFromDB(supabase, courseId, moduleId)
      : await loadQuizzesFromFilesystem(slug, modDir)

    // Generate PPTX
    const pptxBuffer = await generatePptx({
      courseTitle: course.title,
      moduleTitle: module.title,
      moduleNumber: module.order_index,
      lessons: parsedLessons,
      quizzes,
    })

    // Sanitize filename
    const filename = `${slug || 'curso'}-modulo-${String(module.order_index).padStart(2, '0')}.pptx`

    return new Response(new Uint8Array(pptxBuffer), {
      headers: {
        'Content-Type': 'application/vnd.openxmlformats-officedocument.presentationml.presentation',
        'Content-Disposition': `attachment; filename="${filename}"`,
        'Content-Length': String(pptxBuffer.length),
      },
    })
  } catch (error) {
    console.error('Error generating slides:', error)
    return NextResponse.json({ error: 'Failed to generate slides' }, { status: 500 })
  }
}
