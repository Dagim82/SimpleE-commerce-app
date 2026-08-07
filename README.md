# E-Commerce App

A Flutter-based e-commerce mobile app that connects to the FakeStore API to let users browse products, search by name, filter by category, log in, and manage a shopping cart.

## Features

- User login with API-based authentication
- Demo login credentials included for quick testing
- Product listing with search and category filtering
- Product detail viewing
- Shopping cart with quantity updates and total calculation
- Profile screen with user information
- Persistent login and cart state using local storage
- Built with Flutter and Riverpod for state management

## Tech Stack

- Flutter
- Dart
- Riverpod
- HTTP package
- Shared Preferences
- FakeStore API

## Demo Login

Use the following credentials to sign in quickly:

- Username: `mor_2314`
- Password: `83r5^_`

## Getting Started

### Prerequisites

Make sure you have Flutter installed and configured on your machine.

- Flutter SDK
- Android Studio / VS Code with Flutter extensions
- An emulator or connected device

### Install dependencies

```bash
flutter pub get
```

### Run the app

```bash
flutter run
```

### Run in a specific device

```bash
flutter devices
flutter run -d <device-id>
```

## Project Structure

```bash
lib/
├── api_service.dart
├── auth_provider.dart
├── cart_provider.dart
├── cart_screen.dart
├── home_screen.dart
├── login_screen.dart
├── main.dart
├── models.dart
├── product_detail_screen.dart
├── product_provider.dart
├── profile_screen.dart
├── storage_service.dart
└── widgets/
```

## Notes

This app uses the FakeStore API for product and user data, so it is a demo e-commerce application intended for learning and testing UI patterns and app flow.

## License

This project is for educational/demo purposes.
