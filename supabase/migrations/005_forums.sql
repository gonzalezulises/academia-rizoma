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
