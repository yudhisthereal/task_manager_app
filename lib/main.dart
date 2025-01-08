import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:task_manager_app/data/local/shared_prefs_helper.dart';
import 'package:task_manager_app/screens/auth/reset_password.dart';
import 'blocs/auth/auth_bloc.dart';
import 'data/repositories/auth_repository.dart';
import 'screens/auth/login_screen.dart';
import 'screens/auth/register_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {

  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => AuthBloc(AuthRepository(), SharedPrefsHelper()),
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Task Manager App',
        theme: ThemeData(primarySwatch: Colors.blue),
        initialRoute: '/',
        routes: {
          '/': (context) => LoginScreen(
            emailController: TextEditingController(),
            passwordController: TextEditingController(),
          ),
          '/register': (context) => RegisterScreen(
            emailController: TextEditingController(),
            passwordController: TextEditingController(),
            confirmPasswordController: TextEditingController(),
          ),
          '/reset-password': (context) => ResetPasswordScreen(
            emailController: TextEditingController(), 
            newPasswordController: TextEditingController()
          ),
        },
      ),
    );
  }
}
