-- Enable UUID extension
CREATE EXTENSION IF NOT EXISTS "uuid-ossp";

-- Profiles table (extends auth.users)
CREATE TABLE profiles (
  id UUID PRIMARY KEY REFERENCES auth.users ON DELETE CASCADE,
  full_name TEXT,
  avatar_url TEXT,
  role TEXT DEFAULT 'student' CHECK (role IN ('student', 'instructor', 'admin')),
  created_at TIMESTAMPTZ DEFAULT NOW()
);

-- Courses table
CREATE TABLE courses (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  title TEXT NOT NULL,
  description TEXT,
  thumbnail_url TEXT,
  instructor_id UUID REFERENCES profiles ON DELETE SET NULL,
  is_published BOOLEAN DEFAULT FALSE,
  created_at TIMESTAMPTZ DEFAULT NOW()
);

-- Lessons table
CREATE TABLE lessons (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  course_id UUID REFERENCES courses ON DELETE CASCADE,
  title TEXT NOT NULL,
  content TEXT,
  video_url TEXT,
  order_index INTEGER DEFAULT 0,
  duration_minutes INTEGER,
  created_at TIMESTAMPTZ DEFAULT NOW()
);

-- Progress table
CREATE TABLE progress (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  user_id UUID REFERENCES profiles ON DELETE CASCADE,
  lesson_id UUID REFERENCES lessons ON DELETE CASCADE,
  completed BOOLEAN DEFAULT FALSE,
  completed_at TIMESTAMPTZ,
  UNIQUE(user_id, lesson_id)
);

-- Enrollments table
CREATE TABLE enrollments (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  user_id UUID REFERENCES profiles ON DELETE CASCADE,
  course_id UUID REFERENCES courses ON DELETE CASCADE,
  enrolled_at TIMESTAMPTZ DEFAULT NOW(),
  UNIQUE(user_id, course_id)
);

-- Create indexes for better performance
CREATE INDEX idx_courses_instructor ON courses(instructor_id);
CREATE INDEX idx_lessons_course ON lessons(course_id);
CREATE INDEX idx_progress_user ON progress(user_id);
CREATE INDEX idx_progress_lesson ON progress(lesson_id);
CREATE INDEX idx_enrollments_user ON enrollments(user_id);
CREATE INDEX idx_enrollments_course ON enrollments(course_id);

-- Row Level Security (RLS) Policies

-- Enable RLS on all tables
ALTER TABLE profiles ENABLE ROW LEVEL SECURITY;
ALTER TABLE courses ENABLE ROW LEVEL SECURITY;
ALTER TABLE lessons ENABLE ROW LEVEL SECURITY;
ALTER TABLE progress ENABLE ROW LEVEL SECURITY;
ALTER TABLE enrollments ENABLE ROW LEVEL SECURITY;

-- Profiles policies
CREATE POLICY "Public profiles are viewable by everyone"
  ON profiles FOR SELECT
  USING (true);

CREATE POLICY "Users can update own profile"
  ON profiles FOR UPDATE
  USING (auth.uid() = id);

-- Courses policies
CREATE POLICY "Published courses are viewable by everyone"
  ON courses FOR SELECT
  USING (is_published = true OR instructor_id = auth.uid());

CREATE POLICY "Instructors can create courses"
  ON courses FOR INSERT
  WITH CHECK (
    EXISTS (
      SELECT 1 FROM profiles
      WHERE id = auth.uid() AND role IN ('instructor', 'admin')
    )
  );

CREATE POLICY "Instructors can update own courses"
  ON courses FOR UPDATE
  USING (instructor_id = auth.uid());

CREATE POLICY "Instructors can delete own courses"
  ON courses FOR DELETE
  USING (instructor_id = auth.uid());

-- Lessons policies
CREATE POLICY "Lessons of published courses are viewable"
  ON lessons FOR SELECT
  USING (
    EXISTS (
      SELECT 1 FROM courses
      WHERE courses.id = lessons.course_id
      AND (courses.is_published = true OR courses.instructor_id = auth.uid())
    )
  );

CREATE POLICY "Instructors can manage lessons of own courses"
  ON lessons FOR ALL
  USING (
    EXISTS (
      SELECT 1 FROM courses
      WHERE courses.id = lessons.course_id
      AND courses.instructor_id = auth.uid()
    )
  );

-- Progress policies
CREATE POLICY "Users can view own progress"
  ON progress FOR SELECT
  USING (user_id = auth.uid());

CREATE POLICY "Users can update own progress"
  ON progress FOR ALL
  USING (user_id = auth.uid());

-- Enrollments policies
CREATE POLICY "Users can view own enrollments"
  ON enrollments FOR SELECT
  USING (user_id = auth.uid());

CREATE POLICY "Users can enroll themselves"
  ON enrollments FOR INSERT
  WITH CHECK (user_id = auth.uid());

-- Function to automatically create profile on signup
CREATE OR REPLACE FUNCTION public.handle_new_user()
RETURNS TRIGGER AS $$
BEGIN
  INSERT INTO public.profiles (id, full_name, avatar_url)
  VALUES (
    NEW.id,
    NEW.raw_user_meta_data->>'full_name',
    NEW.raw_user_meta_data->>'avatar_url'
  );
  RETURN NEW;
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;

-- Trigger to create profile on signup
CREATE TRIGGER on_auth_user_created
  AFTER INSERT ON auth.users
  FOR EACH ROW EXECUTE FUNCTION public.handle_new_user();
-- Migration: Modules Hierarchy
-- Description: Add modules level between courses and lessons, plus activities

-- Enable UUID extension if not exists
CREATE EXTENSION IF NOT EXISTS "uuid-ossp";

-- ============================================
-- MODULES TABLE
-- ============================================
CREATE TABLE modules (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  course_id UUID NOT NULL REFERENCES courses ON DELETE CASCADE,
  title TEXT NOT NULL,
  description TEXT,
  order_index INTEGER DEFAULT 0,
  is_locked BOOLEAN DEFAULT false,
  unlock_after_module UUID REFERENCES modules(id) ON DELETE SET NULL,
  created_at TIMESTAMPTZ DEFAULT NOW()
);

-- Index for faster course lookups
CREATE INDEX idx_modules_course_id ON modules(course_id);
CREATE INDEX idx_modules_order ON modules(course_id, order_index);

-- ============================================
-- UPDATE LESSONS TABLE
-- ============================================
-- Add module reference
ALTER TABLE lessons ADD COLUMN module_id UUID REFERENCES modules(id) ON DELETE SET NULL;

-- Add lesson type (video, text, quiz, assignment)
ALTER TABLE lessons ADD COLUMN lesson_type TEXT DEFAULT 'video';
ALTER TABLE lessons ADD CONSTRAINT lessons_type_check
  CHECK (lesson_type IN ('video', 'text', 'quiz', 'assignment'));

-- Add required flag
ALTER TABLE lessons ADD COLUMN is_required BOOLEAN DEFAULT true;

-- Add prerequisite lesson
ALTER TABLE lessons ADD COLUMN unlock_after_lesson UUID REFERENCES lessons(id) ON DELETE SET NULL;

-- Index for module lookups
CREATE INDEX idx_lessons_module_id ON lessons(module_id);

-- ============================================
-- ACTIVITIES TABLE
-- ============================================
CREATE TABLE activities (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  lesson_id UUID NOT NULL REFERENCES lessons ON DELETE CASCADE,
  activity_type TEXT NOT NULL,
  title TEXT NOT NULL,
  content JSONB DEFAULT '{}'::jsonb,
  order_index INTEGER DEFAULT 0,
  points INTEGER DEFAULT 0,
  created_at TIMESTAMPTZ DEFAULT NOW(),
  CONSTRAINT activities_type_check
    CHECK (activity_type IN ('watch', 'read', 'quiz', 'submit'))
);

-- Index for lesson lookups
CREATE INDEX idx_activities_lesson_id ON activities(lesson_id);
CREATE INDEX idx_activities_order ON activities(lesson_id, order_index);

-- ============================================
-- ROW LEVEL SECURITY
-- ============================================

-- Modules RLS
ALTER TABLE modules ENABLE ROW LEVEL SECURITY;

-- Everyone can view modules of published courses
CREATE POLICY "Modules are viewable by everyone for published courses"
  ON modules FOR SELECT
  USING (
    EXISTS (
      SELECT 1 FROM courses
      WHERE courses.id = modules.course_id
      AND courses.is_published = true
    )
  );

-- Instructors can view their own course modules
CREATE POLICY "Instructors can view own course modules"
  ON modules FOR SELECT
  USING (
    EXISTS (
      SELECT 1 FROM courses
      WHERE courses.id = modules.course_id
      AND courses.instructor_id = auth.uid()
    )
  );

-- Instructors can manage their own course modules
CREATE POLICY "Instructors can insert modules in own courses"
  ON modules FOR INSERT
  WITH CHECK (
    EXISTS (
      SELECT 1 FROM courses
      WHERE courses.id = course_id
      AND courses.instructor_id = auth.uid()
    )
  );

CREATE POLICY "Instructors can update own course modules"
  ON modules FOR UPDATE
  USING (
    EXISTS (
      SELECT 1 FROM courses
      WHERE courses.id = modules.course_id
      AND courses.instructor_id = auth.uid()
    )
  );

CREATE POLICY "Instructors can delete own course modules"
  ON modules FOR DELETE
  USING (
    EXISTS (
      SELECT 1 FROM courses
      WHERE courses.id = modules.course_id
      AND courses.instructor_id = auth.uid()
    )
  );

