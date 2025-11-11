import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../core/error/failures.dart';
import '../../../core/usecases/usecase.dart';
import '../../../domain/usecases/auth/check_authentication_usecase.dart';
import '../../../domain/usecases/auth/get_current_user_usecase.dart';
import '../../../domain/usecases/auth/login_usecase.dart';
import '../../../domain/usecases/auth/logout_usecase.dart';
import '../../../domain/usecases/auth/register_usecase.dart';
import 'auth_event.dart';
import 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final LoginUseCase loginUseCase;
  final RegisterUseCase registerUseCase;
  final LogoutUseCase logoutUseCase;
  final GetCurrentUserUseCase getCurrentUserUseCase;
  final CheckAuthenticationUseCase checkAuthenticationUseCase;

  AuthBloc({
    required this.loginUseCase,
    required this.registerUseCase,
    required this.logoutUseCase,
    required this.getCurrentUserUseCase,
    required this.checkAuthenticationUseCase,
  }) : super(AuthInitial()) {
    on<CheckAuthenticationEvent>(_onCheckAuthentication);
    on<LoginEvent>(_onLogin);
    on<RegisterEvent>(_onRegister);
    on<LogoutEvent>(_onLogout);
    on<GetCurrentUserEvent>(_onGetCurrentUser);
  }

  Future<void> _onCheckAuthentication(
    CheckAuthenticationEvent event,
    Emitter<AuthState> emit,
  ) async {
    emit(AuthLoading());

    final result = await checkAuthenticationUseCase(NoParams());

    result.fold(
      (failure) => emit(Unauthenticated()),
      (isAuthenticated) async {
        if (isAuthenticated) {
          // Get user data
          final userResult = await getCurrentUserUseCase(NoParams());
          userResult.fold(
            (failure) => emit(Unauthenticated()),
            (user) => emit(Authenticated(user: user)),
          );
        } else {
          emit(Unauthenticated());
        }
      },
    );
  }

  Future<void> _onLogin(
    LoginEvent event,
    Emitter<AuthState> emit,
  ) async {
    emit(AuthLoading());

    final result = await loginUseCase(
      LoginParams(
        email: event.email,
        password: event.password,
      ),
    );

    result.fold(
      (failure) => emit(AuthError(message: _mapFailureToMessage(failure))),
      (authResult) => emit(
        Authenticated(
          user: authResult.user,
          redirectTo: authResult.redirectTo,
        ),
      ),
    );
  }

  Future<void> _onRegister(
    RegisterEvent event,
    Emitter<AuthState> emit,
  ) async {
    emit(AuthLoading());

    final result = await registerUseCase(
      RegisterParams(
        name: event.name,
        email: event.email,
        password: event.password,
        passwordConfirmation: event.passwordConfirmation,
        userType: event.userType,
        companyName: event.companyName,
        companyEmail: event.companyEmail,
      ),
    );

    result.fold(
      (failure) {
        if (failure is ValidationFailure) {
          emit(AuthError(
            message: failure.message,
            errors: failure.errors,
          ));
        } else {
          emit(AuthError(message: _mapFailureToMessage(failure)));
        }
      },
      (authResult) => emit(
        Authenticated(
          user: authResult.user,
          redirectTo: authResult.redirectTo,
        ),
      ),
    );
  }

  Future<void> _onLogout(
    LogoutEvent event,
    Emitter<AuthState> emit,
  ) async {
    emit(AuthLoading());

    final result = await logoutUseCase(NoParams());

    result.fold(
      (failure) {
        // Even on failure, log out locally
        emit(Unauthenticated());
      },
      (_) => emit(Unauthenticated()),
    );
  }

  Future<void> _onGetCurrentUser(
    GetCurrentUserEvent event,
    Emitter<AuthState> emit,
  ) async {
    emit(AuthLoading());

    final result = await getCurrentUserUseCase(NoParams());

    result.fold(
      (failure) => emit(AuthError(message: _mapFailureToMessage(failure))),
      (user) => emit(Authenticated(user: user)),
    );
  }

  String _mapFailureToMessage(Failure failure) {
    switch (failure.runtimeType) {
      case const (ServerFailure):
        return failure.message;
      case const (NetworkFailure):
        return 'No internet connection. Please check your connection.';
      case const (AuthenticationFailure):
        return failure.message;
      case const (ValidationFailure):
        return failure.message;
      default:
        return 'An unexpected error occurred. Please try again.';
    }
  }
}
