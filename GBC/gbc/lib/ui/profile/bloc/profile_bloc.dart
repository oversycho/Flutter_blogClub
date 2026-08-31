import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:gbc/common/app_exception.dart';
import 'package:gbc/data/profile.dart';
import 'package:gbc/data/repo/profile_repository.dart';

part 'profile_event.dart';
part 'profile_state.dart';

class ProfileBloc extends Bloc<ProfileEvent, ProfileState> {
  final IProfileRepository profileRepository;

  ProfileBloc({required this.profileRepository}) : super(ProfileLoading()) {
    on<ProfileStarted>(_onStarted);
  }

  Future<void> _onStarted(
    ProfileStarted event,
    Emitter<ProfileState> emit,
  ) async {
    try {
      emit(ProfileLoading());
      final profile = await profileRepository.getMyProfile();
      emit(ProfileSuccess(profile));
    } catch (e) {
      emit(
        ProfileError(
          e is AppException ? e : AppException(message: e.toString()),
        ),
      );
    }
  }
}
