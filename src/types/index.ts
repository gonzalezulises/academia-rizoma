export type UserRole = 'student' | 'instructor' | 'admin'

export type LessonType = 'video' | 'text' | 'quiz' | 'assignment'

export type ActivityType = 'watch' | 'read' | 'quiz' | 'submit'

export interface Profile {
  id: string
  full_name: string | null
  avatar_url: string | null
  role: UserRole
  created_at: string
}

export interface Course {
  id: string
  title: string
  description: string | null
  thumbnail_url: string | null
  instructor_id: string
  is_published: boolean
  created_at: string
}

export interface Module {
  id: string
  course_id: string
  title: string
  description: string | null
  order_index: number
  is_locked: boolean
  unlock_after_module: string | null
  created_at: string
}

export interface Lesson {
  id: string
  course_id: string
  module_id: string | null
  title: string
  content: string | null
  video_url: string | null
  order_index: number
  duration_minutes: number | null
  lesson_type: LessonType
  is_required: boolean
  unlock_after_lesson: string | null
  created_at: string
}

export interface Activity {
  id: string
  lesson_id: string
  activity_type: ActivityType
  title: string
  content: Record<string, unknown>
  order_index: number
  points: number
  created_at: string
}

export interface Progress {
  id: string
  user_id: string
  lesson_id: string
  completed: boolean
  completed_at: string | null
  time_spent: number
  started_at: string | null
  progress_percentage: number
}

export interface CourseProgress {
  id: string
  user_id: string
  course_id: string
  current_lesson_id: string | null
  progress_percentage: number
  total_time_spent: number
  started_at: string
  last_accessed_at: string
  completed_at: string | null
}

export interface ActivityProgress {
  id: string
  user_id: string
  activity_id: string
  completed: boolean
  score: number | null
  attempts: number
  data: Record<string, unknown>
  completed_at: string | null
}

export interface CourseProgressWithDetails extends CourseProgress {
  course: Course
  current_lesson?: Lesson
}

export interface Enrollment {
  id: string
  user_id: string
  course_id: string
  enrolled_at: string
}

// Extended types with relations
export interface CourseWithInstructor extends Course {
  instructor: Profile
}

export interface CourseWithLessons extends Course {
  lessons: Lesson[]
}

export interface CourseWithModules extends Course {
  modules: ModuleWithLessons[]
  instructor?: Profile
}

export interface ModuleWithLessons extends Module {
  lessons: LessonWithProgress[]
}

export interface LessonWithProgress extends Lesson {
  progress: Progress | null
}

export interface LessonWithActivities extends Lesson {
  activities: Activity[]
  progress?: Progress | null
}

export interface LessonFull extends Lesson {
  activities: Activity[]
  progress?: Progress | null
  module?: Module | null
  course?: Course
}

// Quiz types
export type QuestionType = 'mcq' | 'true_false' | 'short_answer' | 'multiple_select'

export interface QuizOption {
  id: string
  text: string
  is_correct: boolean
}

export interface Quiz {
  id: string
  lesson_id: string
  title: string
  description: string | null
  passing_score: number
  max_attempts: number | null
  time_limit: number | null
  shuffle_questions: boolean
  show_correct_answers: boolean
  is_published: boolean
  created_at: string
  updated_at: string
}

export interface QuizQuestion {
  id: string
  quiz_id: string
  question_type: QuestionType
  question: string
  options: QuizOption[] | null
  correct_answer: string | null
  points: number
  order_index: number
  explanation: string | null
  created_at: string
}

export interface QuizAnswer {
  question_id: string
  answer: string | string[]
  is_correct?: boolean
  points_earned?: number
}

export interface QuizAttempt {
  id: string
  user_id: string
  quiz_id: string
  score: number | null
  max_score: number | null
  passed: boolean | null
  answers: QuizAnswer[]
  started_at: string
  completed_at: string | null
  time_taken: number | null
}

export interface QuizWithQuestions extends Quiz {
  questions: QuizQuestion[]
}

export interface QuizAttemptWithDetails extends QuizAttempt {
  quiz: QuizWithQuestions
}

// Assignment types
export interface Assignment {
  id: string
  lesson_id: string
  title: string
  instructions: string | null
  due_date: string | null
  max_score: number
  allowed_file_types: string[]
  max_file_size: number
  is_published: boolean
  created_at: string
  updated_at: string
}

export type SubmissionStatus = 'pending' | 'reviewed' | 'approved' | 'rejected' | 'late'

export interface Submission {
  id: string
  assignment_id: string
  user_id: string
  file_url: string | null
  file_name: string | null
  file_size: number | null
  comments: string | null
  score: number | null
  feedback: string | null
  status: SubmissionStatus
  submitted_at: string
  reviewed_at: string | null
  reviewed_by: string | null
}

export interface SubmissionWithDetails extends Submission {
  user?: Profile
  assignment?: Assignment
}
