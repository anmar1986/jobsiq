import 'package:flutter/foundation.dart';
import '../../core/network/dio_client.dart';
import '../../core/error/exceptions.dart';
import '../../core/constants/api_constants.dart';

abstract class JobApplicationRemoteDataSource {
  /// Apply for a job
  Future<void> applyForJob(String jobSlug, int? cvId, String? coverLetter);

  /// Check if user has already applied for a job
  Future<bool> checkIfApplied(String jobSlug);

  /// Get user's job applications
  Future<Map<String, dynamic>> getMyApplications(
      {String? status, String? search});
}

class JobApplicationRemoteDataSourceImpl
    implements JobApplicationRemoteDataSource {
  final DioClient client;

  JobApplicationRemoteDataSourceImpl({required this.client});

  @override
  Future<void> applyForJob(
      String jobSlug, int? cvId, String? coverLetter) async {
    try {
      final data = <String, dynamic>{};

      if (cvId != null) {
        data['cv_id'] = cvId;
      }

      if (coverLetter != null && coverLetter.isNotEmpty) {
        data['cover_letter'] = coverLetter;
      }

      final response = await client.post(
        '${ApiConstants.jobs}/$jobSlug/apply',
        data: data,
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        final responseData = response.data;
        if (responseData['success'] != true) {
          throw ServerException(
              responseData['message'] ?? 'Failed to apply for job');
        }
      } else {
        throw ServerException('Server error: ${response.statusCode}');
      }
    } on ServerException {
      rethrow;
    } on NetworkException {
      rethrow;
    } catch (e) {
      debugPrint('❌ Error applying for job: $e');
      throw ServerException('Failed to apply for job: $e');
    }
  }

  @override
  Future<bool> checkIfApplied(String jobSlug) async {
    try {
      final response = await client.get(
        '${ApiConstants.jobs}/$jobSlug/check-application',
      );

      if (response.statusCode == 200) {
        final data = response.data;
        if (data['success'] == true) {
          return data['data']['has_applied'] ?? false;
        } else {
          return false;
        }
      } else {
        return false;
      }
    } catch (e) {
      // If there's an error checking, assume not applied
      return false;
    }
  }

  @override
  Future<Map<String, dynamic>> getMyApplications(
      {String? status, String? search}) async {
    try {
      final queryParams = <String, dynamic>{};

      if (status != null && status.isNotEmpty) {
        queryParams['status'] = status;
      }

      if (search != null && search.isNotEmpty) {
        queryParams['search'] = search;
      }

      final response = await client.get(
        ApiConstants.myApplications,
        queryParameters: queryParams,
      );

      if (response.statusCode == 200) {
        final data = response.data;
        if (data['success'] == true) {
          return data['data'];
        } else {
          throw ServerException(
              data['message'] ?? 'Failed to fetch applications');
        }
      } else {
        throw ServerException('Server error: ${response.statusCode}');
      }
    } on ServerException {
      rethrow;
    } on NetworkException {
      rethrow;
    } catch (e) {
      debugPrint('❌ Error fetching applications: $e');
      throw ServerException('Failed to fetch applications: $e');
    }
  }
}