-- Activities RLS
ALTER TABLE activities ENABLE ROW LEVEL SECURITY;

-- Everyone can view activities of published courses
CREATE POLICY "Activities are viewable for published courses"
  ON activities FOR SELECT
  USING (
    EXISTS (
      SELECT 1 FROM lessons
      JOIN courses ON courses.id = lessons.course_id
      WHERE lessons.id = activities.lesson_id
      AND courses.is_published = true
    )
  );

-- Instructors can view activities of their courses
CREATE POLICY "Instructors can view own course activities"
  ON activities FOR SELECT
  USING (
    EXISTS (
      SELECT 1 FROM lessons
      JOIN courses ON courses.id = lessons.course_id
      WHERE lessons.id = activities.lesson_id
      AND courses.instructor_id = auth.uid()
    )
  );

-- Instructors can manage activities in their courses
CREATE POLICY "Instructors can insert activities in own courses"
  ON activities FOR INSERT
  WITH CHECK (
    EXISTS (
      SELECT 1 FROM lessons
      JOIN courses ON courses.id = lessons.course_id
      WHERE lessons.id = lesson_id
      AND courses.instructor_id = auth.uid()
    )
  );

CREATE POLICY "Instructors can update own course activities"
  ON activities FOR UPDATE
  USING (
    EXISTS (
      SELECT 1 FROM lessons
      JOIN courses ON courses.id = lessons.course_id
      WHERE lessons.id = activities.lesson_id
      AND courses.instructor_id = auth.uid()
    )
  );

CREATE POLICY "Instructors can delete own course activities"
  ON activities FOR DELETE
  USING (
    EXISTS (
      SELECT 1 FROM lessons
      JOIN courses ON courses.id = lessons.course_id
      WHERE lessons.id = activities.lesson_id
      AND courses.instructor_id = auth.uid()
    )
  );

-- ============================================
-- HELPFUL COMMENTS
-- ============================================
COMMENT ON TABLE modules IS 'Course modules - organizational units within a course';
COMMENT ON TABLE activities IS 'Activities within lessons - watch, read, quiz, submit';
COMMENT ON COLUMN lessons.lesson_type IS 'Type of lesson: video, text, quiz, assignment';
COMMENT ON COLUMN lessons.is_required IS 'Whether lesson must be completed to progress';
COMMENT ON COLUMN modules.unlock_after_module IS 'Prerequisite module that must be completed first';
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
-- =====================================================
-- SPRINT 3: Sistema de Evaluaciones (Quizzes)
-- =====================================================

-- Quizzes
CREATE TABLE IF NOT EXISTS quizzes (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  lesson_id UUID REFERENCES lessons ON DELETE CASCADE,
  title TEXT NOT NULL,
  description TEXT,
  passing_score DECIMAL(5,2) DEFAULT 70,
  max_attempts INTEGER, -- NULL = ilimitado
  time_limit INTEGER, -- minutos, NULL = sin limite
  shuffle_questions BOOLEAN DEFAULT false,
  show_correct_answers BOOLEAN DEFAULT true,
  is_published BOOLEAN DEFAULT false,
  created_at TIMESTAMPTZ DEFAULT NOW(),
  updated_at TIMESTAMPTZ DEFAULT NOW()
);

-- Preguntas de quiz
CREATE TABLE IF NOT EXISTS quiz_questions (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  quiz_id UUID REFERENCES quizzes ON DELETE CASCADE,
  question_type TEXT NOT NULL CHECK (question_type IN ('mcq', 'true_false', 'short_answer', 'multiple_select')),
  question TEXT NOT NULL,
  options JSONB, -- [{id, text, is_correct}] para MCQ/multiple_select
  correct_answer TEXT, -- Para short_answer y true_false
  points INTEGER DEFAULT 1,
  order_index INTEGER DEFAULT 0,
  explanation TEXT, -- Feedback despues de responder
  created_at TIMESTAMPTZ DEFAULT NOW()
);

-- Intentos de quiz
CREATE TABLE IF NOT EXISTS quiz_attempts (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  user_id UUID REFERENCES profiles ON DELETE CASCADE,
  quiz_id UUID REFERENCES quizzes ON DELETE CASCADE,
  score DECIMAL(5,2),
  max_score INTEGER,
  passed BOOLEAN,
  answers JSONB, -- [{question_id, answer, is_correct, points_earned}]
  started_at TIMESTAMPTZ DEFAULT NOW(),
  completed_at TIMESTAMPTZ,
  time_taken INTEGER -- segundos
);

-- Assignments (Tareas)
CREATE TABLE IF NOT EXISTS assignments (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  lesson_id UUID REFERENCES lessons ON DELETE CASCADE,
  title TEXT NOT NULL,
  instructions TEXT,
  due_date TIMESTAMPTZ,
  max_score INTEGER DEFAULT 100,
  allowed_file_types TEXT[] DEFAULT ARRAY['pdf', 'docx', 'zip'],
  max_file_size INTEGER DEFAULT 10485760, -- 10MB en bytes
  is_published BOOLEAN DEFAULT false,
  created_at TIMESTAMPTZ DEFAULT NOW(),
  updated_at TIMESTAMPTZ DEFAULT NOW()
);

-- Entregas de tareas
CREATE TABLE IF NOT EXISTS submissions (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  assignment_id UUID REFERENCES assignments ON DELETE CASCADE,
  user_id UUID REFERENCES profiles ON DELETE CASCADE,
  file_url TEXT,
  file_name TEXT,
  file_size INTEGER,
  comments TEXT,
  score DECIMAL(5,2),
  feedback TEXT,
  status TEXT DEFAULT 'pending' CHECK (status IN ('pending', 'reviewed', 'approved', 'rejected', 'late')),
  submitted_at TIMESTAMPTZ DEFAULT NOW(),
  reviewed_at TIMESTAMPTZ,
  reviewed_by UUID REFERENCES profiles,
  UNIQUE(assignment_id, user_id)
);

-- Indices para mejor rendimiento
CREATE INDEX IF NOT EXISTS idx_quiz_questions_quiz_id ON quiz_questions(quiz_id);
CREATE INDEX IF NOT EXISTS idx_quiz_attempts_user_id ON quiz_attempts(user_id);
CREATE INDEX IF NOT EXISTS idx_quiz_attempts_quiz_id ON quiz_attempts(quiz_id);
CREATE INDEX IF NOT EXISTS idx_submissions_user_id ON submissions(user_id);
CREATE INDEX IF NOT EXISTS idx_submissions_assignment_id ON submissions(assignment_id);

-- =====================================================
-- Row Level Security (RLS)
-- =====================================================

ALTER TABLE quizzes ENABLE ROW LEVEL SECURITY;
ALTER TABLE quiz_questions ENABLE ROW LEVEL SECURITY;
ALTER TABLE quiz_attempts ENABLE ROW LEVEL SECURITY;
ALTER TABLE assignments ENABLE ROW LEVEL SECURITY;
ALTER TABLE submissions ENABLE ROW LEVEL SECURITY;

-- Quizzes: Todos pueden ver quizzes publicados
CREATE POLICY "Quizzes visibles si publicados o instructor"
  ON quizzes FOR SELECT
  USING (
    is_published = true
    OR EXISTS (
      SELECT 1 FROM lessons l
      JOIN courses c ON c.id = l.course_id
      WHERE l.id = quizzes.lesson_id
      AND c.instructor_id = auth.uid()
    )
  );

-- Instructores pueden crear/editar quizzes de sus cursos
CREATE POLICY "Instructores pueden gestionar quizzes"
  ON quizzes FOR ALL
  USING (
    EXISTS (
      SELECT 1 FROM lessons l
      JOIN courses c ON c.id = l.course_id
      WHERE l.id = quizzes.lesson_id
      AND c.instructor_id = auth.uid()
    )
  );

-- Quiz Questions: Visibles si el quiz es visible
CREATE POLICY "Questions visibles si quiz visible"
  ON quiz_questions FOR SELECT
  USING (
    EXISTS (
      SELECT 1 FROM quizzes q
      WHERE q.id = quiz_questions.quiz_id
      AND (
        q.is_published = true
        OR EXISTS (
          SELECT 1 FROM lessons l
          JOIN courses c ON c.id = l.course_id
          WHERE l.id = q.lesson_id
          AND c.instructor_id = auth.uid()
        )
      )
    )
  );

-- Instructores pueden gestionar preguntas
CREATE POLICY "Instructores pueden gestionar questions"
  ON quiz_questions FOR ALL
  USING (
    EXISTS (
      SELECT 1 FROM quizzes q
      JOIN lessons l ON l.id = q.lesson_id
      JOIN courses c ON c.id = l.course_id
      WHERE q.id = quiz_questions.quiz_id
      AND c.instructor_id = auth.uid()
    )
  );

-- Quiz Attempts: Usuarios ven sus propios intentos
CREATE POLICY "Usuarios ven sus intentos"
  ON quiz_attempts FOR SELECT
  USING (user_id = auth.uid());

-- Usuarios pueden crear intentos
CREATE POLICY "Usuarios pueden crear intentos"
  ON quiz_attempts FOR INSERT
  WITH CHECK (user_id = auth.uid());

-- Usuarios pueden actualizar sus intentos (para guardar progreso)
CREATE POLICY "Usuarios pueden actualizar sus intentos"
  ON quiz_attempts FOR UPDATE
  USING (user_id = auth.uid());

