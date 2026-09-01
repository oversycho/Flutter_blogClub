part of 'profile_bloc.dart';

sealed class ProfileEvent extends Equatable {
  const ProfileEvent();

  @override
  List<Object?> get props => [];
}

class ProfileStarted extends ProfileEvent {}

class ProfileEditSubmitted extends ProfileEvent {
  final String username;
  final String bio;
  final Uint8List? avatarBytes;
  final String? avatarExtension;

  const ProfileEditSubmitted({
    required this.username,
    required this.bio,
    this.avatarBytes,
    this.avatarExtension,
  });

  @override
  List<Object?> get props => [username, bio, avatarBytes];
}
