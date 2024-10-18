import 'package:blog_app/core/error/exception.dart';
import 'package:blog_app/features/auth/data/models/user_model.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

abstract interface class AuthRemoteDataSource {
  Session? get currentUserSession;
  Future<UserModel> signUpWithEmailAndPassword({
    required String name,
    required String email,
    required String password,
  });

  Future<UserModel> logInWithEmailAndPassword({
    required String email,
    required String password,
  });

  Future<UserModel?> getCurrentUserData();
}

class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  final SupabaseClient supabaseClinet;
  AuthRemoteDataSourceImpl(this.supabaseClinet);

  @override
  Session? get currentUserSession => supabaseClinet.auth.currentSession;

  @override
  Future<UserModel?> getCurrentUserData() async {
    try {
      if (currentUserSession == null) {
        return null;
      }
      final response = await supabaseClinet.from("profiles").select().eq(
            "id",
            currentUserSession!.user.id,
          );
      return UserModel.fromJson(response.first)
          .copyWith(email: currentUserSession!.user.email);
    } catch (e) {
      throw ServerException(e.toString());
    }
  }

  @override
  Future<UserModel> signUpWithEmailAndPassword({
    required String name,
    required String email,
    required String password,
  }) async {
    try {
      final response = await supabaseClinet.auth
          .signUp(password: password, email: email, data: {'name': name});

      if (response.user == null) {
        throw const ServerException('An error occurred while signing up');
      }
      return UserModel.fromJson(response.user!.toJson());
    } catch (e) {
      throw ServerException(e.toString());
    }
  }

  @override
  Future<UserModel> logInWithEmailAndPassword({
    required String email,
    required String password,
  }) async {
    try {
      final response = await supabaseClinet.auth
          .signInWithPassword(password: password, email: email);

      if (response.user == null) {
        throw const ServerException('An error occurred while logging in');
      }
      return UserModel.fromJson(response.user!.toJson());
    } catch (e) {
      throw ServerException(e.toString());
    }
  }
}