-- Instructores ven intentos de sus cursos
CREATE POLICY "Instructores ven intentos de sus cursos"
  ON quiz_attempts FOR SELECT
  USING (
    EXISTS (
      SELECT 1 FROM quizzes q
      JOIN lessons l ON l.id = q.lesson_id
      JOIN courses c ON c.id = l.course_id
      WHERE q.id = quiz_attempts.quiz_id
      AND c.instructor_id = auth.uid()
    )
  );

-- Assignments: Similar a quizzes
CREATE POLICY "Assignments visibles si publicados o instructor"
  ON assignments FOR SELECT
  USING (
    is_published = true
    OR EXISTS (
      SELECT 1 FROM lessons l
      JOIN courses c ON c.id = l.course_id
      WHERE l.id = assignments.lesson_id
      AND c.instructor_id = auth.uid()
    )
  );

CREATE POLICY "Instructores pueden gestionar assignments"
  ON assignments FOR ALL
  USING (
    EXISTS (
      SELECT 1 FROM lessons l
      JOIN courses c ON c.id = l.course_id
      WHERE l.id = assignments.lesson_id
      AND c.instructor_id = auth.uid()
    )
  );

-- Submissions: Usuarios ven sus entregas
CREATE POLICY "Usuarios ven sus entregas"
  ON submissions FOR SELECT
  USING (user_id = auth.uid());

-- Usuarios pueden crear/actualizar sus entregas
CREATE POLICY "Usuarios pueden crear entregas"
  ON submissions FOR INSERT
  WITH CHECK (user_id = auth.uid());

CREATE POLICY "Usuarios pueden actualizar sus entregas"
  ON submissions FOR UPDATE
  USING (user_id = auth.uid() AND status = 'pending');

-- Instructores ven y pueden calificar entregas de sus cursos
CREATE POLICY "Instructores ven entregas de sus cursos"
  ON submissions FOR SELECT
  USING (
    EXISTS (
      SELECT 1 FROM assignments a
      JOIN lessons l ON l.id = a.lesson_id
      JOIN courses c ON c.id = l.course_id
      WHERE a.id = submissions.assignment_id
      AND c.instructor_id = auth.uid()
    )
  );

CREATE POLICY "Instructores pueden calificar entregas"
  ON submissions FOR UPDATE
  USING (
    EXISTS (
      SELECT 1 FROM assignments a
      JOIN lessons l ON l.id = a.lesson_id
      JOIN courses c ON c.id = l.course_id
      WHERE a.id = submissions.assignment_id
      AND c.instructor_id = auth.uid()
    )
  );

-- =====================================================
-- Funcion para verificar intentos restantes
-- =====================================================

CREATE OR REPLACE FUNCTION check_quiz_attempts(p_user_id UUID, p_quiz_id UUID)
RETURNS TABLE (
  can_attempt BOOLEAN,
  attempts_used INTEGER,
  attempts_remaining INTEGER,
  best_score DECIMAL(5,2)
) AS $$
DECLARE
  v_max_attempts INTEGER;
  v_attempts_count INTEGER;
  v_best_score DECIMAL(5,2);
BEGIN
  -- Obtener max_attempts del quiz
  SELECT q.max_attempts INTO v_max_attempts
  FROM quizzes q WHERE q.id = p_quiz_id;

  -- Contar intentos del usuario
  SELECT COUNT(*), MAX(score) INTO v_attempts_count, v_best_score
  FROM quiz_attempts
  WHERE user_id = p_user_id AND quiz_id = p_quiz_id AND completed_at IS NOT NULL;

  RETURN QUERY SELECT
    (v_max_attempts IS NULL OR v_attempts_count < v_max_attempts) AS can_attempt,
    v_attempts_count AS attempts_used,
    CASE WHEN v_max_attempts IS NULL THEN NULL ELSE v_max_attempts - v_attempts_count END AS attempts_remaining,
    v_best_score AS best_score;
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;

-- =====================================================
-- Trigger para actualizar progreso al completar quiz
-- =====================================================

CREATE OR REPLACE FUNCTION on_quiz_completed()
RETURNS TRIGGER AS $$
DECLARE
  v_lesson_id UUID;
  v_course_id UUID;
  v_passed BOOLEAN;
BEGIN
  -- Solo actuar cuando se completa el intento
  IF NEW.completed_at IS NOT NULL AND OLD.completed_at IS NULL THEN
    -- Obtener lesson_id y course_id
    SELECT q.lesson_id, l.course_id INTO v_lesson_id, v_course_id
    FROM quizzes q
    JOIN lessons l ON l.id = q.lesson_id
    WHERE q.id = NEW.quiz_id;

    -- Si paso el quiz, marcar la leccion como completada
    IF NEW.passed = true THEN
      INSERT INTO progress (user_id, lesson_id, completed, completed_at)
      VALUES (NEW.user_id, v_lesson_id, true, NOW())
      ON CONFLICT (user_id, lesson_id)
      DO UPDATE SET completed = true, completed_at = NOW();
    END IF;
  END IF;

  RETURN NEW;
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;

CREATE TRIGGER trigger_quiz_completed
  AFTER UPDATE ON quiz_attempts
  FOR EACH ROW
  EXECUTE FUNCTION on_quiz_completed();

-- =====================================================
-- Datos de ejemplo (Quiz de prueba)
-- =====================================================

-- Insertar un quiz de ejemplo para la primera leccion que exista
DO $$
DECLARE
  v_lesson_id UUID;
  v_quiz_id UUID;
BEGIN
  -- Obtener la primera leccion
  SELECT id INTO v_lesson_id FROM lessons LIMIT 1;

  IF v_lesson_id IS NOT NULL THEN
    -- Crear quiz
    INSERT INTO quizzes (lesson_id, title, description, passing_score, max_attempts, time_limit, is_published)
    VALUES (
      v_lesson_id,
      'Quiz de Evaluacion',
      'Evalua tu comprension del tema',
      70,
      3,
      15,
      true
    )
    RETURNING id INTO v_quiz_id;

    -- Agregar preguntas
    INSERT INTO quiz_questions (quiz_id, question_type, question, options, points, order_index, explanation)
    VALUES
    (
      v_quiz_id,
      'mcq',
      '¿Cual es el principal beneficio de usar Next.js?',
      '[{"id": "a", "text": "Es mas rapido que React puro", "is_correct": false}, {"id": "b", "text": "Server-side rendering y routing integrado", "is_correct": true}, {"id": "c", "text": "No necesita JavaScript", "is_correct": false}, {"id": "d", "text": "Es mas facil que HTML", "is_correct": false}]'::jsonb,
      1,
      0,
      'Next.js ofrece SSR, SSG, y un sistema de routing basado en archivos de forma nativa.'
    ),
    (
      v_quiz_id,
      'true_false',
      'Next.js 14 usa el App Router por defecto.',
      NULL,
      'true',
      1,
      1,
      'Correcto, desde Next.js 13.4 el App Router es estable y es el default en Next.js 14.'
    ),
    (
      v_quiz_id,
      'mcq',
      '¿Que directiva se usa para componentes del cliente en Next.js?',
      '[{"id": "a", "text": "\"use server\"", "is_correct": false}, {"id": "b", "text": "\"use client\"", "is_correct": true}, {"id": "c", "text": "\"client only\"", "is_correct": false}, {"id": "d", "text": "\"no ssr\"", "is_correct": false}]'::jsonb,
      1,
      2,
      'La directiva "use client" indica que el componente debe renderizarse en el cliente.'
    ),
    (
      v_quiz_id,
      'multiple_select',
      '¿Cuales son caracteristicas de Supabase? (Selecciona todas las correctas)',
      '[{"id": "a", "text": "Base de datos PostgreSQL", "is_correct": true}, {"id": "b", "text": "Autenticacion integrada", "is_correct": true}, {"id": "c", "text": "Solo funciona con React", "is_correct": false}, {"id": "d", "text": "Storage para archivos", "is_correct": true}]'::jsonb,
      2,
      3,
      'Supabase incluye PostgreSQL, Auth, Storage, y funciones Edge entre otras caracteristicas.'
    );
  END IF;
END $$;
-- =====================================================
-- SPRINT 4: Sistema de Foros y Comunicacion
-- =====================================================

-- Foros por curso
CREATE TABLE IF NOT EXISTS forums (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  course_id UUID REFERENCES courses ON DELETE CASCADE,
  module_id UUID REFERENCES modules ON DELETE SET NULL,
  title TEXT NOT NULL,
  description TEXT,
  is_locked BOOLEAN DEFAULT false,
  post_count INTEGER DEFAULT 0,
  created_at TIMESTAMPTZ DEFAULT NOW(),
  updated_at TIMESTAMPTZ DEFAULT NOW()
);

-- Posts/Threads del foro
CREATE TABLE IF NOT EXISTS forum_posts (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  forum_id UUID REFERENCES forums ON DELETE CASCADE,
  user_id UUID REFERENCES profiles ON DELETE CASCADE,
  title TEXT NOT NULL,
  content TEXT NOT NULL,
  is_pinned BOOLEAN DEFAULT false,
  is_resolved BOOLEAN DEFAULT false,
  is_locked BOOLEAN DEFAULT false,
  views INTEGER DEFAULT 0,
  reply_count INTEGER DEFAULT 0,
  last_reply_at TIMESTAMPTZ,
  last_reply_by UUID REFERENCES profiles ON DELETE SET NULL,
  created_at TIMESTAMPTZ DEFAULT NOW(),
  updated_at TIMESTAMPTZ DEFAULT NOW()
);

