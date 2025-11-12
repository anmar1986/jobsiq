<?php

namespace App\Http\Controllers\Api\Admin;

use App\Http\Controllers\Controller;
use App\Models\SearchHistory;
use Illuminate\Http\JsonResponse;
use Illuminate\Http\Request;

class SearchHistoryAdminController extends Controller
{
    /**
     * Get all search history with pagination and filters.
     */
    public function index(Request $request): JsonResponse
    {
        // Validate request parameters
        $validated = $request->validate([
            'user_id' => ['sometimes', 'integer', 'exists:users,id'],
            'per_page' => ['sometimes', 'integer', 'min:1', 'max:100'],
            'from_date' => ['sometimes', 'date'],
            'to_date' => ['sometimes', 'date'],
            'search' => ['sometimes', 'string', 'max:255'],
            'location' => ['sometimes', 'string', 'max:255'],
        ]);

        $query = SearchHistory::with('user:id,name,email')
            ->latest();

        // Filter by user
        if (isset($validated['user_id'])) {
            $query->where('user_id', $validated['user_id']);
        }

        // Filter by search query
        if (isset($validated['search'])) {
            $query->where('search_query', 'like', $validated['search'].'%');
        }

        // Filter by date range
        if (isset($validated['from_date'])) {
            $query->whereDate('created_at', '>=', $validated['from_date']);
        }

        if (isset($validated['to_date'])) {
            $query->whereDate('created_at', '<=', $validated['to_date']);
        }

        // Filter by location
        if (isset($validated['location'])) {
            $query->where('location', 'like', $validated['location'].'%');
        }

        $perPage = $validated['per_page'] ?? 15;
        $searches = $query->paginate($perPage);

        return response()->json([
            'success' => true,
            'data' => $searches->items(),
            'current_page' => $searches->currentPage(),
            'last_page' => $searches->lastPage(),
            'per_page' => $searches->perPage(),
            'total' => $searches->total(),
            'from' => $searches->firstItem(),
            'to' => $searches->lastItem(),
        ]);
    }

    /**
     * Get search history statistics.
     */
    public function statistics(): JsonResponse
    {
        $stats = [
            'total_searches' => SearchHistory::count(),
            'unique_users' => SearchHistory::distinct('user_id')->whereNotNull('user_id')->count(),
            'guest_searches' => SearchHistory::whereNull('user_id')->count(),
            'today_searches' => SearchHistory::whereDate('created_at', today())->count(),
            'this_week_searches' => SearchHistory::whereBetween('created_at', [
                now()->startOfWeek(),
                now()->endOfWeek(),
            ])->count(),
            'this_month_searches' => SearchHistory::whereYear('created_at', now()->year)
                ->whereMonth('created_at', now()->month)
                ->count(),
            'top_searches' => SearchHistory::select('search_query')
                ->whereNotNull('search_query')
                ->groupBy('search_query')
                ->selectRaw('count(*) as count')
                ->orderByDesc('count')
                ->limit(10)
                ->get(),
            'top_locations' => SearchHistory::select('location')
                ->whereNotNull('location')
                ->groupBy('location')
                ->selectRaw('count(*) as count')
                ->orderByDesc('count')
                ->limit(10)
                ->get(),
        ];

        return response()->json([
            'success' => true,
            'data' => $stats,
        ]);
    }

    /**
     * Delete search history entry.
     */
    public function destroy(SearchHistory $searchHistory): JsonResponse
    {
        $searchHistory->delete();

        return response()->json([
            'success' => true,
            'message' => 'Search history entry deleted successfully',
        ]);
    }

    /**
     * Clear all search history (with optional filters).
     */
    public function clear(Request $request): JsonResponse
    {
        // Validate input
        $validated = $request->validate([
            'user_id' => ['sometimes', 'integer', 'exists:users,id'],
            'before_date' => ['sometimes', 'date'],
        ]);

        $query = SearchHistory::query();

        // Apply filters if provided
        if (isset($validated['user_id'])) {
            $query->where('user_id', $validated['user_id']);
        }

        if (isset($validated['before_date'])) {
            $query->whereDate('created_at', '<', $validated['before_date']);
        }

        $deleted = $query->delete();

        return response()->json([
            'success' => true,
            'message' => "Deleted {$deleted} search history entries",
            'count' => $deleted,
        ]);
    }
}
