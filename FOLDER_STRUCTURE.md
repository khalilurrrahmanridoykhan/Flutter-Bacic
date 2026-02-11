# Folder Structure

This document summarizes the current Flutter app layout.

## Tree

```text
lib
├── l10n
├── main.dart
├── src
│   ├── app.dart
│   ├── core
│   │   ├── constants
│   │   ├── services
│   │   │   └── auth_service.dart
│   │   ├── utils
│   │   └── widgets
│   ├── features
│   │   ├── auth
│   │   │   ├── data
│   │   │   │   ├── datasources
│   │   │   │   ├── models
│   │   │   │   └── repositories
│   │   │   ├── domain
│   │   │   │   ├── entities
│   │   │   │   └── usecases
│   │   │   └── presentation
│   │   │       ├── bloc
│   │   │       ├── pages
│   │   │       └── widgets
│   │   └── home
│   │       └── presentation
│   │           └── pages
│   └── routes
└── theme
```

## Notes

- `lib/main.dart` is the entry point.
- `lib/src/app.dart` is the root widget and route table.
- `lib/src/core/` holds shared, cross-feature code (services, utils, common widgets).
- `lib/src/features/` is feature-first; each feature can contain `data`, `domain`, and `presentation` layers.
- `lib/src/features/auth/presentation/` contains the login UI.
- `lib/src/features/home/presentation/` contains the post-login UI.
- `lib/l10n` and `lib/theme` hold localization and theming.
