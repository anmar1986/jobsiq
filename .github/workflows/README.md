# GitHub Actions CI/CD Workflows

This directory contains the CI/CD pipelines for the JobsIQ application, which includes:
- **Laravel Backend API**
- **Vue.js Web Frontend**
- **Flutter Mobile App**

## Workflows Overview

### 1. `flutter-ci.yml` - Flutter Mobile CI
**Triggers:** Push/PR to `main` or `develop` with changes in `frontend/**`

**Jobs:**
- **analyze**: Runs `flutter analyze` to check for code issues
- **test**: Runs `flutter test --coverage` and uploads coverage
- **build-android**: Builds Android APK (on push to main/develop)
- **build-ios**: Builds iOS app on macOS (on push to main only)
- **format-check**: Checks Dart code formatting

**Artifacts:**
- Android APK: Available for 30 days after build

---

### 2. `tests.yml` - Backend & Web Tests
**Triggers:** Push/PR to `main` or `develop` with changes in backend/web code

**Jobs:**
- **backend-tests**: 
  - Sets up PHP 8.3, MySQL 8.0
  - Runs Laravel migrations
  - Executes PHPUnit tests with coverage
  
- **web-frontend-tests**:
  - Builds Vue.js frontend assets
  - Runs TypeScript type checking

---

### 3. `lint.yml` - Code Quality Checks
**Triggers:** Push/PR to `main` or `develop` with changes in backend/web code

**Jobs:**
- **php-lint**: Runs Laravel Pint for PHP code style
- **web-frontend-lint**: Runs ESLint and TypeScript checks for Vue.js

---

### 4. `ci-cd.yml` - Full CI/CD Pipeline
**Triggers:** Push/PR to `main` or `develop`

**Jobs:**
1. **security**: Security vulnerability scanning
2. **code-quality**: PHP code quality (Pint, PHPStan)
3. **frontend-quality**: Vue.js linting and type checking
4. **flutter-quality**: Flutter analyze and formatting
5. **test**: Runs all tests (depends on all quality checks)
6. **build**: Creates deployment artifacts
7. **deploy-staging**: Deploys to staging (develop branch)
8. **deploy-production**: Deploys to production (main branch)

---

## Path-Based Triggering

The workflows are optimized to run only when relevant files change:

- **Flutter workflows** trigger on `frontend/**` changes
- **Backend workflows** trigger on `app/**`, `config/**`, `database/**`, `routes/**`, `tests/**` changes
- **Web frontend workflows** trigger on `src/**`, `package.json` changes

This saves CI/CD minutes and speeds up the pipeline.

---

## Required Secrets

For deployment jobs, configure these secrets in GitHub Settings:

### Staging Environment
- `STAGING_SSH_KEY`: SSH private key for staging server
- `STAGING_HOST`: Staging server hostname
- `STAGING_USER`: SSH username for staging

### Production Environment
- `PRODUCTION_SSH_KEY`: SSH private key for production server
- `PRODUCTION_HOST`: Production server hostname
- `PRODUCTION_USER`: SSH username for production

---

## Flutter Setup

The Flutter workflow uses:
- **Flutter Version**: 3.27.0 (stable channel)
- **Java Version**: 17 (Zulu distribution) for Android builds
- **macOS runner**: Required for iOS builds
- **flutter_lints**: 4.0.0 (compatible with Dart SDK 3.3.0+)

---

## Coverage Reports

Both PHP and Flutter tests generate coverage reports:
- **PHP**: Uploaded to Codecov with flag `phpunit`
- **Flutter**: Uploaded to Codecov with flag `flutter`

---

## Deployment

### Current Setup
Deployment steps are placeholders. To enable:

1. Uncomment deployment steps in `ci-cd.yml`
2. Configure SSH keys in GitHub Secrets
3. Update server paths and URLs

### Recommended Deployment Tools
- **Laravel**: [Laravel Forge](https://forge.laravel.com/), [Envoyer](https://envoyer.io/)
- **Flutter**: [Fastlane](https://fastlane.tools/) for app store deployment

---

## Local Testing

### Test PHP Backend
```bash
./vendor/bin/phpunit
```

### Test Vue.js Frontend
```bash
npm run lint
npm run type-check
npm run build
```

### Test Flutter App
```bash
cd frontend
flutter analyze
flutter test
dart format --set-exit-if-changed .
```

---

## Troubleshooting

### Flutter Build Fails
- Ensure `pubspec.yaml` dependencies are compatible
- Check Flutter SDK version matches workflow (3.24.0)
- Verify Android/iOS configuration files

### Backend Tests Fail
- Check MySQL connection settings
- Ensure migrations run successfully
- Verify `.env.example` has all required variables

### Web Frontend Fails
- Check Node.js version (20.x required)
- Ensure `npm ci` runs without errors
- Verify TypeScript configuration

---

## Future Enhancements

- [ ] Add Flutter integration tests
- [ ] Implement automatic versioning
- [ ] Add app store deployment (TestFlight, Play Store)
- [ ] Add performance benchmarks
- [ ] Implement blue-green deployments
- [ ] Add security scanning for dependencies

---

## Contact

For workflow issues, contact the DevOps team or check the [GitHub Actions documentation](https://docs.github.com/en/actions).
