# GBC — Games Blog Club

A cross-platform Flutter blog app for gaming news, reviews, and community posts, backed by Supabase (Postgres + Auth + Storage).

## Tech Stack

- **Frontend:** Flutter, `flutter_bloc` (Bloc pattern throughout — no `Provider`/`Riverpod`)
- **Networking:** `dio`, talking directly to Supabase's REST (PostgREST) and Auth (GoTrue) HTTP APIs — no `supabase_flutter` SDK
- **Backend:** Supabase (Postgres, Row Level Security, Storage, Auth — email/password + Google + Discord OAuth)
- **Local persistence:** `shared_preferences` (auth tokens, theme, language)

## Architecture

Every feature follows the same layered pattern:

```
UI (Screen/Widget)
  -> Bloc (events in, states out)
    -> Repository (interface + singleton instance)
      -> Data Source (raw Dio calls to Supabase)
```

- Repositories are exposed as top-level singletons (e.g. `final postRepository = PostRepository(...)`) and injected into blocs via their constructor — screens never talk to a data source or Dio directly.
- Auth state is a global `ValueNotifier<AuthInfo?>` on `AuthRepository` (`authChangeNotifier`), which any screen can listen to for an instant auth-gate (see `create_post.dart` or `profile.dart`) without needing a bloc round-trip.
- Cross-feature notifications (e.g. "a post was just published, refresh the Home feed") go through a similar static `ValueNotifier` pattern (`PostRepository.postCreatedNotifier`), which `HomeBloc` subscribes to in its constructor.

## Features

- **Auth:** email/password signup & login, optional email confirmation flow, Google & Discord OAuth (via `flutter_web_auth_2` + Supabase's `/auth/v1/authorize` redirect flow), token refresh, token persistence via `shared_preferences`
- **Posts:** feed, full-text search, create/edit with an optional cover image upload (Supabase Storage), like/bookmark/view-count (all atomic via Postgres RPCs), comments
- **Profile:** avatar + bio + username editing (with live username-availability checking), "My Posts," "Saved" (bookmarks), theme switching (light/dark/system, persisted), language switching (English/Persian, with automatic RTL)
- **Banners:** a simple admin-managed promo carousel (read-only from the app; managed via Supabase dashboard/SQL)

## Backend Setup (Supabase)

1. Create a project at [supabase.com](https://supabase.com).
2. Open **SQL Editor** and run `supabase/schema.sql` in full. It's fully idempotent — safe to re-run anytime after future edits.
3. **Authentication -> URL Configuration:**
   - Site URL: `gbc://login-callback`
   - Redirect URLs: add `gbc://login-callback`
4. **Authentication -> Sign In / Providers:**
   - Toggle **Confirm email** on/off depending on whether you want email verification.
   - Enable **Google**: create an OAuth Client ID (type: **Web application**) in Google Cloud Console, redirect URI = `https://YOUR-PROJECT.supabase.co/auth/v1/callback`. Paste the Client ID/Secret into Supabase.
   - Enable **Discord**: same pattern, via Discord Developer Portal -> OAuth2 -> Redirects.
5. Grab your **Project URL** and **anon/publishable key** from **Project Settings -> API** — these go into `lib/common/http_client.dart`.

## App Setup

```bash
flutter pub get
```

Update the Supabase URL/key constants in `lib/common/http_client.dart` if you're pointing at your own project.

### Android — required for OAuth

In `android/app/build.gradle.kts`, inside `defaultConfig`:
```kotlin
manifestPlaceholders["appAuthRedirectScheme"] = "gbc"
```
This is required by `flutter_web_auth_2` to catch the OAuth redirect — without it, Google/Discord login will silently report `CANCELED`.

### iOS — required for OAuth

In `ios/Runner/Info.plist`, add the `gbc` URL scheme under `CFBundleURLTypes`.

### Run

```bash
flutter run
```

## Project Structure

```
lib/
  common/           # Dio clients, auth header helper, JWT decoding, shared exceptions
  data/             # Models + repositories + data sources (one trio per feature)
  l10n/             # Hand-rolled AppLocalizations (English/Persian)
  ui/
    auth/           # Login/signup, OAuth buttons, email confirmation screen
    create/         # Create-post screen + bloc
    home/           # Feed screen + bloc
    posts/          # Post card, post detail screen + bloc, comments
    profile/        # Profile screen, edit profile, my posts, saved posts, settings
    settings/       # ThemeBloc, LocaleBloc
    root.dart       # Bottom nav + per-tab Navigator stacks
supabase/
  schema.sql        # Full backend: tables, RLS, triggers, RPCs, storage buckets
```

## Known Limitations / Next Steps

- No automatic token-refresh-and-retry on a `401` — a request just fails; the user needs to log in again or the app needs to call `authRepository.refreshToken()` explicitly.
- Cover image / avatar uploads use fixed or timestamped filenames in Supabase Storage; there's no cleanup job for orphaned files from replaced covers.
- "Saved" list doesn't auto-refresh when you unbookmark a post from its detail screen — needs the same notifier pattern `HomeBloc` uses for new posts.
- No pagination yet on the feed, My Posts, or Saved lists — all load in full.
