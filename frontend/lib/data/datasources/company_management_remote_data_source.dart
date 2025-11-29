import 'package:flutter/foundation.dart';
import 'package:dio/dio.dart';
import '../../core/network/dio_client.dart';
import '../../core/error/exceptions.dart';
import '../../core/constants/api_constants.dart';
import '../models/company_model.dart';
import '../models/job_model.dart';

abstract class CompanyManagementRemoteDataSource {
  /// Get all companies owned by the authenticated user
  Future<List<CompanyModel>> getMyCompanies();

  /// Get a single owned company by ID
  Future<CompanyModel> getMyCompany(int id);

  /// Get a single owned company by slug
  Future<CompanyModel> getMyCompanyBySlug(String slug);

  /// Create a new company
  Future<CompanyModel> createCompany(Map<String, dynamic> data);

  /// Update an existing company
  Future<CompanyModel> updateCompany(int id, Map<String, dynamic> data);

  /// Delete a company
  Future<void> deleteCompany(int id);

  /// Get all jobs for owned companies
  Future<List<JobModel>> getMyJobs({
    int? companyId,
    String? status,
    int page = 1,
    int perPage = 15,
  });

  /// Create a new job
  Future<JobModel> createJob(Map<String, dynamic> data);

  /// Update an existing job
  Future<JobModel> updateJob(int id, Map<String, dynamic> data);

  /// Delete a job
  Future<void> deleteJob(int id);
}

