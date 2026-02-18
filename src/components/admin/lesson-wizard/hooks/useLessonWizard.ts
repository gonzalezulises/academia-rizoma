'use client'

import { useReducer, useMemo, useCallback, useEffect, useRef } from 'react'
import type {
  LessonWizardState,
  WizardAction,
  ValidationResult,
  ValidationRule,
} from '../types'
import { INITIAL_STATE } from '../types'

function wizardReducer(state: LessonWizardState, action: WizardAction): LessonWizardState {
  switch (action.type) {
    case 'SET_STEP':
      return { ...state, currentStep: action.step }

    case 'SET_METADATA':
      return { ...state, metadata: { ...state.metadata, ...action.payload }, isDirty: true }

    case 'SET_OBJECTIVES':
      return { ...state, metadata: { ...state.metadata, objectives: action.objectives }, isDirty: true }

    case 'SET_CONNECTION':
      return { ...state, connection: { ...state.connection, ...action.payload }, isDirty: true }

    case 'SET_CONCEPTS_BLOCKS':
      return { ...state, concepts: { ...state.concepts, blocks: action.blocks }, isDirty: true }

    case 'ADD_CONCEPT_BLOCK':
      return {
        ...state,
        concepts: { ...state.concepts, blocks: [...state.concepts.blocks, action.block] },
        isDirty: true,
      }

    case 'UPDATE_CONCEPT_BLOCK':
      return {
        ...state,
        concepts: {
          ...state.concepts,
          blocks: state.concepts.blocks.map(b =>
            b.id === action.id ? { ...b, ...action.updates } : b
          ),
        },
        isDirty: true,
      }

    case 'REMOVE_CONCEPT_BLOCK':
      return {
        ...state,
        concepts: {
          ...state.concepts,
          blocks: state.concepts.blocks.filter(b => b.id !== action.id),
        },
        isDirty: true,
      }

    case 'REORDER_CONCEPT_BLOCKS':
      return { ...state, concepts: { ...state.concepts, blocks: action.blocks }, isDirty: true }

    case 'SET_EXERCISES':
      return { ...state, practice: { ...state.practice, exercises: action.exercises }, isDirty: true }

    case 'ADD_EXERCISE':
      return {
        ...state,
        practice: { ...state.practice, exercises: [...state.practice.exercises, action.exercise] },
        isDirty: true,
      }

    case 'UPDATE_EXERCISE':
      return {
        ...state,
        practice: {
          ...state.practice,
          exercises: state.practice.exercises.map(e =>
            e.id === action.id ? { ...e, ...action.updates } : e
          ),
        },
        isDirty: true,
      }

    case 'REMOVE_EXERCISE':
      return {
        ...state,
        practice: {
          ...state.practice,
          exercises: state.practice.exercises.filter(e => e.id !== action.id),
        },
        isDirty: true,
      }

    case 'SET_QUIZ_QUESTIONS':
      return {
        ...state,
        conclusions: { ...state.conclusions, quizQuestions: action.questions },
        isDirty: true,
      }

    case 'ADD_QUIZ_QUESTION':
      return {
        ...state,
        conclusions: {
          ...state.conclusions,
          quizQuestions: [...state.conclusions.quizQuestions, action.question],
        },
        isDirty: true,
      }

    case 'UPDATE_QUIZ_QUESTION':
      return {
        ...state,
        conclusions: {
          ...state.conclusions,
          quizQuestions: state.conclusions.quizQuestions.map(q =>
            q.id === action.id ? { ...q, ...action.updates } : q
          ),
        },
        isDirty: true,
      }

    case 'REMOVE_QUIZ_QUESTION':
      return {
        ...state,
        conclusions: {
          ...state.conclusions,
          quizQuestions: state.conclusions.quizQuestions.filter(q => q.id !== action.id),
        },
        isDirty: true,
      }

    case 'SET_CONNECT_FORWARD':
      return {
        ...state,
        conclusions: { ...state.conclusions, connectForward: action.content },
        isDirty: true,
      }

    case 'SET_VIDEO_URL':
      return { ...state, videoUrl: action.url, isDirty: true }

    case 'HYDRATE':
      return { ...action.state, isDirty: false }

    case 'RESET':
      return { ...INITIAL_STATE }

    default:
      return state
  }
}

export function assembleMarkdown(state: LessonWizardState): string {
  const sections: string[] = []

  // Connection section
  if (state.connection.content) {
    sections.push(state.connection.content)
  }

  // Concepts section
  for (const block of state.concepts.blocks) {
    if (block.type === 'video' && block.videoUrl) {
      sections.push(`### ${block.title}\n\n${block.content}\n\n[Video](${block.videoUrl})`)
    } else {
      sections.push(`### ${block.title}\n\n${block.content}`)
    }
  }

  // Practice section — embed exercises
  if (state.practice.exercises.length > 0) {
    sections.push('## Practica')
    for (const ex of state.practice.exercises) {
      sections.push(`<!-- exercise:${ex.id} -->`)
    }
  }

  // Conclusions section
  if (state.conclusions.quizQuestions.length > 0) {
    sections.push('## Evaluacion')
    // Quiz will be stored separately; embed a reference
    sections.push('<!-- quiz:lesson-quiz -->')
  }

  if (state.conclusions.connectForward) {
    sections.push('## Siguiente paso\n\n' + state.conclusions.connectForward)
  }

  return sections.join('\n\n')
}

