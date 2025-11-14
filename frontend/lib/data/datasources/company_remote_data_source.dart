import 'package:flutter/foundation.dart';
import '../../core/network/dio_client.dart';
import '../../core/error/exceptions.dart';
import '../../core/constants/api_constants.dart';
import '../models/company_model.dart';

abstract class CompanyRemoteDataSource {
  /// Get all companies with optional filters
  Future<List<CompanyModel>> getCompanies({
    String? search,
    String? city,
    String? country,
    String? sort,
    int page = 1,
    int perPage = 15,
  });

  /// Get a single company by slug
  Future<CompanyModel> getCompanyBySlug(String slug);
}

class CompanyRemoteDataSourceImpl implements CompanyRemoteDataSource {
  final DioClient client;

  CompanyRemoteDataSourceImpl({required this.client});

  @override
  Future<List<CompanyModel>> getCompanies({
    String? search,
    String? city,
    String? country,
    String? sort,
    int page = 1,
    int perPage = 15,
  }) async {
    try {
      debugPrint('🏢 Fetching companies...');

      final queryParameters = <String, dynamic>{
        'page': page,
        'per_page': perPage,
        if (search != null && search.isNotEmpty) 'search': search,
        if (city != null && city.isNotEmpty) 'city': city,
        if (country != null && country.isNotEmpty) 'country': country,
        if (sort != null && sort.isNotEmpty) 'sort': sort,
      };

      debugPrint('🏢 Query parameters: $queryParameters');

      final response = await client.get(
        ApiConstants.companies,
        queryParameters: queryParameters,
      );

      debugPrint('🏢 Response status: ${response.statusCode}');
      debugPrint('🏢 Response data: ${response.data}');

      if (response.statusCode == 200) {
        final data = response.data;
        if (data['success'] == true) {
          // Handle pagination
          final companiesData = data['data'];

          List<dynamic> companiesJson;
          if (companiesData is Map && companiesData.containsKey('data')) {
            // Paginated response
            companiesJson = companiesData['data'];
          } else if (companiesData is List) {
            // Direct list response
            companiesJson = companiesData;
          } else {
            throw ServerException('Unexpected response format');
          }

          debugPrint('🏢 Found ${companiesJson.length} companies');

          final List<CompanyModel> companies = [];
          for (int i = 0; i < companiesJson.length; i++) {
            try {
              debugPrint('🏢 Parsing company ${i + 1}/${companiesJson.length}');
              final company = CompanyModel.fromJson(companiesJson[i] as Map<String, dynamic>);
              companies.add(company);
              debugPrint('✅ Successfully parsed company ${i + 1}');
            } catch (e, stackTrace) {
              debugPrint('❌ Error parsing company ${i + 1}: $e');
              debugPrint('🏢 Company JSON: ${companiesJson[i]}');
              debugPrint('🏢 Stack trace: $stackTrace');
            }
          }

          return companies;
        } else {
          throw ServerException(data['message'] ?? 'Failed to fetch companies');
        }
      } else {
        throw ServerException('Server error: ${response.statusCode}');
      }
    } catch (e) {
      debugPrint('❌ Error fetching companies: $e');
      throw ServerException('Failed to fetch companies: $e');
    }
  }

  @override
  Future<CompanyModel> getCompanyBySlug(String slug) async {
    try {
      debugPrint('🏢 Fetching company with slug: $slug');

      final response = await client.get('${ApiConstants.companies}/$slug');

      debugPrint('🏢 Response status: ${response.statusCode}');
      debugPrint('🏢 Response data: ${response.data}');

      if (response.statusCode == 200) {
        final data = response.data;
        if (data['success'] == true) {
          debugPrint('✅ Company fetched successfully');
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
}
