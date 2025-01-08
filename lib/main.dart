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
          create: (context) => AuthBloc(AuthRepository(), SharedPrefsHelper())
        ),
        BlocProvider<TaskBloc>(
          create: (context) => TaskBloc(TaskRepository())
        )
      ],
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
          '/tasks' : (context) => const TaskListScreen(),
          '/add-edit-task': (context) => AddEditTaskScreen(
            task: ModalRoute.of(context)?.settings.arguments as Task?
          )
        },
      ),
    );
  }
}
