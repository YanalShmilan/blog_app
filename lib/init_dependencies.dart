import 'package:blog_app/core/common/cubits/app_user/app_user_cubit.dart';
import 'package:blog_app/core/secret/app_secrets.dart';
import 'package:blog_app/features/auth/data/datasources/auth_remote_data_source.dart';
import 'package:blog_app/features/auth/data/repositories/auth_repository_impl.dart';
import 'package:blog_app/features/auth/domain/usecases/current_user.dart';
import 'package:blog_app/features/auth/domain/usecases/user_sign_in.dart';
import 'package:blog_app/features/auth/domain/usecases/user_sign_up.dart';
import 'package:blog_app/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:blog_app/features/blog/data/datasources/blog_remote_datasource.dart';
import 'package:blog_app/features/blog/data/repositories/blog_repository_impl.dart';
import 'package:blog_app/features/blog/domain/repositories/blog_repository.dart';
import 'package:blog_app/features/blog/domain/usecases/get_blogs.dart';
import 'package:blog_app/features/blog/domain/usecases/upload_blog.dart';
import 'package:blog_app/features/blog/presentation/bloc/blog_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'features/auth/domain/repository/auth_repository.dart';

final serviceLocater = GetIt.instance;

Future<void> initDependencies() async {
  final supabase = await Supabase.initialize(
    url: AppSecrets.url,
    anonKey: AppSecrets.apiKey,
    debug: true,
  );

  serviceLocater.registerLazySingleton(() => supabase.client);
  _initAuth();
  _initBlog();
}

void _initAuth() {
  serviceLocater.registerFactory<AuthRemoteDataSource>(
    () => AuthRemoteDataSourceImpl(serviceLocater()),
  );

  serviceLocater.registerFactory<AuthRepository>(
    () => AuthRepositoryImpl(
      serviceLocater(),
    ),
  );

  serviceLocater.registerFactory(
    () => UserSignUp(
      serviceLocater(),
    ),
  );

  serviceLocater.registerFactory(
    () => UserSignIn(
      serviceLocater(),
    ),
  );

  serviceLocater.registerFactory(
    () => CurrentUser(
      serviceLocater(),
    ),
  );

  serviceLocater.registerLazySingleton(
    () => AppUserCubit(),
  );

  serviceLocater.registerLazySingleton(
    () => AuthBloc(
      userSignup: serviceLocater(),
      userSignIn: serviceLocater(),
      currentUser: serviceLocater(),
      appUserCubit: serviceLocater(),
    ),
  );
}

void _initBlog() {
  serviceLocater.registerFactory<BlogRemoteDatasource>(
    () => BlogRemoteDatasourceImpl(supabaseClinet: serviceLocater()),
  );

  serviceLocater.registerFactory<BlogRepository>(
    () => BlogRepositoryImpl(
      blogRemoteDatasource: serviceLocater(),
    ),
  );

  serviceLocater.registerFactory(
    () => UploadBlog(
      blogRepository: serviceLocater(),
    ),
  );

  serviceLocater.registerLazySingleton(
    () => GetBlogs(
      serviceLocater(),
    ),
  );

  serviceLocater.registerLazySingleton(
    () => BlogBloc(
      createBlog: serviceLocater(),
      getBlogs: serviceLocater(),
    ),
  );
}