class CompanyManagementRemoteDataSourceImpl
    implements CompanyManagementRemoteDataSource {
  final DioClient client;

  CompanyManagementRemoteDataSourceImpl({required this.client});

  @override
  Future<List<CompanyModel>> getMyCompanies() async {
    try {
      debugPrint('🏢 Fetching my companies...');

      final response = await client.get(ApiConstants.myCompanies);

      debugPrint('🏢 Response status: ${response.statusCode}');

      if (response.statusCode == 200) {
        final data = response.data;
        if (data['success'] == true) {
          final companiesJson = data['data'] as List;
          debugPrint('🏢 Found ${companiesJson.length} companies');

          final List<CompanyModel> companies = companiesJson
              .map(
                  (json) => CompanyModel.fromJson(json as Map<String, dynamic>))
              .toList();

          return companies;
        } else {
          throw ServerException(data['message'] ?? 'Failed to fetch companies');
        }
      } else {
        throw ServerException('Server error: ${response.statusCode}');
      }
    } catch (e) {
      debugPrint('❌ Error fetching my companies: $e');
      throw ServerException('Failed to fetch companies: $e');
    }
  }

  @override
  Future<CompanyModel> getMyCompany(int id) async {
    try {
      debugPrint('🏢 Fetching company with ID: $id');

      final response = await client.get('${ApiConstants.myCompanies}/$id');

      if (response.statusCode == 200) {
        final data = response.data;
        if (data['success'] == true) {
          return CompanyModel.fromJson(data['data']);
        } else {
          throw ServerException(data['message'] ?? 'Failed to fetch company');
        }
      } else {
        throw ServerException('Server error: ${response.statusCode}');
      }
    } catch (e) {
      debugPrint('❌ Error fetching company: $e');
      throw ServerException('Failed to fetch company: $e');
    }
  }

  @override
  Future<CompanyModel> getMyCompanyBySlug(String slug) async {
    try {
      debugPrint('🏢 Fetching company with slug: $slug');

      final response =
          await client.get('${ApiConstants.myCompanies}/slug/$slug');

      if (response.statusCode == 200) {
        final data = response.data;
        if (data['success'] == true) {
          return CompanyModel.fromJson(data['data']);
        } else {
          throw ServerException(data['message'] ?? 'Failed to fetch company');
        }
      } else {
        throw ServerException('Server error: ${response.statusCode}');
      }
    } catch (e) {
      debugPrint('❌ Error fetching company: $e');
      throw ServerException('Failed to fetch company: $e');
    }
  }

  @override
  Future<CompanyModel> createCompany(Map<String, dynamic> data) async {
    try {
      debugPrint('🏢 Creating company...');

      FormData formData = FormData.fromMap(data);

      final response = await client.post(
        ApiConstants.companies,
        data: formData,
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        final responseData = response.data;
        if (responseData['success'] == true) {
          debugPrint('✅ Company created successfully');
          return CompanyModel.fromJson(responseData['data']);
        } else {
          throw ServerException(
              responseData['message'] ?? 'Failed to create company');
        }
      } else {
        throw ServerException('Server error: ${response.statusCode}');
      }
    } catch (e) {
      debugPrint('❌ Error creating company: $e');
      throw ServerException('Failed to create company: $e');
    }
  }

  @override
  Future<CompanyModel> updateCompany(int id, Map<String, dynamic> data) async {
    try {
      debugPrint('🏢 Updating company with ID: $id');

      FormData formData = FormData.fromMap(data);

      // Use POST with _method override for file uploads
      final response = await client.post(
        '${ApiConstants.companies}/$id',
        data: formData,
      );

      if (response.statusCode == 200) {
        final responseData = response.data;
        if (responseData['success'] == true) {
          debugPrint('✅ Company updated successfully');
          return CompanyModel.fromJson(responseData['data']);
        } else {
          throw ServerException(
              responseData['message'] ?? 'Failed to update company');
        }
      } else {
        throw ServerException('Server error: ${response.statusCode}');
      }
    } catch (e) {
      debugPrint('❌ Error updating company: $e');
      throw ServerException('Failed to update company: $e');
    }
  }

  @override
  Future<void> deleteCompany(int id) async {
    try {
      debugPrint('🏢 Deleting company with ID: $id');

      final response = await client.delete('${ApiConstants.companies}/$id');

      if (response.statusCode == 200) {
        final data = response.data;
        if (data['success'] == true) {
          debugPrint('✅ Company deleted successfully');
        } else {
          throw ServerException(data['message'] ?? 'Failed to delete company');
        }
      } else {
        throw ServerException('Server error: ${response.statusCode}');
      }
    } catch (e) {
      debugPrint('❌ Error deleting company: $e');
      throw ServerException('Failed to delete company: $e');
    }
  }

  @override
  Future<List<JobModel>> getMyJobs({
    int? companyId,
    String? status,
    int page = 1,
    int perPage = 15,
  }) async {
    try {
      debugPrint('💼 Fetching my jobs...');

      final queryParameters = <String, dynamic>{
        'page': page,
        'per_page': perPage,
        if (companyId != null) 'company_id': companyId,
        if (status != null) 'status': status,
      };

      final response = await client.get(
        ApiConstants.myJobs,
        queryParameters: queryParameters,
      );

      if (response.statusCode == 200) {
        final data = response.data;
        if (data['success'] == true) {
          final jobsData = data['data'];

          List<dynamic> jobsJson;
          if (jobsData is Map && jobsData.containsKey('data')) {
            jobsJson = jobsData['data'];
          } else if (jobsData is List) {
            jobsJson = jobsData;
          } else {
            throw ServerException('Unexpected response format');
          }

          debugPrint('💼 Found ${jobsJson.length} jobs');

          final List<JobModel> jobs = jobsJson
              .map((json) => JobModel.fromJson(json as Map<String, dynamic>))
              .toList();

          return jobs;
        } else {
          throw ServerException(data['message'] ?? 'Failed to fetch jobs');
        }
      } else {
        throw ServerException('Server error: ${response.statusCode}');
      }
    } catch (e) {
      debugPrint('❌ Error fetching my jobs: $e');
      throw ServerException('Failed to fetch jobs: $e');
    }
  }

  @override
  Future<JobModel> createJob(Map<String, dynamic> data) async {
    try {
      debugPrint('💼 Creating job...');

      final response = await client.post(
        ApiConstants.jobs,
        data: data,
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        final responseData = response.data;
        if (responseData['success'] == true) {
          debugPrint('✅ Job created successfully');
          return JobModel.fromJson(responseData['data']);
        } else {
          throw ServerException(
              responseData['message'] ?? 'Failed to create job');
        }
      } else {
        throw ServerException('Server error: ${response.statusCode}');
      }
    } catch (e) {
      debugPrint('❌ Error creating job: $e');
      throw ServerException('Failed to create job: $e');
    }
  }

  @override
  Future<JobModel> updateJob(int id, Map<String, dynamic> data) async {
    try {
      debugPrint('💼 Updating job with ID: $id');

      final response = await client.put(
        '${ApiConstants.jobs}/$id',
        data: data,
      );

      if (response.statusCode == 200) {
        final responseData = response.data;
        if (responseData['success'] == true) {
          debugPrint('✅ Job updated successfully');
          return JobModel.fromJson(responseData['data']);
        } else {
          throw ServerException(
              responseData['message'] ?? 'Failed to update job');
        }
      } else {
        throw ServerException('Server error: ${response.statusCode}');
      }
    } catch (e) {
      debugPrint('❌ Error updating job: $e');
      throw ServerException('Failed to update job: $e');
    }
  }

  @override
  Future<void> deleteJob(int id) async {
    try {
      debugPrint('💼 Deleting job with ID: $id');

      final response = await client.delete('${ApiConstants.jobs}/$id');

      if (response.statusCode == 200) {
        final data = response.data;
        if (data['success'] == true) {
          debugPrint('✅ Job deleted successfully');
        } else {
          throw ServerException(data['message'] ?? 'Failed to delete job');
        }
      } else {
        throw ServerException('Server error: ${response.statusCode}');
      }
    } catch (e) {
      debugPrint('❌ Error deleting job: $e');
      throw ServerException('Failed to delete job: $e');
    }
  }
}
