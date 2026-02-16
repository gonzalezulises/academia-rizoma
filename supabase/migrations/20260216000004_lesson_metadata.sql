-- Lesson metadata for 4C pedagogical model wizard
CREATE TABLE IF NOT EXISTS lesson_metadata (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  lesson_id UUID NOT NULL REFERENCES lessons(id) ON DELETE CASCADE,
  learning_objectives JSONB DEFAULT '[]',
  bloom_level TEXT,
  connection_type TEXT,
  practice_ratio DECIMAL(3,2),
  estimated_duration_minutes INTEGER,
  validation_result JSONB DEFAULT '{}',
  ai_provider TEXT,
  wizard_state JSONB,
  created_at TIMESTAMPTZ DEFAULT NOW(),
  updated_at TIMESTAMPTZ DEFAULT NOW(),
  UNIQUE(lesson_id)
);

-- RLS policies: instructors and admins only
ALTER TABLE lesson_metadata ENABLE ROW LEVEL SECURITY;

CREATE POLICY "Instructors and admins can read lesson metadata"
  ON lesson_metadata FOR SELECT
  TO authenticated
  USING (
    EXISTS (
      SELECT 1 FROM lessons l
      JOIN courses c ON c.id = l.course_id
      JOIN profiles p ON p.id = auth.uid()
      WHERE l.id = lesson_metadata.lesson_id
        AND (c.instructor_id = auth.uid() OR p.role = 'admin')
    )
  );

CREATE POLICY "Instructors and admins can insert lesson metadata"
  ON lesson_metadata FOR INSERT
  TO authenticated
  WITH CHECK (
    EXISTS (
      SELECT 1 FROM lessons l
      JOIN courses c ON c.id = l.course_id
      JOIN profiles p ON p.id = auth.uid()
      WHERE l.id = lesson_metadata.lesson_id
        AND (c.instructor_id = auth.uid() OR p.role = 'admin')
    )
  );

CREATE POLICY "Instructors and admins can update lesson metadata"
  ON lesson_metadata FOR UPDATE
  TO authenticated
  USING (
    EXISTS (
      SELECT 1 FROM lessons l
      JOIN courses c ON c.id = l.course_id
      JOIN profiles p ON p.id = auth.uid()
      WHERE l.id = lesson_metadata.lesson_id
        AND (c.instructor_id = auth.uid() OR p.role = 'admin')
    )
  );

CREATE POLICY "Instructors and admins can delete lesson metadata"
  ON lesson_metadata FOR DELETE
  TO authenticated
  USING (
    EXISTS (
      SELECT 1 FROM lessons l
      JOIN courses c ON c.id = l.course_id
      JOIN profiles p ON p.id = auth.uid()
      WHERE l.id = lesson_metadata.lesson_id
        AND (c.instructor_id = auth.uid() OR p.role = 'admin')
    )
  );

-- Trigger to auto-update updated_at
CREATE OR REPLACE FUNCTION update_lesson_metadata_updated_at()
RETURNS TRIGGER AS $$
BEGIN
  NEW.updated_at = NOW();
  RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER lesson_metadata_updated_at
  BEFORE UPDATE ON lesson_metadata
  FOR EACH ROW
  EXECUTE FUNCTION update_lesson_metadata_updated_at();
