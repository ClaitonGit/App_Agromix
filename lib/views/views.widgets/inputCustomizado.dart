import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class inputCustomizado extends StatelessWidget {
  final TextEditingController controller;
  final String hint;
  final bool obscure;
  final bool autofocus;
  final TextInputType type;
  final int maxLines;
  final List<TextInputFormatter> inputFormatters;
  final FormFieldValidator<String>? validator;
  final void Function(String?)? onSaved;

  inputCustomizado(
      {required this.controller,
      required this.hint,
      this.obscure = false,
      this.autofocus = false,
      this.type = TextInputType.text,
      required this.maxLines,
        this.validator,
        required List inputFormaterrs,
        this.onSaved,
        required this.inputFormatters
      });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: this.controller,
      obscureText: this.obscure,
      autofocus: this.autofocus,
      keyboardType: this.type,
      validator: this.validator,
      onSaved: this.onSaved,
      maxLines: this.maxLines,
      style: TextStyle(fontSize: 20),
      decoration: InputDecoration(
          contentPadding: EdgeInsets.fromLTRB(32, 16, 32, 16),
          hintText: this.hint,
          filled: true,
          fillColor: Colors.white,
          border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(6),
              borderSide: BorderSide( color: Colors.orange)
      )
      ),
          cursorColor: Colors.orangeAccent,


    );
  }
}
