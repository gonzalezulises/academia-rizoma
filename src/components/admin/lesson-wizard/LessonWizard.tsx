'use client'

import { useState, useEffect, useCallback } from 'react'
import { useRouter } from 'next/navigation'
import { createClient } from '@/lib/supabase/client'
import { useLessonWizard, assembleMarkdown } from './hooks/useLessonWizard'
import { WIZARD_STEPS } from './types'
import type { LessonWizardState, ExerciseDefinition, WizardQuizQuestion } from './types'
import type { Module } from '@/types'
import MetadataStep from './steps/MetadataStep'
import ConnectionStep from './steps/ConnectionStep'
import ConceptsStep from './steps/ConceptsStep'
import PracticeStep from './steps/PracticeStep'
import ConclusionsStep from './steps/ConclusionsStep'
import ReviewStep from './steps/ReviewStep'
import ValidationChecklist from './shared/ValidationChecklist'

interface LessonWizardProps {
  courseId: string
  lessonId?: string
}

export default function LessonWizard({ courseId, lessonId }: LessonWizardProps) {
  const router = useRouter()
  const supabase = createClient()
  const [modules, setModules] = useState<Module[]>([])
  const [courseName, setCourseName] = useState('')
  const [saving, setSaving] = useState(false)
  const [saveError, setSaveError] = useState<string | null>(null)

  // storageKey: use lessonId for edits, courseId+new for new lessons
  const storageKey = lessonId ? `edit-${lessonId}` : `new-${courseId}`

  const { state, dispatch, validation, canProceed, markdownPreview, goToStep, nextStep, prevStep, clearDraft } =
    useLessonWizard(undefined, storageKey)

  // Load course data and modules
  useEffect(() => {
    const loadCourseData = async () => {
      const { data: course } = await supabase
        .from('courses')
        .select('title')
        .eq('id', courseId)
        .single()

      if (course) setCourseName(course.title)

      const { data: modulesData } = await supabase
        .from('modules')
        .select('*')
        .eq('course_id', courseId)
        .order('order_index', { ascending: true })

      if (modulesData) setModules(modulesData)
    }

    loadCourseData()
  }, [courseId, supabase])

  // Load existing lesson for edit mode
  useEffect(() => {
    if (!lessonId) return

    const loadLesson = async () => {
      const { data: meta } = await supabase
        .from('lesson_metadata')
        .select('wizard_state')
        .eq('lesson_id', lessonId)
        .single()

      if (meta?.wizard_state) {
        dispatch({ type: 'HYDRATE', state: meta.wizard_state as LessonWizardState })
      }
    }

    loadLesson()
  }, [lessonId, supabase, dispatch])

  const selectedModuleName = modules.find(m => m.id === state.metadata.moduleId)?.title

  // Convert wizard exercises to DB format
  const buildExerciseData = (exercise: ExerciseDefinition) => {
    const base = {
      id: exercise.id,
      title: exercise.title,
      type: exercise.type,
      description: exercise.description,
      instructions: exercise.instructions,
      difficulty: exercise.difficulty,
      estimated_time_minutes: exercise.estimatedMinutes,
      points: 10,
    }

    switch (exercise.type) {
      case 'code-python':
        return {
          ...base,
          runtime_tier: 'pyodide' as const,
          starter_code: exercise.starterCode,
          solution_code: exercise.solutionCode,
          test_cases: [{
            id: 'test-1',
            name: 'Validacion',
            test_code: exercise.testCode,
            points: 10,
          }],
          hints: exercise.hints.filter(h => h.trim()),
        }
      case 'sql':
        return {
          ...base,
          schema_id: 'default',
          starter_code: exercise.starterCode,
          solution_query: exercise.solutionCode,
          test_cases: [{
            id: 'test-1',
            name: 'Validacion',
            test_code: exercise.testCode,
            points: 10,
          }],
          hints: exercise.hints.filter(h => h.trim()),
        }
      case 'colab':
        return {
          ...base,
          colab_url: exercise.colabUrl || '',
          github_url: exercise.githubUrl || '',
          notebook_name: exercise.notebookName || '',
          completion_criteria: exercise.completionCriteria || '',
          manual_completion: exercise.manualCompletion ?? true,
        }
      case 'reflection':
        return {
          ...base,
          reflection_prompt: exercise.reflectionPrompt || '',
        }
      case 'case-study':
        return {
          ...base,
          scenario_text: exercise.scenarioText || '',
          analysis_questions: (exercise.analysisQuestions || []).filter(q => q.trim()),
        }
    }
  }

  // Convert quiz questions to DB format
  const buildQuizQuestions = (questions: WizardQuizQuestion[]) => {
    return questions.map((q, i) => ({
      question_type: q.type === 'multiple_select' ? 'multiple_select' : q.type === 'true_false' ? 'true_false' : 'mcq',
      question: q.question,
      options: q.options.map(opt => ({
        id: opt.id,
        text: opt.text,
        is_correct: Array.isArray(q.correctAnswer)
          ? q.correctAnswer.includes(opt.id)
          : q.correctAnswer === opt.id,
      })),
      correct_answer: Array.isArray(q.correctAnswer) ? q.correctAnswer.join(',') : q.correctAnswer,
      points: q.points,
      order_index: i,
      explanation: q.explanation || null,
    }))
  }

  const handleSave = useCallback(async () => {
    setSaving(true)
    setSaveError(null)

    try {
      const markdown = assembleMarkdown(state)

      // 1. Upsert lesson
      const lessonPayload = {
        course_id: courseId,
        module_id: state.metadata.moduleId,
        title: state.metadata.title,
        content: markdown,
        video_url: state.videoUrl,
        duration_minutes: state.metadata.durationMinutes,
        lesson_type: 'text' as const,
        is_required: true,
      }

      let finalLessonId = lessonId

      if (lessonId) {
        const { error } = await supabase
          .from('lessons')
          .update(lessonPayload)
          .eq('id', lessonId)
        if (error) throw error
      } else {
        // Get order_index
        const { data: existing } = await supabase
          .from('lessons')
          .select('order_index')
          .eq('course_id', courseId)
          .order('order_index', { ascending: false })
          .limit(1)

        const orderIndex = (existing?.[0]?.order_index ?? -1) + 1

        const { data, error } = await supabase
          .from('lessons')
          .insert({ ...lessonPayload, order_index: orderIndex })
          .select('id')
          .single()

        if (error) throw error
        finalLessonId = data.id
      }

      // 2. Insert exercises into course_exercises
      for (const exercise of state.practice.exercises) {
        const exerciseData = buildExerciseData(exercise)

        await supabase
          .from('course_exercises')
          .upsert({
            course_id: courseId,
            module_id: state.metadata.moduleId,
            lesson_id: finalLessonId,
            exercise_id: exercise.id,
            exercise_type: exercise.type,
            exercise_data: exerciseData,
          }, { onConflict: 'course_id,exercise_id' })
      }

      // 3. Insert quiz
      if (state.conclusions.quizQuestions.length > 0 && finalLessonId) {
        // Delete existing quiz if editing
        if (lessonId) {
          const { data: existingQuiz } = await supabase
            .from('quizzes')
            .select('id')
            .eq('lesson_id', lessonId)
            .single()

          if (existingQuiz) {
            await supabase.from('quiz_questions').delete().eq('quiz_id', existingQuiz.id)
            await supabase.from('quizzes').delete().eq('id', existingQuiz.id)
          }
        }

        const { data: quiz, error: quizError } = await supabase
          .from('quizzes')
          .insert({
            lesson_id: finalLessonId,
            title: `Quiz: ${state.metadata.title}`,
            passing_score: 70,
            is_published: true,
          })
          .select('id')
          .single()

        if (quizError) throw quizError

        const quizQuestions = buildQuizQuestions(state.conclusions.quizQuestions)
          .map(q => ({ ...q, quiz_id: quiz.id }))

        const { error: questionsError } = await supabase
          .from('quiz_questions')
          .insert(quizQuestions)

        if (questionsError) throw questionsError
      }

      // 4. Save lesson metadata
      const metadataPayload = {
        lesson_id: finalLessonId!,
        learning_objectives: state.metadata.objectives.filter(o => o.trim()),
        bloom_level: state.metadata.bloomLevel,
        connection_type: state.connection.hookType,
        practice_ratio: state.metadata.durationMinutes > 0
          ? state.practice.exercises.reduce((s, e) => s + e.estimatedMinutes, 0) / state.metadata.durationMinutes
          : 0,
        estimated_duration_minutes: state.metadata.durationMinutes,
        validation_result: validation,
        wizard_state: state,
      }

      await supabase
        .from('lesson_metadata')
        .upsert(metadataPayload, { onConflict: 'lesson_id' })

      clearDraft()
      router.push(`/admin/courses/${courseId}`)
    } catch (err) {
      console.error('Save error:', err)
      setSaveError(err instanceof Error ? err.message : 'Error al guardar')
    } finally {
      setSaving(false)
    }
  }, [state, courseId, lessonId, validation, supabase, router, clearDraft])

  const handleSaveDraft = useCallback(async () => {
    setSaving(true)
    try {
      // Save just the wizard state as a draft lesson
      const lessonPayload = {
        course_id: courseId,
        module_id: state.metadata.moduleId,
        title: state.metadata.title || 'Borrador sin titulo',
        content: '(Borrador - creado con wizard)',
        lesson_type: 'text' as const,
        is_required: true,
      }

      let finalLessonId = lessonId

      if (!lessonId) {
        const { data: existing } = await supabase
          .from('lessons')
          .select('order_index')
          .eq('course_id', courseId)
          .order('order_index', { ascending: false })
          .limit(1)

        const { data, error } = await supabase
          .from('lessons')
          .insert({ ...lessonPayload, order_index: (existing?.[0]?.order_index ?? -1) + 1 })
          .select('id')
          .single()

        if (error) throw error
        finalLessonId = data.id
      } else {
        await supabase.from('lessons').update(lessonPayload).eq('id', lessonId)
      }

      await supabase
        .from('lesson_metadata')
        .upsert({
          lesson_id: finalLessonId!,
          wizard_state: state,
        }, { onConflict: 'lesson_id' })

      clearDraft()
      router.push(`/admin/courses/${courseId}`)
    } catch (err) {
      setSaveError(err instanceof Error ? err.message : 'Error al guardar borrador')
    } finally {
      setSaving(false)
    }
  }, [state, courseId, lessonId, supabase, router, clearDraft])

  const renderStep = () => {
    switch (state.currentStep) {
      case 1:
        return <MetadataStep state={state} dispatch={dispatch} modules={modules} courseName={courseName} />
      case 2:
        return <ConnectionStep state={state} dispatch={dispatch} courseName={courseName} moduleName={selectedModuleName} />
      case 3:
        return <ConceptsStep state={state} dispatch={dispatch} courseName={courseName} />
      case 4:
        return <PracticeStep state={state} dispatch={dispatch} courseName={courseName} />
      case 5:
        return <ConclusionsStep state={state} dispatch={dispatch} courseName={courseName} />
      case 6:
        return (
          <ReviewStep
            state={state}
            validation={validation}
            markdownPreview={markdownPreview}
            onSave={handleSave}
            onSaveDraft={handleSaveDraft}
            saving={saving}
            onGoToStep={goToStep}
          />
        )
      default:
        return null
    }
  }

  return (
    <div className="max-w-7xl mx-auto">
      {/* Draft auto-save indicator */}
      {state.isDirty && (
        <div className="flex items-center justify-between mb-3 px-3 py-2 bg-amber-50 dark:bg-amber-900/20 border border-amber-200 dark:border-amber-800 rounded-lg text-sm">
          <span className="text-amber-700 dark:text-amber-400">
            Borrador guardado automaticamente
          </span>
          <button
            type="button"
            onClick={() => { clearDraft(); dispatch({ type: 'RESET' }) }}
            className="text-amber-600 dark:text-amber-400 hover:underline text-xs"
          >
            Descartar borrador
          </button>
        </div>
      )}

      {/* Step indicator */}
      <div className="flex items-center mb-8 overflow-x-auto pb-2">
        {WIZARD_STEPS.map((step, i) => (
          <div key={step.id} className="flex items-center">
            <button
              type="button"
              onClick={() => goToStep(step.id)}
              className={`flex items-center gap-2 px-3 py-1.5 rounded-full text-sm font-medium transition-colors whitespace-nowrap ${
                state.currentStep === step.id
                  ? 'bg-rizoma-green text-white'
                  : state.currentStep > step.id
                    ? 'bg-green-100 dark:bg-green-900/30 text-green-700 dark:text-green-400'
                    : 'bg-gray-100 dark:bg-gray-800 text-gray-500 dark:text-gray-400'
              }`}
            >
              <span className="w-5 h-5 rounded-full bg-white/20 flex items-center justify-center text-xs">
                {state.currentStep > step.id ? '\u2713' : step.id}
              </span>
              <span className="hidden sm:inline">{step.label}</span>
              <span className="sm:hidden">{step.shortLabel}</span>
            </button>
            {i < WIZARD_STEPS.length - 1 && (
              <div className={`w-8 h-0.5 mx-1 ${
                state.currentStep > step.id
                  ? 'bg-green-300 dark:bg-green-700'
                  : 'bg-gray-200 dark:bg-gray-700'
              }`} />
            )}
          </div>
        ))}
      </div>

      {/* Content area */}
      <div className="flex gap-6">
        {/* Main wizard area */}
        <div className="flex-1 min-w-0">
          <div className="bg-white dark:bg-gray-800 rounded-xl p-6 shadow-sm">
            {renderStep()}
          </div>

          {/* Navigation */}
          {state.currentStep < 6 && (
            <div className="flex justify-between mt-4">
              <button
                type="button"
                onClick={prevStep}
                disabled={state.currentStep === 1}
                className="px-4 py-2 border border-gray-300 dark:border-gray-600 rounded-lg text-gray-700 dark:text-gray-300 hover:bg-gray-100 dark:hover:bg-gray-700 disabled:opacity-50"
              >
                Anterior
              </button>
              <button
                type="button"
                onClick={nextStep}
                disabled={!canProceed}
                className="px-4 py-2 bg-rizoma-green text-white rounded-lg hover:bg-rizoma-green-dark disabled:opacity-50"
              >
                Siguiente
              </button>
            </div>
          )}

          {saveError && (
            <div className="mt-4 p-3 bg-red-50 dark:bg-red-900/20 border border-red-200 dark:border-red-800 rounded-lg text-red-700 dark:text-red-400 text-sm">
              {saveError}
            </div>
          )}
        </div>

        {/* Sidebar: validation checklist (visible on lg+) */}
        <div className="hidden lg:block w-72 flex-shrink-0">
          <div className="sticky top-4">
            <ValidationChecklist validation={validation} onGoToStep={goToStep} />
          </div>
        </div>
      </div>
    </div>
  )
}
