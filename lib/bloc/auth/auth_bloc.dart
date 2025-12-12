import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../data/models/user_model.dart';
import '../../data/services/auth_service.dart';

part 'auth_event.dart';
part 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  AuthBloc() : super(AuthInitial()) {
    on<AuthLogin>((event, emit) async {
      emit(AuthLoading());
      final result = await AuthService().login(
        email: event.email,
        password: event.password,
      );
      result.fold(
        (error) => emit(AuthFailed(error)),
        (data) => emit(AuthSuccess(data)),
      );
    });

    on<AuthLogout>((event, emit) async {
      emit(AuthLoading());
      final result = await AuthService().logout();
      result.fold(
        (error) => emit(AuthLogoutFailed(error)),
        (data) => emit(AuthLogoutSuccess()),
      );
    });
  }
}
