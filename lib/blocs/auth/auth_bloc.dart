import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import '../../data/repositories/auth_repository.dart';

// Events
abstract class AuthEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class RegisterEvent extends AuthEvent {
  final String email;
  final String password;

  RegisterEvent(this.email, this.password);

  @override
  List<Object?> get props => [email, password];
}

class LoginEvent extends AuthEvent {
  final String email;
  final String password;

  LoginEvent(this.email, this.password);

  @override
  List<Object?> get props => [email, password];
}

class ResetPasswordEvent extends AuthEvent {
  final String email;
  final String newPassword;

  ResetPasswordEvent(this.email, this.newPassword);

  @override
  List<Object?> get props => [email, newPassword];
}

// States
abstract class AuthState extends Equatable {
  @override
  List<Object?> get props => [];
}

class AuthInitial extends AuthState {}

class AuthLoading extends AuthState {}

class AuthSuccess extends AuthState {}

class AuthFailure extends AuthState {
  final String message;

  AuthFailure(this.message);

  @override
  List<Object?> get props => [message];
}

// BLoC
class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final AuthRepository authRepository;

  AuthBloc(this.authRepository) : super(AuthInitial()) {
    on<RegisterEvent>(_onRegister);
    on<LoginEvent>(_onLogin);
    on<ResetPasswordEvent>(_onResetPassword);
  }

  void _onRegister(RegisterEvent event, Emitter<AuthState> emit) async {
    emit(AuthLoading());
    try {
      await authRepository.registerUser(event.email, event.password);
      emit(AuthSuccess());
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
        emit(AuthSuccess());
      } else {
        emit(AuthFailure("Invalid Credentials"));
      }
    } catch (e) {
      emit(AuthFailure("Login Failed"));
    }
  }

  void _onResetPassword(
      ResetPasswordEvent event, Emitter<AuthState> emit) async {
    emit(AuthLoading());
    try {
      final success =
          await authRepository.resetPassword(event.email, event.newPassword);
      if (success) {
        emit(AuthSuccess());
      } else {
        emit(AuthFailure("Password Reset Failed"));
      }
    } catch (e) {
      emit(AuthFailure("Error Resetting Password"));
    }
  }
}
