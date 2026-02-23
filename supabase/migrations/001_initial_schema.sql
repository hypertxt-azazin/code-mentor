-- Enable UUID extension
CREATE EXTENSION IF NOT EXISTS "uuid-ossp";

-- ============================================================
-- A) IDENTITY
-- ============================================================

CREATE TABLE IF NOT EXISTS profiles (
  id uuid PRIMARY KEY REFERENCES auth.users(id) ON DELETE CASCADE,
  username text UNIQUE,
  display_name text,
  interests text[] DEFAULT '{}',
  is_admin boolean DEFAULT false,
  is_premium boolean DEFAULT false,
  created_at timestamptz DEFAULT now()
);

-- ============================================================
-- B) CONTENT (admin-managed)
-- ============================================================

CREATE TABLE IF NOT EXISTS tracks (
  id uuid PRIMARY KEY DEFAULT uuid_generate_v4(),
  title text NOT NULL,
  description text,
  difficulty text NOT NULL DEFAULT 'beginner',
  tags text[] DEFAULT '{}',
  "order" int NOT NULL DEFAULT 0,
  created_at timestamptz DEFAULT now()
);

CREATE TABLE IF NOT EXISTS modules (
  id uuid PRIMARY KEY DEFAULT uuid_generate_v4(),
  track_id uuid NOT NULL REFERENCES tracks(id) ON DELETE CASCADE,
  title text NOT NULL,
  description text,
  "order" int NOT NULL DEFAULT 0,
  pass_percent int NOT NULL DEFAULT 70,
  created_at timestamptz DEFAULT now()
);

CREATE TABLE IF NOT EXISTS lessons (
  id uuid PRIMARY KEY DEFAULT uuid_generate_v4(),
  module_id uuid NOT NULL REFERENCES modules(id) ON DELETE CASCADE,
  title text NOT NULL,
  content jsonb NOT NULL DEFAULT '{}',
  "order" int NOT NULL DEFAULT 0,
  estimated_minutes int NOT NULL DEFAULT 5,
  created_at timestamptz DEFAULT now()
);

CREATE TABLE IF NOT EXISTS challenges (
  id uuid PRIMARY KEY DEFAULT uuid_generate_v4(),
  lesson_id uuid NOT NULL REFERENCES lessons(id) ON DELETE CASCADE,
  type text NOT NULL,  -- 'multiple_choice', 'short_text', 'code_style'
  prompt text NOT NULL,
  data jsonb NOT NULL DEFAULT '{}',
  "order" int NOT NULL DEFAULT 0,
  created_at timestamptz DEFAULT now()
);

CREATE TABLE IF NOT EXISTS quiz_questions (
  id uuid PRIMARY KEY DEFAULT uuid_generate_v4(),
  module_id uuid NOT NULL REFERENCES modules(id) ON DELETE CASCADE,
  type text NOT NULL,  -- 'multiple_choice', 'short_text'
  prompt text NOT NULL,
  data jsonb NOT NULL DEFAULT '{}',
  "order" int NOT NULL DEFAULT 0,
  created_at timestamptz DEFAULT now()
);

-- ============================================================
-- C) USER PROGRESS
-- ============================================================

CREATE TABLE IF NOT EXISTS user_lesson_progress (
  id uuid PRIMARY KEY DEFAULT uuid_generate_v4(),
  user_id uuid NOT NULL REFERENCES auth.users(id) ON DELETE CASCADE,
  lesson_id uuid NOT NULL REFERENCES lessons(id) ON DELETE CASCADE,
  completed boolean DEFAULT false,
  completed_at timestamptz,
  UNIQUE(user_id, lesson_id)
);

CREATE TABLE IF NOT EXISTS user_challenge_attempts (
  id uuid PRIMARY KEY DEFAULT uuid_generate_v4(),
  user_id uuid NOT NULL REFERENCES auth.users(id) ON DELETE CASCADE,
  challenge_id uuid NOT NULL REFERENCES challenges(id) ON DELETE CASCADE,
  user_answer text,
  is_correct boolean,
  time_taken_seconds int,
  created_at timestamptz DEFAULT now()
);

