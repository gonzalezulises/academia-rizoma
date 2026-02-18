-- Atomic increment for time tracking (prevents overwrite bug)
CREATE OR REPLACE FUNCTION increment_time_spent(p_user_id UUID, p_course_id UUID, p_delta INTEGER)
RETURNS void AS $$
BEGIN
  INSERT INTO course_progress (user_id, course_id, total_time_spent, last_accessed_at)
  VALUES (p_user_id, p_course_id, p_delta, NOW())
  ON CONFLICT (user_id, course_id)
  DO UPDATE SET
    total_time_spent = course_progress.total_time_spent + p_delta,
    last_accessed_at = NOW();
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;

-- Atomic increment for forum post views (prevents race condition)
CREATE OR REPLACE FUNCTION increment_post_views(p_post_id UUID)
RETURNS void AS $$
BEGIN
  UPDATE forum_posts SET views = views + 1 WHERE id = p_post_id;
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;
