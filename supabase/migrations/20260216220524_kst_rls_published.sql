-- Allow anonymous reads of KST for published courses
CREATE POLICY "kst_definitions_select_published"
  ON kst_definitions FOR SELECT
  USING (
    EXISTS (
      SELECT 1 FROM courses
      WHERE courses.id = kst_definitions.course_id
      AND courses.content_status = 'published'
    )
  );
