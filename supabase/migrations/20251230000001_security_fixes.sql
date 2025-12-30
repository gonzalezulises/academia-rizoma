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
