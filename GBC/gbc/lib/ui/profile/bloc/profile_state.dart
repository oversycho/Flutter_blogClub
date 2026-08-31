part of 'profile_bloc.dart';

sealed class ProfileState extends Equatable {
  const ProfileState();

  @override
  List<Object> get props => [];
}

class ProfileLoading extends ProfileState {}

class ProfileSuccess extends ProfileState {
  final ProfileEntity profile;
  const ProfileSuccess(this.profile);

  @override
  List<Object> get props => [profile];
}

class ProfileError extends ProfileState {
  final AppException exception;
  const ProfileError(this.exception);

  @override
  List<Object> get props => [exception];
}
