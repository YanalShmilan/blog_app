import 'package:blog_app/core/common/cubits/app_user/app_user_cubit.dart';
import 'package:blog_app/core/entities/user.dart';
import 'package:blog_app/features/auth/domain/usecases/current_user.dart';
import 'package:blog_app/features/auth/domain/usecases/user_sign_in.dart';
import 'package:blog_app/features/auth/domain/usecases/user_sign_up.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'auth_event.dart';
part 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final UserSignUp _userSignUp;
  final UserSignIn _userSignIn;
  final CurrentUser _currentUser;
  final AppUserCubit _appUserCubit;

  AuthBloc({
    required UserSignUp userSignup,
    required UserSignIn userSignIn,
    required CurrentUser currentUser,
    required AppUserCubit appUserCubit,
  })  : _userSignUp = userSignup,
        _userSignIn = userSignIn,
        _currentUser = currentUser,
        _appUserCubit = appUserCubit,
        super(AuthInitial()) {
    on<AuthSignUp>((event, emit) async {
      emit(AuthLoading());
      final result = await _userSignUp(UserSignUpParams(
        name: event.name,
        email: event.email,
        password: event.password,
      ));
      result.fold(
        (failure) => emit(AuthFailure(failure.message)),
        (user) => emit(AuthSuccess(user)),
      );
    });

    on<AuthSignIn>((event, emit) async {
      emit(AuthLoading());
      final result = await _userSignIn(UserSignInParams(
        email: event.email,
        password: event.password,
      ));
      result.fold(
        (failure) => emit(AuthFailure(failure.message)),
        (user) => _emitUser(user, emit),
      );
    });

    on<AuthIsUserSignedIn>((event, emit) async {
      emit(AuthLoading());
      final result = await _currentUser({});
      result.fold(
        (failure) => _emitUser(null, emit),
        (user) => _emitUser(user, emit),
      );
    });
  }

  void _emitUser(User? user, Emitter<AuthState> emit) {
    if (user != null) {
      emit(AuthSuccess(user));
      _appUserCubit.setUser(user);
    } else {
      emit(AuthInitial());
    }
  }
}
