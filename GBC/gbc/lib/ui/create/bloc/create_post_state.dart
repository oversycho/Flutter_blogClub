part of 'create_post_bloc.dart';

sealed class CreatePostState extends Equatable {
  const CreatePostState();

  @override
  List<Object?> get props => [];
}

class CreatePostLoading extends CreatePostState {}

/// The form is visible and usable. isSubmitting drives the Share button's
/// loading spinner; errorMessage (if set) shows inline without losing
/// whatever the user already typed.
class CreatePostReady extends CreatePostState {
  final List<CategoriesEntity> categories;
  final bool isSubmitting;
  final String? errorMessage;

  const CreatePostReady({
    required this.categories,
    this.isSubmitting = false,
    this.errorMessage,
  });

  CreatePostReady copyWith({
    List<CategoriesEntity>? categories,
    bool? isSubmitting,
    String? errorMessage,
  }) {
    return CreatePostReady(
      categories: categories ?? this.categories,
      isSubmitting: isSubmitting ?? this.isSubmitting,
      errorMessage: errorMessage,
    );
  }

  @override
  List<Object?> get props => [categories, isSubmitting, errorMessage];
}

class CreatePostSuccess extends CreatePostState {
  final PostEntity post;
  const CreatePostSuccess(this.post);

  @override
  List<Object?> get props => [post];
}
