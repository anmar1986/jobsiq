<?php

namespace App\Http\Controllers\Api;

use App\Http\Controllers\Controller;
use App\Models\Blog;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Auth;
use Illuminate\Support\Facades\Log;

class BlogController extends Controller
{
    /**
     * Display a listing of all blogs (for development - showing all blogs).
     */
    public function index(Request $request)
    {
        // TEMPORARY: Show all blogs to debug
        $query = Blog::with('user:id,name')->latest();

        // Filter by category
        if ($request->has('category')) {
            $query->where('category', $request->category);
        }

        // Search
        if ($request->has('search')) {
            $search = $request->search;
            $query->where(function ($q) use ($search) {
                $q->where('title', 'like', "%{$search}%")
                    ->orWhere('excerpt', 'like', "%{$search}%")
                    ->orWhere('content', 'like', "%{$search}%");
            });
        }

        $blogs = $query->paginate(12);

        return response()->json($blogs);
    }

    /**
     * Display the specified blog by slug.
     */
    public function show(string $slug)
    {
        $query = Blog::with('user:id,name')->where('slug', $slug);

        // Allow viewing own drafts if authenticated
        if (Auth::check()) {
            $userId = Auth::id();
            $query->where(function ($q) use ($userId) {
                $q->where('status', 'published')
                    ->whereNotNull('published_at')
                    ->where('published_at', '<=', now())
                    ->orWhere('user_id', $userId);
            });
        } else {
            // For guests, only show published blogs
            $query->published();
        }

        $blog = $query->firstOrFail();

        // Increment views only for published blogs
        if ($blog->status === 'published') {
            $blog->incrementViews();
        }

        return response()->json($blog);
    }

    /**
     * Store a newly created blog (admin/authenticated users).
     */
    public function store(Request $request)
    {
        $validated = $request->validate([
            'title' => 'required|string|max:255',
            'excerpt' => 'nullable|string',
            'content' => 'required|string',
            'featured_image' => 'nullable|string',
            'category' => 'nullable|string|max:100',
            'tags' => 'nullable|array',
            'status' => 'required|in:draft,published',
            'published_at' => 'nullable|date',
        ]);

        $validated['user_id'] = Auth::id() ?? 1; // Default to user ID 1 if not authenticated

        if ($validated['status'] === 'published' && empty($validated['published_at'])) {
            $validated['published_at'] = now();
        }

        $blog = Blog::create($validated);

        return response()->json($blog, 201);
    }

    /**
     * Update the specified blog.
     */
    public function update(Request $request, string $id)
    {
        $blog = Blog::findOrFail($id);

        // Authorization check - allow if authenticated and owns the blog, or if not authenticated
        if (Auth::check() && $blog->user_id !== Auth::id()) {
            return response()->json(['message' => 'Unauthorized'], 403);
        }

        $validated = $request->validate([
            'title' => 'sometimes|string|max:255',
            'excerpt' => 'nullable|string',
            'content' => 'sometimes|string',
            'featured_image' => 'nullable|string',
            'category' => 'nullable|string|max:100',
            'tags' => 'nullable|array',
            'status' => 'sometimes|in:draft,published',
            'published_at' => 'nullable|date',
        ]);

        if (isset($validated['status']) && $validated['status'] === 'published' && empty($validated['published_at'])) {
            $validated['published_at'] = now();
        }

        $blog->update($validated);

        return response()->json($blog);
    }

    /**
     * Remove the specified blog.
     */
    public function destroy(string $id)
    {
        $blog = Blog::findOrFail($id);

        // Authorization check - allow if authenticated and owns the blog, or if not authenticated
        if (Auth::check() && $blog->user_id !== Auth::id()) {
            return response()->json(['message' => 'Unauthorized'], 403);
        }

        $blog->delete();

        return response()->json(['message' => 'Blog deleted successfully']);
    }

    /**
     * Get blog categories.
     */
    public function categories()
    {
        $categories = Blog::published()
            ->distinct()
            ->pluck('category')
            ->filter()
            ->values();

        return response()->json($categories);
    }

    /**
     * Get featured/popular blogs.
     */
    public function featured()
    {
        $blogs = Blog::with('user:id,name')
            ->published()
            ->orderBy('views', 'desc')
            ->take(6)
            ->get();

        return response()->json($blogs);
    }

    /**
     * Upload blog image.
     */
    public function uploadImage(Request $request)
    {
        $request->validate([
            'image' => 'required|image|mimes:jpeg,png,jpg,gif|max:5120', // 5MB max
        ]);

        if ($request->hasFile('image')) {
            $image = $request->file('image');
            $path = $image->store('blogs', 'public');

            return response()->json([
                'path' => $path,
                'url' => asset('storage/' . $path),
            ]);
        }

        return response()->json(['message' => 'No image uploaded'], 400);
    }
}
