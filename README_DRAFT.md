# Zmare — Flutter Music Streaming App

> A Flutter audio streaming app with playlist management, queue control, artist pages, album browsing, and singleton BLoC-based playback.

## Description

Zmare is a mobile music streaming application built with Flutter using Clean Architecture and BLoC for state management. It allows users to browse and stream audio content organised by artists, albums, and playlists, manage a playback queue, search across the catalogue, and control audio through a persistent background player (audio_service + just_audio). Firebase provides auth, cloud storage, crash reporting, and push notifications.

<!-- TODO: add screenshot at docs/screenshot.png -->
<!-- ![Zmare Player Screenshot](docs/screenshot.png) -->

## Live / Download

<!-- TODO: add Play Store link if published -->
<!-- 🛒 [Google Play Store](#) -->

## Tech Stack

- **Framework:** Flutter (Dart)
- **Architecture:** Clean Architecture
- **State Management:** BLoC / flutter_bloc
- **Dependency Injection:** GetIt + service_locator pattern
- **Audio:** just_audio + audio_service (background playback)
- **Networking:** Dio (REST API client) with interceptors
- **Local Storage:** Hive (offline caching)
- **Firebase:** Auth, Storage, Crashlytics, Messaging
- **UI:** Google Fonts, carousel_slider, palette_generator (dynamic album colours), glassmorphism
- **Reactive:** RxDart

## Key Features

- 🎵 **Background Audio Playback** — singleton audio_service player, persists across app states
- 📂 **Library & Queue** — playlist management, queue control, track ordering
- 🎨 **Dynamic Theming** — palette_generator extracts dominant colours from album art
- 🔍 **Search** — search across tracks, albums, artists
- 👤 **User Profiles** — account management, profile image cropping
- 🔔 **Push Notifications** — FCM-based for new content

## Project Structure

```
lib/
├── src/
│   ├── app/routes.dart         # GoRouter navigation
│   ├── core/                   # API client (Dio), error handling, enums, theme
│   ├── data/                   # Repository implementations, data sources
│   ├── presentation/           # BLoC + UI per feature (album, artist, library, search, login)
│   └── service_locator.dart    # GetIt DI setup
└── main.dart
```

## Setup & Run

```bash
flutter pub get
# Add google-services.json (Android) and GoogleService-Info.plist (iOS)
# from your Firebase project using: flutterfire configure
flutter run
```

> ⚠️ Firebase config files are not committed. You need your own Firebase project or the one from the app owner.

## Backend

Zmare connects to a Laravel REST API. Backend repo: [Menfesawi-Zmare/zmare-backend](https://github.com/Menfesawi-Zmare) *(update with correct backend URL)*
