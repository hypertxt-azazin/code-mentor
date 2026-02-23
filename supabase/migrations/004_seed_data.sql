-- ============================================================
-- SEED: Badges
-- ============================================================
INSERT INTO badges (id, code, title, description) VALUES
  (uuid_generate_v4(), 'FIRST_LESSON', 'First Steps', 'Completed your very first lesson'),
  (uuid_generate_v4(), 'SEVEN_DAY_STREAK', 'Week Warrior', 'Maintained a 7-day learning streak'),
  (uuid_generate_v4(), 'TEN_CORRECT', 'Perfect Ten', 'Answered 10 practice questions correctly'),
  (uuid_generate_v4(), 'FIRST_QUIZ_PASS', 'Quiz Champion', 'Passed your first module quiz')
ON CONFLICT (code) DO NOTHING;

-- ============================================================
-- SEED: App Config
-- ============================================================
INSERT INTO app_config (key, value) VALUES
  ('free_daily_attempt_limit', '{"limit": 15}'),
  ('free_modules_per_track', '{"limit": 2}')
ON CONFLICT (key) DO NOTHING;
