import 'dart:io';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import '../../core/network/dio_client.dart';
import '../../core/error/exceptions.dart';
import '../../core/constants/api_constants.dart';
import '../models/cv_model.dart';

abstract class CvRemoteDataSource {
  /// Get all CVs for the authenticated user
  Future<List<CvModel>> getMyCvs();

  /// Get a single CV by ID
  Future<CvModel> getCvById(int cvId);

  /// Create a new CV
  Future<CvModel> createCv(Map<String, dynamic> cvData);

  /// Update an existing CV
  Future<CvModel> updateCv(int cvId, Map<String, dynamic> cvData);

  /// Delete a CV
  Future<void> deleteCv(int cvId);

  /// Set a CV as primary
  Future<void> setPrimaryCv(int cvId);
}

class CvRemoteDataSourceImpl implements CvRemoteDataSource {
  final DioClient client;

  CvRemoteDataSourceImpl({required this.client});

  @override
  Future<List<CvModel>> getMyCvs() async {
    try {
      debugPrint('📄 Fetching user CVs...');
      final response = await client.get(ApiConstants.myCvs);

      debugPrint('📄 Response status: ${response.statusCode}');
      debugPrint('📄 Response data: ${response.data}');

      if (response.statusCode == 200) {
        final data = response.data;
        if (data['success'] == true) {
          final List<dynamic> cvsJson = data['data'];
          debugPrint('📄 Found ${cvsJson.length} CVs');

          final List<CvModel> cvs = [];
          for (int i = 0; i < cvsJson.length; i++) {
            try {
              debugPrint('📄 Parsing CV ${i + 1}/${cvsJson.length}');
              final cv = CvModel.fromJson(cvsJson[i] as Map<String, dynamic>);
              cvs.add(cv);
              debugPrint('✅ Successfully parsed CV ${i + 1}');
            } catch (e, stackTrace) {
              debugPrint('❌ Error parsing CV ${i + 1}: $e');
              debugPrint('📄 CV JSON: ${cvsJson[i]}');
              debugPrint('📄 Stack trace: $stackTrace');
              // Skip this CV and continue with others
            }
          }

          return cvs;
        } else {
          throw ServerException(data['message'] ?? 'Failed to fetch CVs');
        }
      } else {
        throw ServerException('Server error: ${response.statusCode}');
      }
    } catch (e) {
      debugPrint('❌ Error fetching CVs: $e');
      throw ServerException('Failed to fetch CVs: $e');
    }
  }

  @override
  Future<CvModel> createCv(Map<String, dynamic> cvData) async {
    try {
      debugPrint('📝 Creating new CV...');
      debugPrint('📝 CV Data: $cvData');

      // Prepare FormData for file upload
      final formData = await _prepareFormData(cvData);

      final response = await client.post(
        ApiConstants.myCvs,
        data: formData,
      );

      debugPrint('📝 Create response status: ${response.statusCode}');
      debugPrint('📝 Create response data: ${response.data}');

      if (response.statusCode == 200 || response.statusCode == 201) {
        final data = response.data;
        if (data['success'] == true) {
          debugPrint('✅ CV created successfully');
          return CvModel.fromJson(data['data']);
        } else {
          final errorMsg = data['message'] ?? 'Failed to create CV';
          debugPrint('❌ Server returned error: $errorMsg');
          throw ServerException(errorMsg);
        }
      } else {
        debugPrint('❌ Server status error: ${response.statusCode}');
        throw ServerException('Server error: ${response.statusCode}');
      }
    } on ServerException {
      rethrow;
    } on DioException catch (e) {
      debugPrint('❌ DioException: ${e.message}');
      debugPrint('❌ Response: ${e.response?.data}');

      if (e.response?.data != null && e.response!.data is Map) {
        final errorData = e.response!.data as Map<String, dynamic>;
        final errorMessage =
            errorData['message'] ?? errorData['error'] ?? 'Failed to create CV';
        throw ServerException(errorMessage);
      }
      throw ServerException('Network error: ${e.message}');
    } catch (e) {
      debugPrint('❌ Unexpected error creating CV: $e');
      throw ServerException('Failed to create CV: $e');
    }
  }

