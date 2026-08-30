part of 'create_post_bloc.dart';

sealed class CreatePostEvent extends Equatable {
  const CreatePostEvent();

  @override
  List<Object?> get props => [];
}

/// Loads categories for the dropdown when the screen opens.
class CreatePostStarted extends CreatePostEvent {}

class CreatePostSubmitted extends CreatePostEvent {
  final String title;
  final String? excerpt;
  final String content;
  final String? categoryId;

  /// If the user picked a cover image, its raw bytes + extension.
  /// The bloc uploads it to storage first, then creates the post with
  /// the resulting public URL.
  final Uint8List? coverImageBytes;
  final String? coverImageExtension;

  const CreatePostSubmitted({
    required this.title,
    this.excerpt,
    required this.content,
    this.categoryId,
    this.coverImageBytes,
    this.coverImageExtension,
  });

  @override
  List<Object?> get props => [title, content, coverImageBytes];
}
