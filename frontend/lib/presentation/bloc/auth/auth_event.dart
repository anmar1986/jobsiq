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
