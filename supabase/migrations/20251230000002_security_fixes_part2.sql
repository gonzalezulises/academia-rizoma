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
