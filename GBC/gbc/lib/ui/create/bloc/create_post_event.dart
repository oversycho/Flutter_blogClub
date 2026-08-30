part of 'create_post_bloc.dart';

sealed class CreatePostEvent extends Equatable {
  const CreatePostEvent();

  @override
  List<Object> get props => [];
}

/// Loads categories for the dropdown when the screen opens.
class CreatePostStarted extends CreatePostEvent {}

class CreatePostSubmitted extends CreatePostEvent {
  final String title;
  final String? excerpt;
  final String content;
  final String? coverImageUrl;
  final String? categoryId;

  const CreatePostSubmitted({
    required this.title,
    this.excerpt,
    required this.content,
    this.coverImageUrl,
    this.categoryId,
  });

  @override
  List<Object> get props => [title, content];
}