-- Respuestas a posts
CREATE TABLE IF NOT EXISTS forum_replies (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  post_id UUID REFERENCES forum_posts ON DELETE CASCADE,
  user_id UUID REFERENCES profiles ON DELETE CASCADE,
  parent_reply_id UUID REFERENCES forum_replies ON DELETE CASCADE,
  content TEXT NOT NULL,
  is_answer BOOLEAN DEFAULT false,
  is_edited BOOLEAN DEFAULT false,
  created_at TIMESTAMPTZ DEFAULT NOW(),
  updated_at TIMESTAMPTZ DEFAULT NOW()
);

-- Notificaciones
CREATE TABLE IF NOT EXISTS notifications (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  user_id UUID REFERENCES profiles ON DELETE CASCADE,
  type TEXT NOT NULL CHECK (type IN ('reply', 'mention', 'announcement', 'grade', 'reminder', 'answer')),
  title TEXT NOT NULL,
  content TEXT,
  related_url TEXT,
  related_id UUID,
  is_read BOOLEAN DEFAULT false,
  created_at TIMESTAMPTZ DEFAULT NOW()
);

-- Anuncios del instructor
CREATE TABLE IF NOT EXISTS announcements (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  course_id UUID REFERENCES courses ON DELETE CASCADE,
  user_id UUID REFERENCES profiles ON DELETE CASCADE,
  title TEXT NOT NULL,
  content TEXT NOT NULL,
  is_pinned BOOLEAN DEFAULT false,
  target_segment TEXT DEFAULT 'all' CHECK (target_segment IN ('all', 'not_started', 'in_progress', 'completed')),
  created_at TIMESTAMPTZ DEFAULT NOW(),
  updated_at TIMESTAMPTZ DEFAULT NOW()
);

-- Indices
CREATE INDEX IF NOT EXISTS idx_forums_course_id ON forums(course_id);
CREATE INDEX IF NOT EXISTS idx_forum_posts_forum_id ON forum_posts(forum_id);
CREATE INDEX IF NOT EXISTS idx_forum_posts_user_id ON forum_posts(user_id);
CREATE INDEX IF NOT EXISTS idx_forum_replies_post_id ON forum_replies(post_id);
CREATE INDEX IF NOT EXISTS idx_forum_replies_user_id ON forum_replies(user_id);
CREATE INDEX IF NOT EXISTS idx_notifications_user_id ON notifications(user_id);
CREATE INDEX IF NOT EXISTS idx_notifications_is_read ON notifications(user_id, is_read);
CREATE INDEX IF NOT EXISTS idx_announcements_course_id ON announcements(course_id);

-- =====================================================
-- Row Level Security (RLS)
-- =====================================================

ALTER TABLE forums ENABLE ROW LEVEL SECURITY;
ALTER TABLE forum_posts ENABLE ROW LEVEL SECURITY;
ALTER TABLE forum_replies ENABLE ROW LEVEL SECURITY;
ALTER TABLE notifications ENABLE ROW LEVEL SECURITY;
ALTER TABLE announcements ENABLE ROW LEVEL SECURITY;

-- Forums: Visibles para usuarios inscritos
CREATE POLICY "Forums visibles para inscritos"
  ON forums FOR SELECT
  USING (
    EXISTS (
      SELECT 1 FROM enrollments e
      WHERE e.course_id = forums.course_id
      AND e.user_id = auth.uid()
    )
    OR EXISTS (
      SELECT 1 FROM courses c
      WHERE c.id = forums.course_id
      AND c.instructor_id = auth.uid()
    )
  );

-- Instructores pueden gestionar foros
CREATE POLICY "Instructores pueden gestionar forums"
  ON forums FOR ALL
  USING (
    EXISTS (
      SELECT 1 FROM courses c
      WHERE c.id = forums.course_id
      AND c.instructor_id = auth.uid()
    )
  );

-- Posts: Visibles para inscritos, creacion para inscritos
CREATE POLICY "Posts visibles para inscritos"
  ON forum_posts FOR SELECT
  USING (
    EXISTS (
      SELECT 1 FROM forums f
      JOIN enrollments e ON e.course_id = f.course_id
      WHERE f.id = forum_posts.forum_id
      AND e.user_id = auth.uid()
    )
    OR EXISTS (
      SELECT 1 FROM forums f
      JOIN courses c ON c.id = f.course_id
      WHERE f.id = forum_posts.forum_id
      AND c.instructor_id = auth.uid()
    )
  );

CREATE POLICY "Usuarios pueden crear posts"
  ON forum_posts FOR INSERT
  WITH CHECK (
    user_id = auth.uid()
    AND EXISTS (
      SELECT 1 FROM forums f
      WHERE f.id = forum_posts.forum_id
      AND f.is_locked = false
    )
  );

CREATE POLICY "Usuarios pueden editar sus posts"
  ON forum_posts FOR UPDATE
  USING (user_id = auth.uid());

CREATE POLICY "Usuarios pueden eliminar sus posts"
  ON forum_posts FOR DELETE
  USING (user_id = auth.uid());

-- Instructores pueden gestionar todos los posts de sus cursos
CREATE POLICY "Instructores pueden gestionar posts"
  ON forum_posts FOR ALL
  USING (
    EXISTS (
      SELECT 1 FROM forums f
      JOIN courses c ON c.id = f.course_id
      WHERE f.id = forum_posts.forum_id
      AND c.instructor_id = auth.uid()
    )
  );

-- Replies: Similar a posts
CREATE POLICY "Replies visibles para inscritos"
  ON forum_replies FOR SELECT
  USING (
    EXISTS (
      SELECT 1 FROM forum_posts p
      JOIN forums f ON f.id = p.forum_id
      JOIN enrollments e ON e.course_id = f.course_id
      WHERE p.id = forum_replies.post_id
      AND e.user_id = auth.uid()
    )
    OR EXISTS (
      SELECT 1 FROM forum_posts p
      JOIN forums f ON f.id = p.forum_id
      JOIN courses c ON c.id = f.course_id
      WHERE p.id = forum_replies.post_id
      AND c.instructor_id = auth.uid()
    )
  );

CREATE POLICY "Usuarios pueden crear replies"
  ON forum_replies FOR INSERT
  WITH CHECK (
    user_id = auth.uid()
    AND EXISTS (
      SELECT 1 FROM forum_posts p
      WHERE p.id = forum_replies.post_id
      AND p.is_locked = false
    )
  );

CREATE POLICY "Usuarios pueden editar sus replies"
  ON forum_replies FOR UPDATE
  USING (user_id = auth.uid());

CREATE POLICY "Usuarios pueden eliminar sus replies"
  ON forum_replies FOR DELETE
  USING (user_id = auth.uid());

-- Notificaciones: Solo el usuario dueno
CREATE POLICY "Usuarios ven sus notificaciones"
  ON notifications FOR SELECT
  USING (user_id = auth.uid());

CREATE POLICY "Sistema puede crear notificaciones"
  ON notifications FOR INSERT
  WITH CHECK (true);

CREATE POLICY "Usuarios pueden actualizar sus notificaciones"
  ON notifications FOR UPDATE
  USING (user_id = auth.uid());

CREATE POLICY "Usuarios pueden eliminar sus notificaciones"
  ON notifications FOR DELETE
  USING (user_id = auth.uid());

-- Announcements: Visibles para inscritos
CREATE POLICY "Announcements visibles para inscritos"
  ON announcements FOR SELECT
  USING (
    EXISTS (
      SELECT 1 FROM enrollments e
      WHERE e.course_id = announcements.course_id
      AND e.user_id = auth.uid()
    )
    OR EXISTS (
      SELECT 1 FROM courses c
      WHERE c.id = announcements.course_id
      AND c.instructor_id = auth.uid()
    )
  );

CREATE POLICY "Instructores pueden gestionar announcements"
  ON announcements FOR ALL
  USING (
    EXISTS (
      SELECT 1 FROM courses c
      WHERE c.id = announcements.course_id
      AND c.instructor_id = auth.uid()
    )
  );

-- =====================================================
-- Triggers para actualizar contadores
-- =====================================================

-- Actualizar post_count en forums
CREATE OR REPLACE FUNCTION update_forum_post_count()
RETURNS TRIGGER AS $$
BEGIN
  IF TG_OP = 'INSERT' THEN
    UPDATE forums SET post_count = post_count + 1, updated_at = NOW()
    WHERE id = NEW.forum_id;
  ELSIF TG_OP = 'DELETE' THEN
    UPDATE forums SET post_count = post_count - 1, updated_at = NOW()
    WHERE id = OLD.forum_id;
  END IF;
  RETURN NULL;
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;

CREATE TRIGGER trigger_forum_post_count
  AFTER INSERT OR DELETE ON forum_posts
  FOR EACH ROW
  EXECUTE FUNCTION update_forum_post_count();

-- Actualizar reply_count y last_reply en posts
CREATE OR REPLACE FUNCTION update_post_reply_count()
RETURNS TRIGGER AS $$
BEGIN
  IF TG_OP = 'INSERT' THEN
    UPDATE forum_posts SET
      reply_count = reply_count + 1,
      last_reply_at = NOW(),
      last_reply_by = NEW.user_id,
      updated_at = NOW()
    WHERE id = NEW.post_id;
  ELSIF TG_OP = 'DELETE' THEN
    UPDATE forum_posts SET
      reply_count = reply_count - 1,
      updated_at = NOW()
    WHERE id = OLD.post_id;
  END IF;
  RETURN NULL;
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;

CREATE TRIGGER trigger_post_reply_count
  AFTER INSERT OR DELETE ON forum_replies
  FOR EACH ROW
  EXECUTE FUNCTION update_post_reply_count();

