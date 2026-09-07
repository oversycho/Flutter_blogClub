import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:gbc/common/app_exception.dart';
import 'package:gbc/data/repo/auth_repository.dart';

part 'reset_password_event.dart';
part 'reset_password_state.dart';

class ResetPasswordBloc extends Bloc<ResetPasswordEvent, ResetPasswordState> {
  final IAuthRepository authRepository;
  final String accessToken;
  final String refreshToken;

  ResetPasswordBloc({
    required this.authRepository,
    required this.accessToken,
    required this.refreshToken,
  }) : super(ResetPasswordInitial()) {
    on<ResetPasswordSubmitted>(_onSubmitted);
  }

  Future<void> _onSubmitted(
    ResetPasswordSubmitted event,
    Emitter<ResetPasswordState> emit,
  ) async {
    if (event.newPassword.length < 6) {
      emit(
        ResetPasswordError(
          AppException(message: 'Password must be at least 6 characters.'),
        ),
      );
      return;
    }

    try {
      emit(ResetPasswordLoading());
      await authRepository.completePasswordReset(
        accessToken: accessToken,
        refreshToken: refreshToken,
        newPassword: event.newPassword,
      );
      emit(ResetPasswordSuccess());
    } catch (e) {
      emit(
        ResetPasswordError(
          e is AppException ? e : AppException(message: e.toString()),
        ),
      );
    }
  }
}