export function computeValidation(state: LessonWizardState): ValidationResult {
  const rules: ValidationRule[] = []

  // 1. All 4 phases present
  const hasConnection = state.connection.content.trim().length > 0
  const hasConcepts = state.concepts.blocks.length > 0
  const hasExercises = state.practice.exercises.length > 0
  const hasQuiz = state.conclusions.quizQuestions.length > 0

  const phasesPresent = [hasConnection, hasConcepts, hasExercises, hasQuiz].filter(Boolean).length
  rules.push({
    id: 'phases',
    label: '4 fases presentes (Connection, Concepts, Practice, Quiz)',
    status: phasesPresent === 4 ? 'pass' : phasesPresent >= 2 ? 'warning' : 'error',
    message: `${phasesPresent}/4 fases completas`,
  })

  // 2. Practice ratio (informational — never blocks saving)
  const totalMinutes = state.metadata.durationMinutes || 1
  const exerciseMinutes = state.practice.exercises.reduce((sum, ex) => sum + ex.estimatedMinutes, 0)
  const practiceRatio = exerciseMinutes / totalMinutes
  rules.push({
    id: 'practice-ratio',
    label: 'Ratio practica (ideal 40-50%)',
    status: practiceRatio >= 0.35 && practiceRatio <= 0.55 ? 'pass' : practiceRatio > 0 ? 'pass' : 'warning',
    message: `${Math.round(practiceRatio * 100)}% practica (${exerciseMinutes}/${totalMinutes} min)`,
  })

  // 3. Exercise count >= 2
  rules.push({
    id: 'exercise-count',
    label: 'Al menos 2 ejercicios',
    status: state.practice.exercises.length >= 2 ? 'pass' : state.practice.exercises.length === 1 ? 'warning' : 'error',
    message: `${state.practice.exercises.length} ejercicio(s)`,
  })

  // 4. Quiz count >= 5
  rules.push({
    id: 'quiz-count',
    label: 'Al menos 5 preguntas de quiz',
    status: state.conclusions.quizQuestions.length >= 5 ? 'pass' : state.conclusions.quizQuestions.length >= 3 ? 'warning' : 'error',
    message: `${state.conclusions.quizQuestions.length} pregunta(s)`,
  })

  // 5. Objectives defined
  const validObjectives = state.metadata.objectives.filter(o => o.trim().length > 0)
  rules.push({
    id: 'objectives',
    label: 'Objetivos de aprendizaje (2-4)',
    status: validObjectives.length >= 2 && validObjectives.length <= 4 ? 'pass' : validObjectives.length >= 1 ? 'warning' : 'error',
    message: `${validObjectives.length} objetivo(s)`,
  })

  // 6. Title present
  rules.push({
    id: 'title',
    label: 'Titulo de la leccion',
    status: state.metadata.title.trim().length > 0 ? 'pass' : 'error',
  })

  const isValid = rules.every(r => r.status !== 'error')
  return { rules, isValid }
}

const AUTOSAVE_PREFIX = 'wizard-draft-'
const AUTOSAVE_DEBOUNCE_MS = 1500

export function useLessonWizard(initialState?: LessonWizardState, storageKey?: string) {
  const [state, dispatch] = useReducer(wizardReducer, initialState || INITIAL_STATE)
  const timerRef = useRef<ReturnType<typeof setTimeout> | null>(null)
  const hydratedRef = useRef(false)

  // Restore from localStorage on mount (only if no initialState provided)
  useEffect(() => {
    if (initialState || !storageKey || hydratedRef.current) return
    hydratedRef.current = true
    try {
      const saved = localStorage.getItem(AUTOSAVE_PREFIX + storageKey)
      if (saved) {
        const parsed = JSON.parse(saved) as LessonWizardState
        if (parsed.metadata?.title) {
          dispatch({ type: 'HYDRATE', state: parsed })
        }
      }
    } catch { /* ignore corrupt data */ }
  }, [storageKey, initialState])

  // Auto-save to localStorage on every dirty change (debounced)
  useEffect(() => {
    if (!storageKey || !state.isDirty) return
    if (timerRef.current) clearTimeout(timerRef.current)
    timerRef.current = setTimeout(() => {
      try {
        localStorage.setItem(AUTOSAVE_PREFIX + storageKey, JSON.stringify(state))
      } catch { /* quota exceeded — ignore */ }
    }, AUTOSAVE_DEBOUNCE_MS)
    return () => { if (timerRef.current) clearTimeout(timerRef.current) }
  }, [state, storageKey])

  const clearDraft = useCallback(() => {
    if (storageKey) {
      localStorage.removeItem(AUTOSAVE_PREFIX + storageKey)
    }
  }, [storageKey])

  const validation = useMemo(() => computeValidation(state), [state])

  const canProceed = useMemo(() => {
    switch (state.currentStep) {
      case 1: return state.metadata.title.trim().length > 0
      case 2: return true // Connection is optional to proceed
      case 3: return true
      case 4: return true
      case 5: return true
      case 6: return validation.isValid
      default: return false
    }
  }, [state.currentStep, state.metadata.title, validation.isValid])

  const markdownPreview = useMemo(() => assembleMarkdown(state), [state])

  const goToStep = useCallback((step: number) => {
    if (step >= 1 && step <= 6) dispatch({ type: 'SET_STEP', step })
  }, [])

  const nextStep = useCallback(() => {
    if (state.currentStep < 6) dispatch({ type: 'SET_STEP', step: state.currentStep + 1 })
  }, [state.currentStep])

  const prevStep = useCallback(() => {
    if (state.currentStep > 1) dispatch({ type: 'SET_STEP', step: state.currentStep - 1 })
  }, [state.currentStep])

  return {
    state,
    dispatch,
    validation,
    canProceed,
    markdownPreview,
    goToStep,
    nextStep,
    prevStep,
    clearDraft,
  }
}