-- Crear notificacion cuando hay una respuesta
CREATE OR REPLACE FUNCTION notify_on_reply()
RETURNS TRIGGER AS $$
DECLARE
  v_post_title TEXT;
  v_post_author UUID;
  v_course_id UUID;
BEGIN
  -- Obtener info del post
  SELECT p.title, p.user_id, f.course_id
  INTO v_post_title, v_post_author, v_course_id
  FROM forum_posts p
  JOIN forums f ON f.id = p.forum_id
  WHERE p.id = NEW.post_id;

  -- Notificar al autor del post (si no es el mismo que responde)
  IF v_post_author != NEW.user_id THEN
    INSERT INTO notifications (user_id, type, title, content, related_url, related_id)
    VALUES (
      v_post_author,
      'reply',
      'Nueva respuesta en tu post',
      'Alguien respondio a: ' || v_post_title,
      '/courses/' || v_course_id || '/forum/' || NEW.post_id,
      NEW.id
    );
  END IF;

  -- Si es respuesta a otra respuesta, notificar al autor de esa respuesta
  IF NEW.parent_reply_id IS NOT NULL THEN
    DECLARE
      v_parent_author UUID;
    BEGIN
      SELECT user_id INTO v_parent_author
      FROM forum_replies
      WHERE id = NEW.parent_reply_id;

      IF v_parent_author != NEW.user_id AND v_parent_author != v_post_author THEN
        INSERT INTO notifications (user_id, type, title, content, related_url, related_id)
        VALUES (
          v_parent_author,
          'reply',
          'Nueva respuesta a tu comentario',
          'Alguien respondio a tu comentario en: ' || v_post_title,
          '/courses/' || v_course_id || '/forum/' || NEW.post_id,
          NEW.id
        );
      END IF;
    END;
  END IF;

  RETURN NEW;
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;

CREATE TRIGGER trigger_notify_on_reply
  AFTER INSERT ON forum_replies
  FOR EACH ROW
  EXECUTE FUNCTION notify_on_reply();

-- Notificar cuando se marca una respuesta como "answer"
CREATE OR REPLACE FUNCTION notify_answer_marked()
RETURNS TRIGGER AS $$
DECLARE
  v_post_title TEXT;
  v_course_id UUID;
BEGIN
  IF NEW.is_answer = true AND (OLD.is_answer = false OR OLD.is_answer IS NULL) THEN
    SELECT p.title, f.course_id
    INTO v_post_title, v_course_id
    FROM forum_posts p
    JOIN forums f ON f.id = p.forum_id
    WHERE p.id = NEW.post_id;

    INSERT INTO notifications (user_id, type, title, content, related_url, related_id)
    VALUES (
      NEW.user_id,
      'answer',
      'Tu respuesta fue marcada como solucion',
      'Tu respuesta en "' || v_post_title || '" fue marcada como la solucion',
      '/courses/' || v_course_id || '/forum/' || NEW.post_id,
      NEW.id
    );
  END IF;

  RETURN NEW;
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;

CREATE TRIGGER trigger_notify_answer_marked
  AFTER UPDATE ON forum_replies
  FOR EACH ROW
  EXECUTE FUNCTION notify_answer_marked();

-- =====================================================
-- Crear foro general para cursos existentes
-- =====================================================

DO $$
DECLARE
  v_course RECORD;
BEGIN
  FOR v_course IN SELECT id, title FROM courses
  LOOP
    INSERT INTO forums (course_id, title, description)
    VALUES (
      v_course.id,
      'Foro General',
      'Espacio para discusiones generales sobre ' || v_course.title
    )
    ON CONFLICT DO NOTHING;
  END LOOP;
END $$;
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
-- Test migration to verify Supabase CLI setup
-- This adds a bio column to profiles

ALTER TABLE profiles
ADD COLUMN IF NOT EXISTS bio TEXT;

COMMENT ON COLUMN profiles.bio IS 'User biography/description';
-- Migration: Interactive Exercises System
-- Description: Adds support for tracking progress on interactive Python, SQL, and Colab exercises

-- Exercise Progress Table
-- Tracks user progress on individual exercises
CREATE TABLE IF NOT EXISTS exercise_progress (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  user_id UUID NOT NULL REFERENCES profiles(id) ON DELETE CASCADE,
  exercise_id TEXT NOT NULL,
  status TEXT NOT NULL DEFAULT 'not_started' CHECK (status IN ('not_started', 'in_progress', 'completed', 'failed')),
  current_code TEXT,
  attempts INTEGER NOT NULL DEFAULT 0,
  score DECIMAL(10,2),
  max_score DECIMAL(10,2),
  test_results JSONB DEFAULT '[]'::jsonb,
  started_at TIMESTAMPTZ DEFAULT NOW(),
  completed_at TIMESTAMPTZ,
  last_attempt_at TIMESTAMPTZ,
  created_at TIMESTAMPTZ DEFAULT NOW(),
  updated_at TIMESTAMPTZ DEFAULT NOW(),
  UNIQUE(user_id, exercise_id)
);

-- Indexes for common queries
CREATE INDEX IF NOT EXISTS idx_exercise_progress_user_id ON exercise_progress(user_id);
CREATE INDEX IF NOT EXISTS idx_exercise_progress_exercise_id ON exercise_progress(exercise_id);
CREATE INDEX IF NOT EXISTS idx_exercise_progress_status ON exercise_progress(status);
CREATE INDEX IF NOT EXISTS idx_exercise_progress_user_status ON exercise_progress(user_id, status);

-- Enable RLS
ALTER TABLE exercise_progress ENABLE ROW LEVEL SECURITY;

-- RLS Policies

-- Users can view their own exercise progress
CREATE POLICY "Users can view own exercise progress"
  ON exercise_progress
  FOR SELECT
  USING (auth.uid() = user_id);

-- Users can insert their own exercise progress
CREATE POLICY "Users can create own exercise progress"
  ON exercise_progress
  FOR INSERT
  WITH CHECK (auth.uid() = user_id);

-- Users can update their own exercise progress
CREATE POLICY "Users can update own exercise progress"
  ON exercise_progress
  FOR UPDATE
  USING (auth.uid() = user_id);

-- Instructors and admins can view all exercise progress (for analytics)
CREATE POLICY "Instructors can view all exercise progress"
  ON exercise_progress
  FOR SELECT
  USING (
    EXISTS (
      SELECT 1 FROM profiles
      WHERE profiles.id = auth.uid()
      AND profiles.role IN ('instructor', 'admin')
    )
  );

-- Updated_at trigger
CREATE OR REPLACE FUNCTION update_exercise_progress_updated_at()
RETURNS TRIGGER AS $$
BEGIN
  NEW.updated_at = NOW();
  RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER trigger_exercise_progress_updated_at
  BEFORE UPDATE ON exercise_progress
  FOR EACH ROW
  EXECUTE FUNCTION update_exercise_progress_updated_at();

-- Course Exercise Stats View
-- Aggregated stats for exercises by course/module
CREATE OR REPLACE VIEW exercise_stats AS
SELECT
  exercise_id,
  COUNT(*) AS total_attempts,
  COUNT(DISTINCT user_id) AS unique_users,
  COUNT(*) FILTER (WHERE status = 'completed') AS completions,
  AVG(attempts) AS avg_attempts,
  AVG(score) AS avg_score,
  AVG(EXTRACT(EPOCH FROM (completed_at - started_at))/60) FILTER (WHERE completed_at IS NOT NULL) AS avg_completion_time_minutes
FROM exercise_progress
GROUP BY exercise_id;

-- User Exercise Summary View
-- Summary of a user's exercise performance
CREATE OR REPLACE VIEW user_exercise_summary AS
SELECT
  user_id,
  COUNT(*) AS total_exercises_attempted,
  COUNT(*) FILTER (WHERE status = 'completed') AS exercises_completed,
  SUM(score) AS total_score,
  SUM(max_score) AS total_possible_score,
  ROUND((SUM(score) / NULLIF(SUM(max_score), 0) * 100)::numeric, 2) AS score_percentage
FROM exercise_progress
GROUP BY user_id;

-- Grant access to views
GRANT SELECT ON exercise_stats TO authenticated;
GRANT SELECT ON user_exercise_summary TO authenticated;

COMMENT ON TABLE exercise_progress IS 'Tracks user progress on interactive exercises (Python, SQL, Colab)';
COMMENT ON COLUMN exercise_progress.exercise_id IS 'Unique identifier matching the exercise YAML file ID';
COMMENT ON COLUMN exercise_progress.current_code IS 'Last saved code from the user';
COMMENT ON COLUMN exercise_progress.test_results IS 'JSON array of test case results from last submission';
-- =====================================================
-- Add slug column to courses table
-- =====================================================
-- This migration was partially applied - the slug column was added
-- See 20251225000006_fix_course_slugs.sql for actual slug values

-- Add slug column (if not exists is handled via DO block)
DO $$
BEGIN
  IF NOT EXISTS (
    SELECT 1 FROM information_schema.columns
    WHERE table_name = 'courses' AND column_name = 'slug'
  ) THEN
    ALTER TABLE courses ADD COLUMN slug TEXT;
  END IF;
END $$;

-- Create unique index on slug (only if not exists)
DO $$
BEGIN
  IF NOT EXISTS (
    SELECT 1 FROM pg_indexes WHERE indexname = 'courses_slug_idx'
  ) THEN
    CREATE UNIQUE INDEX courses_slug_idx ON courses(slug) WHERE slug IS NOT NULL;
  END IF;
END $$;

-- Add comment
COMMENT ON COLUMN courses.slug IS 'URL-friendly identifier matching content folder name';
-- =====================================================
-- Fix course slugs (repair migration)
-- =====================================================

