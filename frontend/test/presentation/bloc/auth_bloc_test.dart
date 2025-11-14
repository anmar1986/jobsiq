import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:jobsiq_mobile/core/error/failures.dart';
import 'package:jobsiq_mobile/domain/entities/user_entity.dart';
import 'package:jobsiq_mobile/domain/repositories/auth_repository.dart';
import 'package:jobsiq_mobile/domain/usecases/auth/change_password_usecase.dart';
import 'package:jobsiq_mobile/domain/usecases/auth/check_authentication_usecase.dart';
import 'package:jobsiq_mobile/domain/usecases/auth/get_current_user_usecase.dart';
import 'package:jobsiq_mobile/domain/usecases/auth/login_usecase.dart';
import 'package:jobsiq_mobile/domain/usecases/auth/logout_usecase.dart';
import 'package:jobsiq_mobile/domain/usecases/auth/register_usecase.dart';
import 'package:jobsiq_mobile/domain/usecases/auth/update_profile_usecase.dart';
import 'package:jobsiq_mobile/presentation/bloc/auth/auth_bloc.dart';
import 'package:jobsiq_mobile/presentation/bloc/auth/auth_event.dart';
import 'package:jobsiq_mobile/presentation/bloc/auth/auth_state.dart';

import 'auth_bloc_test.mocks.dart';