CREATE TABLE IF NOT EXISTS user_quiz_attempts (
  id uuid PRIMARY KEY DEFAULT uuid_generate_v4(),
  user_id uuid NOT NULL REFERENCES auth.users(id) ON DELETE CASCADE,
  module_id uuid NOT NULL REFERENCES modules(id) ON DELETE CASCADE,
  score int NOT NULL,
  total int NOT NULL,
  passed boolean NOT NULL DEFAULT false,
  answers jsonb NOT NULL DEFAULT '{}',
  created_at timestamptz DEFAULT now()
);

CREATE TABLE IF NOT EXISTS user_streaks (
  user_id uuid PRIMARY KEY REFERENCES auth.users(id) ON DELETE CASCADE,
  current_streak int DEFAULT 0,
  longest_streak int DEFAULT 0,
  last_activity_date date
);

-- ============================================================
-- D) BADGES
-- ============================================================

CREATE TABLE IF NOT EXISTS badges (
  id uuid PRIMARY KEY DEFAULT uuid_generate_v4(),
  code text UNIQUE NOT NULL,
  title text NOT NULL,
  description text,
  created_at timestamptz DEFAULT now()
);

CREATE TABLE IF NOT EXISTS user_badges (
  id uuid PRIMARY KEY DEFAULT uuid_generate_v4(),
  user_id uuid NOT NULL REFERENCES auth.users(id) ON DELETE CASCADE,
  badge_id uuid NOT NULL REFERENCES badges(id) ON DELETE CASCADE,
  earned_at timestamptz DEFAULT now(),
  UNIQUE(user_id, badge_id)
);

-- ============================================================
-- E) FREEMIUM CONFIG + ENFORCEMENT
-- ============================================================

CREATE TABLE IF NOT EXISTS app_config (
  key text PRIMARY KEY,
  value jsonb NOT NULL
);

CREATE TABLE IF NOT EXISTS daily_usage (
  user_id uuid NOT NULL REFERENCES auth.users(id) ON DELETE CASCADE,
  usage_date date NOT NULL,
  practice_attempts int DEFAULT 0,
  PRIMARY KEY(user_id, usage_date)
);

-- ============================================================
-- F) ANALYTICS (optional)
-- ============================================================

CREATE TABLE IF NOT EXISTS events (
  id uuid PRIMARY KEY DEFAULT uuid_generate_v4(),
  user_id uuid REFERENCES auth.users(id) ON DELETE SET NULL,
  name text NOT NULL,
  meta jsonb DEFAULT '{}',
  created_at timestamptz DEFAULT now()
);

-- ============================================================
-- INDEXES
-- ============================================================

-- FK indexes on content tables
CREATE INDEX IF NOT EXISTS idx_modules_track_id ON modules(track_id);
CREATE INDEX IF NOT EXISTS idx_lessons_module_id ON lessons(module_id);
CREATE INDEX IF NOT EXISTS idx_challenges_lesson_id ON challenges(lesson_id);
CREATE INDEX IF NOT EXISTS idx_quiz_questions_module_id ON quiz_questions(module_id);

-- FK + time indexes on user progress tables
CREATE INDEX IF NOT EXISTS idx_user_lesson_progress_user_id ON user_lesson_progress(user_id);
CREATE INDEX IF NOT EXISTS idx_user_lesson_progress_lesson_id ON user_lesson_progress(lesson_id);
CREATE INDEX IF NOT EXISTS idx_challenge_attempts_user_created ON user_challenge_attempts(user_id, created_at DESC);
CREATE INDEX IF NOT EXISTS idx_quiz_attempts_user_module ON user_quiz_attempts(user_id, module_id);
CREATE INDEX IF NOT EXISTS idx_quiz_attempts_user_created ON user_quiz_attempts(user_id, created_at DESC);

-- User badges index
CREATE INDEX IF NOT EXISTS idx_user_badges_user_id ON user_badges(user_id);

-- Daily usage index
CREATE INDEX IF NOT EXISTS idx_daily_usage_user_date ON daily_usage(user_id, usage_date);

-- GIN index on tracks.tags
CREATE INDEX IF NOT EXISTS idx_tracks_tags ON tracks USING GIN(tags);

-- Events index
CREATE INDEX IF NOT EXISTS idx_events_user_created ON events(user_id, created_at DESC);
