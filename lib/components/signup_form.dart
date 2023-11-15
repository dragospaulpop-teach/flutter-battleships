import 'package:flutter/material.dart';
import 'package:flutter_battleships/components/naval_text_field.dart';
import 'package:flutter_battleships/state/auth_notifier.dart';
import 'package:provider/provider.dart';

class SignupForm extends StatefulWidget {
  const SignupForm({super.key, required this.switchForms});

  final VoidCallback switchForms;

  @override
  State<SignupForm> createState() => _SignupFormState();
}

class _SignupFormState extends State<SignupForm> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final _usernameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _passwordMatchController = TextEditingController();

  @override
  void dispose() {
    _usernameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _passwordMatchController.dispose();
    super.dispose();
  }

  void logIn() async {
    if (_formKey.currentState!.validate()) {
      final authProvider = Provider.of<AuthNotifier>(context, listen: false);
      try {
        await authProvider.signUp(
            email: _emailController.text,
            password: _passwordController.text,
            username: _usernameController.text);
      } catch (e) {
        if (!mounted) return;

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(e.toString()),
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Form(
        key: _formKey,
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.account_circle, size: 100),
              const SizedBox(height: 24),
              NavalTextField(
                controller: _usernameController,
                label: 'Username',
                hint: 'Enter your username',
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your username';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              NavalTextField(
                controller: _emailController,
                label: 'Email',
                hint: 'Enter your email',
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your email';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              NavalTextField(
                controller: _passwordController,
                label: 'Password',
                hint: 'Enter your password',
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your password';
                  }
                  return null;
                },
                obscureText: true,
              ),
              const SizedBox(height: 16),
              NavalTextField(
                controller: _passwordMatchController,
                label: 'Password confirm',
                hint: 'Enter your password again',
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your password';
                  } else if (value != _passwordController.text) {
                    return 'Passwords do not match';
                  }
                  return null;
                },
                obscureText: true,
              ),
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: () => logIn(),
                child: const Text('Create account'),
              ),
              const SizedBox(height: 32),
              const Text('Already have an account?'),
              TextButton(
                  child: const Text('Authenticate'),
                  onPressed: () => widget.switchForms())
            ],
          ),
        ),
      ),
    );
  }
}
