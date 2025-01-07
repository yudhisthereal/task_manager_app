import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../blocs/auth/auth_bloc.dart';

class RegisterScreen extends StatelessWidget {
  final TextEditingController emailController;
  final TextEditingController passwordController;
  final TextEditingController confirmPasswordController;

  const RegisterScreen({
    super.key,
    required this.emailController,
    required this.passwordController,
    required this.confirmPasswordController,
  });

  @override
  Widget build(BuildContext context) {
    // Controllers that hold input error state
    final emailError = ValueNotifier<String?>(null);
    final passwordError = ValueNotifier<String?>(null);
    final confirmPasswordError = ValueNotifier<String?>(null);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Register'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            ValueListenableBuilder<String?>(
              valueListenable: emailError, 
              builder: (context, error, child) {
                return TextField(
                  controller: emailController,
                  decoration: InputDecoration(
                    labelText: 'Email',
                    errorText: error
                    ),
                  keyboardType: TextInputType.emailAddress,
                );
              }),
            const SizedBox(height: 16),
            ValueListenableBuilder<String?>(
              valueListenable: passwordError, 
              builder: (context, error, child) {
                return TextField(
                  controller: passwordController,
                  decoration: InputDecoration(
                    labelText: 'Password', 
                    errorText: error
                    ),
                  obscureText: true,
                );
              }),
            const SizedBox(height: 16),
            ValueListenableBuilder(
              valueListenable: confirmPasswordError, 
              builder: (context, error, child) {
                return TextField(
                  controller: confirmPasswordController,
                  decoration: InputDecoration(
                    labelText: 'Confirm Password',
                    errorText: error
                    ),
                  obscureText: true,
                );
              }),
            const SizedBox(height: 32),
            BlocConsumer<AuthBloc, AuthState>(
              listener: (context, state) {
                if (state is AuthSuccess) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Registration Successful!')),
                  );
                  Navigator.pop(context); // Navigate back to Login Screen
                } else if (state is AuthFailure) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text(state.message)),
                  );
                }
              },
              builder: (context, state) {
                if (state is AuthLoading) {
                  return const Center(child: CircularProgressIndicator());
                }
                return ElevatedButton(
                  onPressed: () {
                    final email = emailController.text.trim();
                    final password = passwordController.text.trim();
                    final confirmPassword = confirmPasswordController.text.trim();

                    bool isValid = true;
                    
                    // Validate email
                    if (email.isEmpty) {
                      emailError.value = 'Email must be filled';
                      isValid = false;
                    } else if (!EmailValidator.validate(email)) {
                      emailError.value = 'Invalid email format';
                      isValid = false;
                    } else {
                      emailError.value = null;
                    }

                    // Validate password
                    if (password.isEmpty) {
                      passwordError.value = 'Password must be filled';
                      confirmPasswordError.value = null;
                      isValid = false;
                    } else if (password != confirmPassword) {
                      passwordError.value = null;
                      confirmPasswordError.value = 'Passwords do not match';
                      isValid = false;
                    } else {
                      passwordError.value = null;
                      confirmPasswordError.value = null;
                    }

                    if (isValid) {
                      context
                          .read<AuthBloc>()
                          .add(RegisterEvent(email, password));
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Please correct the errors'))
                      );
                    }
                  },
                  child: const Text('Register'),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
