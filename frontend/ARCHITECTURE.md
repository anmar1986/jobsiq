# JobsIQ Mobile App - Architecture Documentation

## Overview

This document provides a comprehensive overview of the JobsIQ mobile application architecture, design patterns, and implementation details.

## Architecture Pattern

The app follows **Clean Architecture** principles, organized into three distinct layers:

```
┌─────────────────────────────────────────────────────────────┐
│                    Presentation Layer                        │
│  (UI, Pages, Widgets, BLoC State Management)                │
└───────────────────┬─────────────────────────────────────────┘
                    │
                    ↓
┌─────────────────────────────────────────────────────────────┐
│                      Domain Layer                            │
│  (Entities, Repository Interfaces, Use Cases)               │
└───────────────────┬─────────────────────────────────────────┘
                    │
                    ↓
┌─────────────────────────────────────────────────────────────┐
│                       Data Layer                             │
│  (Models, Repositories, Data Sources: API & Local)          │
└─────────────────────────────────────────────────────────────┘
```

## Layer Responsibilities

### 1. Presentation Layer (`lib/presentation/`)

**Purpose**: Handles UI rendering and user interactions

**Components**:
- **Pages**: Full-screen views (Jobs, Saved, CV, Profile, Auth)
- **Widgets**: Reusable UI components (JobCard, CVCard, etc.)
- **BLoC**: State management (Events, States, BLoCs)

**Key Features**:
- Reactive UI updates with BLoC pattern
- Navigation with go_router
- Responsive design with ScreenUtil
- Theme-aware components

### 2. Domain Layer (`lib/domain/`)

**Purpose**: Contains business logic and rules

**Components**:
- **Entities**: Pure business objects (User, Job, CV, etc.)
- **Repository Interfaces**: Abstract data access contracts
- **Use Cases**: Single-responsibility business operations

**Key Features**:
- Framework-independent
- Testable business logic
- Clear separation of concerns

### 3. Data Layer (`lib/data/`)

**Purpose**: Manages data sources and implements repositories

**Components**:
- **Models**: Data transfer objects (JSON serialization)
- **Data Sources**:
  - Remote: API client (Dio/Retrofit)
  - Local: Storage (SharedPreferences, SecureStorage, Hive)
- **Repositories**: Implements domain repository interfaces

**Key Features**:
- API integration
- Local caching
- Error handling
- Network monitoring

## Core Module (`lib/core/`)

### Constants
- **API Constants**: Endpoint URLs and configurations
- **App Constants**: App-wide constants and enums

### Error Handling
- **Failures**: Domain-level error types
- **Exceptions**: Data-level exceptions
- Error mapping and transformation

### Network
- **Dio Client**: Configured HTTP client
- **Network Info**: Connectivity checking
- Interceptors for auth and logging

### Theme
- **App Colors**: Light and dark theme colors
- **App Text Styles**: Typography system
- **App Theme**: Complete Material theme configuration

### Utils
- **Logger**: Centralized logging utility
- Helper functions and extensions

## Design Patterns

### 1. BLoC Pattern (Business Logic Component)

```dart
Event → BLoC → State
  ↑              ↓
  └──── UI ←─────┘
```

**Benefits**:
- Separation of business logic from UI
- Testable code
- Reactive programming
- Predictable state management

### 2. Repository Pattern

```dart
Use Case → Repository Interface → Repository Implementation
                                          ↓
                                   Data Sources (API/Local)
```

**Benefits**:
- Abstraction of data sources
- Easy to mock for testing
- Flexible data source switching

### 3. Dependency Injection

Using `get_it` for service locator pattern:

```dart
// Registration
sl.registerLazySingleton<Repository>(
  () => RepositoryImpl(dataSource: sl())
);

// Usage
final repository = sl<Repository>();
```

**Benefits**:
- Loose coupling
- Easy testing
- Better code organization

## State Management Flow

### Example: Loading Jobs

```
1. User Action
   └→ JobsPage widget dispatch LoadJobsEvent

2. BLoC Processing
   └→ JobsBloc receives event
      └→ Calls GetJobsUseCase
         └→ UseCase calls JobRepository
            └→ Repository calls ApiDataSource
               └→ API request via Dio

3. State Update
   └→ BLoC emits new state (Loading → Loaded/Error)
      └→ UI rebuilds with BlocBuilder
```

## Navigation Architecture

Using **go_router** for declarative routing:

```dart
/ (splash)
├── /login
├── /register
└── /main
    ├── ?tab=jobs
    ├── ?tab=saved
    ├── ?tab=cvs
    └── ?tab=profile
```

**Features**:
- Deep linking support
- Type-safe navigation
- Query parameters for tabs
- Custom transitions

## Data Flow

### API Request Flow

