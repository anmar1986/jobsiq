# Job Application System - Testing Guide

## ✅ Backend is Working Correctly!

The test shows:
- ✓ Database table exists with correct structure
- ✓ Application was created (ID: 2)
- ✓ Applicant: Howard Robles (User ID: 1, Type: job_seeker)
- ✓ Job: Senior PHP Full Stack Software Developer
- ✓ Company: ayad (ID: 1)
- ✓ Company Owner: ayad bahram (User ID: 3, Type: company_owner)
- ✓ API query returns the application correctly

## How to Test on Frontend

### Step 1: Make sure you're logged in as the COMPANY OWNER
- **Email**: The email for "ayad bahram" (User ID: 3)
- **User Type**: company_owner

### Step 2: Navigate to Company Applications
- Go to: `http://localhost:5173/en/company-applications`
- Or click "Applications" from the dashboard

### Step 3: You should see the application
- Applicant: Howard Robles
- Job: Senior PHP Full Stack Software Developer
- Status: Pending
- Applied: 2025-11-27 14:12

## Common Issues

### Issue 1: "No applications found"
**Cause**: You're logged in as the wrong user
**Solution**: Log out and login as the company owner (ayad bahram, User ID: 3)

### Issue 2: API returns empty array
**Cause**: The company owner user is not linked to the company
**Solution**: Check the `company_owners` table:
```sql
SELECT * FROM company_owners WHERE user_id = 3 AND company_id = 1;
```

### Issue 3: Console errors in browser
**Solution**: 
1. Open browser DevTools (F12)
2. Go to Console tab
3. Go to Network tab
4. Navigate to /company-applications
5. Check the API call to `/api/company-applications`
6. Look at the response

## Manual API Testing

### 1. Get Authentication Token
Login via API to get a token for the company owner:
```bash
curl -X POST http://localhost:8000/api/login \
  -H "Content-Type: application/json" \
  -d '{"email":"owner-email@example.com","password":"password"}'
```

### 2. Test Company Applications Endpoint
```bash
curl -X GET http://localhost:8000/api/company-applications \
  -H "Authorization: Bearer YOUR_TOKEN_HERE" \
  -H "Accept: application/json"
```

Expected Response:
```json
{
  "success": true,
  "data": {
    "current_page": 1,
    "data": [
      {
        "id": 2,
        "user_id": 1,
        "job_id": 1,
        "status": "pending",
        "applied_at": "2025-11-27T14:12:27.000000Z",
        "user": {
          "id": 1,
          "name": "Howard Robles",
          "email": "..."
        },
        "job": {
          "id": 1,
          "title": "Senior PHP Full Stack Software Developer",
          "company": {
            "id": 1,
            "name": "ayad"
          }
        }
      }
    ],
    "total": 1
  }
}
```

## Database Verification

Check if the application exists:
```sql
SELECT 
    ja.id,
    u.name as applicant,
    j.title as job,
    c.name as company,
    ja.status,
    ja.applied_at
FROM job_applications ja
JOIN users u ON ja.user_id = u.id
JOIN jobs j ON ja.job_id = j.id
JOIN companies c ON j.company_id = c.id
ORDER BY ja.applied_at DESC;
```

Check company ownership:
```sql
SELECT 
    u.id as user_id,
    u.name as owner_name,
    u.email,
    c.id as company_id,
    c.name as company_name
FROM company_owners co
JOIN users u ON co.user_id = u.id
JOIN companies c ON co.company_id = c.id;
```

## Quick Test Commands

Run these in your Laravel project:

```bash
# Check total applications
php artisan tinker --execute="echo \App\Models\JobApplication::count() . ' applications'"

# Check company owner's applications
php artisan tinker --execute="\$owner = \App\Models\User::find(3); \$ids = \$owner->ownedCompanies()->pluck('companies.id'); echo \App\Models\JobApplication::whereHas('job', fn(\$q) => \$q->whereIn('company_id', \$ids))->count() . ' applications for owner'"

# List all applications
php artisan tinker --execute="\$apps = \App\Models\JobApplication::with(['user', 'job.company'])->get(); foreach(\$apps as \$a) { echo \$a->user->name . ' -> ' . \$a->job->title . ' at ' . \$a->job->company->name . PHP_EOL; }"
```

## Frontend Debugging

Add this to your CompanyApplicationsView.vue temporarily to debug:

```typescript
onMounted(async () => {
  console.log('=== Company Applications Debug ===');
  console.log('Current User:', authStore.user);
  console.log('User Type:', authStore.user?.user_type);
  
  // Fetch companies first
  if (companyStore.myCompanies.length === 0) {
    await companyStore.fetchMyCompanies()
  }
  
  console.log('My Companies:', companyStore.myCompanies);
  console.log('Company IDs:', companyStore.myCompanies.map(c => c.id));
  
  await fetchApplications()
  
  console.log('Applications:', applications.value);
  console.log('Total:', pagination.value?.total);
  console.log('================================');
})
```

## Summary

**Your system is working correctly!** The application exists in the database and the API can retrieve it. The only thing you need to do is:

1. **Log in as the company owner** (ayad bahram, User ID: 3)
2. **Navigate to** `/en/company-applications`
3. **You should see** Howard Robles' application

If you still don't see it, check the browser console (F12) and the Network tab to see what the API is returning.
