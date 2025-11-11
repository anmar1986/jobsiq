# Getting Started with JobsIQ Mobile

This guide will help you set up and run the JobsIQ mobile application.

## Prerequisites

Before you begin, ensure you have the following installed:

- ✅ Flutter SDK (3.3.0 or higher) - **INSTALLED**
- ✅ Dart SDK (3.3.0 or higher) - **INSTALLED**
- ✅ Android Studio - **INSTALLED**
- ✅ VS Code with Flutter extension - **INSTALLED**
- ⚠️ Xcode (for iOS development) - Optional
- ⚠️ Visual Studio (for Windows development) - Optional

## Quick Start

### 1. Navigate to Project Directory

```bash
cd C:\xampp\htdocs\myProjects\jobsiq\frontend
```

### 2. Install Dependencies

```bash
flutter pub get
```

### 3. Configure API Endpoint

Open `lib/core/constants/api_constants.dart` and update the base URL:

```dart
static const String baseUrl = 'http://localhost:8000';  // Your Laravel API URL
```

For Android emulator, use: `http://10.0.2.2:8000`
For iOS simulator, use: `http://localhost:8000`
For physical device, use your computer's IP: `http://192.168.x.x:8000`

### 4. Run the App

```bash
# List available devices
flutter devices

# Run on specific device
flutter run -d android         # For Android
flutter run -d ios            # For iOS
flutter run -d chrome         # For Web (testing only)

# Or simply run (will prompt device selection)
flutter run
```

## Project Structure Overview

```
frontend/
├── lib/
│   ├── config/              # App configuration
│   │   ├── di/             # Dependency injection
│   │   └── routes/         # Navigation routes
│   ├── core/               # Core utilities
│   │   ├── constants/      # App & API constants
│   │   ├── error/          # Error handling
│   │   ├── network/        # Network client
│   │   ├── theme/          # App theming
│   │   ├── usecases/       # Base use case
│   │   └── utils/          # Utilities
│   ├── data/               # Data layer (to be implemented)
│   │   ├── datasources/    # API & local data sources
│   │   ├── models/         # Data models
│   │   └── repositories/   # Repository implementations
│   ├── domain/             # Domain layer
│   │   ├── entities/       # Business entities
│   │   ├── repositories/   # Repository interfaces
│   │   └── usecases/       # Business logic
│   └── presentation/       # UI layer
│       ├── bloc/           # State management (to be implemented)
│       ├── pages/          # App screens
│       └── widgets/        # Reusable widgets
├── assets/                 # App assets
│   ├── images/
│   ├── icons/
│   ├── animations/
│   └── fonts/
├── test/                   # Unit & widget tests
└── integration_test/       # Integration tests
```

## Development Workflow

### 1. Hot Reload

While the app is running, press:
- `r` - Hot reload (applies code changes)
- `R` - Hot restart (restarts the app)
- `q` - Quit

### 2. Code Analysis

```bash
# Analyze code for issues
flutter analyze

# Format code
flutter format lib/

# Check for outdated packages
flutter pub outdated
```

### 3. Build for Release

#### Android

```bash
# Build APK
flutter build apk --release

# Build App Bundle (for Play Store)
flutter build appbundle --release
```

Output: `build/app/outputs/flutter-apk/app-release.apk`

#### iOS

```bash
flutter build ios --release
```

Then open in Xcode for signing and distribution.

## Current Features

### ✅ Implemented

1. **Authentication Pages**
   - Login page with form validation
   - Register page with user type selection
   - Splash screen with branding

2. **Main Navigation**
   - Fixed bottom navigation bar
   - 4 main tabs: Jobs, Saved, CV, Profile
   - Smooth tab transitions

3. **Jobs Tab**
   - Search functionality
   - Filter button
   - Job cards with company info
   - Featured jobs section

4. **Saved Jobs Tab**
   - List of saved jobs
   - Quick access to bookmarks

5. **CV Tab**
   - CV list view
   - Primary CV indicator
   - CV statistics

6. **Profile Tab**
   - User information display
   - Settings sections
   - Theme toggle (Dark/Light)
   - Logout functionality

