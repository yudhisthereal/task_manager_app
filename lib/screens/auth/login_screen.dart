import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../blocs/auth/auth_bloc.dart';

class LoginScreen extends StatelessWidget {
  final TextEditingController emailController;
  final TextEditingController passwordController;

  const LoginScreen({
    super.key,
    required this.emailController,
    required this.passwordController,
  });

  @override
  Widget build(BuildContext context) {
    // Controllers to hold the error messages
    final emailError = ValueNotifier<String?>(null);
    final passwordError = ValueNotifier<String?>(null);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Login'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Email TextField with error handling
            ValueListenableBuilder<String?>(
              valueListenable: emailError,
              builder: (context, error, child) {
                return TextField(
                  controller: emailController,
                  decoration: InputDecoration(
                    labelText: 'Email',
                    errorText: error,
                  ),
                  keyboardType: TextInputType.emailAddress,
                );
              },
            ),
            const SizedBox(height: 16),
            
            // Password TextField with error handling
            ValueListenableBuilder<String?>(
              valueListenable: passwordError,
              builder: (context, error, child) {
                return TextField(
                  controller: passwordController,
                  decoration: InputDecoration(
                    labelText: 'Password',
                    errorText: error,
                  ),
                  obscureText: true,
                );
              },
            ),
            const SizedBox(height: 32),
            
            BlocConsumer<AuthBloc, AuthState>(
              listener: (context, state) {
                if (state is LoginSuccess) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Login Successful!')),
                  );
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

                    // Validate email and password
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
                      isValid = false;
                    } else {
                      passwordError.value = null;
                    }

                    if (isValid) {
                      // Proceed with login
                      context.read<AuthBloc>().add(LoginEvent(email, password));
                    } else {
                      // Show error snackbars if needed
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Please correct the errors')),
                      );
                    }
                  },
                  child: const Text('Login'),
                );
              },
            ),
            const SizedBox(height: 16),
            TextButton(
              onPressed: () {
                Navigator.pushNamed(context, '/register');
              },
              child: const Text('Register'),
            ),
            TextButton(
              onPressed: () {
                Navigator.pushNamed(context, '/reset-password');
              },
              child: const Text('Forgot Password?'),
            ),
          ],
        ),
      ),
    );
  }
}
