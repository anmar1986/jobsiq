import 'package:equatable/equatable.dart';
import '../../../domain/entities/user_entity.dart';

abstract class AuthState extends Equatable {
  const AuthState();

  @override
  List<Object?> get props => [];
}

class AuthInitial extends AuthState {}

class AuthLoading extends AuthState {}

class Authenticated extends AuthState {
  final UserEntity user;
  final String? redirectTo;

  const Authenticated({
    required this.user,
    this.redirectTo,
  });

  @override
  List<Object?> get props => [user, redirectTo];
}

class Unauthenticated extends AuthState {}

class AuthError extends AuthState {
  final String message;
  final Map<String, List<String>>? errors;

  const AuthError({
    required this.message,
    this.errors,
  });

  @override
  List<Object?> get props => [message, errors];
}
