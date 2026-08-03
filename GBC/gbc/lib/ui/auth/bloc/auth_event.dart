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
