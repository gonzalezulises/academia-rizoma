-- Programs: Academic programs (carreras, diplomados, especializaciones)
-- Run against: academia-rizoma Supabase project
-- Date: 2026-02-17

-- ============================================
-- Programs table
-- ============================================

CREATE TABLE IF NOT EXISTS programs (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  title TEXT NOT NULL,
  description TEXT NOT NULL,
  slug TEXT NOT NULL UNIQUE,
  program_type TEXT NOT NULL CHECK (program_type IN ('carrera', 'diplomado', 'especializacion')),
  content_status TEXT NOT NULL DEFAULT 'draft'
    CHECK (content_status IN ('draft', 'review', 'published')),
  estimated_duration_weeks INTEGER,
  required_electives INTEGER DEFAULT 0,
  generation_job_id UUID REFERENCES generation_jobs(id) ON DELETE SET NULL,
  created_by TEXT NOT NULL,
  image_url TEXT,
  created_at TIMESTAMPTZ DEFAULT NOW(),
  updated_at TIMESTAMPTZ DEFAULT NOW()
);

-- ============================================
-- Program ↔ Courses junction (many-to-many)
-- ============================================

CREATE TABLE IF NOT EXISTS program_courses (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  program_id UUID NOT NULL REFERENCES programs(id) ON DELETE CASCADE,
  course_id UUID NOT NULL REFERENCES courses(id) ON DELETE CASCADE,
  order_index INTEGER NOT NULL DEFAULT 0,
  is_required BOOLEAN NOT NULL DEFAULT true,
  prerequisite_course_ids UUID[] DEFAULT '{}',
  parallel_group TEXT,
  created_at TIMESTAMPTZ DEFAULT NOW(),
  UNIQUE(program_id, course_id)
);

-- ============================================
-- Student enrollments
-- ============================================

CREATE TABLE IF NOT EXISTS program_enrollments (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  user_id UUID NOT NULL REFERENCES auth.users(id) ON DELETE CASCADE,
  program_id UUID NOT NULL REFERENCES programs(id) ON DELETE CASCADE,
  enrolled_at TIMESTAMPTZ DEFAULT NOW(),
  completed_at TIMESTAMPTZ,
  UNIQUE(user_id, program_id)
);

-- ============================================
-- Indexes
-- ============================================

CREATE INDEX IF NOT EXISTS idx_programs_slug ON programs(slug);
CREATE INDEX IF NOT EXISTS idx_programs_type ON programs(program_type);
CREATE INDEX IF NOT EXISTS idx_programs_status ON programs(content_status);
CREATE INDEX IF NOT EXISTS idx_program_courses_program ON program_courses(program_id);
CREATE INDEX IF NOT EXISTS idx_program_courses_course ON program_courses(course_id);
CREATE INDEX IF NOT EXISTS idx_program_enrollments_user ON program_enrollments(user_id);
CREATE INDEX IF NOT EXISTS idx_program_enrollments_program ON program_enrollments(program_id);

-- ============================================
-- RLS Policies
-- ============================================

ALTER TABLE programs ENABLE ROW LEVEL SECURITY;
ALTER TABLE program_courses ENABLE ROW LEVEL SECURITY;
ALTER TABLE program_enrollments ENABLE ROW LEVEL SECURITY;

-- Programs: anon can read published, authenticated can CRUD
CREATE POLICY "programs_select_published" ON programs
  FOR SELECT USING (content_status = 'published');

CREATE POLICY "programs_authenticated_all" ON programs
  FOR ALL TO authenticated USING (true) WITH CHECK (true);

-- Program courses: anon can read (for published programs), authenticated can CRUD
CREATE POLICY "program_courses_select" ON program_courses
  FOR SELECT USING (true);

CREATE POLICY "program_courses_authenticated_all" ON program_courses
  FOR ALL TO authenticated USING (true) WITH CHECK (true);

-- Enrollments: users can manage own, authenticated admins can read all
CREATE POLICY "enrollments_select_own" ON program_enrollments
  FOR SELECT TO authenticated USING (true);

CREATE POLICY "enrollments_insert_own" ON program_enrollments
  FOR INSERT TO authenticated WITH CHECK (auth.uid() = user_id);

CREATE POLICY "enrollments_update_own" ON program_enrollments
  FOR UPDATE TO authenticated USING (auth.uid() = user_id);
