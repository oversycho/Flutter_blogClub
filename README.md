Absolutely — here’s a **GitHub-ready README.md** for your GBC project, based on the project information you provided. 

# 🎮 GBC — Games Blog Club

A cross-platform **Flutter gaming blog application** for discovering, creating, and sharing gaming news, reviews, and community posts.

Built with **Flutter, BLoC, Dio, and Supabase**, with authentication, posts, bookmarks, likes, comments, profiles, localization, themes, and image uploads.

---

## ✨ Features

### 🔐 Authentication

* Email & password registration and login
* Optional email confirmation
* Google OAuth
* Discord OAuth
* Persistent authentication sessions
* Automatic authentication state handling

### 📰 Posts

* Browse a gaming community feed
* Create and edit posts
* Optional cover images
* Search posts
* View post details
* Like posts
* Bookmark/save posts
* View counts
* Comments

### 👤 Profile

* Edit profile information
* Change username
* Username availability checking
* Avatar upload
* Bio editing
* View **My Posts**
* View **Saved Posts**

### 🎨 Personalization

* Light theme
* Dark theme
* System theme
* English localization
* Persian localization
* Automatic RTL support for Persian

### 📢 Banners

* Admin-managed promotional banners
* Carousel display inside the application

---

## 🛠️ Tech Stack

| Technology             | Purpose                |
| ---------------------- | ---------------------- |
| **Flutter**            | Cross-platform UI      |
| **Dart**               | Application language   |
| **flutter_bloc**       | State management       |
| **Dio**                | HTTP networking        |
| **Supabase**           | Backend infrastructure |
| **PostgreSQL**         | Database               |
| **Supabase Auth**      | Authentication         |
| **Supabase Storage**   | Image storage          |
| **shared_preferences** | Local persistence      |

> The application communicates with Supabase through its REST/Auth APIs using Dio rather than the `supabase_flutter` SDK.

---

## 🏗️ Architecture

GBC follows a layered architecture using BLoC for state management:

```text
┌──────────────────────────┐
│           UI             │
│     Screens / Widgets    │
└────────────┬─────────────┘
             │
             ▼
┌──────────────────────────┐
│           BLoC           │
│       Events / States    │
└────────────┬─────────────┘
             │
             ▼
┌──────────────────────────┐
│       Repository         │
│     Business Access      │
└────────────┬─────────────┘
             │
             ▼
┌──────────────────────────┐
│       Data Source        │
│       Dio / REST API     │
└────────────┬─────────────┘
             │
             ▼
┌──────────────────────────┐
│         Supabase         │
│ PostgreSQL / Auth /      │
│ Storage / RPC / RLS      │
└──────────────────────────┘
```

Repositories are exposed as top-level singleton instances and injected into BLoCs through their constructors.

Screens do not communicate directly with Dio or data sources.

---

## 📁 Project Structure

```text
lib/
├── common/
│   ├── Dio clients
│   ├── Auth helpers
│   ├── JWT utilities
│   └── Shared exceptions
│
├── data/
│   ├── Models
│   ├── Repositories
│   └── Data sources
│
├── l10n/
│   └── AppLocalizations
│
└── ui/
    ├── auth/
    │   ├── Login
    │   ├── Signup
    │   ├── OAuth
    │   └── Email confirmation
    │
    ├── create/
    │   └── Create post
    │
    ├── home/
    │   └── Home feed
    │
    ├── posts/
    │   ├── Post cards
    │   ├── Post details
    │   └── Comments
    │
    ├── profile/
    │   ├── Profile
    │   ├── Edit profile
    │   ├── My posts
    │   ├── Saved posts
    │   └── Settings
    │
    ├── settings/
    │   ├── Theme
    │   └── Locale
    │
    └── root.dart
        └── Bottom navigation
```

Backend:

```text
supabase/
└── schema.sql
    ├── Tables
    ├── RLS policies
    ├── Triggers
    ├── PostgreSQL functions / RPCs
    └── Storage buckets
```

---

# 🚀 Getting Started

## Prerequisites

Make sure you have installed:

* Flutter SDK
* Dart SDK
* Android Studio and/or Xcode
* A Supabase account

---

## 1. Clone the repository

```bash
git clone <YOUR_REPOSITORY_URL>
cd GBC
```

