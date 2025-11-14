import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import '../../core/network/dio_client.dart';
import '../../core/error/exceptions.dart';
import '../../core/constants/api_constants.dart';
import '../models/job_model.dart';

abstract class JobRemoteDataSource {
  /// Get paginated list of jobs with filters
  Future<JobsResponse> getJobs({
    int page = 1,
    int perPage = 15,
    String? search,
    String? location,
    List<String>? employmentTypes,
    List<String>? experienceLevels,
    bool? isRemote,
    String? category,
    double? salaryMin,
    String? company,
    String? sort,
    int? seed,
  });

  /// Get featured jobs
  Future<List<JobModel>> getFeaturedJobs({int limit = 6});

  /// Get job by slug
  Future<JobModel> getJobBySlug(String slug);

  /// Get jobs posted by authenticated user's companies
  Future<List<JobModel>> getMyJobs();
}

class JobRemoteDataSourceImpl implements JobRemoteDataSource {
  final DioClient client;

  JobRemoteDataSourceImpl({required this.client});

  @override
  Future<JobsResponse> getJobs({
    int page = 1,
    int perPage = 15, // Reduced from 20 to avoid truncation issues
    String? search,
    String? location,
    List<String>? employmentTypes,
    List<String>? experienceLevels,
    bool? isRemote,
    String? category,
    double? salaryMin,
    String? company,
    String? sort,
    int? seed,
  }) async {
    try {
      final queryParameters = <String, dynamic>{
        'page': page,
        'per_page': perPage,
      };

      if (search != null && search.isNotEmpty) {
        queryParameters['search'] = search;
      }
      if (location != null && location.isNotEmpty) {
        queryParameters['location'] = location;
      }
      if (employmentTypes != null && employmentTypes.isNotEmpty) {
        queryParameters['employment_type'] = employmentTypes;
      }
      if (experienceLevels != null && experienceLevels.isNotEmpty) {
        queryParameters['experience_level'] = experienceLevels;
      }
      if (isRemote != null) {
        queryParameters['is_remote'] = isRemote ? 1 : 0;
      }
      if (category != null && category.isNotEmpty) {
        queryParameters['category'] = category;
      }
      if (salaryMin != null && salaryMin > 0) {
        queryParameters['salary_min'] = salaryMin;
      }
      if (company != null && company.isNotEmpty) {
        queryParameters['company'] = company;
      }
      if (sort != null && sort.isNotEmpty) {
        queryParameters['sort'] = sort;
      }
      if (seed != null) {
        queryParameters['seed'] = seed;
      }

      final response = await client.get(
        ApiConstants.jobs,
        queryParameters: queryParameters,
        options: Options(
          responseType: ResponseType.plain,
          receiveTimeout: const Duration(seconds: 45), // Increased timeout
          sendTimeout: const Duration(seconds: 30),
          // Add headers to prevent compression issues
          headers: {
            'Accept-Encoding': 'identity',
            'Accept': 'application/json',
          },
          // Increase receive data buffer
          receiveDataWhenStatusError: true,
          validateStatus: (status) => status != null && status < 500,
        ),
      );

      if (response.statusCode == 200) {
        try {
          // Parse the raw response manually
          final rawData = response.data as String;

          // Debug: Check if response is complete
          if (!rawData.endsWith('}')) {
            debugPrint(
                '⚠️ Warning: Response appears truncated. Length: ${rawData.length}');
            debugPrint(
                '⚠️ Last 200 chars: ${rawData.substring(rawData.length > 200 ? rawData.length - 200 : 0)}');

            // Try to salvage partial JSON by finding the last complete object
            final lastBraceIndex = rawData.lastIndexOf('}');
            if (lastBraceIndex > 0) {
              debugPrint(
                  '⚠️ Attempting to parse truncated JSON up to last complete brace');
              final truncatedData = rawData.substring(0, lastBraceIndex + 1);
              try {
                final data = jsonDecode(truncatedData);
                if (data['success'] == true && data['data'] != null) {
                  debugPrint('✅ Successfully parsed truncated response');
                  return JobsResponse.fromJson(data['data']);
                }
              } catch (e) {
                debugPrint('❌ Failed to parse truncated JSON: $e');
              }
            }

            throw const FormatException(
                'Response truncated - incomplete JSON received');
          }

          final data = jsonDecode(rawData);
          if (data['success'] == true) {
            return JobsResponse.fromJson(data['data']);
          } else {
            throw ServerException(data['message'] ?? 'Failed to fetch jobs');
          }
        } on FormatException catch (e) {
          debugPrint('❌ JSON Parse Error: $e');
          debugPrint('📏 Response length: ${(response.data as String).length}');
          throw ServerException(
            'Failed to parse jobs data. Try reducing results or check network connection.',
          );
        } catch (e) {
          debugPrint('❌ Error processing response: $e');
          debugPrint('📏 Response length: ${(response.data as String).length}');
          rethrow;
        }
      } else {
        throw ServerException('Server error: ${response.statusCode}');
      }
    } on ServerException {
      rethrow;
    } on NetworkException {
      rethrow;
    } catch (e, stackTrace) {
      // Log detailed error for debugging
      debugPrint('❌ Error fetching jobs: $e');
      debugPrint('📍 Stack trace: $stackTrace');
      throw ServerException('Failed to fetch jobs: $e');
    }
  }

