# CodePath

A cross-platform Flutter coding-education app that teaches programming through structured tracks, interactive lessons, practice challenges, and module quizzes — with streak tracking and a freemium model.

---

## Features

- **Learning Tracks** — Curated courses organised into modules and bite-sized lessons
- **Practice Challenges** — Multiple-choice, short-answer, and code-style exercises
- **Module Quizzes** — End-of-module assessments with configurable pass thresholds
- **Streak Tracking** — Daily UTC-based learning streaks with longest-streak history
- **Badges** — Unlock achievement badges (First Steps, Week Warrior, Perfect Ten, Quiz Champion)
- **Freemium Model** — Free tier with daily practice limits and module caps; Premium unlocks everything
- **Offline Caching** — Hive-backed local storage keeps content available offline
- **Admin Tools** — Admin users can manage all content and toggle Premium for any user

---

## Tech Stack

| Layer | Technology |
|---|---|
| UI | Flutter 3.10+ / Material 3 |
| State management | Riverpod 2 (code-generated) |
| Navigation | go_router 13 |
| Backend | Supabase (Auth, Postgres, RLS, Edge RPCs) |
| Local cache | Hive Flutter |
| Fonts | Google Fonts |

---

## Setup Instructions

### 1. Prerequisites

- [Flutter 3.10+](https://docs.flutter.dev/get-started/install) with Dart 3.0+
- [Supabase CLI](https://supabase.com/docs/guides/cli) (for local dev or `supabase db push`)
- A Supabase project (free tier works fine)

### 2. Clone the repo

```bash
git clone https://github.com/your-org/code-mentor.git
cd code-mentor
```

### 3. Install dependencies

```bash
flutter pub get
```

### 4. Set up Supabase

Create a new project at [supabase.com](https://supabase.com) and note your **Project URL** and **anon public key**.

### 5. Apply migrations

**Option A — Supabase CLI (recommended):**

```bash
supabase link --project-ref <your-project-ref>
supabase db push
```

**Option B — Supabase dashboard SQL editor:**

Run each file in order in the Supabase **SQL Editor**:

1. `supabase/migrations/001_initial_schema.sql`
2. `supabase/migrations/002_rls_policies.sql`
3. `supabase/migrations/003_rpc_functions.sql`
4. `supabase/migrations/004_seed_data.sql`

### 6. Run on Android

```bash
flutter run \
  --dart-define=SUPABASE_URL=https://<ref>.supabase.co \
  --dart-define=SUPABASE_ANON_KEY=<your-anon-key>
```

### 7. Run on Web

```bash
flutter run -d chrome \
  --dart-define=SUPABASE_URL=https://<ref>.supabase.co \
  --dart-define=SUPABASE_ANON_KEY=<your-anon-key>
```

### 8. Dev seed mode (default on)

In dev seed mode the app loads a local JSON fixture instead of hitting Supabase, so you can develop without a live project:

```bash
flutter run --dart-define=DEV_SEED_MODE=true
```

`DEV_SEED_MODE` defaults to `true`; pass `false` to force live Supabase calls.

---

## Creating Admin / Premium Test Users

**Via Supabase dashboard (SQL editor):**

```sql
-- Grant admin
UPDATE profiles SET is_admin = true WHERE id = '<user-uuid>';

-- Grant premium
UPDATE profiles SET is_premium = true WHERE id = '<user-uuid>';
```

**Via RPC (from another admin session or the dashboard):**

```sql
SELECT rpc_toggle_premium('<user-uuid>', true);
```

---

## Architecture

The project follows **feature-first clean architecture**:

```
lib/
  core/
    utils/          # Pure utility classes (StringUtils, ProgressUtils, etc.)
    theme/
    widgets/
  features/
    auth/
      domain/models/
      data/repositories/
      presentation/
    catalog/        # Tracks, modules, lessons, challenges
    progress/       # Lesson progress, quiz attempts, streaks
    practice/       # Practice session UI
    quiz/
    profile/
```

Key patterns:
- **Repository pattern** — each feature has a repository interface + Supabase implementation
- **Riverpod providers** — UI consumes `AsyncValue`-based providers; no business logic in widgets
- **Immutable models** — all domain models are `const`-constructable with `copyWith`

---

## Freemium Model

| Feature | Free | Premium |
|---|---|---|
| Modules per track | First 2 (`order` 0–1) | Unlimited |
| Daily practice attempts | 15 | Unlimited (999) |
| Streak tracking | ✅ | ✅ |
| Badges | ✅ | ✅ |

Limits are enforced **server-side** via the `rpc_record_practice_attempt` and `rpc_is_module_unlocked` Postgres functions, so they cannot be bypassed by a modified client.

Configuration is stored in the `app_config` table and can be updated without a redeploy:

| Key | Default |
|---|---|
| `free_daily_attempt_limit` | `{"limit": 15}` |
| `free_modules_per_track` | `{"limit": 2}` |

---

## Streak Rules

- Streaks are calculated in **UTC** — a "day" resets at `00:00 UTC`.
- Completing any lesson or challenge on a new UTC day increments the streak.
- Missing a day resets `current_streak` to 1 but preserves `longest_streak`.
- Multiple activities on the same UTC day do not increment the streak further.

---

## Phase 2 Roadmap

- [ ] AI code feedback via OpenAI / Gemini
- [ ] Social leaderboards and friend streaks
- [ ] Push notifications for streak reminders
- [ ] Offline-first sync with conflict resolution
- [ ] In-app purchase integration (RevenueCat)
- [ ] Instructor dashboard for content authoring
- [ ] Adaptive difficulty based on quiz performance
