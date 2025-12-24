export type UserRole = 'student' | 'instructor' | 'admin'

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

export interface Lesson {
  id: string
  course_id: string
  title: string
  content: string | null
  video_url: string | null
  order_index: number
  duration_minutes: number | null
  created_at: string
}

export interface Progress {
  id: string
  user_id: string
  lesson_id: string
  completed: boolean
  completed_at: string | null
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

export interface LessonWithProgress extends Lesson {
  progress: Progress | null
}
