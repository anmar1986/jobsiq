import 'package:equatable/equatable.dart';

abstract class AuthEvent extends Equatable {
  const AuthEvent();

  @override
  List<Object?> get props => [];
}

class CheckAuthenticationEvent extends AuthEvent {}

class LoginEvent extends AuthEvent {
  final String email;
  final String password;

  const LoginEvent({
    required this.email,
    required this.password,
  });

  @override
  List<Object> get props => [email, password];
}

class RegisterEvent extends AuthEvent {
  final String name;
  final String email;
  final String password;
  final String passwordConfirmation;
  final String userType;
  final String? companyName;
  final String? companyEmail;

  const RegisterEvent({
    required this.name,
    required this.email,
    required this.password,
    required this.passwordConfirmation,
    required this.userType,
    this.companyName,
    this.companyEmail,
  });

  @override
  List<Object?> get props => [
        name,
        email,
        password,
        passwordConfirmation,
        userType,
        companyName,
        companyEmail,
      ];
}

class LogoutEvent extends AuthEvent {}

class GetCurrentUserEvent extends AuthEvent {}

class UpdateProfileEvent extends AuthEvent {
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

  const UpdateProfileEvent({
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

  @override
  List<Object?> get props => [
        name,
        email,
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
      ];
}

class ChangePasswordEvent extends AuthEvent {
  final String currentPassword;
  final String password;
  final String passwordConfirmation;

  const ChangePasswordEvent({
    required this.currentPassword,
    required this.password,
    required this.passwordConfirmation,
  });

  @override
  List<Object> get props => [currentPassword, password, passwordConfirmation];
}
