import 'package:dartz/dartz.dart';
import '../../../core/error/failures.dart';
import '../../../core/usecases/usecase.dart';
import '../../entities/user_entity.dart';
import '../../repositories/auth_repository.dart';

class UpdateProfileUseCase implements UseCase<UserEntity, UpdateProfileParams> {
  final AuthRepository repository;

  UpdateProfileUseCase(this.repository);

  @override
  Future<Either<Failure, UserEntity>> call(UpdateProfileParams params) async {
    return await repository.updateProfile(
      name: params.name,
      email: params.email,
      profilePhoto: params.profilePhoto,
      headline: params.headline,
      gender: params.gender,
      dateOfBirth: params.dateOfBirth,
      nationality: params.nationality,
      city: params.city,
      country: params.country,
      address: params.address,
      phoneNumber: params.phoneNumber,
      linkedinUrl: params.linkedinUrl,
    );
  }
}

class UpdateProfileParams {
  final String? name;
  final String? email;
  final String? profilePhoto;
  final String? headline;
  final String? gender;
  final String? dateOfBirth;
  final String? nationality;
  final String? city;
  final String? country;
  final String? address;
  final String? phoneNumber;
  final String? linkedinUrl;

  UpdateProfileParams({
    this.name,
    this.email,
    this.profilePhoto,
    this.headline,
    this.gender,
    this.dateOfBirth,
    this.nationality,
    this.city,
    this.country,
    this.address,
    this.phoneNumber,
    this.linkedinUrl,
  });
}
