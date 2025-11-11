# JobsIQ Mobile App

A professional, enterprise-grade Flutter mobile application for the JobsIQ job board platform.

## Features

- 🎯 **Clean Architecture** - Maintainable and scalable code structure
- 🎨 **Modern UI** - Beautiful design with light/dark theme support
- 📱 **Responsive Design** - Optimized for one-handed mobile use
- 🔐 **Secure Authentication** - Token-based authentication with Laravel Sanctum
- 💼 **Job Management** - Browse, search, filter, and save jobs
- 📄 **CV Management** - Create and manage multiple CVs
- 🔔 **Real-time Updates** - Stay informed with notifications
- 🌐 **API Integration** - Full integration with JobsIQ backend API

## Architecture

This app follows **Clean Architecture** principles with three main layers:

### 1. Presentation Layer
- **Pages**: UI screens for different features
- **Widgets**: Reusable UI components
- **BLoC**: State management using BLoC pattern

### 2. Domain Layer
- **Entities**: Business objects
- **Repositories**: Abstract repository interfaces
- **Use Cases**: Business logic implementation

### 3. Data Layer
- **Models**: Data transfer objects (DTOs)
- **Data Sources**: API and local storage implementations
- **Repositories**: Repository implementations

## Project Structure

```
lib/
├── config/
│   ├── di/                  # Dependency injection setup
│   └── routes/              # App routing configuration
├── core/
│   ├── constants/           # App constants and API endpoints
│   ├── error/              # Error handling and exceptions
│   ├── network/            # Network client configuration
│   ├── theme/              # App theme and styling
│   ├── usecases/           # Base use case classes
│   └── utils/              # Utility functions
├── data/
│   ├── datasources/        # API and local data sources
│   ├── models/             # Data models
│   └── repositories/       # Repository implementations
├── domain/
│   ├── entities/           # Business entities
│   ├── repositories/       # Repository interfaces
│   └── usecases/           # Business logic use cases
└── presentation/
    ├── bloc/               # BLoC state management
    ├── pages/              # App screens
    └── widgets/            # Reusable widgets
```

## Technology Stack

### Core
- **Flutter SDK**: >= 3.3.0
- **Dart**: >= 3.3.0

### State Management
- **flutter_bloc**: State management
- **equatable**: Value equality

### Dependency Injection
- **get_it**: Service locator
- **injectable**: Code generation for DI

### Networking
- **dio**: HTTP client
- **retrofit**: Type-safe REST client
- **pretty_dio_logger**: Network logging

### Storage
- **shared_preferences**: Local key-value storage
- **flutter_secure_storage**: Secure credential storage
- **hive**: Fast local database

### Navigation
- **go_router**: Declarative routing

### UI Components
- **flutter_screenutil**: Responsive UI
- **cached_network_image**: Image caching
- **shimmer**: Loading placeholders
- **flutter_svg**: SVG support

## Getting Started

### Prerequisites

- Flutter SDK (3.3.0 or higher)
- Dart SDK (3.3.0 or higher)
- Android Studio / Xcode (for mobile development)
- VS Code with Flutter extension (recommended)

### Installation

1. **Navigate to frontend directory**
   ```bash
   cd C:\xampp\htdocs\myProjects\jobsiq\frontend
   ```

2. **Install dependencies**
   ```bash
   flutter pub get
   ```

3. **Configure API endpoint**

   Update the base URL in `lib/core/constants/api_constants.dart`:
   ```dart
   static const String baseUrl = 'http://your-api-url.com';
   ```

4. **Run the app**
   ```bash
   # For development
   flutter run

   # For specific platform
   flutter run -d android
   flutter run -d ios
   ```

## App Structure

### Bottom Navigation

The app features a fixed bottom navigation bar with 4 main sections:

1. **Jobs** (🔍) - Browse all jobs, search and filter
2. **Saved** (🔖) - View saved jobs and bookmarks
3. **CV** (📄) - Create and manage CVs
4. **Profile** (👤) - View profile and settings

## Building for Release

### Android
```bash
flutter build apk --release
flutter build appbundle --release
```

### iOS
```bash
flutter build ios --release
```

## Code Quality

The project follows Flutter best practices and includes:
- Clean Architecture
- BLoC pattern for state management
- Dependency injection
- Error handling
- Code linting

## License

This project is proprietary software for JobsIQ.

---

**Version**: 1.0.0
**Last Updated**: 2025-01-11
