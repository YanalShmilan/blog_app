import 'dart:io';

import 'package:blog_app/core/error/exception.dart';
import 'package:blog_app/features/blog/data/models/blog_model.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

abstract interface class BlogRemoteDatasource {
  Future<BlogModel> createBlog(BlogModel blog);
  Future<String> uploadImage({required File image, required String blogId});
  Future<List<BlogModel>> getBlogs();
}

class BlogRemoteDatasourceImpl implements BlogRemoteDatasource {
  final SupabaseClient supabaseClinet;

  BlogRemoteDatasourceImpl({required this.supabaseClinet});

  @override
  Future<String> uploadImage(
      {required File image, required String blogId}) async {
    try {
      await supabaseClinet.storage.from('blog_images').upload(
            blogId,
            image,
          );
      return supabaseClinet.storage.from("blog_images").getPublicUrl(blogId);
    } catch (e) {
      throw ServerException(e.toString());
    }
  }

  @override
  Future<BlogModel> createBlog(BlogModel blog) async {
    try {
      final createdBlog =
          await supabaseClinet.from('blogs').insert(blog.toJson()).select();
      return BlogModel.fromJson(createdBlog.first);
    } catch (e) {
      throw ServerException(e.toString());
    }
  }

  @override
  Future<List<BlogModel>> getBlogs() async {
    try {
      final blogs =
          await supabaseClinet.from('blogs').select("*,profiles (name)");
      return blogs.map((e) => BlogModel.fromJson(e)).toList();
    } catch (e) {
      throw ServerException(e.toString());
    }
  }
}
