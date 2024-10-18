import 'package:blog_app/features/blog/data/models/blog_model.dart';
import 'package:hive/hive.dart';

abstract interface class BlogLocalDataSource {
  void cacheBlogs(List<BlogModel> blogs);
  List<BlogModel> getBlogs();
}

class BlogLocalDatasourceImpl implements BlogLocalDataSource {
  final Box box;

  BlogLocalDatasourceImpl(this.box);
  @override
  void cacheBlogs(List<BlogModel> blogs) {
    box.clear();
    for (var i = 0; i < blogs.length; i++) {
      box.put('blog_$i', blogs[i].toJson());
    }
  }

  @override
  List<BlogModel> getBlogs() {
    final List<BlogModel> blogs = [];
    for (var i = 0; i < box.length; i++) {
      final blog = box.get('blog_$i');
      if (blog != null) {
        blogs.add(BlogModel.fromJson(blog));
      }
    }
    return blogs;
  }
}
