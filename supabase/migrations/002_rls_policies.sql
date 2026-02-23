-- ============================================================
-- Enable RLS on all tables
-- ============================================================
ALTER TABLE profiles ENABLE ROW LEVEL SECURITY;
ALTER TABLE tracks ENABLE ROW LEVEL SECURITY;
ALTER TABLE modules ENABLE ROW LEVEL SECURITY;
ALTER TABLE lessons ENABLE ROW LEVEL SECURITY;
ALTER TABLE challenges ENABLE ROW LEVEL SECURITY;
ALTER TABLE quiz_questions ENABLE ROW LEVEL SECURITY;
ALTER TABLE user_lesson_progress ENABLE ROW LEVEL SECURITY;
ALTER TABLE user_challenge_attempts ENABLE ROW LEVEL SECURITY;
ALTER TABLE user_quiz_attempts ENABLE ROW LEVEL SECURITY;
ALTER TABLE user_streaks ENABLE ROW LEVEL SECURITY;
ALTER TABLE badges ENABLE ROW LEVEL SECURITY;
ALTER TABLE user_badges ENABLE ROW LEVEL SECURITY;
ALTER TABLE app_config ENABLE ROW LEVEL SECURITY;
ALTER TABLE daily_usage ENABLE ROW LEVEL SECURITY;
ALTER TABLE events ENABLE ROW LEVEL SECURITY;

-- Helper function: check if current user is admin
CREATE OR REPLACE FUNCTION is_admin()
RETURNS boolean
LANGUAGE sql
SECURITY DEFINER
STABLE
AS $$
  SELECT COALESCE(
    (SELECT is_admin FROM profiles WHERE id = auth.uid()),
    false
  );
$$;

-- ============================================================
-- profiles
-- ============================================================
CREATE POLICY "profiles_select_own" ON profiles FOR SELECT
  USING (auth.uid() = id OR is_admin());

CREATE POLICY "profiles_insert_own" ON profiles FOR INSERT
  WITH CHECK (auth.uid() = id);

CREATE POLICY "profiles_update_own" ON profiles FOR UPDATE
  USING (auth.uid() = id OR is_admin())
  WITH CHECK (
    auth.uid() = id OR is_admin()
  );

-- Prevent non-admins from setting is_admin or is_premium
CREATE POLICY "profiles_admin_columns" ON profiles FOR UPDATE
  USING (
    CASE WHEN (NEW.is_admin != OLD.is_admin OR NEW.is_premium != OLD.is_premium)
    THEN is_admin()
    ELSE true
    END
  );

-- ============================================================
-- Content tables: SELECT open to authenticated; writes admin-only
-- ============================================================
CREATE POLICY "tracks_select" ON tracks FOR SELECT TO authenticated USING (true);
CREATE POLICY "tracks_insert" ON tracks FOR INSERT TO authenticated WITH CHECK (is_admin());
CREATE POLICY "tracks_update" ON tracks FOR UPDATE TO authenticated USING (is_admin());
CREATE POLICY "tracks_delete" ON tracks FOR DELETE TO authenticated USING (is_admin());

CREATE POLICY "modules_select" ON modules FOR SELECT TO authenticated USING (true);
CREATE POLICY "modules_insert" ON modules FOR INSERT TO authenticated WITH CHECK (is_admin());
CREATE POLICY "modules_update" ON modules FOR UPDATE TO authenticated USING (is_admin());
CREATE POLICY "modules_delete" ON modules FOR DELETE TO authenticated USING (is_admin());

CREATE POLICY "lessons_select" ON lessons FOR SELECT TO authenticated USING (true);
CREATE POLICY "lessons_insert" ON lessons FOR INSERT TO authenticated WITH CHECK (is_admin());
CREATE POLICY "lessons_update" ON lessons FOR UPDATE TO authenticated USING (is_admin());
CREATE POLICY "lessons_delete" ON lessons FOR DELETE TO authenticated USING (is_admin());

