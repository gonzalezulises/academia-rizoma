-- =============================================
-- MIGRATION 006: Content Versioning & Resources
-- EduPlatform - Sprint 5 Polish
-- =============================================

-- =============================================
-- CONTENT VERSIONS TABLE
-- Track lesson content history
-- =============================================
CREATE TABLE content_versions (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  lesson_id UUID REFERENCES lessons ON DELETE CASCADE NOT NULL,
  version_number INTEGER NOT NULL,
  content TEXT,
  video_url TEXT,
  change_notes TEXT,
  created_by UUID REFERENCES profiles ON DELETE SET NULL,
  created_at TIMESTAMPTZ DEFAULT NOW(),
  is_active BOOLEAN DEFAULT false,
  UNIQUE(lesson_id, version_number)
);

-- Index for quick lookup
CREATE INDEX idx_content_versions_lesson ON content_versions(lesson_id);
CREATE INDEX idx_content_versions_active ON content_versions(lesson_id, is_active) WHERE is_active = true;

-- =============================================
-- RESOURCES TABLE
-- Downloadable files per lesson
-- =============================================
CREATE TABLE resources (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  lesson_id UUID REFERENCES lessons ON DELETE CASCADE NOT NULL,
  title TEXT NOT NULL,
  description TEXT,
  file_url TEXT NOT NULL,
  file_type TEXT,
  file_size INTEGER, -- bytes
  download_count INTEGER DEFAULT 0,
  created_by UUID REFERENCES profiles ON DELETE SET NULL,
  created_at TIMESTAMPTZ DEFAULT NOW(),
  updated_at TIMESTAMPTZ DEFAULT NOW()
);

-- Index for resources
CREATE INDEX idx_resources_lesson ON resources(lesson_id);

-- =============================================
-- ROW LEVEL SECURITY
-- =============================================

-- Content Versions RLS
ALTER TABLE content_versions ENABLE ROW LEVEL SECURITY;

-- Anyone enrolled can view active versions
CREATE POLICY "Enrolled users can view active content versions"
  ON content_versions FOR SELECT
  USING (
    is_active = true
    AND EXISTS (
      SELECT 1 FROM lessons l
      JOIN courses c ON l.course_id = c.id
      WHERE l.id = content_versions.lesson_id
      AND (
        c.is_published = true
        OR c.instructor_id = auth.uid()
        OR EXISTS (
          SELECT 1 FROM enrollments e
          WHERE e.course_id = c.id AND e.user_id = auth.uid()
        )
      )
    )
  );

-- Instructors can view all versions of their courses
CREATE POLICY "Instructors can view all content versions"
  ON content_versions FOR SELECT
  USING (
    EXISTS (
      SELECT 1 FROM lessons l
      JOIN courses c ON l.course_id = c.id
      WHERE l.id = content_versions.lesson_id
      AND c.instructor_id = auth.uid()
    )
  );

-- Instructors can create versions
CREATE POLICY "Instructors can create content versions"
  ON content_versions FOR INSERT
  WITH CHECK (
    EXISTS (
      SELECT 1 FROM lessons l
      JOIN courses c ON l.course_id = c.id
      WHERE l.id = content_versions.lesson_id
      AND c.instructor_id = auth.uid()
    )
  );

-- Instructors can update versions (activate/deactivate)
CREATE POLICY "Instructors can update content versions"
  ON content_versions FOR UPDATE
  USING (
    EXISTS (
      SELECT 1 FROM lessons l
      JOIN courses c ON l.course_id = c.id
      WHERE l.id = content_versions.lesson_id
      AND c.instructor_id = auth.uid()
    )
  );

-- Resources RLS
ALTER TABLE resources ENABLE ROW LEVEL SECURITY;

-- Enrolled users can view resources
CREATE POLICY "Enrolled users can view resources"
  ON resources FOR SELECT
  USING (
    EXISTS (
      SELECT 1 FROM lessons l
      JOIN courses c ON l.course_id = c.id
      WHERE l.id = resources.lesson_id
      AND (
        c.is_published = true
        OR c.instructor_id = auth.uid()
        OR EXISTS (
          SELECT 1 FROM enrollments e
          WHERE e.course_id = c.id AND e.user_id = auth.uid()
        )
      )
    )
  );

-- Instructors can manage resources
CREATE POLICY "Instructors can manage resources"
  ON resources FOR ALL
  USING (
    EXISTS (
      SELECT 1 FROM lessons l
      JOIN courses c ON l.course_id = c.id
      WHERE l.id = resources.lesson_id
      AND c.instructor_id = auth.uid()
    )
  );

-- =============================================
-- FUNCTIONS & TRIGGERS
-- =============================================

-- Auto-increment version number
CREATE OR REPLACE FUNCTION auto_version_number()
RETURNS TRIGGER AS $$
BEGIN
  SELECT COALESCE(MAX(version_number), 0) + 1
  INTO NEW.version_number
  FROM content_versions
  WHERE lesson_id = NEW.lesson_id;

  RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER trigger_auto_version_number
BEFORE INSERT ON content_versions
FOR EACH ROW
WHEN (NEW.version_number IS NULL)
EXECUTE FUNCTION auto_version_number();

-- Deactivate other versions when activating one
CREATE OR REPLACE FUNCTION handle_version_activation()
RETURNS TRIGGER AS $$
BEGIN
  IF NEW.is_active = true AND (OLD.is_active IS NULL OR OLD.is_active = false) THEN
    -- Deactivate all other versions for this lesson
    UPDATE content_versions
    SET is_active = false
    WHERE lesson_id = NEW.lesson_id
    AND id != NEW.id
    AND is_active = true;
  END IF;

  RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER trigger_version_activation
AFTER UPDATE ON content_versions
FOR EACH ROW
EXECUTE FUNCTION handle_version_activation();

-- Increment download count
CREATE OR REPLACE FUNCTION increment_download_count(resource_id UUID)
RETURNS void AS $$
BEGIN
  UPDATE resources
  SET download_count = download_count + 1
  WHERE id = resource_id;
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;

-- Update resources updated_at
CREATE OR REPLACE FUNCTION update_resources_timestamp()
RETURNS TRIGGER AS $$
BEGIN
  NEW.updated_at = NOW();
  RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER trigger_resources_updated_at
BEFORE UPDATE ON resources
FOR EACH ROW
EXECUTE FUNCTION update_resources_timestamp();

-- =============================================
-- STORAGE BUCKET FOR RESOURCES
-- =============================================

-- Create resources bucket if not exists
INSERT INTO storage.buckets (id, name, public)
VALUES ('resources', 'resources', true)
ON CONFLICT (id) DO NOTHING;

-- Storage policies for resources bucket
CREATE POLICY "Anyone can view resources"
ON storage.objects FOR SELECT
USING (bucket_id = 'resources');

CREATE POLICY "Instructors can upload resources"
ON storage.objects FOR INSERT
WITH CHECK (
  bucket_id = 'resources'
  AND auth.role() = 'authenticated'
);

CREATE POLICY "Instructors can delete resources"
ON storage.objects FOR DELETE
USING (
  bucket_id = 'resources'
  AND auth.uid()::text = (storage.foldername(name))[1]
);

-- =============================================
-- ADD is_pinned TO ANNOUNCEMENTS (if missing)
-- =============================================
ALTER TABLE announcements
ADD COLUMN IF NOT EXISTS is_pinned BOOLEAN DEFAULT false;