  @override
  Future<void> deleteCv(int cvId) async {
    try {
      debugPrint('🗑️ Deleting CV $cvId...');
      final response = await client.delete('${ApiConstants.myCvs}/$cvId');

      debugPrint('🗑️ Delete response status: ${response.statusCode}');
      debugPrint('🗑️ Delete response data: ${response.data}');

      if (response.statusCode == 200) {
        final data = response.data;
        if (data['success'] == true) {
          debugPrint('✅ CV $cvId deleted successfully');
        } else {
          throw ServerException(data['message'] ?? 'Failed to delete CV');
        }
      } else {
        throw ServerException('Server error: ${response.statusCode}');
      }
    } catch (e) {
      debugPrint('❌ Error deleting CV: $e');
      throw ServerException('Failed to delete CV: $e');
    }
  }

  @override
  Future<void> setPrimaryCv(int cvId) async {
    try {
      debugPrint('⭐ Setting CV $cvId as primary...');
      final response = await client.post('${ApiConstants.myCvs}/$cvId/primary');

      debugPrint('⭐ Primary response status: ${response.statusCode}');
      debugPrint('⭐ Primary response data: ${response.data}');

      if (response.statusCode == 200) {
        final data = response.data;
        if (data['success'] == true) {
          debugPrint('✅ CV $cvId set as primary successfully');
        } else {
          throw ServerException(
              data['message'] ?? 'Failed to set CV as primary');
        }
      } else {
        throw ServerException('Server error: ${response.statusCode}');
      }
    } catch (e) {
      debugPrint('❌ Error setting CV as primary: $e');
      throw ServerException('Failed to set CV as primary: $e');
    }
  }

  @override
  Future<CvModel> getCvById(int cvId) async {
    try {
      debugPrint('📄 Fetching CV $cvId...');
      final response = await client.get('${ApiConstants.myCvs}/$cvId');

      debugPrint('📄 Response status: ${response.statusCode}');
      debugPrint('📄 Response data: ${response.data}');

      if (response.statusCode == 200) {
        final data = response.data;
        if (data['success'] == true) {
          debugPrint('✅ CV fetched successfully');
          return CvModel.fromJson(data['data']);
        } else {
          throw ServerException(data['message'] ?? 'Failed to fetch CV');
        }
      } else {
        throw ServerException('Server error: ${response.statusCode}');
      }
    } catch (e) {
      debugPrint('❌ Error fetching CV: $e');
      throw ServerException('Failed to fetch CV: $e');
    }
  }

  @override
  Future<CvModel> updateCv(int cvId, Map<String, dynamic> cvData) async {
    try {
      debugPrint('✏️ Updating CV $cvId...');
      debugPrint('✏️ CV Data: $cvData');

      // Prepare FormData for file upload
      final formData = await _prepareFormData(cvData);

      final response = await client.post(
        '${ApiConstants.myCvs}/$cvId',
        data: formData,
      );

      debugPrint('✏️ Update response status: ${response.statusCode}');
      debugPrint('✏️ Update response data: ${response.data}');

      if (response.statusCode == 200) {
        final data = response.data;
        if (data['success'] == true) {
          debugPrint('✅ CV updated successfully');
          return CvModel.fromJson(data['data']);
        } else {
          throw ServerException(data['message'] ?? 'Failed to update CV');
        }
      } else {
        throw ServerException('Server error: ${response.statusCode}');
      }
    } catch (e) {
      debugPrint('❌ Error updating CV: $e');
      throw ServerException('Failed to update CV: $e');
    }
  }

  /// Helper method to prepare FormData for CV creation/update
  Future<FormData> _prepareFormData(Map<String, dynamic> cvData) async {
    final Map<String, dynamic> fields = {};

    // Handle profile image if present
    if (cvData['profileImage'] != null && cvData['profileImage'] is File) {
      final File imageFile = cvData['profileImage'];
      fields['profile_image'] = await MultipartFile.fromFile(
        imageFile.path,
        filename: 'profile_${DateTime.now().millisecondsSinceEpoch}.jpg',
      );
      debugPrint('📸 Profile image added to FormData');
    }

    // Add all other fields (excluding profileImage)
    cvData.forEach((key, value) {
      if (key != 'profileImage' && value != null) {
        // Convert lists and maps to JSON strings
        if (value is List || value is Map) {
          fields[key] = value;
        } else {
          fields[key] = value;
        }
      }
    });

    return FormData.fromMap(fields);
  }
}