```
UI Event
  ↓
BLoC
  ↓
Use Case
  ↓
Repository Interface
  ↓
Repository Implementation
  ↓
Remote Data Source
  ↓
Dio Client
  ↓
API Response
  ↓
Model → Entity
  ↓
Success/Failure
  ↓
BLoC State
  ↓
UI Update
```

## Security Implementation

### 1. Token Management
- Secure storage using `flutter_secure_storage`
- Automatic token refresh
- Token expiration handling

### 2. API Security
- HTTPS-only communication
- Bearer token authentication
- Request/response encryption

### 3. Local Storage
- Sensitive data in secure storage
- Non-sensitive data in shared preferences
- Data encryption at rest

## Performance Optimization

### 1. Image Loading
- Cached network images
- Placeholder shimmer effects
- Lazy loading

### 2. List Optimization
- `ListView.builder` for large lists
- Pagination support
- Pull-to-refresh

### 3. State Management
- Efficient BLoC rebuilds
- Selective widget rebuilding
- Memory management

### 4. Network
- Request caching
- Retry logic
- Connection pooling

## Testing Strategy

### 1. Unit Tests
```
test/
├── domain/
│   ├── entities/
│   └── usecases/
├── data/
│   ├── models/
│   └── repositories/
└── core/
```

### 2. Widget Tests
```
test/
└── presentation/
    └── widgets/
```

### 3. Integration Tests
```
integration_test/
└── app_test.dart
```

## Error Handling Strategy

### Error Flow

```
Exception (Data Layer)
    ↓
Failure (Domain Layer)
    ↓
Error State (Presentation Layer)
    ↓
User-Friendly Message (UI)
```

### Error Types

1. **Network Errors**: No connection, timeout
2. **Server Errors**: 500, 503, etc.
3. **Client Errors**: 400, 401, 404, etc.
4. **Validation Errors**: Form validation failures
5. **Cache Errors**: Local storage failures

## Bottom Navigation Structure

### Fixed Bottom Bar (One-Handed Optimized)

```
┌─────────┬─────────┬─────────┬─────────┐
│  Jobs   │  Saved  │   CV    │ Profile │
│    🔍   │    🔖   │   📄    │    👤   │
└─────────┴─────────┴─────────┴─────────┘
```

**Design Principles**:
- Fixed position for easy thumb reach
- Clear, descriptive icons
- Active state indication
- Smooth tab transitions

## API Integration

### Endpoints Configuration

All endpoints are centralized in `api_constants.dart`:

```dart
class ApiConstants {
  static const String baseUrl = 'http://localhost:8000';
  static const String jobs = '/api/jobs';
  static const String savedJobs = '/api/saved-jobs';
  // ... more endpoints
}
```

### Request Flow

1. User action triggers event
2. BLoC calls use case
3. Use case calls repository
4. Repository calls data source
5. Data source makes API call
6. Response mapped to model
7. Model converted to entity
8. Entity returned through layers
9. BLoC emits new state
10. UI updates

## Theme System

### Light/Dark Mode Support

```dart
ThemeMode.system  // Follows device settings
ThemeMode.light   // Force light mode
ThemeMode.dark    // Force dark mode
```

### Color System

- Primary: Blue (#2563EB)
- Secondary: Green (#10B981)
- Semantic: Success, Error, Warning, Info
- Neutral: Grey scale (50-900)
- Dark theme variants

### Typography

- Font: Inter
- Responsive sizing
- Accessibility support

## Code Organization Best Practices

1. **File Naming**: snake_case
2. **Class Naming**: PascalCase
3. **Variable Naming**: camelCase
4. **Constants**: SCREAMING_SNAKE_CASE
5. **One class per file** (except small helper classes)
6. **Barrel exports** for public APIs
7. **Feature-based folder structure**

## Future Enhancements

### Planned Features

1. **Offline Support**: Complete offline functionality
2. **Push Notifications**: Job alerts and updates
3. **Biometric Auth**: Fingerprint/Face ID login
4. **Advanced Filters**: Complex job search filters
5. **Analytics**: User behavior tracking
6. **Internationalization**: Multi-language support
7. **Accessibility**: Screen reader optimization
8. **Animation**: Smooth transitions and micro-interactions

### Technical Debt

1. Complete BLoC implementation for all features
2. Add comprehensive test coverage
3. Implement API models with code generation
4. Add error boundary widgets
5. Implement retry mechanisms
6. Add analytics tracking

## Contributing Guidelines

1. Follow Clean Architecture principles
2. Write tests for new features
3. Update documentation
4. Use meaningful commit messages
5. Code review before merge
6. Follow Dart/Flutter style guide

## Resources

- [Flutter Documentation](https://docs.flutter.dev/)
- [BLoC Library](https://bloclibrary.dev/)
- [Clean Architecture](https://blog.cleancoder.com/uncle-bob/2012/08/13/the-clean-architecture.html)
- [Material Design 3](https://m3.material.io/)

---

**Last Updated**: 2025-01-11
**Architecture Version**: 1.0.0
