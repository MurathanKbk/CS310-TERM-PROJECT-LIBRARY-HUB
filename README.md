# LibraryHub

CS310 Mobile Application Development, Fall 2026, Group 34.
LibraryHub helps students find library books and reserve study rooms.

Team members: Hasan Demirhan Durmaz, Ongun Arda Münüsoğlu, Javid Ramazanlı, and Murathan Kabak.

## Run the app

This checkout was tested with Flutter **3.47.7** (stable) and Dart **3.13.5**.
Install Flutter and the Android SDK, then start an Android emulator from Android
Studio's Device Manager. From the repository root, run:

```sh
flutter doctor
flutter pub get
flutter devices
flutter run
```

When several devices are connected, use `flutter run -d <device-id>` with the
Android device ID shown by `flutter devices`.

## Verify the room flow

After the splash screen, log in with a sample email such as `demo@example.com`
and any non-empty sample password. The Step 2.2 login checks input locally.
From Home, tap **Browse Rooms**. Open a room, tap **Reserve**, select a date,
and enter a time interval in 24-hour format (for example, `17:00 - 19:00`).
Confirm the reservation, then open **My Room Reservations** to review or cancel
it. To view reminders, tap the bell on Home.

```sh
dart analyze lib test
flutter test
```

Step 2.2 uses sample data. Room reservations are kept for the current app
session. Network book covers fall back to placeholders when a cover is unavailable.
