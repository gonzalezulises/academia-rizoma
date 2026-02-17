-- Expand exercise_type CHECK constraint to include 'reflection' and 'case-study'
-- This allows the lesson wizard to create these new exercise types.

ALTER TABLE course_exercises
  DROP CONSTRAINT IF EXISTS course_exercises_exercise_type_check;

ALTER TABLE course_exercises
  ADD CONSTRAINT course_exercises_exercise_type_check
  CHECK (exercise_type IN ('code-python', 'sql', 'quiz', 'colab', 'reflection', 'case-study'));