@GenerateMocks([
  LoginUseCase,
  RegisterUseCase,
  LogoutUseCase,
  GetCurrentUserUseCase,
  CheckAuthenticationUseCase,
  UpdateProfileUseCase,
  ChangePasswordUseCase,
])
void main() {
  late AuthBloc bloc;
  late MockLoginUseCase mockLoginUseCase;
  late MockRegisterUseCase mockRegisterUseCase;
  late MockLogoutUseCase mockLogoutUseCase;
  late MockGetCurrentUserUseCase mockGetCurrentUserUseCase;
  late MockCheckAuthenticationUseCase mockCheckAuthenticationUseCase;
  late MockUpdateProfileUseCase mockUpdateProfileUseCase;
  late MockChangePasswordUseCase mockChangePasswordUseCase;

  setUp(() {
    mockLoginUseCase = MockLoginUseCase();
    mockRegisterUseCase = MockRegisterUseCase();
    mockLogoutUseCase = MockLogoutUseCase();
    mockGetCurrentUserUseCase = MockGetCurrentUserUseCase();
    mockCheckAuthenticationUseCase = MockCheckAuthenticationUseCase();
    mockUpdateProfileUseCase = MockUpdateProfileUseCase();
    mockChangePasswordUseCase = MockChangePasswordUseCase();

    bloc = AuthBloc(
      loginUseCase: mockLoginUseCase,
      registerUseCase: mockRegisterUseCase,
      logoutUseCase: mockLogoutUseCase,
      getCurrentUserUseCase: mockGetCurrentUserUseCase,
      checkAuthenticationUseCase: mockCheckAuthenticationUseCase,
      updateProfileUseCase: mockUpdateProfileUseCase,
      changePasswordUseCase: mockChangePasswordUseCase,
    );
  });

  tearDown(() {
    bloc.close();
  });

  group('AuthBloc', () {
    final tUser = UserEntity(
      id: 1,
      name: 'John Doe',
      email: 'john@example.com',
      userType: 'job_seeker',
      isAdmin: false,
      createdAt: DateTime(2024, 1, 1),
      updatedAt: DateTime(2024, 1, 1),
    );

    final tAuthResult = AuthResult(
      user: tUser,
      token: 'test-token',
      redirectTo: '/main',
    );

    test('initial state should be AuthInitial', () {
      expect(bloc.state, equals(AuthInitial()));
    });

    group('CheckAuthenticationEvent', () {
      blocTest<AuthBloc, AuthState>(
        'emits [AuthLoading, Authenticated] when check succeeds and user is found',
        build: () {
          when(mockCheckAuthenticationUseCase(any)).thenAnswer(
            (_) async => const Right(true),
          );
          when(mockGetCurrentUserUseCase(any)).thenAnswer(
            (_) async => Right(tUser),
          );
          return bloc;
        },
        act: (bloc) => bloc.add(CheckAuthenticationEvent()),
        expect: () => [
          AuthLoading(),
          Authenticated(user: tUser),
        ],
      );

      blocTest<AuthBloc, AuthState>(
        'emits [AuthLoading, Unauthenticated] when check returns false',
        build: () {
          when(mockCheckAuthenticationUseCase(any)).thenAnswer(
            (_) async => const Right(false),
          );
          return bloc;
        },
        act: (bloc) => bloc.add(CheckAuthenticationEvent()),
        expect: () => [
          AuthLoading(),
          Unauthenticated(),
        ],
      );

      blocTest<AuthBloc, AuthState>(
        'emits [AuthLoading, Unauthenticated] when check fails',
        build: () {
          when(mockCheckAuthenticationUseCase(any)).thenAnswer(
            (_) async => const Left(AuthenticationFailure('Not authenticated')),
          );
          return bloc;
        },
        act: (bloc) => bloc.add(CheckAuthenticationEvent()),
        expect: () => [
          AuthLoading(),
          Unauthenticated(),
        ],
      );

      blocTest<AuthBloc, AuthState>(
        'emits [AuthLoading, Unauthenticated] when get current user fails',
        build: () {
          when(mockCheckAuthenticationUseCase(any)).thenAnswer(
            (_) async => const Right(true),
          );
          when(mockGetCurrentUserUseCase(any)).thenAnswer(
            (_) async => const Left(ServerFailure('Server error')),
          );
          return bloc;
        },
        act: (bloc) => bloc.add(CheckAuthenticationEvent()),
        expect: () => [
          AuthLoading(),
          Unauthenticated(),
        ],
      );
    });

    group('LoginEvent', () {
      blocTest<AuthBloc, AuthState>(
        'emits [AuthLoading, Authenticated] when login succeeds',
        build: () {
          when(mockLoginUseCase(any)).thenAnswer(
            (_) async => Right(tAuthResult),
          );
          return bloc;
        },
        act: (bloc) => bloc.add(
          const LoginEvent(
            email: 'john@example.com',
            password: 'password123',
          ),
        ),
        expect: () => [
          AuthLoading(),
          Authenticated(user: tUser, redirectTo: '/main'),
        ],
        verify: (_) {
          final captured = verify(mockLoginUseCase(captureAny)).captured;
          final params = captured.first as LoginParams;
          expect(params.email, 'john@example.com');
          expect(params.password, 'password123');
        },
      );

      blocTest<AuthBloc, AuthState>(
        'emits [AuthLoading, AuthError] when login fails',
        build: () {
          when(mockLoginUseCase(any)).thenAnswer(
            (_) async =>
                const Left(AuthenticationFailure('Invalid credentials')),
          );
          return bloc;
        },
        act: (bloc) => bloc.add(
          const LoginEvent(
            email: 'john@example.com',
            password: 'wrongpassword',
          ),
        ),
        expect: () => [
          AuthLoading(),
          const AuthError(message: 'Invalid credentials'),
        ],
      );

      blocTest<AuthBloc, AuthState>(
        'emits AuthError with network message on NetworkFailure',
        build: () {
          when(mockLoginUseCase(any)).thenAnswer(
            (_) async => const Left(NetworkFailure('No connection')),
          );
          return bloc;
        },
        act: (bloc) => bloc.add(
          const LoginEvent(
            email: 'john@example.com',
            password: 'password123',
          ),
        ),
        expect: () => [
          AuthLoading(),
          const AuthError(
            message: 'No internet connection. Please check your connection.',
          ),
        ],
      );
    });

    group('RegisterEvent', () {
      blocTest<AuthBloc, AuthState>(
        'emits [AuthLoading, Authenticated] when registration succeeds',
        build: () {
          when(mockRegisterUseCase(any)).thenAnswer(
            (_) async => Right(tAuthResult),
          );
          return bloc;
        },
        act: (bloc) => bloc.add(
          const RegisterEvent(
            name: 'John Doe',
            email: 'john@example.com',
            password: 'password123',
            passwordConfirmation: 'password123',
            userType: 'job_seeker',
          ),
        ),
        expect: () => [
          AuthLoading(),
          Authenticated(user: tUser, redirectTo: '/main'),
        ],
        verify: (_) {
          final captured = verify(mockRegisterUseCase(captureAny)).captured;
          final params = captured.first as RegisterParams;
          expect(params.name, 'John Doe');
          expect(params.email, 'john@example.com');
          expect(params.userType, 'job_seeker');
        },
      );

      blocTest<AuthBloc, AuthState>(
        'emits [AuthLoading, AuthError] with validation errors',
        build: () {
          when(mockRegisterUseCase(any)).thenAnswer(
            (_) async => const Left(ValidationFailure(
              'Validation failed',
              errors: {
                'email': ['Email is already taken'],
                'password': ['Password must be at least 8 characters'],
              },
            )),
          );
          return bloc;
        },
        act: (bloc) => bloc.add(
          const RegisterEvent(
            name: 'John Doe',
            email: 'john@example.com',
            password: '123',
            passwordConfirmation: '123',
            userType: 'job_seeker',
          ),
        ),
        expect: () => [
          AuthLoading(),
          const AuthError(
            message: 'Validation failed',
            errors: {
              'email': ['Email is already taken'],
              'password': ['Password must be at least 8 characters'],
            },
          ),
        ],
      );

      blocTest<AuthBloc, AuthState>(
        'emits Authenticated with company data when registering as employer',
        build: () {
          when(mockRegisterUseCase(any)).thenAnswer(
            (_) async => Right(tAuthResult),
          );
          return bloc;
        },
        act: (bloc) => bloc.add(
          const RegisterEvent(
            name: 'Jane Company',
            email: 'jane@company.com',
            password: 'password123',
            passwordConfirmation: 'password123',
            userType: 'employer',
            companyName: 'Tech Corp',
            companyEmail: 'contact@techcorp.com',
          ),
        ),
        expect: () => [
          AuthLoading(),
          Authenticated(user: tUser, redirectTo: '/main'),
        ],
        verify: (_) {
          final captured = verify(mockRegisterUseCase(captureAny)).captured;
          final params = captured.first as RegisterParams;
          expect(params.userType, 'employer');
          expect(params.companyName, 'Tech Corp');
          expect(params.companyEmail, 'contact@techcorp.com');
        },
      );
    });

    group('LogoutEvent', () {
      blocTest<AuthBloc, AuthState>(
        'emits [AuthLoading, Unauthenticated] when logout succeeds',
        build: () {
          when(mockLogoutUseCase(any)).thenAnswer(
            (_) async => const Right(null),
          );
          return bloc;
        },
        act: (bloc) => bloc.add(LogoutEvent()),
        expect: () => [
          AuthLoading(),
          Unauthenticated(),
        ],
      );

      blocTest<AuthBloc, AuthState>(
        'emits [AuthLoading, Unauthenticated] even when logout fails (local logout)',
        build: () {
          when(mockLogoutUseCase(any)).thenAnswer(
            (_) async => const Left(ServerFailure('Server error')),
          );
          return bloc;
        },
        act: (bloc) => bloc.add(LogoutEvent()),
        expect: () => [
          AuthLoading(),
          Unauthenticated(),
        ],
      );
    });

    group('GetCurrentUserEvent', () {
      blocTest<AuthBloc, AuthState>(
        'emits [AuthLoading, Authenticated] when get user succeeds',
        build: () {
          when(mockGetCurrentUserUseCase(any)).thenAnswer(
            (_) async => Right(tUser),
          );
          return bloc;
        },
        act: (bloc) => bloc.add(GetCurrentUserEvent()),
        expect: () => [
          AuthLoading(),
          Authenticated(user: tUser),
        ],
      );

      blocTest<AuthBloc, AuthState>(
        'emits [AuthLoading, AuthError] when get user fails',
        build: () {
          when(mockGetCurrentUserUseCase(any)).thenAnswer(
            (_) async => const Left(ServerFailure('Failed to get user')),
          );
          return bloc;
        },
        act: (bloc) => bloc.add(GetCurrentUserEvent()),
        expect: () => [
          AuthLoading(),
          const AuthError(message: 'Failed to get user'),
        ],
      );
    });

    group('UpdateProfileEvent', () {
      final tUpdatedUser = UserEntity(
        id: 1,
        name: 'John Updated',
        email: 'johnupdated@example.com',
        userType: 'job_seeker',
        isAdmin: false,
        headline: 'Senior Flutter Developer',
        createdAt: DateTime(2024, 1, 1),
        updatedAt: DateTime(2024, 1, 2),
      );

      blocTest<AuthBloc, AuthState>(
        'emits [AuthLoading, ProfileUpdateSuccess] when update succeeds',
        build: () {
          when(mockUpdateProfileUseCase(any)).thenAnswer(
            (_) async => Right(tUpdatedUser),
          );
          return bloc;
        },
        act: (bloc) => bloc.add(
          const UpdateProfileEvent(
            name: 'John Updated',
            email: 'johnupdated@example.com',
            headline: 'Senior Flutter Developer',
          ),
        ),
        expect: () => [
          AuthLoading(),
          ProfileUpdateSuccess(user: tUpdatedUser),
        ],
        verify: (_) {
          final captured =
              verify(mockUpdateProfileUseCase(captureAny)).captured;
          final params = captured.first as UpdateProfileParams;
          expect(params.name, 'John Updated');
          expect(params.email, 'johnupdated@example.com');
          expect(params.headline, 'Senior Flutter Developer');
        },
      );

      blocTest<AuthBloc, AuthState>(
        'emits [AuthLoading, AuthError] with validation errors',
        build: () {
          when(mockUpdateProfileUseCase(any)).thenAnswer(
            (_) async => const Left(ValidationFailure(
              'Validation failed',
              errors: {
                'email': ['Email is already taken'],
              },
            )),
          );
          return bloc;
        },
        act: (bloc) => bloc.add(
          const UpdateProfileEvent(
            email: 'taken@example.com',
          ),
        ),
        expect: () => [
          AuthLoading(),
          const AuthError(
            message: 'Validation failed',
            errors: {
              'email': ['Email is already taken'],
            },
          ),
        ],
      );
    });

    group('ChangePasswordEvent', () {
      blocTest<AuthBloc, AuthState>(
        'emits [AuthLoading, PasswordChangeSuccess] when password change succeeds',
        build: () {
          when(mockChangePasswordUseCase(any)).thenAnswer(
            (_) async => const Right(null),
          );
          return bloc;
        },
        act: (bloc) => bloc.add(
          const ChangePasswordEvent(
            currentPassword: 'oldpassword',
            password: 'newpassword',
            passwordConfirmation: 'newpassword',
          ),
        ),
        expect: () => [
          AuthLoading(),
          const PasswordChangeSuccess(),
        ],
        verify: (_) {
          final captured =
              verify(mockChangePasswordUseCase(captureAny)).captured;
          final params = captured.first as ChangePasswordParams;
          expect(params.currentPassword, 'oldpassword');
          expect(params.password, 'newpassword');
          expect(params.passwordConfirmation, 'newpassword');
        },
      );

      blocTest<AuthBloc, AuthState>(
        'emits [AuthLoading, AuthError] when current password is wrong',
        build: () {
          when(mockChangePasswordUseCase(any)).thenAnswer(
            (_) async => const Left(
                AuthenticationFailure('Current password is incorrect')),
          );
          return bloc;
        },
        act: (bloc) => bloc.add(
          const ChangePasswordEvent(
            currentPassword: 'wrongpassword',
            password: 'newpassword',
            passwordConfirmation: 'newpassword',
          ),
        ),
        expect: () => [
          AuthLoading(),
          const AuthError(message: 'Current password is incorrect'),
        ],
      );

      blocTest<AuthBloc, AuthState>(
        'emits [AuthLoading, AuthError] with validation errors',
        build: () {
          when(mockChangePasswordUseCase(any)).thenAnswer(
            (_) async => const Left(ValidationFailure(
              'Validation failed',
              errors: {
                'password': ['Password must be at least 8 characters'],
              },
            )),
          );
          return bloc;
        },
        act: (bloc) => bloc.add(
          const ChangePasswordEvent(
            currentPassword: 'oldpassword',
            password: '123',
            passwordConfirmation: '123',
          ),
        ),
        expect: () => [
          AuthLoading(),
          const AuthError(
            message: 'Validation failed',
            errors: {
              'password': ['Password must be at least 8 characters'],
            },
          ),
        ],
      );
    });
  });
}
