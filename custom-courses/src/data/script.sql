-- ===================================================================
--  Learning Platform – FULL SCHEMA (24 tables) + FUNCTIONS + TRIGGERS + SEED DATA
--  PostgreSQL 16+  |  Author: ChatGPT — 10 Jul 2025
-- ===================================================================

/*
   ░░ CONTENTS ░░
   1. Extension
   2. Functions (utility + business)
   3. Tables (24) – all UUID PKs, users include password_hash (bcrypt)
   4. Indexes
   5. Triggers
   6. Seed data (one row per table, deterministic UUIDs)
*/

-- ░░ 1. EXTENSION ░░ -------------------------------------------------
CREATE EXTENSION IF NOT EXISTS pgcrypto; -- gen_random_uuid(), crypt(), gen_salt()

-- ░░ 2. FUNCTIONS ░░ -------------------------------------------------

-- 2.1 updated_at timestamp helper
CREATE OR REPLACE FUNCTION update_updated_at_column()
RETURNS TRIGGER AS $$
BEGIN
  NEW.updated_at := NOW();
  RETURN NEW;
END;
$$ LANGUAGE plpgsql;

-- 2.2 maintain likes_count
CREATE OR REPLACE FUNCTION update_comment_likes_count()
RETURNS TRIGGER AS $$
BEGIN
  IF TG_OP = 'INSERT' THEN
    UPDATE comments SET likes_count = likes_count + 1 WHERE id = NEW.comment_id;
  ELSIF TG_OP = 'DELETE' THEN
    UPDATE comments SET likes_count = likes_count - 1 WHERE id = OLD.comment_id;
  END IF;
  RETURN NULL;
END;
$$ LANGUAGE plpgsql;

-- 2.3 enforce quiz attempt limit
CREATE OR REPLACE FUNCTION check_quiz_attempt_limit()
RETURNS TRIGGER AS $$
DECLARE
  max_attempts INTEGER;
  attempts     INTEGER;
BEGIN
  SELECT q.max_attempts INTO max_attempts FROM quizzes q WHERE q.id = NEW.quiz_id;
  SELECT COUNT(*)        INTO attempts FROM quiz_attempts WHERE quiz_id = NEW.quiz_id AND user_id = NEW.user_id;
  IF max_attempts IS NOT NULL AND attempts >= max_attempts THEN
    RAISE EXCEPTION 'Se superó el máximo de intentos (%).', max_attempts;
  END IF;
  NEW.attempt_no := attempts + 1;
  RETURN NEW;
END;
$$ LANGUAGE plpgsql;

-- 2.4 validate answer & award points
CREATE OR REPLACE FUNCTION validate_quiz_answer()
RETURNS TRIGGER AS $$
DECLARE
  qt   VARCHAR(50);
  pts  NUMERIC(5,2);
  corr UUID;
BEGIN
  SELECT question_type, points INTO qt, pts FROM quiz_questions WHERE id = NEW.question_id;

  IF qt = 'multiple_choice' THEN
    SELECT id INTO corr FROM quiz_options WHERE question_id = NEW.question_id AND is_correct LIMIT 1;
    NEW.is_correct    := (NEW.selected_option_id = corr);
    NEW.points_earned := CASE WHEN NEW.is_correct THEN pts ELSE 0 END;

  ELSIF qt = 'true_false' THEN
    SELECT is_correct INTO NEW.is_correct FROM quiz_options WHERE question_id = NEW.question_id AND option_text = NEW.answer_text LIMIT 1;
    NEW.points_earned := CASE WHEN NEW.is_correct THEN pts ELSE 0 END;

  ELSE -- short_answer
    NEW.is_correct    := FALSE;
    NEW.points_earned := 0;
  END IF;
  RETURN NEW;
END;
$$ LANGUAGE plpgsql;

-- 2.5 calculate overall score
CREATE OR REPLACE FUNCTION calculate_quiz_score(p_attempt UUID)
RETURNS VOID AS $$
DECLARE
  t_total  NUMERIC(5,2);
  t_earned NUMERIC(5,2);
  v_quiz   UUID;
  req_pc   INTEGER;
BEGIN
  SELECT quiz_id INTO v_quiz FROM quiz_attempts WHERE id = p_attempt;
  SELECT passing_score INTO req_pc FROM quizzes WHERE id = v_quiz;

  SELECT COALESCE(SUM(points),0)        INTO t_total  FROM quiz_questions WHERE quiz_id = v_quiz;
  SELECT COALESCE(SUM(points_earned),0) INTO t_earned FROM quiz_user_answers WHERE attempt_id = p_attempt;
  IF t_total = 0 THEN t_total := 1; END IF;

  UPDATE quiz_attempts
    SET score = t_earned,
        max_score = t_total,
        passed = (t_earned / t_total * 100) >= req_pc,
        completed_at = NOW()
  WHERE id = p_attempt;
