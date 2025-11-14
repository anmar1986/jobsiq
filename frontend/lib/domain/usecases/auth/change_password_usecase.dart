import 'package:dartz/dartz.dart';
import '../../../core/error/failures.dart';
import '../../../core/usecases/usecase.dart';
import '../../repositories/auth_repository.dart';

class ChangePasswordUseCase implements UseCase<void, ChangePasswordParams> {
  final AuthRepository repository;

  ChangePasswordUseCase(this.repository);

  @override
  Future<Either<Failure, void>> call(ChangePasswordParams params) async {
    return await repository.changePassword(
      currentPassword: params.currentPassword,
      password: params.password,
      passwordConfirmation: params.passwordConfirmation,
    );
  }
}

class ChangePasswordParams {
  final String currentPassword;
  final String password;
  final String passwordConfirmation;

  ChangePasswordParams({
    required this.currentPassword,
    required this.password,
    required this.passwordConfirmation,
  });
}
