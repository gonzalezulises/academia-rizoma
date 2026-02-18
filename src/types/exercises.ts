// Interactive Exercise Types for Python, SQL, and Colab
// Compatible with markdown embeds: <!-- exercise:id -->

export type ExerciseType = 'code-python' | 'sql' | 'quiz' | 'colab' | 'reflection' | 'case-study'
export type RuntimeTier = 'pyodide' | 'jupyterlite' | 'colab'
export type DifficultyLevel = 'beginner' | 'intermediate' | 'advanced'
export type ExerciseStatus = 'not_started' | 'in_progress' | 'completed' | 'failed'

// Test case for code validation
export interface TestCase {
  id: string
  name: string
  test_code: string
  points: number
  hidden?: boolean
  error_message?: string
}

// Dataset reference for exercises
export interface DatasetReference {
  id: string
  path: string
  name: string
  description?: string
  schema?: Record<string, string>
}

// SQL Schema reference
export interface SQLSchemaReference {
  id: string
  path: string
  name: string
  tables: string[]
}

// UI configuration for exercise display
export interface UIConfig {
  hide_code?: boolean
  show_output_only?: boolean
  interactive_mode?: 'edit' | 'visualization' | 'readonly'
  auto_run?: boolean
}

// Base exercise interface
export interface BaseExercise {
  id: string
  title: string
  description: string
  instructions: string
  difficulty: DifficultyLevel
  estimated_time_minutes: number
  points: number
  hints?: string[]
  tags?: string[]
  ui_config?: UIConfig
}

// Comprehension question for code exercises (shown after visualization)
export interface ComprehensionQuestion {
  id: string
  question: string
  options: { id: string; text: string }[]
  correct: string
  feedback_correct?: string
  feedback_incorrect?: string
}

// Python code exercise
export interface CodeExercise extends BaseExercise {
  type: 'code-python'
  runtime_tier: RuntimeTier
  starter_code: string
  solution_code: string
  test_cases: TestCase[]
  required_packages?: string[]
  datasets?: DatasetReference[]
  forbidden_keywords?: string[]
  required_keywords?: string[]
  comprehension_questions?: ComprehensionQuestion[] // Preguntas interactivas post-visualización
}

// SQL exercise
export interface SQLExercise extends BaseExercise {
  type: 'sql'
  schema_id: string
  starter_code: string
  solution_query: string
  expected_output?: Record<string, unknown>[]
  datasets?: DatasetReference[]
  test_cases?: TestCase[]
}

// Quiz exercise (inline questions)
export interface QuizExerciseOption {
  id: string
  text: string
  is_correct?: boolean // Computed from 'correct' field
}

export interface QuizExerciseQuestion {
  id: string
  question: string
  type: 'mcq' | 'true_false' | 'multiple_select' | 'multiple_choice'
  options: QuizExerciseOption[]
  correct: string | string[] // ID(s) de la opción correcta
  points: number
  bloom_level?: 'remember' | 'understand' | 'apply' | 'analyze' | 'evaluate' | 'create'
  feedback_correct?: string
  feedback_incorrect?: string
  explanation?: string // Alias for feedback_incorrect
}

export interface QuizConfig {
  passing_score: number
  show_feedback?: boolean
  randomize_questions?: boolean
  allow_retry?: boolean
  estimated_time_minutes?: number
}

export interface QuizExercise extends BaseExercise {
  type: 'quiz'
  questions: QuizExerciseQuestion[]
  config?: QuizConfig
  passing_score?: number // Fallback si no hay config
  shuffle_questions?: boolean
  show_explanation_on_wrong?: boolean
  total_points?: number
  passing_points?: number
}

// Google Colab exercise
export interface ColabExercise extends BaseExercise {
  type: 'colab'
  colab_url: string
  github_url?: string
  notebook_name: string
  completion_criteria: string
  manual_completion?: boolean
}

// Reflection exercise (open-ended reflection question)
export interface ReflectionExercise extends BaseExercise {
  type: 'reflection'
  reflection_prompt: string
}

// Case study exercise (scenario with analysis questions)
export interface CaseStudyExercise extends BaseExercise {
  type: 'case-study'
  scenario_text: string
  analysis_questions: string[]
}

// Union type for all exercises
export type Exercise = CodeExercise | SQLExercise | QuizExercise | ColabExercise | ReflectionExercise | CaseStudyExercise

// Exercise progress tracking
export interface ExerciseProgress {
  id: string
  user_id: string
  exercise_id: string
  status: ExerciseStatus
  current_code?: string
  attempts: number
  score: number | null
  max_score: number
  test_results?: TestResult[]
  started_at: string
  completed_at: string | null
  last_attempt_at: string | null
}

export interface TestResult {
  test_id: string
  passed: boolean
  points_earned: number
  error_message?: string
  execution_time_ms?: number
}

// Pyodide execution result
export interface PythonExecutionResult {
  success: boolean
  stdout: string
  stderr: string
  error?: string
  execution_time_ms: number
  test_results?: TestResult[]
  figures?: string[] // Base64-encoded matplotlib figures
}

// SQL execution result
export interface SQLExecutionResult {
  success: boolean
  columns: string[]
  rows: Record<string, unknown>[]
  error?: string
  execution_time_ms: number
  rows_affected?: number
}

// Embed parsing types
export type EmbedType = 'exercise' | 'dataset' | 'colab'

export interface ParsedEmbed {
  type: EmbedType
  id: string
  raw: string
}

export interface ContentSegment {
  type: 'markdown' | 'embed'
  content: string
  embed?: ParsedEmbed
}

export interface ParsedContent {
  segments: ContentSegment[]
  embeds: ParsedEmbed[]
}

// Exercise loader result
export interface LoadedExercise {
  exercise: Exercise
  datasets: Map<string, string> // id -> CSV content
  schema?: string // SQL schema content
}

