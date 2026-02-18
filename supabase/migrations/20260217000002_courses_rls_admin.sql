-- Fix: Allow authenticated users to see all courses with content_source='database'
-- These are AI-generated courses managed via the portal admin.
-- The original policy only allowed: is_published=true OR instructor_id=auth.uid()
-- which blocked all AI-generated courses (instructor_id=NULL, is_published=false).

-- Drop the old restrictive policy
DROP POLICY IF EXISTS "Published courses are viewable by everyone" ON courses;

-- New policy: published courses are public, database-sourced courses visible to authenticated users
CREATE POLICY "Courses viewable by role"
  ON courses FOR SELECT
  USING (
    is_published = true
    OR instructor_id = auth.uid()
    OR (content_source = 'database' AND auth.role() = 'authenticated')
  );
