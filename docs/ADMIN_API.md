# Admin API Documentation

## Overview

This is a complete **API-based admin panel** for JobsIQ. All admin functionality is accessed through RESTful API endpoints - **no Blade templates or web views are used**.

## Features

- ✅ **100% API-based** - Pure JSON API, no Blade views
- ✅ **Free & Open Source** - No license required
- ✅ **Built with Laravel** - Uses native Laravel features
- ✅ **Sanctum Authentication** - Secure token-based auth
- ✅ **Role-based Access** - Admin middleware protection
- ✅ **Full CRUD Operations** - Manage all resources
- ✅ **Advanced Filtering** - Search, sort, and paginate
- ✅ **Statistics & Metrics** - Dashboard analytics
- ✅ **RESTful Standards** - Clean API design

## Getting Started

### 1. Run Migrations

```bash
php artisan migrate:fresh --seed
```

### 2. Create Admin User

```bash
php artisan admin:create
```

Or with options:
```bash
php artisan admin:create --name="Admin User" --email="admin@example.com" --password="admin123"
```

### 3. Login as Admin

**POST** `/api/login`

```json
{
  "email": "admin@example.com",
  "password": "admin123"
}
```

**Response:**
```json
{
  "user": {
    "id": 1,
    "name": "Admin User",
    "email": "admin@example.com",
    "is_admin": true,
    ...
  },
  "token": "1|xxxxxxxxxxxxx"
}
```

### 4. Use the Token

Include the token in all admin API requests:

```
Authorization: Bearer 1|xxxxxxxxxxxxx
```

## Admin API Endpoints

All admin endpoints are prefixed with `/api/admin` and require authentication + admin role.

### Dashboard

#### Get Dashboard Statistics
**GET** `/api/admin/dashboard`

Returns comprehensive statistics for users, companies, jobs, applications, and activity metrics.

---

### User Management

#### List Users
**GET** `/api/admin/users`

Query Parameters:
- `search` - Search by name or email
- `user_type` - Filter by type (`job_seeker`, `company_owner`)
- `is_admin` - Filter by admin status (boolean)
- `sort_by` - Sort field (default: `created_at`)
- `sort_order` - Sort order (`asc`, `desc`)
- `per_page` - Items per page (default: 15)

Example:
```
GET /api/admin/users?search=john&user_type=job_seeker&per_page=20
```

#### Get User Statistics
**GET** `/api/admin/users/statistics`

#### Create User
**POST** `/api/admin/users`

```json
{
  "name": "John Doe",
  "email": "john@example.com",
  "password": "password123",
  "user_type": "job_seeker",
  "is_admin": false,
  "headline": "Software Developer",
  "city": "Baghdad",
  "country": "Iraq"
}
```

#### Get User Details
**GET** `/api/admin/users/{id}`

#### Update User
**PUT** `/api/admin/users/{id}`

```json
{
  "name": "John Updated",
  "is_admin": true
}
```

#### Delete User
**DELETE** `/api/admin/users/{id}`

---

### Company Management

#### List Companies
**GET** `/api/admin/companies`

Query Parameters:
- `search` - Search by name, email, or industry
- `industry` - Filter by industry
- `company_size` - Filter by company size
- `country` - Filter by country
- `sort_by` - Sort field
- `sort_order` - Sort order
- `per_page` - Items per page

#### Get Company Statistics
**GET** `/api/admin/companies/statistics`

#### Create Company
**POST** `/api/admin/companies`

```json
{
  "name": "Tech Corp",
  "slug": "tech-corp",
  "description": "A leading tech company",
  "industry": "Technology",
  "company_size": "50-100",
  "email": "info@techcorp.com",
  "website": "https://techcorp.com",
  "address": "123 Tech Street",
  "city": "Baghdad",
  "country": "Iraq",
  "owner_id": 1
}
```

#### Get Company Details
**GET** `/api/admin/companies/{id}`

#### Update Company
**PUT** `/api/admin/companies/{id}`

#### Delete Company
**DELETE** `/api/admin/companies/{id}`

---

### Job Management

#### List Jobs
**GET** `/api/admin/jobs`

Query Parameters:
- `search` - Search by title or description
- `job_type` - Filter by type (`full-time`, `part-time`, etc.)
- `experience_level` - Filter by level (`entry`, `mid`, etc.)
- `status` - Filter by status (`active`, `closed`, `draft`)
- `is_featured` - Filter featured jobs (boolean)
- `company_id` - Filter by company
- `sort_by` - Sort field
- `sort_order` - Sort order
- `per_page` - Items per page

#### Get Job Statistics
**GET** `/api/admin/jobs/statistics`

#### Create Job
**POST** `/api/admin/jobs`

```json
{
  "company_id": 1,
  "user_id": 1,
  "title": "Senior Developer",
  "slug": "senior-developer",
  "description": "We are hiring...",
  "requirements": "5+ years experience...",
  "job_type": "full-time",
  "experience_level": "senior",
  "location": "Baghdad, Iraq",
  "remote_option": "hybrid",
  "status": "active",
  "is_featured": true,
  "salary_min": 1000,
  "salary_max": 2000,
  "salary_currency": "USD"
}
```