  @override
  Future<List<JobModel>> getFeaturedJobs({int limit = 6}) async {
    try {
      final response = await client.get(
        ApiConstants.featuredJobs,
        queryParameters: {'limit': limit},
      );

      if (response.statusCode == 200) {
        final data = response.data;
        if (data['success'] == true) {
          final List<dynamic> jobsJson = data['data'];
          return jobsJson.map((json) => JobModel.fromJson(json)).toList();
        } else {
          throw ServerException(
              data['message'] ?? 'Failed to fetch featured jobs');
        }
      } else {
        throw ServerException('Server error: ${response.statusCode}');
      }
    } on ServerException {
      rethrow;
    } catch (e) {
      throw ServerException('Failed to fetch featured jobs: $e');
    }
  }

  @override
  Future<JobModel> getJobBySlug(String slug) async {
    try {
      final response = await client.get('${ApiConstants.jobs}/$slug');

      if (response.statusCode == 200) {
        final data = response.data;
        if (data['success'] == true) {
          return JobModel.fromJson(data['data']);
        } else {
          throw ServerException(data['message'] ?? 'Job not found');
        }
      } else if (response.statusCode == 404) {
        throw NotFoundException('Job not found');
      } else {
        throw ServerException('Server error: ${response.statusCode}');
      }
    } on ServerException {
      rethrow;
    } on NotFoundException {
      rethrow;
    } catch (e) {
      throw ServerException('Failed to fetch job: $e');
    }
  }

  @override
  Future<List<JobModel>> getMyJobs() async {
    try {
      final response = await client.get(ApiConstants.myJobs);

      if (response.statusCode == 200) {
        final data = response.data;
        if (data['success'] == true) {
          final List<dynamic> jobsJson = data['data'];
          return jobsJson.map((json) => JobModel.fromJson(json)).toList();
        } else {
          throw ServerException(data['message'] ?? 'Failed to fetch your jobs');
        }
      } else {
        throw ServerException('Server error: ${response.statusCode}');
      }
    } on ServerException {
      rethrow;
    } catch (e) {
      throw ServerException('Failed to fetch your jobs: $e');
    }
  }
}

/// Response model for paginated jobs
class JobsResponse {
  final List<JobModel> data;
  final int currentPage;
  final int lastPage;
  final int perPage;
  final int total;
  final int? seed;

  JobsResponse({
    required this.data,
    required this.currentPage,
    required this.lastPage,
    required this.perPage,
    required this.total,
    this.seed,
  });

  factory JobsResponse.fromJson(Map<String, dynamic> json) {
    final seedValue = json['seed'];
    int? parsedSeed;
    if (seedValue != null) {
      parsedSeed =
          seedValue is int ? seedValue : int.tryParse(seedValue.toString());
    }

    return JobsResponse(
      data: (json['data'] as List<dynamic>)
          .map((e) => JobModel.fromJson(e as Map<String, dynamic>))
          .toList(),
      currentPage: json['current_page'] as int,
      lastPage: json['last_page'] as int,
      perPage: json['per_page'] as int,
      total: json['total'] as int,
      seed: parsedSeed,
    );
  }

  bool get hasMore => currentPage < lastPage;
}
