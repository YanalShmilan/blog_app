import 'dart:io';

import 'package:blog_app/core/error/failures.dart';
import 'package:blog_app/core/usecase/usecase.dart';
import 'package:blog_app/features/blog/domain/entities/blog.dart';
import 'package:blog_app/features/blog/domain/repositories/blog_repository.dart';
import 'package:fpdart/fpdart.dart';

class UploadBlog implements UseCase<Blog, UploadBlogParams> {
  final BlogRepository blogRepository;

  UploadBlog({required this.blogRepository});
  @override
  Future<Either<Failure, Blog>> call(UploadBlogParams params) async {
    return await blogRepository.createBlog(
      title: params.title,
      description: params.description,
      tags: params.tags,
      image: params.image,
      authorId: params.authorId,
    );
  }
}

class UploadBlogParams {
  final String title;
  final String description;
  final List<String> tags;
  final File image;
  final String authorId;

  UploadBlogParams({
    required this.title,
    required this.description,
    required this.tags,
    required this.image,
    required this.authorId,
  });
}
