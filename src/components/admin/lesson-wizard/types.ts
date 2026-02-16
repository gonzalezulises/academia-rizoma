// Wizard types for the 4C pedagogical model lesson creation wizard

export type BloomLevel = 'remember' | 'understand' | 'apply' | 'analyze' | 'evaluate' | 'create'
export type HookType = 'analogy' | 'question' | 'real_world' | 'challenge'
export type ConceptBlockType = 'explanation' | 'example' | 'diagram' | 'video'
export type WizardExerciseType = 'code-python' | 'sql' | 'quiz'

export interface ConceptBlock {
  id: string
  title: string
  type: ConceptBlockType
  content: string
  videoUrl?: string
  order: number
}

export interface ExerciseDefinition {
  id: string
  title: string
  type: WizardExerciseType
  difficulty: 'beginner' | 'intermediate' | 'advanced'
  description: string
  instructions: string
  starterCode: string
  solutionCode: string
  testCode: string
  hints: string[]
  estimatedMinutes: number
}

export interface WizardQuizQuestion {
  id: string
  question: string
  type: 'mcq' | 'true_false' | 'multiple_select'
  options: { id: string; text: string }[]
  correctAnswer: string | string[]
  explanation: string
  points: number
}

export interface ValidationRule {
  id: string
  label: string
  status: 'pass' | 'warning' | 'error'
  message?: string
}

export interface ValidationResult {
  rules: ValidationRule[]
  isValid: boolean
}

// State for each wizard step
export interface MetadataState {
  title: string
  moduleId: string | null
  durationMinutes: number
  objectives: string[]
  bloomLevel: BloomLevel
}

export interface ConnectionState {
  hookType: HookType
  content: string
  estimatedMinutes: number
}

export interface ConceptsState {
  blocks: ConceptBlock[]
  estimatedMinutes: number
}

export interface PracticeState {
  exercises: ExerciseDefinition[]
  estimatedMinutes: number
}

export interface ConclusionsState {
  quizQuestions: WizardQuizQuestion[]
  connectForward: string
  estimatedMinutes: number
}

export interface LessonWizardState {
  currentStep: number
  metadata: MetadataState
  connection: ConnectionState
  concepts: ConceptsState
  practice: PracticeState
  conclusions: ConclusionsState
  videoUrl: string | null
  isDirty: boolean
}

// Wizard actions for useReducer
export type WizardAction =
  | { type: 'SET_STEP'; step: number }
  | { type: 'SET_METADATA'; payload: Partial<MetadataState> }
  | { type: 'SET_OBJECTIVES'; objectives: string[] }
  | { type: 'SET_CONNECTION'; payload: Partial<ConnectionState> }
  | { type: 'SET_CONCEPTS_BLOCKS'; blocks: ConceptBlock[] }
  | { type: 'ADD_CONCEPT_BLOCK'; block: ConceptBlock }
  | { type: 'UPDATE_CONCEPT_BLOCK'; id: string; updates: Partial<ConceptBlock> }
  | { type: 'REMOVE_CONCEPT_BLOCK'; id: string }
  | { type: 'REORDER_CONCEPT_BLOCKS'; blocks: ConceptBlock[] }
  | { type: 'SET_EXERCISES'; exercises: ExerciseDefinition[] }
  | { type: 'ADD_EXERCISE'; exercise: ExerciseDefinition }
  | { type: 'UPDATE_EXERCISE'; id: string; updates: Partial<ExerciseDefinition> }
  | { type: 'REMOVE_EXERCISE'; id: string }
  | { type: 'SET_QUIZ_QUESTIONS'; questions: WizardQuizQuestion[] }
  | { type: 'ADD_QUIZ_QUESTION'; question: WizardQuizQuestion }
  | { type: 'UPDATE_QUIZ_QUESTION'; id: string; updates: Partial<WizardQuizQuestion> }
  | { type: 'REMOVE_QUIZ_QUESTION'; id: string }
  | { type: 'SET_CONNECT_FORWARD'; content: string }
  | { type: 'SET_VIDEO_URL'; url: string | null }
  | { type: 'HYDRATE'; state: LessonWizardState }
  | { type: 'RESET' }

export const WIZARD_STEPS = [
  { id: 1, label: 'Metadata', shortLabel: 'Meta' },
  { id: 2, label: 'Conexion', shortLabel: 'Hook' },
  { id: 3, label: 'Conceptos', shortLabel: 'Conceptos' },
  { id: 4, label: 'Practica', shortLabel: 'Practica' },
  { id: 5, label: 'Conclusiones', shortLabel: 'Cierre' },
  { id: 6, label: 'Revision', shortLabel: 'Revision' },
] as const

export const BLOOM_LEVELS: { value: BloomLevel; label: string }[] = [
  { value: 'remember', label: 'Recordar' },
  { value: 'understand', label: 'Comprender' },
  { value: 'apply', label: 'Aplicar' },
  { value: 'analyze', label: 'Analizar' },
  { value: 'evaluate', label: 'Evaluar' },
  { value: 'create', label: 'Crear' },
]

export const HOOK_TYPES: { value: HookType; label: string; description: string }[] = [
  { value: 'analogy', label: 'Analogia', description: 'Conecta con algo familiar' },
  { value: 'question', label: 'Pregunta', description: 'Plantea una pregunta intrigante' },
  { value: 'real_world', label: 'Caso real', description: 'Ejemplo del mundo real' },
  { value: 'challenge', label: 'Desafio', description: 'Presenta un reto motivador' },
]

export const INITIAL_STATE: LessonWizardState = {
  currentStep: 1,
  metadata: {
    title: '',
    moduleId: null,
    durationMinutes: 30,
    objectives: [''],
    bloomLevel: 'understand',
  },
  connection: {
    hookType: 'real_world',
    content: '',
    estimatedMinutes: 3,
  },
  concepts: {
    blocks: [],
    estimatedMinutes: 0,
  },
  practice: {
    exercises: [],
    estimatedMinutes: 0,
  },
  conclusions: {
    quizQuestions: [],
    connectForward: '',
    estimatedMinutes: 5,
  },
  videoUrl: null,
  isDirty: false,
}
