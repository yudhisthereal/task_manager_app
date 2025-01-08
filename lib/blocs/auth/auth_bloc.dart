import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:task_manager_app/blocs/auth/auth_event.dart';
import 'package:task_manager_app/blocs/auth/auth_state.dart';
import 'package:task_manager_app/data/local/shared_prefs_helper.dart';
import '../../data/repositories/auth_repository.dart';

// BLoC
class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final AuthRepository authRepository;
  final SharedPrefsHelper sharedPrefsHelper;

  AuthBloc(this.authRepository, this.sharedPrefsHelper) : super(AuthInitial()) {
    on<RegisterEvent>(_onRegister);
    on<LoginEvent>(_onLogin);
    on<ResetPasswordEvent>(_onResetPassword);
    on<LogoutEvent>(_onLogout);
  }

  void _onRegister(RegisterEvent event, Emitter<AuthState> emit) async {
    emit(AuthLoading());
    try {
      await authRepository.registerUser(event.email, event.password);
      emit(RegistrationSuccess());
    } catch (e) {
      emit(AuthFailure("Registration Failed"));
    }
  }

  void _onLogin(LoginEvent event, Emitter<AuthState> emit) async {
    emit(AuthLoading());
    try {
      final user =
          await authRepository.loginUser(event.email, event.password);
      if (user != null) {
        await sharedPrefsHelper.saveUserId(user['id']);
        emit(LoginSuccess());
      } else {
        emit(AuthFailure("Invalid Credentials"));
      }
    } catch (e) {
      emit(AuthFailure("Login Failed"));
    }
  }

  void _onLogout(LogoutEvent event, Emitter<AuthState> emit) async {
    await sharedPrefsHelper.clearUserId();
    emit(AuthInitial());
  }

  void _onResetPassword(
      ResetPasswordEvent event, Emitter<AuthState> emit) async {
    emit(AuthLoading());
    try {
      final success =
          await authRepository.resetPassword(event.email, event.newPassword);
      if (success) {
        emit(ResetPasswordSuccess());
      } else {
        emit(AuthFailure("Password Reset Failed"));
      }
    } catch (e) {
      emit(AuthFailure("Error Resetting Password"));
    }
  }
}
