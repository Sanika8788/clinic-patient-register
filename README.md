# Clinic Patient Register (Flutter)

A small offline-first Flutter app for clinics to register and look up patients. Built as a personal demo project.

## Features
- Patient list with search by name or phone
- Add / edit / delete with form validation
- Offline storage with SQLite (`sqflite`) on Android
- PDF export of the register (`pdf` + `printing`)
- Biometric / device-credential lock on launch (`local_auth`)
- Material 3 UI with light and dark theme

## Tech
Flutter, Dart, SQLite, Material 3

## Run
```bash
flutter pub get
flutter run          # Android device or emulator
flutter test         # widget tests
```

## Notes
- SQLite and the biometric lock work on Android/iOS. The web build uses an in-memory store and skips the lock, and exists only for quick previews.
- All data shown in screenshots is fictional sample data.
