-- Phase 4: Database fixes

-- 1. NOT NULL constraints on quiz_attempts
-- Pre-check: ensure no NULL values exist before adding constraints
DO $$
BEGIN
  IF EXISTS (SELECT 1 FROM quiz_attempts WHERE user_id IS NULL) THEN
    RAISE EXCEPTION 'quiz_attempts has rows with NULL user_id — clean up before applying NOT NULL';
  END IF;
  IF EXISTS (SELECT 1 FROM quiz_attempts WHERE quiz_id IS NULL) THEN
    RAISE EXCEPTION 'quiz_attempts has rows with NULL quiz_id — clean up before applying NOT NULL';
  END IF;
END $$;

ALTER TABLE quiz_attempts ALTER COLUMN user_id SET NOT NULL;
ALTER TABLE quiz_attempts ALTER COLUMN quiz_id SET NOT NULL;

-- 2. Composite indexes for common query patterns
CREATE INDEX IF NOT EXISTS idx_forum_posts_forum_pinned
  ON forum_posts(forum_id, is_pinned DESC, created_at DESC);
CREATE INDEX IF NOT EXISTS idx_forum_replies_post_created
  ON forum_replies(post_id, created_at);
CREATE INDEX IF NOT EXISTS idx_quiz_attempts_user_quiz
  ON quiz_attempts(user_id, quiz_id);

-- 3. FK reviewed_by with ON DELETE SET NULL
ALTER TABLE submissions DROP CONSTRAINT IF EXISTS submissions_reviewed_by_fkey;
ALTER TABLE submissions ADD CONSTRAINT submissions_reviewed_by_fkey
  FOREIGN KEY (reviewed_by) REFERENCES profiles(id) ON DELETE SET NULL;