#### Get Job Details
**GET** `/api/admin/jobs/{id}`

#### Update Job
**PUT** `/api/admin/jobs/{id}`

#### Delete Job
**DELETE** `/api/admin/jobs/{id}`

#### Toggle Featured Status
**POST** `/api/admin/jobs/{id}/toggle-featured`

---

### Job Application Management

#### List Applications
**GET** `/api/admin/applications`

Query Parameters:
- `search` - Search by user name/email or job title
- `status` - Filter by status
- `job_id` - Filter by job
- `user_id` - Filter by user
- `company_id` - Filter by company
- `sort_by` - Sort field
- `sort_order` - Sort order
- `per_page` - Items per page

#### Get Application Statistics
**GET** `/api/admin/applications/statistics`

#### Get Application Details
**GET** `/api/admin/applications/{id}`

#### Update Application Status
**PUT** `/api/admin/applications/{id}/status`

```json
{
  "status": "interview",
  "notes": "Scheduled for interview next week"
}
```

Status options:
- `pending`
- `reviewed`
- `shortlisted`
- `interview`
- `rejected`
- `accepted`

#### Delete Application
**DELETE** `/api/admin/applications/{id}`

---

## Authentication

All admin endpoints require:
1. Valid Sanctum authentication token
2. User must have `is_admin = true`

If not authenticated or not admin:
```json
{
  "message": "Unauthorized. Admin access required."
}
```

## Response Format

### Success Response
```json
{
  "message": "Operation successful",
  "data": {...}
}
```

### Paginated Response
```json
{
  "data": [...],
  "links": {...},
  "meta": {
    "current_page": 1,
    "total": 100,
    "per_page": 15
  }
}
```

### Error Response
```json
{
  "message": "Error message",
  "errors": {
    "field": ["validation error"]
  }
}
```

## Best Practices

### 1. Always Use Pagination
```
GET /api/admin/users?per_page=50
```

### 2. Filter Large Datasets
```
GET /api/admin/jobs?status=active&job_type=full-time
```

### 3. Use Search for Quick Lookups
```
GET /api/admin/users?search=john
```

### 4. Sort Results
```
GET /api/admin/companies?sort_by=name&sort_order=asc
```

### 5. Check Statistics Before Listing
```
GET /api/admin/users/statistics
GET /api/admin/jobs/statistics
```

## Frontend Integration

This API is designed to work with any frontend framework:

- **Vue.js** (recommended, already in your project)
- **React**
- **Angular**
- **Mobile Apps** (Flutter, React Native)

Example Vue.js integration:

```javascript
// api/admin.js
import axios from 'axios';

const api = axios.create({
  baseURL: '/api/admin',
  headers: {
    'Authorization': `Bearer ${localStorage.getItem('token')}`,
    'Accept': 'application/json',
  }
});

export const adminAPI = {
  // Dashboard
  getDashboard: () => api.get('/dashboard'),
  
  // Users
  getUsers: (params) => api.get('/users', { params }),
  getUser: (id) => api.get(`/users/${id}`),
  createUser: (data) => api.post('/users', data),
  updateUser: (id, data) => api.put(`/users/${id}`, data),
  deleteUser: (id) => api.delete(`/users/${id}`),
  
  // Companies
  getCompanies: (params) => api.get('/companies', { params }),
  
  // Jobs
  getJobs: (params) => api.get('/jobs', { params }),
  toggleFeatured: (id) => api.post(`/jobs/${id}/toggle-featured`),
  
  // Applications
  getApplications: (params) => api.get('/applications', { params }),
  updateApplicationStatus: (id, data) => api.put(`/applications/${id}/status`, data),
};
```

## Security

- ✅ CSRF protection disabled for API routes
- ✅ Sanctum token authentication
- ✅ Admin middleware authorization
- ✅ Rate limiting (Laravel default)
- ✅ Input validation on all endpoints
- ✅ SQL injection protection (Eloquent ORM)

## Testing Admin API

### Using cURL

```bash
# Login
curl -X POST http://localhost/api/login \
  -H "Content-Type: application/json" \
  -d '{"email":"admin@example.com","password":"admin123"}'

# Get dashboard (replace TOKEN with your actual token)
curl -X GET http://localhost/api/admin/dashboard \
  -H "Authorization: Bearer TOKEN"

# List users
curl -X GET "http://localhost/api/admin/users?per_page=10" \
  -H "Authorization: Bearer TOKEN"
```

### Using Postman

1. Create a collection for "Admin API"
2. Set collection-level Authorization: Bearer Token
3. Add endpoints from this documentation
4. Use environment variables for token

## Summary

You now have a complete, free, open-source admin panel that works entirely through API endpoints. No Blade views, no license required - just pure RESTful API that you can connect to any frontend framework of your choice!
