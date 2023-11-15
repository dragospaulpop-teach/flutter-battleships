import 'package:flutter/material.dart';

class NavalTextField extends StatelessWidget {
  const NavalTextField({
    super.key,
    this.label,
    this.hint,
    this.obscureText = false,
    this.validator,
    this.controller,
  });

  final TextEditingController? controller;
  final String? label;
  final String? hint;
  final bool obscureText;
  final String? Function(String?)? validator;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      decoration: InputDecoration(
          labelText: label,
          hintText: hint,
          border: const OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(10.0)),
            borderSide: BorderSide(color: Colors.grey),
          )),
      obscureText: obscureText,
      validator: validator,
    );
  }
}
