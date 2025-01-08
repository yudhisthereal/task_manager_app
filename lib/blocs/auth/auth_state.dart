
// States
import 'package:equatable/equatable.dart';

abstract class AuthState extends Equatable {
  @override
  List<Object?> get props => [];
}

class AuthInitial extends AuthState {}

class AuthLoading extends AuthState {}

class AuthFailure extends AuthState {
  final String message;

  AuthFailure(this.message);

  @override
  List<Object?> get props => [message];
}

class LoginSuccess extends AuthState {}
class RegistrationSuccess extends AuthState {}
class ResetPasswordSuccess extends AuthState {}
class LogoutSuccess extends AuthState {}