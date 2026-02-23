-- ============================================================
-- RPC: rpc_can_attempt_practice
-- Returns: {can_attempt: bool, remaining: int, daily_limit: int}
-- ============================================================
CREATE OR REPLACE FUNCTION rpc_can_attempt_practice()
RETURNS jsonb
LANGUAGE plpgsql
SECURITY DEFINER
AS $$
DECLARE
  v_user_id uuid := auth.uid();
  v_is_premium boolean;
  v_daily_limit int;
  v_used_today int;
  v_today date := CURRENT_DATE;
BEGIN
  IF v_user_id IS NULL THEN
    RETURN jsonb_build_object('can_attempt', false, 'remaining', 0, 'daily_limit', 0);
  END IF;

  -- Check premium status
  SELECT is_premium INTO v_is_premium FROM profiles WHERE id = v_user_id;

  IF v_is_premium THEN
    RETURN jsonb_build_object('can_attempt', true, 'remaining', 999, 'daily_limit', 999);
  END IF;

  -- Get daily limit from config
  SELECT (value->>'limit')::int INTO v_daily_limit
  FROM app_config WHERE key = 'free_daily_attempt_limit';
  v_daily_limit := COALESCE(v_daily_limit, 15);

  -- Get usage today
  SELECT practice_attempts INTO v_used_today
  FROM daily_usage WHERE user_id = v_user_id AND usage_date = v_today;
  v_used_today := COALESCE(v_used_today, 0);

  RETURN jsonb_build_object(
    'can_attempt', v_used_today < v_daily_limit,
    'remaining', GREATEST(0, v_daily_limit - v_used_today),
    'daily_limit', v_daily_limit
  );
END;
$$;

-- ============================================================
-- RPC: rpc_record_practice_attempt
-- Atomically checks quota + inserts attempt + increments daily_usage
-- Returns: {success: bool, is_correct: bool, error: text}
-- ============================================================
CREATE OR REPLACE FUNCTION rpc_record_practice_attempt(
  p_challenge_id uuid,
  p_user_answer text,
  p_is_correct boolean,
  p_time_taken_seconds int
)
RETURNS jsonb
LANGUAGE plpgsql
SECURITY DEFINER
AS $$
DECLARE
  v_user_id uuid := auth.uid();
  v_is_premium boolean;
  v_daily_limit int;
  v_used_today int;
  v_today date := CURRENT_DATE;
BEGIN
  IF v_user_id IS NULL THEN
    RETURN jsonb_build_object('success', false, 'error', 'Not authenticated');
  END IF;

  -- Check premium
  SELECT is_premium INTO v_is_premium FROM profiles WHERE id = v_user_id;

  IF NOT v_is_premium THEN
    -- Get daily limit
    SELECT (value->>'limit')::int INTO v_daily_limit
    FROM app_config WHERE key = 'free_daily_attempt_limit';
    v_daily_limit := COALESCE(v_daily_limit, 15);

    -- Get current usage
    SELECT practice_attempts INTO v_used_today
    FROM daily_usage WHERE user_id = v_user_id AND usage_date = v_today;
    v_used_today := COALESCE(v_used_today, 0);

    IF v_used_today >= v_daily_limit THEN
      RETURN jsonb_build_object('success', false, 'error', 'Daily practice limit reached. Upgrade to Premium for unlimited practice.');
    END IF;
  END IF;

  -- Insert attempt
  INSERT INTO user_challenge_attempts (id, user_id, challenge_id, user_answer, is_correct, time_taken_seconds)
  VALUES (uuid_generate_v4(), v_user_id, p_challenge_id, p_user_answer, p_is_correct, p_time_taken_seconds);

  -- Increment daily usage (upsert)
  INSERT INTO daily_usage (user_id, usage_date, practice_attempts)
  VALUES (v_user_id, v_today, 1)
  ON CONFLICT (user_id, usage_date)
  DO UPDATE SET practice_attempts = daily_usage.practice_attempts + 1;

  RETURN jsonb_build_object('success', true, 'is_correct', p_is_correct, 'error', null);
END;
$$;

-- ============================================================
-- RPC: rpc_is_module_unlocked
-- Returns: {unlocked: bool, reason: text}
-- ============================================================
CREATE OR REPLACE FUNCTION rpc_is_module_unlocked(p_module_id uuid)
RETURNS jsonb
LANGUAGE plpgsql
SECURITY DEFINER
AS $$
DECLARE
  v_user_id uuid := auth.uid();
  v_is_premium boolean;
  v_free_limit int;
  v_module_order int;
BEGIN
  IF v_user_id IS NULL THEN
    RETURN jsonb_build_object('unlocked', false, 'reason', 'Not authenticated');
  END IF;

  SELECT is_premium INTO v_is_premium FROM profiles WHERE id = v_user_id;

  IF v_is_premium THEN
    RETURN jsonb_build_object('unlocked', true, 'reason', 'premium');
  END IF;

  -- Get free module limit
  SELECT (value->>'limit')::int INTO v_free_limit
  FROM app_config WHERE key = 'free_modules_per_track';
  v_free_limit := COALESCE(v_free_limit, 2);

  -- Get module order (0-indexed)
  SELECT "order" INTO v_module_order FROM modules WHERE id = p_module_id;

  IF v_module_order IS NULL THEN
    RETURN jsonb_build_object('unlocked', false, 'reason', 'Module not found');
  END IF;

  -- order field is 0-indexed; modules with order 0..v_free_limit are free (inclusive)
  IF v_module_order <= v_free_limit THEN
    RETURN jsonb_build_object('unlocked', true, 'reason', 'free_tier');
  END IF;

  RETURN jsonb_build_object('unlocked', false, 'reason', 'upgrade_required');
END;
$$;

-- ============================================================
-- RPC: rpc_toggle_premium (admin only)
-- ============================================================
CREATE OR REPLACE FUNCTION rpc_toggle_premium(p_user_id uuid, p_is_premium boolean)
RETURNS void
LANGUAGE plpgsql
SECURITY DEFINER
AS $$
BEGIN
  IF NOT is_admin() THEN
    RAISE EXCEPTION 'Access denied: admin only';
  END IF;
  UPDATE profiles SET is_premium = p_is_premium WHERE id = p_user_id;
END;
$$;
