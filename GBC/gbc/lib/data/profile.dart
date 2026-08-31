class ProfileEntity {
  final String id;
  final String username;
  final String? avatarUrl;
  final String? bio;

  ProfileEntity({
    required this.id,
    required this.username,
    this.avatarUrl,
    this.bio,
  });

  factory ProfileEntity.fromJson(Map<String, dynamic> json) {
    return ProfileEntity(
      id: json['id'] as String,
      username: json['username'] as String,
      avatarUrl: json['avatar_url'] as String?,
      bio: json['bio'] as String?,
    );
  }
}