END;
$$ LANGUAGE plpgsql;

-- ░░ 3. TABLES (24) ░░ ----------------------------------------------

-- 3.1 users
CREATE TABLE IF NOT EXISTS users (
  id               UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  email            VARCHAR(255) UNIQUE NOT NULL,
  name             VARCHAR(255) NOT NULL,
  avatar           TEXT,
  role             VARCHAR(50) DEFAULT 'student' CHECK (role IN ('student','instructor','admin')),
  password_hash    TEXT NOT NULL,
  password_changed_at TIMESTAMPTZ,
  bio              TEXT,
  website          VARCHAR(255),
  location         VARCHAR(255),
  phone            VARCHAR(50),
  birth_date       DATE,
  is_active        BOOLEAN DEFAULT TRUE,
  email_verified   BOOLEAN DEFAULT FALSE,
  last_login       TIMESTAMPTZ,
  created_at       TIMESTAMPTZ DEFAULT NOW(),
  updated_at       TIMESTAMPTZ DEFAULT NOW()
); 

-- 3.2 categories
CREATE TABLE IF NOT EXISTS categories (
  id          UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  name        VARCHAR(255) NOT NULL,
  description TEXT,
  slug        VARCHAR(255) UNIQUE NOT NULL,
  icon        VARCHAR(100),
  color       VARCHAR(7),
  is_active   BOOLEAN DEFAULT TRUE,
  created_at  TIMESTAMPTZ DEFAULT NOW(),
  updated_at  TIMESTAMPTZ DEFAULT NOW()
);

-- 3.3 courses
CREATE TABLE IF NOT EXISTS courses (
  id              UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  title           VARCHAR(255) NOT NULL,
  description     TEXT NOT NULL,
  short_description TEXT,
  thumbnail       TEXT,
  video_url       TEXT,
  price           DECIMAL(10,2) DEFAULT 0,
  original_price  DECIMAL(10,2),
  level           VARCHAR(50) DEFAULT 'beginner' CHECK (level IN ('beginner','intermediate','advanced')),
  duration        INTEGER DEFAULT 0,
  language        VARCHAR(10) DEFAULT 'es',
  status          VARCHAR(50) DEFAULT 'draft' CHECK (status IN ('draft','published','archived')),
  author_id       UUID NOT NULL REFERENCES users(id) ON DELETE CASCADE,
  category_id     UUID NOT NULL REFERENCES categories(id) ON DELETE RESTRICT,
  tags            TEXT[],
  requirements    TEXT[],
  what_you_learn  TEXT[],
  is_featured     BOOLEAN DEFAULT FALSE,
  is_free         BOOLEAN DEFAULT FALSE,
  enrollment_count INTEGER DEFAULT 0,
  rating          DECIMAL(3,2) DEFAULT 0,
  rating_count    INTEGER DEFAULT 0,
  lesson_count    INTEGER DEFAULT 0,
  created_at      TIMESTAMPTZ DEFAULT NOW(),
  updated_at      TIMESTAMPTZ DEFAULT NOW()
);

-- 3.4 lessons
CREATE TABLE IF NOT EXISTS lessons (
  id         UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  course_id  UUID NOT NULL REFERENCES courses(id) ON DELETE CASCADE,
  title      VARCHAR(255) NOT NULL,
  description TEXT,
  video_url  TEXT,
  duration   INTEGER DEFAULT 0,
  order_index INTEGER NOT NULL,
  is_free    BOOLEAN DEFAULT FALSE,
  is_published BOOLEAN DEFAULT TRUE,
  created_at TIMESTAMPTZ DEFAULT NOW(),
  updated_at TIMESTAMPTZ DEFAULT NOW()
);

-- 3.5 enrollments
CREATE TABLE IF NOT EXISTS enrollments (
  id               UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  user_id          UUID NOT NULL REFERENCES users(id) ON DELETE CASCADE,
  course_id        UUID NOT NULL REFERENCES courses(id) ON DELETE CASCADE,
  enrolled_at      TIMESTAMPTZ DEFAULT NOW(),
  completed_at     TIMESTAMPTZ,
  progress         INTEGER DEFAULT 0 CHECK (progress BETWEEN 0 AND 100),
  last_accessed_at TIMESTAMPTZ,
  is_active        BOOLEAN DEFAULT TRUE,
  UNIQUE(user_id,course_id)
);

