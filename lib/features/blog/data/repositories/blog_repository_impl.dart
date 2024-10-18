import 'dart:io';

import 'package:blog_app/core/error/exception.dart';
import 'package:blog_app/core/error/failures.dart';
import 'package:blog_app/features/blog/data/datasources/blog_remote_datasource.dart';
import 'package:blog_app/features/blog/data/models/blog_model.dart';
import 'package:blog_app/features/blog/domain/entities/blog.dart';
import 'package:blog_app/features/blog/domain/repositories/blog_repository.dart';
import 'package:fpdart/fpdart.dart';
import 'package:uuid/uuid.dart';

class BlogRepositoryImpl implements BlogRepository {
  final BlogRemoteDatasource blogRemoteDatasource;

  BlogRepositoryImpl({required this.blogRemoteDatasource});
  @override
  Future<Either<Failure, Blog>> createBlog({
    required String title,
    required String description,
    required List<String> tags,
    required File image,
    required String authorId,
  }) async {
    try {
      final id = const Uuid().v1();

      final imageUrl = await blogRemoteDatasource.uploadImage(
        image: image,
        blogId: id,
      );

      final model = BlogModel(
        id: id,
        authorId: authorId,
        title: title,
        description: description,
        imageUrl: imageUrl,
        tags: tags,
        updatedAt: DateTime.now(),
      );

      final createdBlog = await blogRemoteDatasource.createBlog(model);
      return Right(createdBlog);
    } on ServerException catch (e) {
      return Left(
        Failure(message: e.message),
      );
    }
  }

  @override
  Future<Either<Failure, List<Blog>>> getBlogs() async {
    try {
      final blogs = await blogRemoteDatasource.getBlogs();
      return Right(blogs);
    } on ServerException catch (e) {
      return Left(
        Failure(message: e.message),
      );
    } catch (e) {
      return Left(
        Failure(message: e.toString()),
      );
    }
  }
}
