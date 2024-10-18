import 'package:blog_app/core/error/failures.dart';
import 'package:blog_app/core/usecase/usecase.dart';
import 'package:blog_app/features/blog/domain/entities/blog.dart';
import 'package:blog_app/features/blog/domain/repositories/blog_repository.dart';
import 'package:fpdart/fpdart.dart';

class GetBlogs implements UseCase<List<Blog>, void> {
  final BlogRepository blogRepository;

  GetBlogs(this.blogRepository);
  @override
  Future<Either<Failure, List<Blog>>> call(void params) async {
    return await blogRepository.getBlogs();
  }
}