-- 3.6 lesson_progress
CREATE TABLE IF NOT EXISTS lesson_progress (
  id         UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  user_id    UUID NOT NULL REFERENCES users(id) ON DELETE CASCADE,
  lesson_id  UUID NOT NULL REFERENCES lessons(id) ON DELETE CASCADE,
  completed  BOOLEAN DEFAULT FALSE,
  completed_at TIMESTAMPTZ,
  watch_time INTEGER DEFAULT 0,
  created_at TIMESTAMPTZ DEFAULT NOW(),
  updated_at TIMESTAMPTZ DEFAULT NOW(),
  UNIQUE(user_id,lesson_id)
);

-- 3.7 favorites
CREATE TABLE IF NOT EXISTS favorites (
  id        UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  user_id   UUID NOT NULL REFERENCES users(id) ON DELETE CASCADE,
  course_id UUID NOT NULL REFERENCES courses(id) ON DELETE CASCADE,
  created_at TIMESTAMPTZ DEFAULT NOW(),
  UNIQUE(user_id,course_id)
);

-- 3.8 wishlist
CREATE TABLE IF NOT EXISTS wishlist (
  id        UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  user_id   UUID NOT NULL REFERENCES users(id) ON DELETE CASCADE,
  course_id UUID NOT NULL REFERENCES courses(id) ON DELETE CASCADE,
  created_at TIMESTAMPTZ DEFAULT NOW(),
  UNIQUE(user_id,course_id)
);

-- 3.9 achievements
CREATE TABLE IF NOT EXISTS achievements (
  id          UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  name        VARCHAR(255) NOT NULL,
  description TEXT,
  icon        VARCHAR(100),
  category_id UUID REFERENCES categories(id) ON DELETE SET NULL,
  points      INTEGER DEFAULT 0,
  is_active   BOOLEAN DEFAULT TRUE,
  created_at  TIMESTAMPTZ DEFAULT NOW(),
  updated_at  TIMESTAMPTZ DEFAULT NOW()
);

-- 3.10 user_achievements
CREATE TABLE IF NOT EXISTS user_achievements (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  user_id UUID NOT NULL REFERENCES users(id) ON DELETE CASCADE,
  achievement_id UUID NOT NULL REFERENCES achievements(id) ON DELETE CASCADE,
  achieved_at TIMESTAMPTZ DEFAULT NOW(),
  is_active BOOLEAN DEFAULT TRUE,

  UNIQUE(user_id,achievement_id)
);

-- 3.11 user_activity
CREATE TABLE IF NOT EXISTS user_activity (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  user_id UUID NOT NULL REFERENCES users(id) ON DELETE CASCADE,
  activity_type VARCHAR(100) NOT NULL,
  activity_data JSONB,
  created_at TIMESTAMPTZ DEFAULT NOW()
);

-- 3.12 notifications
CREATE TABLE IF NOT EXISTS notifications (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  user_id UUID NOT NULL REFERENCES users(id) ON DELETE CASCADE,
  title VARCHAR(255) NOT NULL,
  message TEXT NOT NULL,
  type VARCHAR(50) DEFAULT 'info' CHECK (type IN ('info','success','warning','error')),
  read BOOLEAN DEFAULT FALSE,
  action_url TEXT,
  created_at TIMESTAMPTZ DEFAULT NOW()
);

-- 3.13 comments
CREATE TABLE IF NOT EXISTS comments (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  user_id UUID NOT NULL REFERENCES users(id) ON DELETE CASCADE,
  course_id UUID REFERENCES courses(id) ON DELETE CASCADE,
  lesson_id UUID REFERENCES lessons(id) ON DELETE CASCADE,
  parent_id UUID REFERENCES comments(id) ON DELETE CASCADE,
  content TEXT NOT NULL,
  is_pinned BOOLEAN DEFAULT FALSE,
  pinned_at TIMESTAMPTZ,
  pinned_by UUID REFERENCES users(id) ON DELETE SET NULL,
  likes_count INTEGER DEFAULT 0,
  created_at TIMESTAMPTZ DEFAULT NOW(),
  updated_at TIMESTAMPTZ DEFAULT NOW(),
  CHECK (course_id IS NOT NULL OR lesson_id IS NOT NULL)
);

-- 3.14 comment_likes
CREATE TABLE IF NOT EXISTS comment_likes (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  user_id UUID NOT NULL REFERENCES users(id) ON DELETE CASCADE,
  comment_id UUID NOT NULL REFERENCES comments(id) ON DELETE CASCADE,
  created_at TIMESTAMPTZ DEFAULT NOW(),
  UNIQUE(user_id,comment_id)
);

