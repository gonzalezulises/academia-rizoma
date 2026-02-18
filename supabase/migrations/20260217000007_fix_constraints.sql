-- Fix schema constraints found during audit
-- 1) course_exercises.module_id: NOT NULL but wizard allows null → make nullable
-- 2) lesson_metadata.practice_ratio: DECIMAL(3,2) overflows at >9.99 → widen

-- ============================================================
-- 1. course_exercises.module_id → nullable
-- ============================================================
ALTER TABLE course_exercises ALTER COLUMN module_id DROP NOT NULL;

-- ============================================================
-- 2. lesson_metadata.practice_ratio → DECIMAL(5,4) to support any ratio
-- ============================================================
ALTER TABLE lesson_metadata ALTER COLUMN practice_ratio TYPE DECIMAL(5,4);
