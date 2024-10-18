part of 'blog_bloc.dart';

@immutable
sealed class BlogEvent {}

final class CreateBlog extends BlogEvent {
  final String title;
  final String description;
  final List<String> tags;
  final File image;
  final String authorId;

  CreateBlog({
    required this.title,
    required this.description,
    required this.tags,
    required this.image,
    required this.authorId,
  });
}

final class GetBlogsEvent extends BlogEvent {}
