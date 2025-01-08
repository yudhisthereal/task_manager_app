// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:task_manager_app/blocs/tasks/task_bloc.dart';
import 'package:task_manager_app/data/local/shared_prefs_helper.dart';
import 'package:task_manager_app/data/models/task.dart';
import 'package:task_manager_app/data/repositories/task_repository.dart';
import 'package:task_manager_app/screens/auth/reset_password.dart';
import 'package:task_manager_app/screens/tasks/add_edit_task_screen.dart';
import 'package:task_manager_app/screens/tasks/task_list_screen.dart';
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
    return MultiBlocProvider(
      providers: [
        BlocProvider<AuthBloc>(
          create: (context) =>
              AuthBloc(AuthRepository(), SharedPrefsHelper()),
        ),
        BlocProvider<TaskBloc>(
          create: (context) => TaskBloc(TaskRepository()),
        ),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Task Manager App',
        theme: ThemeData(primarySwatch: Colors.blue),
        home: const InitialScreen(),
        routes: {
          '/login': (context) => LoginScreen(
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
                newPasswordController: TextEditingController(),
              ),
          '/tasks': (context) => const TaskListScreen(),
          '/add-edit-task': (context) => AddEditTaskScreen(
                task: ModalRoute.of(context)?.settings.arguments as Task?,
              ),
        },
      ),
    );
  }
}

class InitialScreen extends StatelessWidget {
  const InitialScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<bool>(
      future: _checkUserLoginStatus(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }

        final bool isLoggedIn = snapshot.data ?? false;

        if (context.mounted) {
          if (isLoggedIn) {
            // Navigate directly to the task list
            Future.microtask(() => Navigator.pushReplacementNamed(context, '/tasks'));
          } else {
            // Navigate to the login screen
            Future.microtask(() => Navigator.pushReplacementNamed(context, '/login'));
          }
        }

        // Placeholder widget while navigation happens
        return const SizedBox.shrink();
      },
    );
  }

  Future<bool> _checkUserLoginStatus() async {
    final SharedPrefsHelper prefs = SharedPrefsHelper();
    final userId = await prefs.getUserId();
    return userId != null;
  }
}
