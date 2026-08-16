part of 'auth_bloc.dart';

sealed class AuthState extends Equatable {
  const AuthState(this.isLoginMode);
  final bool isLoginMode;
  @override
  List<Object> get props => [isLoginMode];
}

class AuthInitial extends AuthState {
  const AuthInitial(super.isLoginMode);
}

class AuthLoading extends AuthState {
  const AuthLoading(super.isLoginMode);
}

class AuthErorr extends AuthState {
  final AppException exception;
  const AuthErorr(super.isLoginMode, this.exception);

  @override
  List<Object> get props => [isLoginMode, exception];
}

class AuthSuccess extends AuthState {
  const AuthSuccess(super.isLoginMode);
}

/// Emitted after a successful signup when email confirmation is required —
/// there's no session yet, just a message telling the user to check email.
class AuthConfirmationRequired extends AuthState {
  final String email;
  const AuthConfirmationRequired(super.isLoginMode, this.email);

  @override
  List<Object> get props => [isLoginMode, email];
}
