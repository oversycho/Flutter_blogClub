part of 'post_detail_bloc.dart';

sealed class PostDetailEvent extends Equatable {
  const PostDetailEvent();

  @override
  List<Object> get props => [];
}

class PostDetailStarted extends PostDetailEvent {
  final String slug;
  const PostDetailStarted(this.slug);

  @override
  List<Object> get props => [slug];
}

class PostDetailLikeButtonClicked extends PostDetailEvent {}

class PostDetailBookmarkButtonClicked extends PostDetailEvent {}
