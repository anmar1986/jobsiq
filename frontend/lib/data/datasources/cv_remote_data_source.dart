import 'package:flutter/foundation.dart';
import '../../core/network/dio_client.dart';
import '../../core/error/exceptions.dart';
import '../../core/constants/api_constants.dart';
import '../models/cv_model.dart';

abstract class CvRemoteDataSource {
  /// Get all CVs for the authenticated user
  Future<List<CvModel>> getMyCvs();

  /// Create a new CV
  Future<CvModel> createCv(Map<String, dynamic> cvData);

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

      final response = await client.post(
        ApiConstants.myCvs,
        data: cvData,
      );

      debugPrint('📝 Create response status: ${response.statusCode}');
      debugPrint('📝 Create response data: ${response.data}');

      if (response.statusCode == 200 || response.statusCode == 201) {
        final data = response.data;
        if (data['success'] == true) {
          debugPrint('✅ CV created successfully');
          return CvModel.fromJson(data['data']);
        } else {
          throw ServerException(data['message'] ?? 'Failed to create CV');
        }
      } else {
        throw ServerException('Server error: ${response.statusCode}');
      }
    } catch (e) {
      debugPrint('❌ Error creating CV: $e');
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
}
