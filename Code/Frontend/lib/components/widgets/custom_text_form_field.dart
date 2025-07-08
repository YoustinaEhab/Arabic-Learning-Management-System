import 'package:flutter/material.dart';
import 'package:flutter_application_1/generated/l10n.dart';

class CustomTextField extends StatefulWidget {
  final TextEditingController controller;
  final String labelText;
  final String? hintText;
  final bool isRequired;
  final TextInputType? keyboardType;
  final Widget? suffixIcon;
  final Function(String)? onChanged;
  final bool isPassword;
  final bool enabled;
  final bool isAuthField;

  const CustomTextField({
    super.key,
    required this.controller,
    required this.labelText,
    this.hintText,
    this.isRequired = false,
    this.keyboardType,
    this.suffixIcon,
    this.onChanged,
    this.isPassword = false,
    this.enabled = true,
    this.isAuthField = false,
  });

  @override
  State<CustomTextField> createState() => _CustomTextFieldState();
}

class _CustomTextFieldState extends State<CustomTextField> {

  bool _obscureText = true;
  
  @override
  Widget build(BuildContext context) {

    return TextFormField(
      controller: widget.controller,
      cursorColor: Colors.orange,
      keyboardType: widget.keyboardType,
      enabled: widget.enabled,
      decoration: InputDecoration(
        labelText: widget.labelText,
        hintText: widget.hintText,
        filled: !widget.enabled,
        fillColor: Colors.grey.shade200,
        hintStyle: const TextStyle(
            color: Colors.black26,
          ),
        enabledBorder: OutlineInputBorder(
          borderSide: const BorderSide(
            color: Colors.black12, // Default border color
          ),
          borderRadius: BorderRadius.circular(10),
        ),
        disabledBorder: OutlineInputBorder(
          borderSide: const BorderSide(color: Colors.grey),
          borderRadius: BorderRadius.circular(10),
        ),
        floatingLabelStyle: TextStyle(color: Colors.orange),
        focusColor: Colors.orange,
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.orange),
          borderRadius: BorderRadius.circular(10),
        ),
        errorBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.red),
          borderRadius: BorderRadius.circular(10),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.red),
          borderRadius: BorderRadius.circular(10),
        ),
        suffixIcon: widget.isPassword ? _buildPasswordVisibilityToggle() : widget.suffixIcon,
      ),
      validator: (value) {
        if (widget.isRequired && (value == null || value.isEmpty)) {
          return S.of(context).requiredField;
        }

        if (widget.isAuthField) {
          if (widget.keyboardType == TextInputType.emailAddress && value != null && value.isNotEmpty) {
            final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
            if (!emailRegex.hasMatch(value)) {
              return S.of(context).emailInvalid;
            }
          }
          if (widget.isPassword && value != null && value.isNotEmpty) {
            final passwordRegex = RegExp(r'^(?=.*[A-Za-z])(?=.*\d)[A-Za-z\d]{6,}$');
            if (!passwordRegex.hasMatch(value)) {
              return S.of(context).passwordInvalid;
            }
          }
        }
        return null;
      },
      onChanged: widget.onChanged,
      obscureText: widget.isPassword? _obscureText :false,
    );
  }

Widget _buildPasswordVisibilityToggle() {
    return IconButton(
      icon: Icon(
        _obscureText ? Icons.visibility_off : Icons.visibility,
        color: Colors.grey,
      ),
      onPressed: () {
        setState(() {
          _obscureText = !_obscureText;
        });
      },
    );
  }
}