CREATE POLICY "challenges_select" ON challenges FOR SELECT TO authenticated USING (true);
CREATE POLICY "challenges_insert" ON challenges FOR INSERT TO authenticated WITH CHECK (is_admin());
CREATE POLICY "challenges_update" ON challenges FOR UPDATE TO authenticated USING (is_admin());
CREATE POLICY "challenges_delete" ON challenges FOR DELETE TO authenticated USING (is_admin());

CREATE POLICY "quiz_questions_select" ON quiz_questions FOR SELECT TO authenticated USING (true);
CREATE POLICY "quiz_questions_insert" ON quiz_questions FOR INSERT TO authenticated WITH CHECK (is_admin());
CREATE POLICY "quiz_questions_update" ON quiz_questions FOR UPDATE TO authenticated USING (is_admin());
CREATE POLICY "quiz_questions_delete" ON quiz_questions FOR DELETE TO authenticated USING (is_admin());

-- ============================================================
-- User progress tables: user can CRUD only their own rows
-- ============================================================
CREATE POLICY "ulp_select" ON user_lesson_progress FOR SELECT USING (user_id = auth.uid());
CREATE POLICY "ulp_insert" ON user_lesson_progress FOR INSERT WITH CHECK (user_id = auth.uid());
CREATE POLICY "ulp_update" ON user_lesson_progress FOR UPDATE USING (user_id = auth.uid());

CREATE POLICY "uca_select" ON user_challenge_attempts FOR SELECT USING (user_id = auth.uid());
CREATE POLICY "uca_insert" ON user_challenge_attempts FOR INSERT WITH CHECK (user_id = auth.uid());

CREATE POLICY "uqa_select" ON user_quiz_attempts FOR SELECT USING (user_id = auth.uid());
CREATE POLICY "uqa_insert" ON user_quiz_attempts FOR INSERT WITH CHECK (user_id = auth.uid());

CREATE POLICY "us_select" ON user_streaks FOR SELECT USING (user_id = auth.uid());
CREATE POLICY "us_insert" ON user_streaks FOR INSERT WITH CHECK (user_id = auth.uid());
CREATE POLICY "us_update" ON user_streaks FOR UPDATE USING (user_id = auth.uid());

-- ============================================================
-- Badges: SELECT open; writes admin-only
-- ============================================================
CREATE POLICY "badges_select" ON badges FOR SELECT TO authenticated USING (true);
CREATE POLICY "badges_insert" ON badges FOR INSERT TO authenticated WITH CHECK (is_admin());
CREATE POLICY "badges_update" ON badges FOR UPDATE TO authenticated USING (is_admin());
CREATE POLICY "badges_delete" ON badges FOR DELETE TO authenticated USING (is_admin());

-- user_badges: user reads own; insert by user (own only) or admin
CREATE POLICY "ub_select" ON user_badges FOR SELECT USING (user_id = auth.uid() OR is_admin());
CREATE POLICY "ub_insert" ON user_badges FOR INSERT WITH CHECK (user_id = auth.uid() OR is_admin());

-- ============================================================
-- app_config: admin manages; authenticated reads
-- ============================================================
CREATE POLICY "config_select" ON app_config FOR SELECT TO authenticated USING (true);
CREATE POLICY "config_insert" ON app_config FOR INSERT TO authenticated WITH CHECK (is_admin());
CREATE POLICY "config_update" ON app_config FOR UPDATE TO authenticated USING (is_admin());

-- ============================================================
-- daily_usage: user manages own row
-- ============================================================
CREATE POLICY "du_select" ON daily_usage FOR SELECT USING (user_id = auth.uid());
CREATE POLICY "du_insert" ON daily_usage FOR INSERT WITH CHECK (user_id = auth.uid());
CREATE POLICY "du_update" ON daily_usage FOR UPDATE USING (user_id = auth.uid());

-- ============================================================
-- events: user inserts own; reads own
-- ============================================================
CREATE POLICY "events_insert" ON events FOR INSERT WITH CHECK (user_id = auth.uid() OR user_id IS NULL);
CREATE POLICY "events_select" ON events FOR SELECT USING (user_id = auth.uid() OR is_admin());