-- 3.15 ratings
CREATE TABLE IF NOT EXISTS ratings (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  user_id UUID NOT NULL REFERENCES users(id) ON DELETE CASCADE,
  course_id UUID NOT NULL REFERENCES courses(id) ON DELETE CASCADE,
  rating INTEGER NOT NULL CHECK (rating BETWEEN 1 AND 5),
  review TEXT,
  created_at TIMESTAMPTZ DEFAULT NOW(),
  updated_at TIMESTAMPTZ DEFAULT NOW(),
  UNIQUE(user_id,course_id)
);

-- 3.16 certificates
CREATE TABLE IF NOT EXISTS certificates (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  user_id UUID NOT NULL REFERENCES users(id) ON DELETE CASCADE,
  course_id UUID NOT NULL REFERENCES courses(id) ON DELETE CASCADE,
  certificate_number VARCHAR(255) UNIQUE NOT NULL,
  issued_at TIMESTAMPTZ DEFAULT NOW(),
  verification_code VARCHAR(255) UNIQUE NOT NULL,
  certificate_url TEXT,
  final_score INTEGER NOT NULL,
  is_valid BOOLEAN DEFAULT TRUE,
  UNIQUE(user_id,course_id)
);

-- 3.17 quizzes
CREATE TABLE IF NOT EXISTS quizzes (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  course_id UUID REFERENCES courses(id) ON DELETE CASCADE,
  lesson_id UUID REFERENCES lessons(id) ON DELETE CASCADE,
  title VARCHAR(255) NOT NULL,
  description TEXT,
  time_limit INTEGER,
  max_attempts INTEGER DEFAULT 1,
  passing_score INTEGER DEFAULT 70,
  is_published BOOLEAN DEFAULT TRUE,
  randomize_questions BOOLEAN DEFAULT FALSE,
  show_correct_answers BOOLEAN DEFAULT TRUE,
  created_at TIMESTAMPTZ DEFAULT NOW(),
  updated_at TIMESTAMPTZ DEFAULT NOW(),
  CHECK (course_id IS NOT NULL OR lesson_id IS NOT NULL)
);

-- 3.18 quiz_questions
CREATE TABLE IF NOT EXISTS quiz_questions (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  quiz_id UUID NOT NULL REFERENCES quizzes(id) ON DELETE CASCADE,
  question TEXT NOT NULL,
  question_type VARCHAR(50) DEFAULT 'multiple_choice' CHECK (question_type IN ('multiple_choice','true_false','short_answer')),
  points NUMERIC(5,2) DEFAULT 1,
  order_index INTEGER NOT NULL,
  created_at TIMESTAMPTZ DEFAULT NOW(),
  updated_at TIMESTAMPTZ DEFAULT NOW()
);

-- 3.19 quiz_options
CREATE TABLE IF NOT EXISTS quiz_options (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  question_id UUID NOT NULL REFERENCES quiz_questions(id) ON DELETE CASCADE,
  option_text TEXT NOT NULL,
  is_correct BOOLEAN DEFAULT FALSE,
  order_index INTEGER NOT NULL,
  created_at TIMESTAMPTZ DEFAULT NOW(),
  updated_at TIMESTAMPTZ DEFAULT NOW()
);

-- 3.20 quiz_attempts
CREATE TABLE IF NOT EXISTS quiz_attempts (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  quiz_id UUID NOT NULL REFERENCES quizzes(id) ON DELETE CASCADE,
  user_id UUID NOT NULL REFERENCES users(id) ON DELETE CASCADE,
  attempt_no INTEGER NOT NULL,
  started_at TIMESTAMPTZ DEFAULT NOW(),
  completed_at TIMESTAMPTZ,
  score NUMERIC(5,2) DEFAULT 0,
  max_score NUMERIC(5,2) DEFAULT 0,
  passed BOOLEAN DEFAULT FALSE,
  answers JSONB DEFAULT '{}',
  UNIQUE(quiz_id,user_id,attempt_no)
);

-- 3.21 quiz_user_answers
CREATE TABLE IF NOT EXISTS quiz_user_answers (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  attempt_id UUID NOT NULL REFERENCES quiz_attempts(id) ON DELETE CASCADE,
  question_id UUID NOT NULL REFERENCES quiz_questions(id) ON DELETE CASCADE,
  answer_text TEXT,
  selected_option_id UUID REFERENCES quiz_options(id) ON DELETE SET NULL,
  is_correct BOOLEAN DEFAULT FALSE,
  points_earned NUMERIC(5,2) DEFAULT 0,
  created_at TIMESTAMPTZ DEFAULT NOW()
);

