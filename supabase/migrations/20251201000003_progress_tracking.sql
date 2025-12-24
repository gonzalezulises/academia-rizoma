-- Migration: Progress Tracking
-- Description: Advanced progress tracking with course-level progress and time tracking

-- ============================================
-- COURSE PROGRESS TABLE
-- ============================================
CREATE TABLE course_progress (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  user_id UUID NOT NULL REFERENCES profiles(id) ON DELETE CASCADE,
  course_id UUID NOT NULL REFERENCES courses(id) ON DELETE CASCADE,
  current_lesson_id UUID REFERENCES lessons(id) ON DELETE SET NULL,
  progress_percentage DECIMAL(5,2) DEFAULT 0,
  total_time_spent INTEGER DEFAULT 0,
  started_at TIMESTAMPTZ DEFAULT NOW(),
  last_accessed_at TIMESTAMPTZ DEFAULT NOW(),
  completed_at TIMESTAMPTZ,
  UNIQUE(user_id, course_id)
);

CREATE INDEX idx_course_progress_user ON course_progress(user_id);
CREATE INDEX idx_course_progress_course ON course_progress(course_id);

-- ============================================
-- UPDATE PROGRESS TABLE
-- ============================================
ALTER TABLE progress ADD COLUMN IF NOT EXISTS time_spent INTEGER DEFAULT 0;
ALTER TABLE progress ADD COLUMN IF NOT EXISTS started_at TIMESTAMPTZ DEFAULT NOW();
ALTER TABLE progress ADD COLUMN IF NOT EXISTS progress_percentage DECIMAL(5,2) DEFAULT 0;

-- Add unique constraint if not exists
DO $$
BEGIN
  IF NOT EXISTS (
    SELECT 1 FROM pg_constraint WHERE conname = 'progress_user_lesson_unique'
  ) THEN
    ALTER TABLE progress ADD CONSTRAINT progress_user_lesson_unique UNIQUE(user_id, lesson_id);
  END IF;
END $$;

-- ============================================
-- ACTIVITY PROGRESS TABLE
-- ============================================
CREATE TABLE activity_progress (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  user_id UUID NOT NULL REFERENCES profiles(id) ON DELETE CASCADE,
  activity_id UUID NOT NULL REFERENCES activities(id) ON DELETE CASCADE,
  completed BOOLEAN DEFAULT false,
  score DECIMAL(5,2),
  attempts INTEGER DEFAULT 0,
  data JSONB DEFAULT '{}'::jsonb,
  completed_at TIMESTAMPTZ,
  UNIQUE(user_id, activity_id)
);

CREATE INDEX idx_activity_progress_user ON activity_progress(user_id);
CREATE INDEX idx_activity_progress_activity ON activity_progress(activity_id);

-- ============================================
-- ROW LEVEL SECURITY
-- ============================================

-- Course Progress RLS
ALTER TABLE course_progress ENABLE ROW LEVEL SECURITY;

CREATE POLICY "Users can view own course progress"
  ON course_progress FOR SELECT
  USING (auth.uid() = user_id);

CREATE POLICY "Users can insert own course progress"
  ON course_progress FOR INSERT
  WITH CHECK (auth.uid() = user_id);

CREATE POLICY "Users can update own course progress"
  ON course_progress FOR UPDATE
  USING (auth.uid() = user_id);

-- Instructors can view progress of their course students
CREATE POLICY "Instructors can view student progress"
  ON course_progress FOR SELECT
  USING (
    EXISTS (
      SELECT 1 FROM courses
      WHERE courses.id = course_progress.course_id
      AND courses.instructor_id = auth.uid()
    )
  );

-- Activity Progress RLS
ALTER TABLE activity_progress ENABLE ROW LEVEL SECURITY;

CREATE POLICY "Users can view own activity progress"
  ON activity_progress FOR SELECT
  USING (auth.uid() = user_id);

CREATE POLICY "Users can insert own activity progress"
  ON activity_progress FOR INSERT
  WITH CHECK (auth.uid() = user_id);

CREATE POLICY "Users can update own activity progress"
  ON activity_progress FOR UPDATE
  USING (auth.uid() = user_id);

-- Instructors can view activity progress of their students
CREATE POLICY "Instructors can view student activity progress"
  ON activity_progress FOR SELECT
  USING (
    EXISTS (
      SELECT 1 FROM activities
      JOIN lessons ON lessons.id = activities.lesson_id
      JOIN courses ON courses.id = lessons.course_id
      WHERE activities.id = activity_progress.activity_id
      AND courses.instructor_id = auth.uid()
    )
  );

-- ============================================
-- HELPER FUNCTION: Update course progress
-- ============================================
CREATE OR REPLACE FUNCTION update_course_progress()
RETURNS TRIGGER AS $$
DECLARE
  v_course_id UUID;
  v_total_lessons INTEGER;
  v_completed_lessons INTEGER;
  v_percentage DECIMAL(5,2);
BEGIN
  -- Get course_id from the lesson
  SELECT course_id INTO v_course_id
  FROM lessons
  WHERE id = NEW.lesson_id;

  -- Count total and completed lessons
  SELECT COUNT(*) INTO v_total_lessons
  FROM lessons
  WHERE course_id = v_course_id;

  SELECT COUNT(*) INTO v_completed_lessons
  FROM progress p
  JOIN lessons l ON l.id = p.lesson_id
  WHERE l.course_id = v_course_id
  AND p.user_id = NEW.user_id
  AND p.completed = true;

  -- Calculate percentage
  IF v_total_lessons > 0 THEN
    v_percentage := (v_completed_lessons::DECIMAL / v_total_lessons) * 100;
  ELSE
    v_percentage := 0;
  END IF;

  -- Upsert course_progress
  INSERT INTO course_progress (user_id, course_id, current_lesson_id, progress_percentage, last_accessed_at)
  VALUES (NEW.user_id, v_course_id, NEW.lesson_id, v_percentage, NOW())
  ON CONFLICT (user_id, course_id)
  DO UPDATE SET
    current_lesson_id = NEW.lesson_id,
    progress_percentage = v_percentage,
    last_accessed_at = NOW(),
    completed_at = CASE WHEN v_percentage >= 100 THEN NOW() ELSE course_progress.completed_at END;

  RETURN NEW;
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;

-- Create trigger
DROP TRIGGER IF EXISTS on_progress_update ON progress;
CREATE TRIGGER on_progress_update
  AFTER INSERT OR UPDATE ON progress
  FOR EACH ROW
  EXECUTE FUNCTION update_course_progress();

-- ============================================
-- COMMENTS
-- ============================================
COMMENT ON TABLE course_progress IS 'Tracks overall progress per user per course';
COMMENT ON TABLE activity_progress IS 'Tracks progress on individual activities';
COMMENT ON COLUMN course_progress.total_time_spent IS 'Total time spent in seconds';
COMMENT ON COLUMN course_progress.current_lesson_id IS 'Last accessed lesson for resume functionality';