-- First, let's see what courses exist and set unique slugs
-- This handles the case where multiple courses might match patterns

-- Set sklearn-intro slug (should already be set from previous partial migration)
UPDATE courses SET slug = 'sklearn-intro'
WHERE id = '7483519d-cc1d-4cba-bf52-6dde74ce8933' AND (slug IS NULL OR slug != 'sklearn-intro');

-- Set python-data-science slug for the Python intro course
-- Use the specific course title to avoid duplicates
UPDATE courses SET slug = 'python-data-science'
WHERE title = 'Introduccion a Python para Ciencia de Datos' AND slug IS NULL;

-- Verify the slugs are set correctly
DO $$
DECLARE
  sklearn_slug TEXT;
  python_slug TEXT;
BEGIN
  SELECT slug INTO sklearn_slug FROM courses WHERE id = '7483519d-cc1d-4cba-bf52-6dde74ce8933';
  SELECT slug INTO python_slug FROM courses WHERE title = 'Introduccion a Python para Ciencia de Datos';

  RAISE NOTICE 'Sklearn course slug: %', COALESCE(sklearn_slug, 'NOT SET');
  RAISE NOTICE 'Python course slug: %', COALESCE(python_slug, 'NOT SET');
END $$;
-- =====================================================
-- SECURITY FIX: search_path para funciones SECURITY DEFINER
-- y verificación de políticas RLS
-- =====================================================
-- Problema: Las funciones con SECURITY DEFINER sin search_path
-- son vulnerables a ataques de path manipulation.
-- Solución: Establecer explícitamente search_path = public
-- Referencia: https://supabase.com/docs/guides/database/functions#security-definer-vs-security-invoker
-- =====================================================

-- =====================================================
-- 1. handle_new_user() - Initial Schema
-- =====================================================
CREATE OR REPLACE FUNCTION public.handle_new_user()
RETURNS TRIGGER AS $$
BEGIN
  INSERT INTO public.profiles (id, full_name, avatar_url)
  VALUES (
    NEW.id,
    NEW.raw_user_meta_data->>'full_name',
    NEW.raw_user_meta_data->>'avatar_url'
  );
  RETURN NEW;
END;
$$ LANGUAGE plpgsql SECURITY DEFINER SET search_path = public;

-- =====================================================
-- 2. update_course_progress() - Progress Tracking
-- =====================================================
CREATE OR REPLACE FUNCTION public.update_course_progress()
RETURNS TRIGGER AS $$
DECLARE
  v_course_id UUID;
  v_total_lessons INTEGER;
  v_completed_lessons INTEGER;
  v_percentage DECIMAL(5,2);
BEGIN
  -- Get course_id from the lesson
  SELECT course_id INTO v_course_id
  FROM public.lessons
  WHERE id = NEW.lesson_id;

  -- Count total and completed lessons
  SELECT COUNT(*) INTO v_total_lessons
  FROM public.lessons
  WHERE course_id = v_course_id;

  SELECT COUNT(*) INTO v_completed_lessons
  FROM public.progress p
  JOIN public.lessons l ON l.id = p.lesson_id
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
  INSERT INTO public.course_progress (user_id, course_id, current_lesson_id, progress_percentage, last_accessed_at)
  VALUES (NEW.user_id, v_course_id, NEW.lesson_id, v_percentage, NOW())
  ON CONFLICT (user_id, course_id)
  DO UPDATE SET
    current_lesson_id = NEW.lesson_id,
    progress_percentage = v_percentage,
    last_accessed_at = NOW(),
    completed_at = CASE WHEN v_percentage >= 100 THEN NOW() ELSE public.course_progress.completed_at END;

  RETURN NEW;
END;
$$ LANGUAGE plpgsql SECURITY DEFINER SET search_path = public;

-- =====================================================
-- 3. check_quiz_attempts() - Quizzes
-- =====================================================
CREATE OR REPLACE FUNCTION public.check_quiz_attempts(p_user_id UUID, p_quiz_id UUID)
RETURNS TABLE (
  can_attempt BOOLEAN,
  attempts_used INTEGER,
  attempts_remaining INTEGER,
  best_score DECIMAL(5,2)
) AS $$
DECLARE
  v_max_attempts INTEGER;
  v_attempts_count INTEGER;
  v_best_score DECIMAL(5,2);
BEGIN
  -- Obtener max_attempts del quiz
  SELECT q.max_attempts INTO v_max_attempts
  FROM public.quizzes q WHERE q.id = p_quiz_id;

  -- Contar intentos del usuario
  SELECT COUNT(*), MAX(score) INTO v_attempts_count, v_best_score
  FROM public.quiz_attempts
  WHERE user_id = p_user_id AND quiz_id = p_quiz_id AND completed_at IS NOT NULL;

  RETURN QUERY SELECT
    (v_max_attempts IS NULL OR v_attempts_count < v_max_attempts) AS can_attempt,
    v_attempts_count AS attempts_used,
    CASE WHEN v_max_attempts IS NULL THEN NULL ELSE v_max_attempts - v_attempts_count END AS attempts_remaining,
    v_best_score AS best_score;
END;
$$ LANGUAGE plpgsql SECURITY DEFINER SET search_path = public;

-- =====================================================
-- 4. on_quiz_completed() - Quizzes
-- =====================================================
CREATE OR REPLACE FUNCTION public.on_quiz_completed()
RETURNS TRIGGER AS $$
DECLARE
  v_lesson_id UUID;
  v_course_id UUID;
  v_passed BOOLEAN;
BEGIN
  -- Solo actuar cuando se completa el intento
  IF NEW.completed_at IS NOT NULL AND OLD.completed_at IS NULL THEN
    -- Obtener lesson_id y course_id
    SELECT q.lesson_id, l.course_id INTO v_lesson_id, v_course_id
    FROM public.quizzes q
    JOIN public.lessons l ON l.id = q.lesson_id
    WHERE q.id = NEW.quiz_id;

    -- Si paso el quiz, marcar la leccion como completada
    IF NEW.passed = true THEN
      INSERT INTO public.progress (user_id, lesson_id, completed, completed_at)
      VALUES (NEW.user_id, v_lesson_id, true, NOW())
      ON CONFLICT (user_id, lesson_id)
      DO UPDATE SET completed = true, completed_at = NOW();
    END IF;
  END IF;

  RETURN NEW;
END;
$$ LANGUAGE plpgsql SECURITY DEFINER SET search_path = public;

-- =====================================================
-- 5. update_forum_post_count() - Forums
-- =====================================================
CREATE OR REPLACE FUNCTION public.update_forum_post_count()
RETURNS TRIGGER AS $$
BEGIN
  IF TG_OP = 'INSERT' THEN
    UPDATE public.forums SET post_count = post_count + 1, updated_at = NOW()
    WHERE id = NEW.forum_id;
  ELSIF TG_OP = 'DELETE' THEN
    UPDATE public.forums SET post_count = post_count - 1, updated_at = NOW()
    WHERE id = OLD.forum_id;
  END IF;
  RETURN NULL;
END;
$$ LANGUAGE plpgsql SECURITY DEFINER SET search_path = public;

-- =====================================================
-- 6. update_post_reply_count() - Forums
-- =====================================================
CREATE OR REPLACE FUNCTION public.update_post_reply_count()
RETURNS TRIGGER AS $$
BEGIN
  IF TG_OP = 'INSERT' THEN
    UPDATE public.forum_posts SET
      reply_count = reply_count + 1,
      last_reply_at = NOW(),
      last_reply_by = NEW.user_id,
      updated_at = NOW()
    WHERE id = NEW.post_id;
  ELSIF TG_OP = 'DELETE' THEN
    UPDATE public.forum_posts SET
      reply_count = reply_count - 1,
      updated_at = NOW()
    WHERE id = OLD.post_id;
  END IF;
  RETURN NULL;
END;
$$ LANGUAGE plpgsql SECURITY DEFINER SET search_path = public;

-- =====================================================
-- 7. notify_on_reply() - Forums
-- =====================================================
CREATE OR REPLACE FUNCTION public.notify_on_reply()
RETURNS TRIGGER AS $$
DECLARE
  v_post_title TEXT;
  v_post_author UUID;
  v_course_id UUID;
BEGIN
  -- Obtener info del post
  SELECT p.title, p.user_id, f.course_id
  INTO v_post_title, v_post_author, v_course_id
  FROM public.forum_posts p
  JOIN public.forums f ON f.id = p.forum_id
  WHERE p.id = NEW.post_id;

  -- Notificar al autor del post (si no es el mismo que responde)
  IF v_post_author != NEW.user_id THEN
    INSERT INTO public.notifications (user_id, type, title, content, related_url, related_id)
    VALUES (
      v_post_author,
      'reply',
      'Nueva respuesta en tu post',
      'Alguien respondio a: ' || v_post_title,
      '/courses/' || v_course_id || '/forum/' || NEW.post_id,
      NEW.id
    );
  END IF;

  -- Si es respuesta a otra respuesta, notificar al autor de esa respuesta
  IF NEW.parent_reply_id IS NOT NULL THEN
    DECLARE
      v_parent_author UUID;
    BEGIN
      SELECT user_id INTO v_parent_author
      FROM public.forum_replies
      WHERE id = NEW.parent_reply_id;

      IF v_parent_author != NEW.user_id AND v_parent_author != v_post_author THEN
        INSERT INTO public.notifications (user_id, type, title, content, related_url, related_id)
        VALUES (
          v_parent_author,
          'reply',
          'Nueva respuesta a tu comentario',
          'Alguien respondio a tu comentario en: ' || v_post_title,
          '/courses/' || v_course_id || '/forum/' || NEW.post_id,
          NEW.id
        );
      END IF;
    END;
  END IF;

  RETURN NEW;