-- 3.22 user_preferences
CREATE TABLE IF NOT EXISTS user_preferences (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  user_id UUID NOT NULL REFERENCES users(id) ON DELETE CASCADE,
  theme VARCHAR(20) DEFAULT 'system' CHECK (theme IN ('light','dark','system')),
  language VARCHAR(10) DEFAULT 'es',
  email_notifications BOOLEAN DEFAULT TRUE,
  push_notifications BOOLEAN DEFAULT TRUE,
  created_at TIMESTAMPTZ DEFAULT NOW(),
  updated_at TIMESTAMPTZ DEFAULT NOW(),
  UNIQUE(user_id)
);

-- 3.23 user_interactions
CREATE TABLE IF NOT EXISTS user_interactions (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  user_id UUID NOT NULL REFERENCES users(id) ON DELETE CASCADE,
  course_id UUID NOT NULL REFERENCES courses(id) ON DELETE CASCADE,
  interaction_type VARCHAR(100) NOT NULL,
  interaction_data JSONB,
  created_at TIMESTAMPTZ DEFAULT NOW()
);

-- 3.24 course_recommendations
CREATE TABLE IF NOT EXISTS course_recommendations (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  user_id UUID NOT NULL REFERENCES users(id) ON DELETE CASCADE,
  course_id UUID NOT NULL REFERENCES courses(id) ON DELETE CASCADE,
  score INTEGER NOT NULL,
  reason TEXT,
  generated_at TIMESTAMPTZ DEFAULT NOW(),
  UNIQUE(user_id,course_id)
);

-- ░░ 4. INDEXES ░░ ---------------------------------------------------
CREATE INDEX IF NOT EXISTS idx_courses_status   ON courses(status);
CREATE INDEX IF NOT EXISTS idx_courses_cat      ON courses(category_id);
CREATE INDEX IF NOT EXISTS idx_courses_author   ON courses(author_id);
CREATE INDEX IF NOT EXISTS idx_courses_featured ON courses(is_featured);
CREATE INDEX IF NOT EXISTS idx_enroll_user      ON enrollments(user_id);
CREATE INDEX IF NOT EXISTS idx_enroll_course    ON enrollments(course_id);
CREATE INDEX IF NOT EXISTS idx_fav_user         ON favorites(user_id);
CREATE INDEX IF NOT EXISTS idx_wish_user        ON wishlist(user_id);
CREATE INDEX IF NOT EXISTS idx_notif_user       ON notifications(user_id);
CREATE INDEX IF NOT EXISTS idx_comments_course  ON comments(course_id);
CREATE INDEX IF NOT EXISTS idx_comments_lesson  ON comments(lesson_id);
CREATE INDEX IF NOT EXISTS idx_rates_course     ON ratings(course_id);
CREATE INDEX IF NOT EXISTS idx_int_user         ON user_interactions(user_id);
CREATE INDEX IF NOT EXISTS idx_rec_user         ON course_recommendations(user_id);

-- ░░ 5. TRIGGERS ░░ --------------------------------------------------

-- 5.1 updated_at for every table with that column
DO $$DECLARE r RECORD;BEGIN
  FOR r IN SELECT table_name FROM information_schema.columns WHERE column_name='updated_at' AND table_schema='public' LOOP
    EXECUTE format('CREATE TRIGGER trg_%I_updated_at BEFORE UPDATE ON %I FOR EACH ROW EXECUTE FUNCTION update_updated_at_column()', r.table_name, r.table_name);
  END LOOP;
EXCEPTION WHEN duplicate_object THEN NULL;END$$;

-- 5.2 likes counter
DROP TRIGGER IF EXISTS trg_comment_likes ON comment_likes;
CREATE TRIGGER trg_comment_likes
AFTER INSERT OR DELETE ON comment_likes
FOR EACH ROW EXECUTE FUNCTION update_comment_likes_count();

-- 5.3 quiz attempt limit
DROP TRIGGER IF EXISTS trg_attempt_limit ON quiz_attempts;
CREATE TRIGGER trg_attempt_limit
BEFORE INSERT ON quiz_attempts
FOR EACH ROW EXECUTE FUNCTION check_quiz_attempt_limit();

-- 5.4 validate each answer
DROP TRIGGER IF EXISTS trg_validate_answer ON quiz_user_answers;
CREATE TRIGGER trg_validate_answer
BEFORE INSERT OR UPDATE ON quiz_user_answers
FOR EACH ROW EXECUTE FUNCTION validate_quiz_answer();
