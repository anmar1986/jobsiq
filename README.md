# JobsIQ - Job Search and CV Management Platform

[![Tests](https://github.com/anmar1986/jobsiq/actions/workflows/tests.yml/badge.svg)](https://github.com/anmar1986/jobsiq/actions/workflows/tests.yml)
[![Code Quality](https://github.com/anmar1986/jobsiq/actions/workflows/lint.yml/badge.svg)](https://github.com/anmar1986/jobsiq/actions/workflows/lint.yml)
[![CI/CD Pipeline](https://github.com/anmar1986/jobsiq/actions/workflows/ci-cd.yml/badge.svg)](https://github.com/anmar1986/jobsiq/actions/workflows/ci-cd.yml)

A modern, full-stack job search and CV management platform built with Laravel and Vue.js.

## Features

- 🔐 **User Authentication** - Secure registration and login with Laravel Sanctum
- 📄 **CV Management** - Create, edit, and manage multiple CVs
- 💼 **Job Listings** - Browse and search for job opportunities
- 🏢 **Company Profiles** - Explore company information
- 🔍 **Advanced Search** - Filter jobs by skills, location, and more
- 📱 **Responsive Design** - Works seamlessly on desktop and mobile

## Tech Stack

### Backend
- **Laravel 12** - PHP Framework
- **MySQL** - Database
- **Laravel Sanctum** - API Authentication
- **Laravel Pint** - Code Style

### Frontend
- **Vue 3** - Progressive JavaScript Framework
- **TypeScript** - Type-safe JavaScript
- **Pinia** - State Management
- **Vue Router** - Routing
- **Tailwind CSS 4** - Utility-first CSS
- **Vite** - Build Tool
- **Axios** - HTTP Client

## Prerequisites

- PHP >= 8.3
- Composer
- Node.js >= 20
- MySQL >= 8.0
- npm or yarn

## Installation

### 1. Clone the repository
```bash
git clone https://github.com/anmar1986/jobsiq.git
cd jobsiq
```

### 2. Install PHP dependencies
```bash
composer install
```

### 3. Install Node dependencies
```bash
npm install
```

### 4. Environment Configuration
```bash
cp .env.example .env
php artisan key:generate
```

Edit `.env` file with your database credentials:
```env
DB_CONNECTION=mysql
DB_HOST=127.0.0.1
DB_PORT=3306
DB_DATABASE=jobsiq
DB_USERNAME=root
DB_PASSWORD=your_password
```

### 5. Database Setup
```bash
php artisan migrate
php artisan db:seed  # Optional: Seed with sample data
```

### 6. Storage Link
```bash
php artisan storage:link
```

### 7. Build Frontend Assets
```bash
npm run build
```

## Development

### Start Backend Server
```bash
php artisan serve
```
The API will be available at `http://localhost:8000`

### Start Frontend Dev Server
```bash
npm run dev
```
The frontend will be available at `http://localhost:5173`

### Code Quality

#### PHP Code Style (Laravel Pint)
```bash
# Check code style
vendor/bin/pint --test

# Fix code style
vendor/bin/pint
```

#### Frontend Linting
```bash
# Run ESLint
npm run lint

# Type checking
npm run type-check
```

### Running Tests

#### PHP Tests
```bash
./vendor/bin/phpunit

# With coverage
./vendor/bin/phpunit --coverage-html coverage
```

## CI/CD Pipeline

This project uses GitHub Actions for continuous integration and deployment:

### Workflows

1. **Tests** (`.github/workflows/tests.yml`)
   - Runs on push/PR to main/develop
   - Sets up MySQL database
   - Runs PHP tests with coverage
   - Type-checks frontend code

2. **Code Quality** (`.github/workflows/lint.yml`)
   - Checks PHP code style with Laravel Pint
   - Runs ESLint on frontend code
   - Performs TypeScript type checking

3. **CI/CD Pipeline** (`.github/workflows/ci-cd.yml`)
   - Security scanning
   - Code quality checks
   - Automated testing
   - Build artifacts
   - Deploy to staging (develop branch)
   - Deploy to production (main branch)

### Setting up GitHub Actions

The workflows will run automatically on push and pull requests. For deployment:

1. Go to your repository settings
2. Navigate to **Secrets and variables** → **Actions**
3. Add the following secrets:
   - `STAGING_SSH_KEY` - SSH private key for staging server
   - `STAGING_HOST` - Staging server hostname
   - `STAGING_USER` - SSH username for staging
   - `PRODUCTION_SSH_KEY` - SSH private key for production
   - `PRODUCTION_HOST` - Production server hostname
   - `PRODUCTION_USER` - SSH username for production

## API Documentation

### Authentication
- `POST /api/register` - Register new user
- `POST /api/login` - Login
- `POST /api/logout` - Logout
- `GET /api/user` - Get authenticated user

### CVs
- `GET /api/user-cvs` - Get all user CVs
- `POST /api/user-cvs` - Create CV
- `GET /api/user-cvs/{id}` - Get CV by ID
- `PUT /api/user-cvs/{id}` - Update CV
- `DELETE /api/user-cvs/{id}` - Delete CV

### Jobs
- `GET /api/jobs` - List all jobs
- `GET /api/jobs/{id}` - Get job details
- `POST /api/jobs` - Create job (requires authentication)
- `PUT /api/jobs/{id}` - Update job
- `DELETE /api/jobs/{id}` - Delete job

## Project Structure

```
jobsiq/
├── app/
│   ├── Http/
│   │   ├── Controllers/
│   │   │   └── Api/          # API Controllers
│   │   └── Requests/          # Form Requests
│   └── Models/                # Eloquent Models
├── database/
│   ├── migrations/            # Database migrations
│   ├── factories/             # Model factories
│   └── seeders/               # Database seeders
├── routes/
│   └── api.php               # API routes
├── src/                      # Vue.js frontend
│   ├── components/           # Vue components
│   ├── views/                # Page views
│   ├── stores/               # Pinia stores
│   ├── services/             # API services
│   └── router/               # Vue Router
├── tests/                    # PHPUnit tests
└── .github/
    └── workflows/            # GitHub Actions workflows
```

## Contributing

1. Fork the repository
2. Create your feature branch (`git checkout -b feature/amazing-feature`)
3. Commit your changes (`git commit -m 'Add some amazing feature'`)
4. Push to the branch (`git push origin feature/amazing-feature`)
5. Open a Pull Request

## License

This project is open-sourced software licensed under the [MIT license](LICENSE).

## Author

**Anmar**
- GitHub: [@anmar1986](https://github.com/anmar1986)

## Support

For support, email support@jobsiq.com or create an issue in the GitHub repository.
