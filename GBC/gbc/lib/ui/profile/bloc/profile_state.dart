part of 'profile_bloc.dart';

sealed class ProfileState extends Equatable {
  const ProfileState();

  @override
  List<Object?> get props => [];
}

class ProfileLoading extends ProfileState {}

class ProfileSuccess extends ProfileState {
  final ProfileEntity profile;
  final bool isSaving;
  final String? errorMessage;

  const ProfileSuccess(
    this.profile, {
    this.isSaving = false,
    this.errorMessage,
  });

  ProfileSuccess copyWith({
    ProfileEntity? profile,
    bool? isSaving,
    String? errorMessage,
  }) {
    return ProfileSuccess(
      profile ?? this.profile,
      isSaving: isSaving ?? this.isSaving,
      errorMessage: errorMessage,
    );
  }

  @override
  List<Object?> get props => [profile, isSaving, errorMessage];
}

class ProfileError extends ProfileState {
  final AppException exception;
  const ProfileError(this.exception);

  @override
  List<Object?> get props => [exception];
}
