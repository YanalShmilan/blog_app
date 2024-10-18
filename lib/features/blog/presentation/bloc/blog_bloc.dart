import 'dart:io';

import 'package:blog_app/features/blog/domain/usecases/upload_blog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'blog_event.dart';
part 'blog_state.dart';

class BlogBloc extends Bloc<BlogEvent, BlogState> {
  final UploadBlog _createBlog;
  BlogBloc({
    required UploadBlog createBlog,
  })  : _createBlog = createBlog,
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
  }
}
