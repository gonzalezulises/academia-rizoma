-- Allow admin-role users full access to all courses (SELECT, UPDATE, DELETE).
-- Previously only instructor_id = auth.uid() could update/delete, and admins
-- couldn't see unpublished file-sourced courses from other instructors.

-- Helper: reusable check for admin role via profiles table
-- (Supabase RLS doesn't have a built-in app-level role concept)

-- 1. SELECT: admins can see ALL courses regardless of published/source/instructor
DROP POLICY IF EXISTS "Courses viewable by role" ON courses;

CREATE POLICY "Courses viewable by role"
  ON courses FOR SELECT
  USING (
    is_published = true
    OR instructor_id = auth.uid()
    OR content_source = 'database'
    OR EXISTS (
      SELECT 1 FROM profiles
      WHERE profiles.id = auth.uid()
        AND profiles.role = 'admin'
    )
  );

-- 2. UPDATE: admins can update any course
DROP POLICY IF EXISTS "Instructors can update own courses" ON courses;

CREATE POLICY "Instructors or admins can update courses"
  ON courses FOR UPDATE
  USING (
    instructor_id = auth.uid()
    OR EXISTS (
      SELECT 1 FROM profiles
      WHERE profiles.id = auth.uid()
        AND profiles.role = 'admin'
    )
  );

-- 3. DELETE: admins can delete any course
DROP POLICY IF EXISTS "Instructors can delete own courses" ON courses;

CREATE POLICY "Instructors or admins can delete courses"
  ON courses FOR DELETE
  USING (
    instructor_id = auth.uid()
    OR EXISTS (
      SELECT 1 FROM profiles
      WHERE profiles.id = auth.uid()
        AND profiles.role = 'admin'
    )
  );
