import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:gbc/common/app_exception.dart';
import 'package:gbc/data/repo/auth_repository.dart';

part 'forgot_password_event.dart';
part 'forgot_password_state.dart';

class ForgotPasswordBloc
    extends Bloc<ForgotPasswordEvent, ForgotPasswordState> {
  final IAuthRepository authRepository;

  ForgotPasswordBloc(this.authRepository) : super(ForgotPasswordInitial()) {
    on<ForgotPasswordSubmitted>(_onSubmitted);
  }

  Future<void> _onSubmitted(
    ForgotPasswordSubmitted event,
    Emitter<ForgotPasswordState> emit,
  ) async {
    try {
      emit(ForgotPasswordLoading());
      await authRepository.sendPasswordResetEmail(event.email);
      emit(ForgotPasswordSuccess());
    } catch (e) {
      emit(
        ForgotPasswordError(
          e is AppException ? e : AppException(message: e.toString()),
        ),
      );
    }
  }
}
