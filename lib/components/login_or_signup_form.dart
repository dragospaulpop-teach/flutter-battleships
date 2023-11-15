import 'package:flutter/material.dart';
import 'package:flutter_battleships/components/login_form.dart';
import 'package:flutter_battleships/components/signup_form.dart';

class LoginOrSignupForm extends StatefulWidget {
  const LoginOrSignupForm({super.key});

  @override
  State<LoginOrSignupForm> createState() => _LoginOrSignupFormState();
}

class _LoginOrSignupFormState extends State<LoginOrSignupForm> {
  String _mode = 'login';

  void switchForms() {
    setState(() {
      _mode = _mode == 'login' ? 'signup' : 'login';
    });
  }

  @override
  Widget build(BuildContext context) {
    return _mode == 'login'
        ? LoginForm(switchForms: switchForms)
        : SignupForm(switchForms: switchForms);
  }
}
