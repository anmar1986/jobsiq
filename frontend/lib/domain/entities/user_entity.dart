import 'package:equatable/equatable.dart';

class UserEntity extends Equatable {
  final int id;
  final String name;
  final String email;
  final String userType; // job_seeker or company_owner
  final bool isAdmin;
  final String? profilePhoto;
  final String? headline;
  final String? gender;
  final DateTime? dateOfBirth;
  final String? nationality;
  final String? city;
  final String? country;
  final String? address;
  final String? phoneNumber;
  final String? linkedinUrl;
  final DateTime createdAt;
  final DateTime updatedAt;

  const UserEntity({
    required this.id,
    required this.name,
    required this.email,
    required this.userType,
    required this.isAdmin,
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
    required this.createdAt,
    required this.updatedAt,
  });

  bool get isJobSeeker => userType == 'job_seeker';
  bool get isCompanyOwner => userType == 'company_owner';

  @override
  List<Object?> get props => [
        id,
        name,
        email,
        userType,
        isAdmin,
        profilePhoto,
        headline,
        gender,
        dateOfBirth,
        nationality,
        city,
        country,
        address,
        phoneNumber,
        linkedinUrl,
        createdAt,
        updatedAt,
      ];
}
