part of 'reset_password_bloc.dart';

sealed class ResetPasswordEvent extends Equatable {
  const ResetPasswordEvent();

  @override
  List<Object> get props => [];
}

class ResetPasswordSubmitted extends ResetPasswordEvent {
  final String newPassword;
  const ResetPasswordSubmitted(this.newPassword);

  @override
  List<Object> get props => [newPassword];
}
