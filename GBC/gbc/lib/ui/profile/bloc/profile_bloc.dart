import 'dart:typed_data';

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
    on<ProfileEditSubmitted>(_onEditSubmitted);
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

  Future<void> _onEditSubmitted(
    ProfileEditSubmitted event,
    Emitter<ProfileState> emit,
  ) async {
    final currentState = state;
    if (currentState is! ProfileSuccess) return;

    emit(currentState.copyWith(isSaving: true, errorMessage: null));
    try {
      final bool usernameChanged =
          event.username != currentState.profile.username;

      if (usernameChanged) {
        final bool available = await profileRepository.checkUsernameAvailable(
          event.username,
        );
        if (!available) {
          emit(
            currentState.copyWith(
              isSaving: false,
              errorMessage:
                  'That username is taken or invalid (3-30 letters, numbers, underscore).',
            ),
          );
          return;
        }
      }

      String? newAvatarUrl;
      if (event.avatarBytes != null && event.avatarExtension != null) {
        newAvatarUrl = await profileRepository.uploadAvatar(
          bytes: event.avatarBytes!,
          fileExtension: event.avatarExtension!,
        );
      }

      final updatedProfile = await profileRepository.updateProfile(
        username: usernameChanged ? event.username : null,
        bio: event.bio,
        avatarUrl: newAvatarUrl,
      );
      emit(ProfileSuccess(updatedProfile));
    } catch (e) {
      emit(
        currentState.copyWith(
          isSaving: false,
          errorMessage: e is AppException ? e.message : e.toString(),
        ),
      );
    }
  }
}
