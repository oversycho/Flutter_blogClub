import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:gbc/common/app_exception.dart';
import 'package:gbc/data/repo/auth_repository.dart';

part 'auth_event.dart';
part 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final IAuthRepository authRepository;
  bool isLoginMode;
  AuthBloc(this.authRepository, {this.isLoginMode = true})
    : super(AuthInitial(isLoginMode)) {
    on<AuthEvent>((event, emit) async {
      try {
        if (event is AuthButtonIsCliked) {
          emit(AuthLoading(isLoginMode));
          if (isLoginMode) {
            await authRepository.login(event.email, event.password);
            emit(AuthSuccess(isLoginMode));
          } else {
            await authRepository.register(
              event.username,
              event.email,
              event.password,
            );
            emit(AuthSuccess(isLoginMode));
          }
        } else if (event is AuthModeChageISClicked) {
          isLoginMode = !isLoginMode;
          emit(AuthInitial(isLoginMode));
        }
      } catch (e) {
        emit(AuthErorr(isLoginMode, AppException()));
      }
    });
  }
}