END;
$$ LANGUAGE plpgsql SECURITY DEFINER SET search_path = public;

-- =====================================================
-- 8. notify_answer_marked() - Forums
-- =====================================================
CREATE OR REPLACE FUNCTION public.notify_answer_marked()
RETURNS TRIGGER AS $$
DECLARE
  v_post_title TEXT;
  v_course_id UUID;
BEGIN
  IF NEW.is_answer = true AND (OLD.is_answer = false OR OLD.is_answer IS NULL) THEN
    SELECT p.title, f.course_id
    INTO v_post_title, v_course_id
    FROM public.forum_posts p
    JOIN public.forums f ON f.id = p.forum_id
    WHERE p.id = NEW.post_id;

    INSERT INTO public.notifications (user_id, type, title, content, related_url, related_id)
    VALUES (
      NEW.user_id,
      'answer',
      'Tu respuesta fue marcada como solucion',
      'Tu respuesta en "' || v_post_title || '" fue marcada como la solucion',
      '/courses/' || v_course_id || '/forum/' || NEW.post_id,
      NEW.id
    );
  END IF;

  RETURN NEW;
END;
$$ LANGUAGE plpgsql SECURITY DEFINER SET search_path = public;

-- =====================================================
-- 9. update_exercise_progress_updated_at() - Exercises
-- Aunque no tiene SECURITY DEFINER, añadimos search_path por consistencia
-- =====================================================
CREATE OR REPLACE FUNCTION public.update_exercise_progress_updated_at()
RETURNS TRIGGER AS $$
BEGIN
  NEW.updated_at = NOW();
  RETURN NEW;
END;
$$ LANGUAGE plpgsql SET search_path = public;

-- =====================================================
-- 10. increment_download_count() - Content Management
-- Esta función también tiene SECURITY DEFINER
-- =====================================================
CREATE OR REPLACE FUNCTION public.increment_download_count(resource_id UUID)
RETURNS void AS $$
BEGIN
  UPDATE public.resources
  SET download_count = download_count + 1
  WHERE id = resource_id;
END;
$$ LANGUAGE plpgsql SECURITY DEFINER SET search_path = public;

-- =====================================================
-- 11. auto_version_number() - Content Management
-- =====================================================
CREATE OR REPLACE FUNCTION public.auto_version_number()
RETURNS TRIGGER AS $$
BEGIN
  SELECT COALESCE(MAX(version_number), 0) + 1
  INTO NEW.version_number
  FROM public.content_versions
  WHERE lesson_id = NEW.lesson_id;

  RETURN NEW;
END;
$$ LANGUAGE plpgsql SET search_path = public;

-- =====================================================
-- 12. handle_version_activation() - Content Management
-- =====================================================
CREATE OR REPLACE FUNCTION public.handle_version_activation()
RETURNS TRIGGER AS $$
BEGIN
  IF NEW.is_active = true AND (OLD.is_active IS NULL OR OLD.is_active = false) THEN
    -- Deactivate all other versions for this lesson
    UPDATE public.content_versions
    SET is_active = false
    WHERE lesson_id = NEW.lesson_id
    AND id != NEW.id
    AND is_active = true;
  END IF;

  RETURN NEW;
END;
$$ LANGUAGE plpgsql SET search_path = public;

-- =====================================================
-- 13. update_resources_timestamp() - Content Management
-- =====================================================
CREATE OR REPLACE FUNCTION public.update_resources_timestamp()
RETURNS TRIGGER AS $$
BEGIN
  NEW.updated_at = NOW();
  RETURN NEW;
END;
$$ LANGUAGE plpgsql SET search_path = public;

-- =====================================================
-- VERIFICACIÓN DE POLÍTICAS RLS PARA content_versions
-- Re-crear las políticas para asegurar que existen
-- =====================================================

-- Eliminar políticas existentes si hay problemas
DROP POLICY IF EXISTS "Enrolled users can view active content versions" ON public.content_versions;
DROP POLICY IF EXISTS "Instructors can view all content versions" ON public.content_versions;
DROP POLICY IF EXISTS "Instructors can create content versions" ON public.content_versions;
DROP POLICY IF EXISTS "Instructors can update content versions" ON public.content_versions;

-- Re-crear las políticas RLS para content_versions

-- Anyone enrolled can view active versions
CREATE POLICY "Enrolled users can view active content versions"
  ON public.content_versions FOR SELECT
  USING (
    is_active = true
    AND EXISTS (
      SELECT 1 FROM public.lessons l
      JOIN public.courses c ON l.course_id = c.id
      WHERE l.id = content_versions.lesson_id
      AND (
        c.is_published = true
        OR c.instructor_id = auth.uid()
        OR EXISTS (
          SELECT 1 FROM public.enrollments e
          WHERE e.course_id = c.id AND e.user_id = auth.uid()
        )
      )
    )
  );

-- Instructors can view all versions of their courses
CREATE POLICY "Instructors can view all content versions"
  ON public.content_versions FOR SELECT
  USING (
    EXISTS (
      SELECT 1 FROM public.lessons l
      JOIN public.courses c ON l.course_id = c.id
      WHERE l.id = content_versions.lesson_id
      AND c.instructor_id = auth.uid()
    )
  );

-- Instructors can create versions
CREATE POLICY "Instructors can create content versions"
  ON public.content_versions FOR INSERT
  WITH CHECK (
    EXISTS (
      SELECT 1 FROM public.lessons l
      JOIN public.courses c ON l.course_id = c.id
      WHERE l.id = content_versions.lesson_id
      AND c.instructor_id = auth.uid()
    )
  );

-- Instructors can update versions (activate/deactivate)
CREATE POLICY "Instructors can update content versions"
  ON public.content_versions FOR UPDATE
  USING (
    EXISTS (
      SELECT 1 FROM public.lessons l
      JOIN public.courses c ON l.course_id = c.id
      WHERE l.id = content_versions.lesson_id
      AND c.instructor_id = auth.uid()
    )
  );

-- =====================================================
-- COMENTARIOS DE DOCUMENTACIÓN
-- =====================================================
COMMENT ON FUNCTION public.handle_new_user() IS 'Crea perfil automáticamente al registrarse un usuario. SECURITY DEFINER con search_path=public.';
COMMENT ON FUNCTION public.update_course_progress() IS 'Actualiza el progreso del curso cuando se completa una lección. SECURITY DEFINER con search_path=public.';
COMMENT ON FUNCTION public.check_quiz_attempts(UUID, UUID) IS 'Verifica intentos restantes de un quiz. SECURITY DEFINER con search_path=public.';
COMMENT ON FUNCTION public.on_quiz_completed() IS 'Marca lección como completada al aprobar quiz. SECURITY DEFINER con search_path=public.';
COMMENT ON FUNCTION public.update_forum_post_count() IS 'Actualiza contador de posts en foros. SECURITY DEFINER con search_path=public.';
COMMENT ON FUNCTION public.update_post_reply_count() IS 'Actualiza contador de respuestas en posts. SECURITY DEFINER con search_path=public.';
COMMENT ON FUNCTION public.notify_on_reply() IS 'Crea notificación al recibir respuesta. SECURITY DEFINER con search_path=public.';
COMMENT ON FUNCTION public.notify_answer_marked() IS 'Notifica cuando respuesta es marcada como solución. SECURITY DEFINER con search_path=public.';
COMMENT ON FUNCTION public.increment_download_count(UUID) IS 'Incrementa contador de descargas de recursos. SECURITY DEFINER con search_path=public.';
-- =====================================================
-- SECURITY FIX PART 2: RLS y Security Definer Views
-- =====================================================

-- =====================================================
-- 1. HABILITAR RLS EN TABLAS (por si se deshabilitó)
-- =====================================================
ALTER TABLE public.profiles ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.courses ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.lessons ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.progress ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.enrollments ENABLE ROW LEVEL SECURITY;

-- =====================================================
-- 2. ARREGLAR VISTAS CON SECURITY DEFINER
-- Las vistas exercise_stats y user_exercise_summary
-- usan SECURITY DEFINER implícitamente.
-- Recrearlas con SECURITY INVOKER.
-- =====================================================

-- Eliminar vistas existentes
DROP VIEW IF EXISTS public.exercise_stats;
DROP VIEW IF EXISTS public.user_exercise_summary;

-- Recrear exercise_stats con SECURITY INVOKER
CREATE VIEW public.exercise_stats
WITH (security_invoker = true)
AS
SELECT
  exercise_id,
  COUNT(*) AS total_attempts,
  COUNT(DISTINCT user_id) AS unique_users,
  COUNT(*) FILTER (WHERE status = 'completed') AS completions,
  AVG(attempts) AS avg_attempts,
  AVG(score) AS avg_score,
  AVG(EXTRACT(EPOCH FROM (completed_at - started_at))/60) FILTER (WHERE completed_at IS NOT NULL) AS avg_completion_time_minutes
FROM public.exercise_progress
GROUP BY exercise_id;

-- Recrear user_exercise_summary con SECURITY INVOKER
CREATE VIEW public.user_exercise_summary
WITH (security_invoker = true)
AS
SELECT
  user_id,
  COUNT(*) AS total_exercises_attempted,
  COUNT(*) FILTER (WHERE status = 'completed') AS exercises_completed,
  SUM(score) AS total_score,
  SUM(max_score) AS total_possible_score,
  ROUND((SUM(score) / NULLIF(SUM(max_score), 0) * 100)::numeric, 2) AS score_percentage
