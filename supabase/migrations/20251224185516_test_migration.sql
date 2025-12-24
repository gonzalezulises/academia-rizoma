-- Test migration to verify Supabase CLI setup
-- This adds a bio column to profiles

ALTER TABLE profiles
ADD COLUMN IF NOT EXISTS bio TEXT;

COMMENT ON COLUMN profiles.bio IS 'User biography/description';
