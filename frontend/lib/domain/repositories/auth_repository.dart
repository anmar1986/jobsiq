import 'package:dartz/dartz.dart';
import '../../core/error/failures.dart';
import '../entities/user_entity.dart';

abstract class AuthRepository {
  Future<Either<Failure, AuthResult>> login({
    required String email,
    required String password,
  });

  Future<Either<Failure, AuthResult>> register({
    required String name,
    required String email,
    required String password,
    required String passwordConfirmation,
    required String userType,
    String? companyName,
    String? companyEmail,
  });

  Future<Either<Failure, void>> logout();

  Future<Either<Failure, void>> logoutAll();

  Future<Either<Failure, UserEntity>> getCurrentUser();

  Future<Either<Failure, bool>> isAuthenticated();

  Future<Either<Failure, String?>> getToken();

  Future<Either<Failure, UserEntity>> updateProfile({
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

  Future<Either<Failure, void>> changePassword({
    required String currentPassword,
    required String password,
    required String passwordConfirmation,
  });

  Future<Either<Failure, void>> forgotPassword({required String email});
}

class AuthResult {
  final UserEntity user;
  final String token;
  final String? redirectTo;

  AuthResult({
    required this.user,
    required this.token,
    this.redirectTo,
  });
}