---

## 2. Install dependencies

```bash
flutter pub get
```

---

## 3. Configure Supabase

Create a new project in Supabase.

Then open the **SQL Editor** and run:

```text
supabase/schema.sql
```

The schema contains the application's database structure, security policies, triggers, RPC functions, and storage configuration.

---

## 4. Configure Supabase credentials

Open:

```text
lib/common/http_client.dart
```

Update the Supabase project URL and public/anonymous key with the credentials from:

```text
Supabase Dashboard
→ Project Settings
→ API
```

---

# 🔑 Authentication Setup

## Email Authentication

In Supabase:

```text
Authentication
→ Providers
→ Email
```

Configure email confirmation according to your needs.

---

## Google OAuth

Enable Google under:

```text
Authentication
→ Sign In / Providers
→ Google
```

Create a Google OAuth client and configure the Supabase callback URL:

```text
https://YOUR-PROJECT.supabase.co/auth/v1/callback
```

Add the client ID and client secret to Supabase.

---

## Discord OAuth

Enable Discord under:

```text
Authentication
→ Sign In / Providers
→ Discord
```

Create an OAuth application in the Discord Developer Portal and use the same Supabase callback pattern:

```text
https://YOUR-PROJECT.supabase.co/auth/v1/callback
```

---

# 📱 Android OAuth Configuration

In:

```text
android/app/build.gradle.kts
```

inside `defaultConfig`, add:

```kotlin
manifestPlaceholders["appAuthRedirectScheme"] = "gbc"
```

This allows `flutter_web_auth_2` to receive the OAuth callback.

---

# 🍎 iOS OAuth Configuration

Add the `gbc` URL scheme to:

```text
ios/Runner/Info.plist
```

under:

```text
CFBundleURLTypes
```

This is required for OAuth redirects on iOS.

---

# ▶️ Running the App

Run the application with:

```bash
flutter run
```

For a specific device:

```bash
flutter devices
flutter run -d <device-id>
```

---

# 🔒 Security

GBC uses **Supabase Row Level Security (RLS)** to control access to application data.

Examples include:

* Users can manage their own bookmarks.
* User profile data is protected by database policies.
* Post operations are controlled through backend policies/functions.
* Authentication is handled through Supabase Auth.

The application also uses PostgreSQL RPC functions for operations such as likes, bookmarks, and view-count updates.

---

# 🌍 Localization

GBC currently supports:

* 🇬🇧 English
* 🇮🇷 Persian

Persian automatically switches the application to an RTL layout.

Localization is implemented through the project's custom `AppLocalizations` system.

---

# 🌓 Theme

Users can choose between:

* **Light**
* **Dark**
* **System default**

The selected theme is persisted locally using `shared_preferences`.

---

# 📌 Current Limitations

The current project has a few known limitations:

* No automatic token-refresh-and-retry flow after a `401` response.
* Replaced cover/avatar files can leave orphaned files in Supabase Storage.
* The Saved Posts screen does not automatically refresh after unbookmarking a post from another screen.
* Feed, My Posts, and Saved Posts currently load all available posts without pagination.

These are potential areas for future improvements.

---

# 🔮 Future Improvements

Possible next steps include:

* [ ] Pagination / infinite scrolling
* [ ] Automatic token refresh and retry
* [ ] Real-time feed updates
* [ ] Automatic Saved Posts refresh
* [ ] Storage cleanup for replaced images
* [ ] Push notifications
* [ ] User-to-user following
* [ ] Post categories and tags
* [ ] Advanced search and filtering
* [ ] Admin dashboard
* [ ] Post reporting and moderation

---

# 🤝 Contributing

Contributions are welcome.

1. Fork the repository
2. Create a feature branch

```bash
git checkout -b feature/my-feature
```

3. Commit your changes

```bash
git commit -m "Add my feature"
```

4. Push the branch

```bash
git push origin feature/my-feature
```

5. Open a Pull Request

---

# 📄 License

Add your preferred license here, for example:

```text
MIT License
```

---

## 🎮 About GBC

**GBC — Games Blog Club** is a gaming-focused social blogging platform built with Flutter.

The goal is to provide a simple place for gamers to **discover gaming content, publish their own posts, interact with the community, and save content they enjoy.**