FROM public.exercise_progress
GROUP BY user_id;

-- Otorgar permisos a las vistas
GRANT SELECT ON public.exercise_stats TO authenticated;
GRANT SELECT ON public.user_exercise_summary TO authenticated;

-- =====================================================
-- COMENTARIOS
-- =====================================================
COMMENT ON VIEW public.exercise_stats IS 'Estadísticas agregadas de ejercicios. SECURITY INVOKER para respetar RLS.';
COMMENT ON VIEW public.user_exercise_summary IS 'Resumen de ejercicios por usuario. SECURITY INVOKER para respetar RLS.';
-- =====================================================
-- Seed: Curso ONA Fundamentals
-- 2 modulos, 5 lecciones, 11 ejercicios (10 + quiz final)
-- Introduccion al Analisis de Redes Organizacionales
-- =====================================================

-- 1. Insertar el curso
INSERT INTO courses (id, title, description, slug, thumbnail_url, is_published)
VALUES (
  'ona00000-0000-0000-0000-000000000001',
  'Introduccion al Analisis de Redes Organizacionales (ONA)',
  'Aprende a revelar la estructura informal de tu organizacion. Diagnostica silos, cuellos de botella y dependencias usando analisis de redes. Curso practico con casos reales de LATAM, sin necesidad de programar.',
  'ona-fundamentals',
  '/images/courses/ona-fundamentals-thumbnail.png',
  true
)
ON CONFLICT (id) DO UPDATE SET
  title = EXCLUDED.title,
  description = EXCLUDED.description,
  slug = EXCLUDED.slug,
  is_published = EXCLUDED.is_published;

-- 2. Insertar los modulos
INSERT INTO modules (id, course_id, title, description, order_index, is_locked)
VALUES
  ('ona10000-0000-0000-0000-000000000001', 'ona00000-0000-0000-0000-000000000001', 'Entendiendo las Redes Ocultas', 'Descubre la diferencia entre organigrama y red informal, aprende las metricas clave y diseña encuestas ONA efectivas.', 1, false),
  ('ona20000-0000-0000-0000-000000000001', 'ona00000-0000-0000-0000-000000000001', 'De Datos a Decisiones', 'Identifica patrones problematicos (silos, cuellos de botella, dependencias) y aprende a formular recomendaciones accionables.', 2, false)
ON CONFLICT (id) DO UPDATE SET
  title = EXCLUDED.title,
  description = EXCLUDED.description;

-- 3. Insertar las lecciones
INSERT INTO lessons (id, course_id, module_id, title, content, lesson_type, order_index, duration_minutes, is_required, video_url)
VALUES
  -- Modulo 1: Entendiendo las Redes Ocultas
  ('ona10100-0000-0000-0000-000000000001', 'ona00000-0000-0000-0000-000000000001', 'ona10000-0000-0000-0000-000000000001', 'Organigrama vs Red Informal', 'Ver archivo: content/courses/ona-fundamentals/module-01/lessons/01-organigrama-vs-red.md', 'text', 1, 20, true, null),
  ('ona10200-0000-0000-0000-000000000001', 'ona00000-0000-0000-0000-000000000001', 'ona10000-0000-0000-0000-000000000001', 'Metricas de Centralidad', 'Ver archivo: content/courses/ona-fundamentals/module-01/lessons/02-metricas-centralidad.md', 'text', 2, 30, true, null),
  ('ona10300-0000-0000-0000-000000000001', 'ona00000-0000-0000-0000-000000000001', 'ona10000-0000-0000-0000-000000000001', 'Disenando Encuestas ONA', 'Ver archivo: content/courses/ona-fundamentals/module-01/lessons/03-diseno-encuesta.md', 'text', 3, 25, true, null),

  -- Modulo 2: De Datos a Decisiones
  ('ona20100-0000-0000-0000-000000000001', 'ona00000-0000-0000-0000-000000000001', 'ona20000-0000-0000-0000-000000000001', 'Patrones Problematicos', 'Ver archivo: content/courses/ona-fundamentals/module-02/lessons/04-patrones-problematicos.md', 'text', 1, 35, true, null),
  ('ona20200-0000-0000-0000-000000000001', 'ona00000-0000-0000-0000-000000000001', 'ona20000-0000-0000-0000-000000000001', 'Caso Integrador: Aseguradora del Pacifico', 'Ver archivo: content/courses/ona-fundamentals/module-02/lessons/05-caso-integrador.md', 'text', 2, 30, true, null)

ON CONFLICT (id) DO UPDATE SET
  title = EXCLUDED.title,
  content = EXCLUDED.content;

-- 4. Insertar los ejercicios
-- Nota: Los ejercicios usan el sistema de archivos YAML, esta tabla es para tracking de progreso

INSERT INTO exercises (id, course_id, module_id, lesson_id, title, description, exercise_type, difficulty, points, order_index)
VALUES
  -- Modulo 1 Ejercicios
  ('ona10101-0000-0000-0000-000000000001', 'ona00000-0000-0000-0000-000000000001', 'ona10000-0000-0000-0000-000000000001', 'ona10100-0000-0000-0000-000000000001', 'Detectando la red oculta', 'Compara el organigrama formal con la red informal de consultas.', 'code-python', 'beginner', 20, 1),
  ('ona10102-0000-0000-0000-000000000001', 'ona00000-0000-0000-0000-000000000001', 'ona10000-0000-0000-0000-000000000001', 'ona10100-0000-0000-0000-000000000001', 'Identificando al broker', 'Encuentra quien conecta departamentos que de otra forma estarian aislados.', 'code-python', 'beginner', 20, 2),
  ('ona10201-0000-0000-0000-000000000001', 'ona00000-0000-0000-0000-000000000001', 'ona10000-0000-0000-0000-000000000001', 'ona10200-0000-0000-0000-000000000001', 'Calculadora de centralidad', 'Explora como cambian las metricas al modificar conexiones.', 'code-python', 'intermediate', 30, 3),
  ('ona10202-0000-0000-0000-000000000001', 'ona00000-0000-0000-0000-000000000001', 'ona10000-0000-0000-0000-000000000001', 'ona10200-0000-0000-0000-000000000001', 'Caso Banco Regional', 'Interpreta las metricas de ONA para diagnosticar tiempos de aprobacion.', 'code-python', 'intermediate', 30, 4),
  ('ona10301-0000-0000-0000-000000000001', 'ona00000-0000-0000-0000-000000000001', 'ona10000-0000-0000-0000-000000000001', 'ona10300-0000-0000-0000-000000000001', 'Constructor de preguntas ONA', 'Aprende a disenar preguntas de encuesta ONA efectivas.', 'quiz', 'beginner', 30, 5),
  ('ona10302-0000-0000-0000-000000000001', 'ona00000-0000-0000-0000-000000000001', 'ona10000-0000-0000-0000-000000000001', 'ona10300-0000-0000-0000-000000000001', 'Auditor de encuestas ONA', 'Evalua la calidad de encuestas ONA reales.', 'quiz', 'intermediate', 40, 6),

  -- Modulo 2 Ejercicios
  ('ona20101-0000-0000-0000-000000000001', 'ona00000-0000-0000-0000-000000000001', 'ona20000-0000-0000-0000-000000000001', 'ona20100-0000-0000-0000-000000000001', 'Diagnostico de silos', 'Identifica y cuantifica silos entre departamentos.', 'code-python', 'intermediate', 30, 7),
  ('ona20102-0000-0000-0000-000000000001', 'ona00000-0000-0000-0000-000000000001', 'ona20000-0000-0000-0000-000000000001', 'ona20100-0000-0000-0000-000000000001', 'Riesgo de dependencia', 'Identifica personas clave cuya salida impactaria la red.', 'code-python', 'intermediate', 35, 8),
  ('ona20103-0000-0000-0000-000000000001', 'ona00000-0000-0000-0000-000000000001', 'ona20000-0000-0000-0000-000000000001', 'ona20100-0000-0000-0000-000000000001', 'Simulador de impacto', 'Simula el impacto de remover o agregar conexiones.', 'code-python', 'intermediate', 35, 9),
  ('ona20201-0000-0000-0000-000000000001', 'ona00000-0000-0000-0000-000000000001', 'ona20000-0000-0000-0000-000000000001', 'ona20200-0000-0000-0000-000000000001', 'Caso Aseguradora del Pacifico', 'Aplica todo lo aprendido en un caso integrador.', 'code-python', 'advanced', 50, 10),
  ('ona20202-0000-0000-0000-000000000001', 'ona00000-0000-0000-0000-000000000001', 'ona20000-0000-0000-0000-000000000001', 'ona20200-0000-0000-0000-000000000001', 'Evaluacion Final ONA', 'Demuestra tu dominio de los conceptos de ONA.', 'quiz', 'intermediate', 100, 11)

ON CONFLICT (id) DO UPDATE SET
  title = EXCLUDED.title,
  description = EXCLUDED.description;

-- Verificacion
SELECT
    'Curso ONA Fundamentals creado' as status,
    (SELECT COUNT(*) FROM courses WHERE slug = 'ona-fundamentals') as cursos,
    (SELECT COUNT(*) FROM modules WHERE course_id = 'ona00000-0000-0000-0000-000000000001') as modulos,
    (SELECT COUNT(*) FROM lessons WHERE course_id = 'ona00000-0000-0000-0000-000000000001') as lecciones,
    (SELECT COUNT(*) FROM exercises WHERE course_id = 'ona00000-0000-0000-0000-000000000001') as ejercicios;
