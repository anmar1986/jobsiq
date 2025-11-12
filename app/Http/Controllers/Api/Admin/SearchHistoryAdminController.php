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
        $query = SearchHistory::with('user:id,name,email')
            ->latest();

        // Filter by user
        if ($request->has('user_id')) {
            $query->where('user_id', $request->user_id);
        }

        // Filter by search query
        if ($request->has('search')) {
            $query->where('search_query', 'like', '%'.$request->search.'%');
        }

        // Filter by date range
        if ($request->has('from_date')) {
            $query->whereDate('created_at', '>=', $request->from_date);
        }

        if ($request->has('to_date')) {
            $query->whereDate('created_at', '<=', $request->to_date);
        }

        // Filter by location
        if ($request->has('location')) {
            $query->where('location', 'like', '%'.$request->location.'%');
        }

        $perPage = $request->get('per_page', 15);
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
        $query = SearchHistory::query();

        // Apply filters if provided
        if ($request->has('user_id')) {
            $query->where('user_id', $request->user_id);
        }

        if ($request->has('before_date')) {
            $query->whereDate('created_at', '<', $request->before_date);
        }

        $deleted = $query->delete();

        return response()->json([
            'success' => true,
            'message' => "Deleted {$deleted} search history entries",
            'count' => $deleted,
        ]);
    }
}
