part of 'auth_bloc.dart';

sealed class AuthEvent extends Equatable {
  const AuthEvent();

  @override
  List<Object> get props => [];
}

class AuthStarted extends AuthEvent {}

class AuthButtonIsCliked extends AuthEvent {
  final String email;
  final String password;
  final String username;
  const AuthButtonIsCliked(this.email, this.password, this.username);
}

class AuthModeChageISClicked extends AuthEvent {}

class AuthOAuthButtonClicked extends AuthEvent {
  final String provider; // 'google' or 'discord'
  const AuthOAuthButtonClicked(this.provider);

  @override
  List<Object> get props => [provider];
}

class AuthResendConfirmationClicked extends AuthEvent {
  final String email;
  const AuthResendConfirmationClicked(this.email);

  @override
  List<Object> get props => [email];
}
