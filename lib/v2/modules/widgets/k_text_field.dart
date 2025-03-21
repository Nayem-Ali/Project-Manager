import 'package:flutter/material.dart';

class KTextField extends StatefulWidget {
  const KTextField({
    super.key,
    required this.controller,
    required this.labelText,
    required this.textInputType,
    required this.helperText,
    required this.validator,
  });

  final TextEditingController controller;
  final String labelText;
  final TextInputType textInputType;
  final String? helperText;
  final String? Function(String?) validator;

  @override
  State<KTextField> createState() => _KTextFieldState();
}

class _KTextFieldState extends State<KTextField> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0, horizontal: 2.0),
      child: TextFormField(
        controller: widget.controller,
        decoration: InputDecoration(
          border: const OutlineInputBorder(),
          labelText: widget.labelText,
          helperText: widget.helperText,
        ),
        keyboardType: widget.textInputType,
        validator: widget.validator,
      ),
    );
  }
}
