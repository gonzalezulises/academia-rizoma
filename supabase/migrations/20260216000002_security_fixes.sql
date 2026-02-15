-- Phase 2: Security fixes
-- 1. Restrict notification INSERT policy (SECURITY DEFINER triggers bypass RLS)
DROP POLICY IF EXISTS "Sistema puede crear notificaciones" ON notifications;
CREATE POLICY "Usuarios pueden crear sus notificaciones"
  ON notifications FOR INSERT
  WITH CHECK (user_id = auth.uid());
