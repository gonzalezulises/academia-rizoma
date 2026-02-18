-- Fix missing RLS write policies for course_exercises, quizzes, quiz_questions
-- These tables were missing INSERT/UPDATE/DELETE policies, blocking all writes

-- ============================================================
-- course_exercises: add full CRUD for instructors and admins
-- ============================================================

CREATE POLICY "Instructors can manage course exercises"
  ON course_exercises FOR ALL
  USING (
    EXISTS (
      SELECT 1 FROM courses c WHERE c.id = course_exercises.course_id AND c.instructor_id = auth.uid()
    )
  )
  WITH CHECK (
    EXISTS (
      SELECT 1 FROM courses c WHERE c.id = course_exercises.course_id AND c.instructor_id = auth.uid()
    )
  );

CREATE POLICY "Admins can manage all course exercises"
  ON course_exercises FOR ALL
  USING (
    EXISTS (
      SELECT 1 FROM profiles p WHERE p.id = auth.uid() AND p.role = 'admin'
    )
  )
  WITH CHECK (
    EXISTS (
      SELECT 1 FROM profiles p WHERE p.id = auth.uid() AND p.role = 'admin'
    )
  );

-- ============================================================
-- quizzes: add admin override
-- ============================================================

CREATE POLICY "Admins can manage all quizzes"
  ON quizzes FOR ALL
  USING (
    EXISTS (
      SELECT 1 FROM profiles p WHERE p.id = auth.uid() AND p.role = 'admin'
    )
  )
  WITH CHECK (
    EXISTS (
      SELECT 1 FROM profiles p WHERE p.id = auth.uid() AND p.role = 'admin'
    )
  );

-- ============================================================
-- quiz_questions: add admin override
-- ============================================================

CREATE POLICY "Admins can manage all quiz questions"
  ON quiz_questions FOR ALL
  USING (
    EXISTS (
      SELECT 1 FROM profiles p WHERE p.id = auth.uid() AND p.role = 'admin'
    )
  )
  WITH CHECK (
    EXISTS (
      SELECT 1 FROM profiles p WHERE p.id = auth.uid() AND p.role = 'admin'
    )
  );
