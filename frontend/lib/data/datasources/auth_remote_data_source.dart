import 'package:dio/dio.dart';
import '../../core/constants/api_constants.dart';
import '../../core/error/exceptions.dart';
import '../../core/network/dio_client.dart';
import '../models/auth_response_model.dart';
import '../models/user_model.dart';

abstract class AuthRemoteDataSource {
  Future<AuthResponseModel> login({
    required String email,
    required String password,
  });

  Future<AuthResponseModel> register({
    required String name,
    required String email,
    required String password,
    required String passwordConfirmation,
    required String userType,
    String? companyName,
    String? companyEmail,
  });

  Future<void> logout();

  Future<void> logoutAll();

  Future<UserModel> getCurrentUser();

  Future<UserModel> updateProfile({
    String? name,
    String? email,
    String? profilePhoto,
    String? headline,
    String? gender,
    String? dateOfBirth,
    String? nationality,
    String? city,
    String? country,
    String? address,
    String? phoneNumber,
    String? linkedinUrl,
  });

  Future<void> changePassword({
    required String currentPassword,
    required String password,
    required String passwordConfirmation,
  });
}

class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  final DioClient client;

  AuthRemoteDataSourceImpl({required this.client});

  @override
  Future<AuthResponseModel> login({
    required String email,
    required String password,
  }) async {
    try {
      final response = await client.post(
        ApiConstants.login,
        data: {
          'email': email,
          'password': password,
        },
      );

      if (response.statusCode == 200) {
        return AuthResponseModel.fromJson(response.data);
      } else {
        throw ServerException(
          response.data['message'] ?? 'Login failed',
          statusCode: response.statusCode,
        );
      }
    } on DioException catch (e) {
      throw _handleDioException(e);
    }
  }

  @override
  Future<AuthResponseModel> register({
    required String name,
    required String email,
    required String password,
    required String passwordConfirmation,
    required String userType,
    String? companyName,
    String? companyEmail,
  }) async {
    try {
      final data = {
        'name': name,
        'email': email,
        'password': password,
        'password_confirmation': passwordConfirmation,
        'user_type': userType,
      };

      if (companyName != null) data['company_name'] = companyName;
      if (companyEmail != null) data['company_email'] = companyEmail;

      final response = await client.post(
        ApiConstants.register,
        data: data,
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        return AuthResponseModel.fromJson(response.data);
      } else {
        throw ServerException(
          response.data['message'] ?? 'Registration failed',
          statusCode: response.statusCode,
        );
      }
    } on DioException catch (e) {
      throw _handleDioException(e);
    }
  }

  @override
  Future<void> logout() async {
    try {
      final response = await client.post(ApiConstants.logout);

      if (response.statusCode != 200) {
        throw ServerException(
          response.data['message'] ?? 'Logout failed',
          statusCode: response.statusCode,
        );
      }
    } on DioException catch (e) {
      throw _handleDioException(e);
    }
  }

  @override
  Future<void> logoutAll() async {
    try {
      final response = await client.post(ApiConstants.logoutAll);

      if (response.statusCode != 200) {
        throw ServerException(
          response.data['message'] ?? 'Logout all failed',
          statusCode: response.statusCode,
        );
      }
    } on DioException catch (e) {
      throw _handleDioException(e);
    }
  }

  @override
  Future<UserModel> getCurrentUser() async {
    try {
      final response = await client.get(ApiConstants.user);

      if (response.statusCode == 200) {
        return UserModel.fromJson(response.data['data']);
      } else {
        throw ServerException(
          response.data['message'] ?? 'Failed to get user',
          statusCode: response.statusCode,
        );
      }
    } on DioException catch (e) {
      throw _handleDioException(e);
    }
  }

  @override
  Future<UserModel> updateProfile({
    String? name,
    String? email,
    String? profilePhoto,
    String? headline,
    String? gender,
    String? dateOfBirth,
    String? nationality,
    String? city,
    String? country,
    String? address,
    String? phoneNumber,
    String? linkedinUrl,
  }) async {
    try {
      final data = <String, dynamic>{};
      if (name != null) data['name'] = name;
      if (email != null) data['email'] = email;
      if (profilePhoto != null) data['profile_photo'] = profilePhoto;
      if (headline != null) data['headline'] = headline;
      if (gender != null) data['gender'] = gender;
      if (dateOfBirth != null) data['date_of_birth'] = dateOfBirth;
      if (nationality != null) data['nationality'] = nationality;
      if (city != null) data['city'] = city;
      if (country != null) data['country'] = country;
      if (address != null) data['address'] = address;
      if (phoneNumber != null) data['phone_number'] = phoneNumber;
      if (linkedinUrl != null) data['linkedin_url'] = linkedinUrl;

      final response = await client.put(
        ApiConstants.profile,
        data: data,
      );

      if (response.statusCode == 200) {
        return UserModel.fromJson(response.data['data']);
      } else {
        throw ServerException(
          response.data['message'] ?? 'Failed to update profile',
          statusCode: response.statusCode,
        );
      }
    } on DioException catch (e) {
      throw _handleDioException(e);
    }
  }

  @override
  Future<void> changePassword({
    required String currentPassword,
    required String password,
    required String passwordConfirmation,
  }) async {
    try {
      final response = await client.put(
        ApiConstants.changePassword,
        data: {
          'current_password': currentPassword,
          'password': password,
          'password_confirmation': passwordConfirmation,
        },
      );

      if (response.statusCode != 200) {
        throw ServerException(
          response.data['message'] ?? 'Failed to change password',
          statusCode: response.statusCode,
        );
      }
    } on DioException catch (e) {
      throw _handleDioException(e);
    }
  }

  Exception _handleDioException(DioException e) {
    switch (e.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.sendTimeout:
      case DioExceptionType.receiveTimeout:
        return NetworkException('Connection timeout');
      case DioExceptionType.badResponse:
        final statusCode = e.response?.statusCode;
        final message = e.response?.data['message'] ?? 'Unknown error';
        final rawErrors = e.response?.data['errors'];

        // Convert errors from Map<String, dynamic> to Map<String, List<String>>
        Map<String, List<String>>? errors;
        if (rawErrors != null && rawErrors is Map) {
          final errorMap = <String, List<String>>{};
          rawErrors.forEach((key, value) {
            if (value is List) {
              errorMap[key] = value.map((e) => e.toString()).toList();
            } else if (value is String) {
              errorMap[key] = [value];
            }
          });
          errors = errorMap;
        }

        if (statusCode == 401) {
          return AuthenticationException(message);
        } else if (statusCode == 422) {
          return ValidationException(message, errors: errors);
        } else if (statusCode == 404) {
          return NotFoundException(message);
        } else {
          return ServerException(message, statusCode: statusCode);
        }
      case DioExceptionType.cancel:
        return ServerException('Request cancelled');
      case DioExceptionType.connectionError:
        return NetworkException('No internet connection');
      default:
        return ServerException('Unknown error occurred');
    }
  }
}
