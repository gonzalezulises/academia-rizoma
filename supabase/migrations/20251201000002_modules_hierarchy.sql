-- Migration: Modules Hierarchy
-- Description: Add modules level between courses and lessons, plus activities

-- Enable UUID extension if not exists
CREATE EXTENSION IF NOT EXISTS "uuid-ossp";

-- ============================================
-- MODULES TABLE
-- ============================================
CREATE TABLE modules (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  course_id UUID NOT NULL REFERENCES courses ON DELETE CASCADE,
  title TEXT NOT NULL,
  description TEXT,
  order_index INTEGER DEFAULT 0,
  is_locked BOOLEAN DEFAULT false,
  unlock_after_module UUID REFERENCES modules(id) ON DELETE SET NULL,
  created_at TIMESTAMPTZ DEFAULT NOW()
);

-- Index for faster course lookups
CREATE INDEX idx_modules_course_id ON modules(course_id);
CREATE INDEX idx_modules_order ON modules(course_id, order_index);

-- ============================================
-- UPDATE LESSONS TABLE
-- ============================================
-- Add module reference
ALTER TABLE lessons ADD COLUMN module_id UUID REFERENCES modules(id) ON DELETE SET NULL;

-- Add lesson type (video, text, quiz, assignment)
ALTER TABLE lessons ADD COLUMN lesson_type TEXT DEFAULT 'video';
ALTER TABLE lessons ADD CONSTRAINT lessons_type_check
  CHECK (lesson_type IN ('video', 'text', 'quiz', 'assignment'));

-- Add required flag
ALTER TABLE lessons ADD COLUMN is_required BOOLEAN DEFAULT true;

-- Add prerequisite lesson
ALTER TABLE lessons ADD COLUMN unlock_after_lesson UUID REFERENCES lessons(id) ON DELETE SET NULL;

-- Index for module lookups
CREATE INDEX idx_lessons_module_id ON lessons(module_id);

-- ============================================
-- ACTIVITIES TABLE
-- ============================================
CREATE TABLE activities (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  lesson_id UUID NOT NULL REFERENCES lessons ON DELETE CASCADE,
  activity_type TEXT NOT NULL,
  title TEXT NOT NULL,
  content JSONB DEFAULT '{}'::jsonb,
  order_index INTEGER DEFAULT 0,
  points INTEGER DEFAULT 0,
  created_at TIMESTAMPTZ DEFAULT NOW(),
  CONSTRAINT activities_type_check
    CHECK (activity_type IN ('watch', 'read', 'quiz', 'submit'))
);

-- Index for lesson lookups
CREATE INDEX idx_activities_lesson_id ON activities(lesson_id);
CREATE INDEX idx_activities_order ON activities(lesson_id, order_index);

-- ============================================
-- ROW LEVEL SECURITY
-- ============================================

-- Modules RLS
ALTER TABLE modules ENABLE ROW LEVEL SECURITY;

-- Everyone can view modules of published courses
CREATE POLICY "Modules are viewable by everyone for published courses"
  ON modules FOR SELECT
  USING (
    EXISTS (
      SELECT 1 FROM courses
      WHERE courses.id = modules.course_id
      AND courses.is_published = true
    )
  );

-- Instructors can view their own course modules
CREATE POLICY "Instructors can view own course modules"
  ON modules FOR SELECT
  USING (
    EXISTS (
      SELECT 1 FROM courses
      WHERE courses.id = modules.course_id
      AND courses.instructor_id = auth.uid()
    )
  );

-- Instructors can manage their own course modules
CREATE POLICY "Instructors can insert modules in own courses"
  ON modules FOR INSERT
  WITH CHECK (
    EXISTS (
      SELECT 1 FROM courses
      WHERE courses.id = course_id
      AND courses.instructor_id = auth.uid()
    )
  );

CREATE POLICY "Instructors can update own course modules"
  ON modules FOR UPDATE
  USING (
    EXISTS (
      SELECT 1 FROM courses
      WHERE courses.id = modules.course_id
      AND courses.instructor_id = auth.uid()
    )
  );

CREATE POLICY "Instructors can delete own course modules"
  ON modules FOR DELETE
  USING (
    EXISTS (
      SELECT 1 FROM courses
      WHERE courses.id = modules.course_id
      AND courses.instructor_id = auth.uid()
    )
  );

-- Activities RLS
ALTER TABLE activities ENABLE ROW LEVEL SECURITY;

-- Everyone can view activities of published courses
CREATE POLICY "Activities are viewable for published courses"
  ON activities FOR SELECT
  USING (
    EXISTS (
      SELECT 1 FROM lessons
      JOIN courses ON courses.id = lessons.course_id
      WHERE lessons.id = activities.lesson_id
      AND courses.is_published = true
    )
  );

-- Instructors can view activities of their courses
CREATE POLICY "Instructors can view own course activities"
  ON activities FOR SELECT
  USING (
    EXISTS (
      SELECT 1 FROM lessons
      JOIN courses ON courses.id = lessons.course_id
      WHERE lessons.id = activities.lesson_id
      AND courses.instructor_id = auth.uid()
    )
  );

-- Instructors can manage activities in their courses
CREATE POLICY "Instructors can insert activities in own courses"
  ON activities FOR INSERT
  WITH CHECK (
    EXISTS (
      SELECT 1 FROM lessons
      JOIN courses ON courses.id = lessons.course_id
      WHERE lessons.id = lesson_id
      AND courses.instructor_id = auth.uid()
    )
  );

CREATE POLICY "Instructors can update own course activities"
  ON activities FOR UPDATE
  USING (
    EXISTS (
      SELECT 1 FROM lessons
      JOIN courses ON courses.id = lessons.course_id
      WHERE lessons.id = activities.lesson_id
      AND courses.instructor_id = auth.uid()
    )
  );

CREATE POLICY "Instructors can delete own course activities"
  ON activities FOR DELETE
  USING (
    EXISTS (
      SELECT 1 FROM lessons
      JOIN courses ON courses.id = lessons.course_id
      WHERE lessons.id = activities.lesson_id
      AND courses.instructor_id = auth.uid()
    )
  );

-- ============================================
-- HELPFUL COMMENTS
-- ============================================
COMMENT ON TABLE modules IS 'Course modules - organizational units within a course';
COMMENT ON TABLE activities IS 'Activities within lessons - watch, read, quiz, submit';
COMMENT ON COLUMN lessons.lesson_type IS 'Type of lesson: video, text, quiz, assignment';
COMMENT ON COLUMN lessons.is_required IS 'Whether lesson must be completed to progress';
COMMENT ON COLUMN modules.unlock_after_module IS 'Prerequisite module that must be completed first';
