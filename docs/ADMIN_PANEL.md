# JobsIQ Admin Panel Documentation

## Overview
This is a professional, full-featured admin panel for JobsIQ built with Vue 3, TypeScript, and Laravel backend API. The admin panel provides complete control over users, companies, jobs, applications, and system statistics.

## Features

### ✅ Completed Features

#### 1. **Dashboard**
- Real-time statistics overview
- User metrics (total, job seekers, company owners)
- Company statistics
- Job metrics (active, closed, draft, featured)
- Application status breakdown
- 7-day activity charts
- Top industries list
- Application status progress bars

#### 2. **Users Management** (`/admin/users`)
- Complete CRUD operations
- Advanced filters:
  - Search by name/email
  - Filter by user type (job seeker/company owner)
  - Filter by admin status
  - Sortable columns
  - Pagination controls
- User creation with:
  - Name, email, password
  - User type selection
  - Admin role toggle
- User editing (all fields except password)
- User deletion with confirmation
- Visual user avatars with initials
- User type badges

#### 3. **Companies Management** (`/admin/companies`)
- View all companies with pagination
- Advanced filters:
  - Search by company name
  - Filter by industry
  - Filter by country
  - Sortable columns
- Company details modal:
  - Logo display
  - Full company information
  - Associated jobs count
- Quick navigation to company jobs
- Company deletion with cascade warning
- Company logos displayed

#### 4. **Jobs Management** (`/admin/jobs`)
- Complete job listings with pagination
- Advanced filters:
  - Search by job title
  - Filter by status (active/closed/draft)
  - Filter by job type
  - Filter by featured status
  - Filter by company
  - Sortable columns
- Job status management:
  - Change status (active → closed → draft)
  - Toggle featured status with one click
- Quick actions:
  - View job details
  - View job applications
  - Delete job with confirmation
- Visual status indicators
- Featured job highlighting

#### 5. **Applications Management** (`/admin/applications`)
- View all applications with pagination
- Advanced filters:
  - Search by applicant name
  - Filter by status
  - Filter by date range (today/week/month)
  - Filter by job
  - Sortable columns
- Status management:
  - Inline status updates (dropdown)
  - Status color coding
  - Status flow: pending → reviewed → interview → accepted/rejected
- Application details modal:
  - Applicant information
  - Job details
  - Application date
  - Cover letter display
- Quick actions:
  - View applicant CV
  - View full application details
  - Delete application

### 🎨 UI/UX Features

#### Professional Design
- Dark sidebar with white icons
- Collapsible navigation
- Active page highlighting
- User dropdown menu with logout
- Responsive layout (mobile-friendly)
- Loading states for all operations
- Empty states with helpful messages
- Confirmation modals for destructive actions

#### Component Library
- **AdminLayout**: Professional sidebar layout with navigation
- **DataTable**: Reusable data table with sorting, pagination, custom cells
- **StatsCard**: Animated statistics cards with icons and colors
- **ActivityChart**: SVG-based line charts for activity visualization
- **BaseCard**: Card wrapper for content sections
- **BaseModal**: Modal dialogs with multiple sizes

#### Design System
- Tailwind CSS utility classes
- Consistent color palette:
  - Indigo for primary actions
  - Green for success/active states
  - Yellow for warnings/pending
  - Red for errors/destructive actions
  - Blue for info
  - Purple for special features
- Icon library (Heroicons via inline SVG)
- Hover effects and transitions

## Technology Stack

### Frontend
- **Vue 3** (Composition API)
- **TypeScript** (full type safety)
- **Vue Router** (client-side routing)
- **Pinia** (state management)
- **Axios** (HTTP client)
- **Tailwind CSS** (styling)

### Backend
- **Laravel 12** (PHP framework)
- **Laravel Sanctum** (API authentication)
- **PostgreSQL/MySQL** (database)
- **RESTful API** (JSON responses)

## API Integration

### Authentication
All API requests require Bearer token authentication:
```typescript
headers: {
  Authorization: `Bearer ${authStore.token}`
}
```

### Endpoints
- `GET /api/admin/dashboard` - Dashboard statistics
- `GET /api/admin/users` - List users with filters
- `POST /api/admin/users` - Create user
- `PUT /api/admin/users/{id}` - Update user
- `DELETE /api/admin/users/{id}` - Delete user
- `GET /api/admin/companies` - List companies with filters
- `DELETE /api/admin/companies/{id}` - Delete company
- `GET /api/admin/jobs` - List jobs with filters
- `PUT /api/admin/jobs/{id}` - Update job
- `POST /api/admin/jobs/{id}/toggle-featured` - Toggle featured status
- `DELETE /api/admin/jobs/{id}` - Delete job
- `GET /api/admin/applications` - List applications with filters
- `PUT /api/admin/applications/{id}` - Update application
- `DELETE /api/admin/applications/{id}` - Delete application

## File Structure

