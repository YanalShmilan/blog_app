import 'dart:io';

import 'package:blog_app/features/blog/domain/entities/blog.dart';
import 'package:blog_app/features/blog/domain/usecases/get_blogs.dart';
import 'package:blog_app/features/blog/domain/usecases/upload_blog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'blog_event.dart';
part 'blog_state.dart';

class BlogBloc extends Bloc<BlogEvent, BlogState> {
  final UploadBlog _createBlog;
  final GetBlogs _getBlogs;
  BlogBloc({
    required UploadBlog createBlog,
    required GetBlogs getBlogs,
  })  : _createBlog = createBlog,
        _getBlogs = getBlogs,
        super(BlogInitial()) {
    on<BlogEvent>((event, emit) {
      emit(BlogLoading());
    });
    on<CreateBlog>((event, emit) async {
      emit(BlogLoading());
      final result = await _createBlog(UploadBlogParams(
        title: event.title,
        image: event.image,
        description: event.description,
        tags: event.tags,
        authorId: event.authorId,
      ));
      result.fold(
        (failure) => emit(BlogError(message: failure.message)),
        (blog) => emit(BlogCreated()),
      );
    });

    on<GetBlogsEvent>((event, emit) async {
      emit(BlogLoading());
      final result = await _getBlogs({});
      result.fold(
        (failure) => emit(BlogError(message: failure.message)),
        (blogs) => emit(BlogsLoaded(blogs: blogs)),
      );
    });
  }
}
