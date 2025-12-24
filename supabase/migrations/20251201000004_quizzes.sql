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