7. **Core Infrastructure**
   - Clean Architecture setup
   - Theme system (Light/Dark)
   - Error handling
   - Dependency injection
   - Network client configuration
   - Logger utility

### 🚧 To Be Implemented

1. **BLoC State Management**
   - Authentication BLoC
   - Jobs BLoC
   - Saved Jobs BLoC
   - CV BLoC
   - Profile BLoC

2. **API Integration**
   - Data models with JSON serialization
   - Repository implementations
   - Use cases for business logic
   - API data sources

3. **Additional Features**
   - Job details page
   - CV create/edit pages
   - Profile edit page
   - Application management
   - Filters and sorting
   - Search functionality
   - Notifications

## Common Issues & Solutions

### Issue 1: "No devices found"

**Solution**:
```bash
# Check connected devices
flutter devices

# For Android emulator
# Open Android Studio > AVD Manager > Start emulator

# For iOS simulator
open -a Simulator
```

### Issue 2: Dependencies not found

**Solution**:
```bash
flutter clean
flutter pub get
```

### Issue 3: Build fails

**Solution**:
```bash
# Clear cache
flutter clean

# Get dependencies
flutter pub get

# Rebuild
flutter run
```

### Issue 4: Hot reload not working

**Solution**:
- Press `R` for hot restart instead of `r`
- Or fully stop and restart: `flutter run`

### Issue 5: API connection fails

**Solutions**:

For **Android Emulator**:
```dart
// Use 10.0.2.2 instead of localhost
static const String baseUrl = 'http://10.0.2.2:8000';
```

For **iOS Simulator**:
```dart
// localhost works fine
static const String baseUrl = 'http://localhost:8000';
```

For **Physical Device**:
```dart
// Use your computer's local IP
static const String baseUrl = 'http://192.168.1.100:8000';
```

Make sure your Laravel backend is running:
```bash
php artisan serve --host=0.0.0.0 --port=8000
```

## Testing

### Run Tests

```bash
# Unit tests
flutter test

# Integration tests
flutter test integration_test/

# With coverage
flutter test --coverage
```

### View Coverage

```bash
# Generate HTML coverage report
genhtml coverage/lcov.info -o coverage/html

# Open in browser
start coverage/html/index.html  # Windows
open coverage/html/index.html   # macOS
```

## Next Steps

### For New Developers

1. **Read the Documentation**
   - `README.md` - Project overview
   - `ARCHITECTURE.md` - Architecture details
   - This file - Getting started guide

2. **Explore the Code**
   - Start with `lib/main.dart`
   - Check out the page structure in `lib/presentation/pages/`
   - Review the theme in `lib/core/theme/`

3. **Run the App**
   - Follow the Quick Start guide above
   - Explore all 4 tabs
   - Try the authentication flow

4. **Make Your First Change**
   - Modify a color in `app_colors.dart`
   - Hot reload and see the change
   - Commit your change

### For API Integration

1. **Start Backend Server**
   ```bash
   cd C:\xampp\htdocs\myProjects\jobsiq
   php artisan serve
   ```

2. **Update API Constants**
   - Configure `baseUrl` in `api_constants.dart`

3. **Implement Data Layer** (Next Phase)
   - Create data models
   - Implement repositories
   - Add API data sources
   - Connect to UI with BLoC

## Development Tools

### Recommended VS Code Extensions

- Flutter
- Dart
- Awesome Flutter Snippets
- Flutter Widget Snippets
- Bloc
- Error Lens

### Useful Commands

```bash
# Check Flutter version
flutter --version

# Update Flutter
flutter upgrade

# List all devices
flutter devices

# Clear all cache
flutter clean

# Update packages
flutter pub upgrade

# Generate code (for future use)
flutter pub run build_runner build --delete-conflicting-outputs
```

## Resources

- **Flutter Docs**: https://docs.flutter.dev/
- **Dart Docs**: https://dart.dev/guides
- **BLoC Library**: https://bloclibrary.dev/
- **Material Design**: https://m3.material.io/

## Support

For questions or issues:
1. Check this documentation
2. Review `ARCHITECTURE.md`
3. Contact the development team

---

**Last Updated**: 2025-01-11
**App Version**: 1.0.0