```
src/
├── views/admin/
│   ├── AdminDashboard.vue          # Main dashboard
│   ├── UsersManagement.vue         # Users CRUD
│   ├── CompaniesManagement.vue     # Companies management
│   ├── JobsManagement.vue          # Jobs management
│   └── ApplicationsManagement.vue  # Applications management
├── components/
│   ├── layout/
│   │   └── AdminLayout.vue         # Sidebar layout
│   ├── admin/
│   │   ├── DataTable.vue           # Reusable table
│   │   ├── StatsCard.vue           # Statistics cards
│   │   └── ActivityChart.vue       # Line charts
│   └── base/
│       ├── BaseCard.vue            # Card wrapper
│       └── BaseModal.vue           # Modal dialogs
├── router/index.ts                 # Route definitions
└── stores/auth.ts                  # Auth state
```

## Routes

### Admin Routes (Protected)
All admin routes require authentication and `is_admin = true`:

- `/admin` - Dashboard
- `/admin/users` - Users Management
- `/admin/companies` - Companies Management
- `/admin/jobs` - Jobs Management
- `/admin/applications` - Applications Management

### Route Guards
```typescript
// In router/index.ts
{
  path: '/admin/*',
  meta: { 
    requiresAuth: true, 
    requiresAdmin: true 
  }
}
```

## Usage

### Creating an Admin User
```bash
php artisan admin:create
```

### Accessing Admin Panel
1. Login with admin credentials
2. Automatically redirected to `/admin`
3. Use sidebar navigation to access different sections

### Managing Resources

#### Users
1. Navigate to Users Management
2. Use filters to find specific users
3. Click actions to view/edit/delete
4. Create new users with "Create User" button

#### Companies
1. Navigate to Companies Management
2. Filter by industry/country
3. View company details in modal
4. Navigate to company jobs
5. Delete companies with cascade warning

#### Jobs
1. Navigate to Jobs Management
2. Filter by status/type/featured
3. Toggle featured status inline
4. Change job status via modal
5. View job applications
6. Delete jobs with confirmation

#### Applications
1. Navigate to Applications Management
2. Filter by status/date range
3. Update status inline with dropdown
4. View application details
5. Access applicant CV
6. Delete applications

## Customization

### Adding New Stats
Edit `src/views/admin/AdminDashboard.vue`:
```vue
<StatsCard
  title="New Metric"
  :value="stats?.new_metric || 0"
  icon="custom-icon"
  color="custom-color"
/>
```

### Adding New Filters
Edit management views:
```vue
<select v-model="filters.new_filter">
  <option value="">All</option>
  <option value="value1">Option 1</option>
</select>
```

### Customizing Table Columns
```typescript
const columns = [
  { key: 'field_name', label: 'Display Name', sortable: true },
  // Add more columns
]
```

### Custom Cell Templates
```vue
<template #cell-custom="{ item, value }">
  <span>{{ formatCustom(value) }}</span>
</template>
```

## Performance

### Optimizations
- Lazy-loaded routes (code splitting)
- Debounced search inputs
- Pagination limits database queries
- Loading states prevent duplicate requests
- Efficient data fetching with filters

### Best Practices
- Use pagination for large datasets
- Apply filters before loading data
- Cache API responses when appropriate
- Use skeleton loaders for better UX

## Security

### Frontend Security
- Route guards prevent unauthorized access
- Admin-only routes checked on every navigation
- Token stored in secure store
- Automatic logout on token expiration

### Backend Security
- Admin middleware validates `is_admin`
- Sanctum token authentication
- CORS configured properly
- Input validation on all endpoints

## Troubleshooting

### Issue: Not redirecting to admin panel
**Solution**: Ensure user has `is_admin = true` in database

### Issue: API returns 403 Forbidden
**Solution**: Check token validity and user admin status

### Issue: Sidebar not showing
**Solution**: Verify AdminLayout is imported correctly

### Issue: Filters not working
**Solution**: Check API endpoint supports filter parameters

## Future Enhancements

### Potential Features
- [ ] Analytics page with detailed charts
- [ ] Settings page for system configuration
- [ ] Bulk operations (delete multiple, export CSV)
- [ ] Real-time notifications
- [ ] Activity log / audit trail
- [ ] Email templates management
- [ ] System health monitoring
- [ ] Advanced search with autocomplete
- [ ] Dark mode toggle
- [ ] Custom dashboard widgets

### UI Improvements
- [ ] Drag-and-drop for reordering
- [ ] Inline editing for quick updates
- [ ] Advanced charts (bar, pie, donut)
- [ ] Export to PDF/Excel
- [ ] Print-friendly views
- [ ] Keyboard shortcuts
- [ ] Quick actions menu

## Changelog

### Version 1.0.0 (Current)
- ✅ Complete admin dashboard with statistics
- ✅ Users management (CRUD)
- ✅ Companies management with filters
- ✅ Jobs management with status controls
- ✅ Applications management with inline updates
- ✅ Professional UI with dark sidebar
- ✅ Reusable component library
- ✅ Full TypeScript support
- ✅ Responsive design
- ✅ Complete API integration

## Support

For issues or questions:
1. Check API documentation in `docs/ADMIN_API.md`
2. Review backend logs for API errors
3. Check browser console for frontend errors
4. Verify database migrations are up to date

## License

This admin panel is part of the JobsIQ project and follows the same license.

---

**Built with ❤️ for JobsIQ**
