-- Fix: rizo-web uses anon key (no auth session), so auth.role()='authenticated'
-- doesn't work. AI-generated courses (content_source='database') are admin-managed
-- and the portal page has its own auth check. Safe to allow anon SELECT.

DROP POLICY IF EXISTS "Courses viewable by role" ON courses;

CREATE POLICY "Courses viewable by role"
  ON courses FOR SELECT
  USING (
    is_published = true
    OR instructor_id = auth.uid()
    OR content_source = 'database'
  );
