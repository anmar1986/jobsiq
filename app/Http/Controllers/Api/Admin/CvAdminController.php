<?php

namespace App\Http\Controllers\Api\Admin;

use App\Http\Controllers\Controller;
use App\Models\UserCv;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Storage;

class CvAdminController extends Controller
{
    /**
     * Display a listing of all CVs (admin can see all).
     */
    public function index(Request $request)
    {
        $query = UserCv::with(['user', 'workExperiences', 'educationEntries', 'certifications', 'languages']);

        // Search filter
        if ($request->has('search') && $request->search) {
            $search = $request->search;
            $query->where(function ($q) use ($search) {
                $q->where('full_name', 'like', "%{$search}%")
                    ->orWhere('title', 'like', "%{$search}%")
                    ->orWhere('email', 'like', "%{$search}%");
            });
        }

        // Visibility filter
        if ($request->has('visibility') && $request->visibility) {
            if ($request->visibility === 'public') {
                $query->where('is_public', true);
            } elseif ($request->visibility === 'private') {
                $query->where('is_public', false);
            }
        }

        // Skills filter
        if ($request->has('skills') && $request->skills) {
            $query->whereJsonContains('skills', $request->skills);
        }

        // Location filter
        if ($request->has('location') && $request->location) {
            $query->where(function ($q) use ($request) {
                $q->where('city', 'like', "%{$request->location}%")
                    ->orWhere('country', 'like', "%{$request->location}%");
            });
        }

        $perPage = $request->get('per_page', 15);
        $cvs = $query->latest('updated_at')->paginate($perPage);

        // Transform the data to include JSON columns as fallback
        $cvs->getCollection()->transform(function ($cv) {
            $cvData = $cv->toArray();

            // If relationships are empty but JSON columns have data, use JSON column data
            if (empty($cvData['work_experiences']) && ! empty($cvData['work_experience'])) {
                $cvData['work_experiences'] = $cvData['work_experience'];
            }
            if (empty($cvData['education_entries']) && ! empty($cvData['education'])) {
                $cvData['education_entries'] = $cvData['education'];
            }

            return $cvData;
        });

        return response()->json([
            'success' => true,
            'data' => $cvs,
        ]);
    }

    /**
     * Display the specified CV (admin can view any CV).
     */
    public function show($identifier)
    {
        $query = UserCv::with(['user', 'workExperiences', 'educationEntries', 'certifications', 'languages']);

        // Check if identifier is numeric (ID) or string (slug)
        if (is_numeric($identifier)) {
            $cv = $query->where('id', $identifier)->first();
        } else {
            $cv = $query->where('slug', $identifier)->first();
        }

        if (! $cv) {
            return response()->json([
                'success' => false,
                'message' => 'CV not found.',
            ], 404);
        }

        // Admin can view any CV (no privacy check)
        $cvData = $cv->toArray();

        // If relationships are empty but JSON columns have data, use JSON column data
        if (empty($cvData['work_experiences']) && ! empty($cvData['work_experience'])) {
            $cvData['work_experiences'] = $cvData['work_experience'];
        }
        if (empty($cvData['education_entries']) && ! empty($cvData['education'])) {
            $cvData['education_entries'] = $cvData['education'];
        }

        return response()->json([
            'success' => true,
            'data' => $cvData,
        ]);
    }

    /**
     * Remove the specified CV (admin can delete any CV).
     */
    public function destroy($id)
    {
        $cv = UserCv::find($id);

        if (! $cv) {
            return response()->json([
                'success' => false,
                'message' => 'CV not found.',
            ], 404);
        }

        // Delete profile image if exists
        if ($cv->profile_image_path) {
            Storage::disk('public')->delete($cv->profile_image_path);
        }

        // Delete all related records (handled by cascade or model events)
        $cv->delete();

        return response()->json([
            'success' => true,
            'message' => 'CV deleted successfully',
        ]);
    }

    /**
     * Toggle CV visibility (public/private).
     */
    public function toggleVisibility($id)
    {
        $cv = UserCv::find($id);

        if (! $cv) {
            return response()->json([
                'success' => false,
                'message' => 'CV not found.',
            ], 404);
        }

        $cv->update(['is_public' => ! $cv->is_public]);

        return response()->json([
            'success' => true,
            'message' => 'CV visibility updated successfully',
            'data' => $cv,
        ]);
    }

    /**
     * Get CV statistics.
     */
    public function statistics()
    {
        $stats = [
            'total' => UserCv::count(),
            'public' => UserCv::where('is_public', true)->count(),
            'private' => UserCv::where('is_public', false)->count(),
            'primary' => UserCv::where('is_primary', true)->count(),
            'recent' => UserCv::where('created_at', '>=', now()->subDays(30))->count(),
        ];

        return response()->json([
            'success' => true,
            'data' => $stats,
        ]);
    }
}
