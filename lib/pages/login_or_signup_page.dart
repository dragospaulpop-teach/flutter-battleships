import 'package:flutter/material.dart';
import 'package:flutter_battleships/components/app_drawer.dart';
import 'package:flutter_battleships/components/appbar_widget.dart';
import 'package:flutter_battleships/components/login_form.dart';
import 'package:flutter_battleships/components/signup_form.dart';

class LoginOrSignupPage extends StatefulWidget {
  const LoginOrSignupPage({super.key, required this.toggleDarkMode});

  final VoidCallback? toggleDarkMode;

  @override
  State<LoginOrSignupPage> createState() => _LoginOrSignupPageState();
}

class _LoginOrSignupPageState extends State<LoginOrSignupPage> {
  String _mode = 'login';

  void switchForms() {
    setState(() {
      _mode = _mode == 'login' ? 'signup' : 'login';
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const AppbarWidget(title: 'Login or Signup'),
      drawer: AppDrawer(toggleDarkMode: widget.toggleDarkMode),
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            child: Column(children: [
              _mode == 'login'
                  ? LoginForm(switchForms: switchForms)
                  : SignupForm(switchForms: switchForms),
            ]),
          ),
        ),
      ),
    );
  }
}
