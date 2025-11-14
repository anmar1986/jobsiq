import 'package:flutter/foundation.dart';
import '../../core/network/dio_client.dart';
import '../../core/error/exceptions.dart';
import '../../core/constants/api_constants.dart';
import '../models/job_model.dart';

abstract class SavedJobRemoteDataSource {
  /// Get all saved jobs
  Future<List<JobModel>> getSavedJobs();

  /// Toggle save/unsave a job
  Future<bool> toggleSaveJob(int jobId);

  /// Check if a job is saved
  Future<bool> checkIfJobSaved(int jobId);
}

class SavedJobRemoteDataSourceImpl implements SavedJobRemoteDataSource {
  final DioClient client;

  SavedJobRemoteDataSourceImpl({required this.client});

  @override
  Future<List<JobModel>> getSavedJobs() async {
    try {
      final response = await client.get(ApiConstants.savedJobs);

      if (response.statusCode == 200) {
        final data = response.data;
        if (data['success'] == true) {
          final List<dynamic> jobsJson = data['data'];
          return jobsJson.map((json) => JobModel.fromJson(json)).toList();
        } else {
          throw ServerException(
              data['message'] ?? 'Failed to fetch saved jobs');
        }
      } else {
        throw ServerException('Server error: ${response.statusCode}');
      }
    } catch (e) {
      debugPrint('❌ Error fetching saved jobs: $e');
      throw ServerException('Failed to fetch saved jobs: $e');
    }
  }

  @override
  Future<bool> toggleSaveJob(int jobId) async {
    try {
      // First check if the job is already saved
      final isSaved = await checkIfJobSaved(jobId);

      if (isSaved) {
        // Unsave the job
        final response =
            await client.delete('${ApiConstants.jobs}/$jobId/save');

        if (response.statusCode == 200) {
          final data = response.data;
          debugPrint('✅ Unsave response: $data');
          if (data['success'] == true) {
            return false; // Job is now unsaved
          } else {
            throw ServerException(data['message'] ?? 'Failed to unsave job');
          }
        } else {
          throw ServerException('Server error: ${response.statusCode}');
        }
      } else {
        // Save the job
        debugPrint('💾 Saving job $jobId...');
        final response = await client.post('${ApiConstants.jobs}/$jobId/save');

        debugPrint('💾 Save response status: ${response.statusCode}');
        debugPrint('💾 Save response data: ${response.data}');

        if (response.statusCode == 200 || response.statusCode == 201) {
          final data = response.data;
          if (data['success'] == true) {
            debugPrint('✅ Job $jobId saved successfully!');
            return true; // Job is now saved
          } else {
            // Check if it's already saved
            if (data['message'] != null &&
                data['message'].toString().contains('already saved')) {
              debugPrint('ℹ️ Job was already saved');
              return true; // Already saved, return true
            }
            throw ServerException(data['message'] ?? 'Failed to save job');
          }
        } else {
          throw ServerException('Server error: ${response.statusCode}');
        }
      }
    } on ServerException {
      rethrow;
    } on NetworkException {
      rethrow;
    } catch (e) {
      debugPrint('❌ Error toggling save job: $e');
      throw ServerException('Failed to toggle save job: $e');
    }
  }

  @override
  Future<bool> checkIfJobSaved(int jobId) async {
    try {
      debugPrint('🔍 Checking if job $jobId is saved...');
      final response = await client.get('${ApiConstants.jobs}/$jobId/saved');

      debugPrint('🔍 Check response status: ${response.statusCode}');
      debugPrint('🔍 Check response data: ${response.data}');

      if (response.statusCode == 200) {
        final data = response.data;
        if (data['success'] == true) {
          final isSaved = data['data']['is_saved'] ?? false;
          debugPrint('🔍 Job $jobId is saved: $isSaved');
          return isSaved;
        } else {
          debugPrint('🔍 Job $jobId check failed: success=false');
          return false;
        }
      } else {
        debugPrint('🔍 Job $jobId check failed: status ${response.statusCode}');
        return false;
      }
    } catch (e) {
      // If there's an error checking (like 401), assume it's not saved
      debugPrint('🔍 Error checking if job $jobId is saved: $e');
      return false;
    }
  }
}
