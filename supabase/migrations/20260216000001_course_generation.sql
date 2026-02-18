-- =============================================================
-- Course Generation Schema (Supabase — academia-rizoma project)
-- =============================================================
-- Run in: academia-rizoma Supabase → SQL Editor
-- Prerequisites: courses, modules, lessons tables must exist
-- =============================================================

-- Extend existing courses table
ALTER TABLE courses ADD COLUMN IF NOT EXISTS content_source TEXT
  DEFAULT 'file' CHECK (content_source IN ('file', 'database'));
ALTER TABLE courses ADD COLUMN IF NOT EXISTS content_status TEXT
  DEFAULT 'published' CHECK (content_status IN ('draft', 'review', 'published'));
ALTER TABLE courses ADD COLUMN IF NOT EXISTS generation_job_id UUID;

-- Exercises stored as JSONB (replaces YAML files for AI-generated courses)
CREATE TABLE IF NOT EXISTS course_exercises (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  course_id UUID NOT NULL REFERENCES courses(id) ON DELETE CASCADE,
  module_id UUID NOT NULL REFERENCES modules(id) ON DELETE CASCADE,
  lesson_id UUID REFERENCES lessons(id) ON DELETE SET NULL,
  exercise_id TEXT NOT NULL,
  exercise_type TEXT NOT NULL CHECK (exercise_type IN ('code-python','sql','quiz','colab')),
  exercise_data JSONB NOT NULL,
  order_index INTEGER DEFAULT 0,
  created_at TIMESTAMPTZ DEFAULT NOW(),
  updated_at TIMESTAMPTZ DEFAULT NOW(),
  UNIQUE(course_id, exercise_id)
);

-- Generation jobs — tracks AI course generation pipeline
CREATE TABLE IF NOT EXISTS generation_jobs (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  topic TEXT NOT NULL,
  target_audience TEXT DEFAULT 'principiantes',
  num_modules INTEGER DEFAULT 5,
  exercise_types TEXT[] DEFAULT ARRAY['code-python','quiz'],
  status TEXT NOT NULL DEFAULT 'pending'
    CHECK (status IN ('pending','planning','generating_lessons',
                      'generating_exercises','generating_kst',
                      'review','completed','failed')),
  progress_pct INTEGER DEFAULT 0,
  current_step TEXT,
  error_message TEXT,
  course_id UUID REFERENCES courses(id) ON DELETE SET NULL,
  created_by TEXT NOT NULL,
  model_used TEXT DEFAULT 'qwen2.5:72b',
  tokens_used INTEGER,
  generation_time_seconds INTEGER,
  created_at TIMESTAMPTZ DEFAULT NOW(),
  started_at TIMESTAMPTZ,
  completed_at TIMESTAMPTZ
);

-- KST definitions per course (Knowledge Space Theory)
CREATE TABLE IF NOT EXISTS kst_definitions (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  course_id UUID NOT NULL REFERENCES courses(id) ON DELETE CASCADE UNIQUE,
  domain_name TEXT NOT NULL,
  items JSONB NOT NULL,
  prerequisite_edges JSONB NOT NULL,
  validation_result JSONB,
  created_at TIMESTAMPTZ DEFAULT NOW()
);

-- Indexes
CREATE INDEX IF NOT EXISTS idx_course_exercises_course ON course_exercises(course_id);
CREATE INDEX IF NOT EXISTS idx_course_exercises_exercise_id ON course_exercises(exercise_id);
CREATE INDEX IF NOT EXISTS idx_generation_jobs_status ON generation_jobs(status);
CREATE INDEX IF NOT EXISTS idx_courses_content_source ON courses(content_source);

-- RLS policies (adjust to your auth setup)
ALTER TABLE course_exercises ENABLE ROW LEVEL SECURITY;
ALTER TABLE generation_jobs ENABLE ROW LEVEL SECURITY;
ALTER TABLE kst_definitions ENABLE ROW LEVEL SECURITY;

-- Allow authenticated users to read published exercises
CREATE POLICY "Authenticated users can read exercises" ON course_exercises
  FOR SELECT USING (auth.role() = 'authenticated');

-- Allow service role full access to generation_jobs
CREATE POLICY "Service role manages generation jobs" ON generation_jobs
  FOR ALL USING (auth.role() = 'service_role');

-- Allow authenticated users to read their own jobs
CREATE POLICY "Users can read own jobs" ON generation_jobs
  FOR SELECT USING (auth.uid()::text = created_by OR auth.role() = 'service_role');

-- Allow authenticated users to create jobs
CREATE POLICY "Users can create jobs" ON generation_jobs
  FOR INSERT WITH CHECK (auth.role() = 'authenticated');

-- Allow authenticated users to read KST definitions
CREATE POLICY "Authenticated users can read KST" ON kst_definitions
  FOR SELECT USING (auth.role() = 'authenticated');

-- Allow service role full access to KST
CREATE POLICY "Service role manages KST" ON kst_definitions
  FOR ALL USING (auth.role() = 'service_role');
