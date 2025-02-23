import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:brooklynbs/src/pages/login.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';

class ResetPasswordPage extends ConsumerStatefulWidget {
  final String token;
  final String email;

  const ResetPasswordPage({required this.token, required this.email, Key? key})
      : super(key: key);

  @override
  _ResetPasswordPageState createState() => _ResetPasswordPageState();
}

class _ResetPasswordPageState extends ConsumerState<ResetPasswordPage> {
  final _formKey = GlobalKey<FormBuilderState>();
  bool _isPasswordVisible = false;
  bool _isLoading = false;

  Future<void> resetPassword() async {
    if (_formKey.currentState?.saveAndValidate() ?? false) {
      final formData = _formKey.currentState!.value;

      final password = formData['password'];
      final confirmPassword = formData['confirm_password'];

      if (password != confirmPassword) {
        _showMessage("Passwords do not match", isError: true);
        return;
      }

      setState(() => _isLoading = true);

      try {
        final response = await http.post(
          Uri.parse(
              "https://shark-app-s8ndy.ondigitalocean.app/api/students/reset-password"),
          headers: {"Content-Type": "application/json"},
          body: jsonEncode({
            "email": widget.email,
            "password": password,
            "password_confirmation": confirmPassword,
            "token": widget.token,
          }),
        );

        final data = jsonDecode(response.body);
        if (response.statusCode == 200) {
          _showMessage("Password reset successful!");
          await Future.delayed(const Duration(seconds: 2));
          if (mounted) {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => const LoginPage()),
            );
          }
        } else {
          _showMessage(data["message"] ?? "Something went wrong",
              isError: true);
        }
      } catch (e) {
        _showMessage("An error occurred. Please try again.", isError: true);
      } finally {
        if (mounted) setState(() => _isLoading = false);
      }
    }
  }

  void _showMessage(String message, {bool isError = false}) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: isError ? Colors.red : Colors.green,
      ),
    );
  }

  // Handle back button press
  Future<bool> _onWillPop() async {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => const LoginPage()),
    );
    return false; // Prevent default back button behavior
  }

  @override
  Widget build(BuildContext context) {
    final backgroundColor = Theme.of(context).cardColor;
    final textColor = Theme.of(context).textTheme.bodyLarge?.color;

    return PopScope(
      canPop: false, // Prevent default back button behavior
      onPopInvoked: (didPop) {
        if (didPop) return;
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const LoginPage()),
        );
      },
      child: Scaffold(
        backgroundColor: backgroundColor,
        appBar: AppBar(
          title: const Text("Reset Password"),
          backgroundColor: backgroundColor,
        ),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: FormBuilder(
            key: _formKey,
            initialValue: {
              'email': widget.email,
              'password': '',
              'confirm_password': '',
            },
            child: Column(
              children: [
                Text(
                  "Reset Password for ${widget.email}",
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: textColor,
                  ),
                ),
                const SizedBox(height: 16),

                // Password Field
                _buildPasswordField(context, 'password', 'New Password'),
                const SizedBox(height: 16),

                // Confirm Password Field
                _buildPasswordField(
                    context, 'confirm_password', 'Confirm Password'),
                const SizedBox(height: 20),

                _isLoading
                    ? const CircularProgressIndicator()
                    : ElevatedButton(
                        onPressed: resetPassword,
                        child: const Text("Reset Password"),
                      ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildPasswordField(
      BuildContext context, String fieldName, String label) {
    return FormBuilderTextField(
      name: fieldName,
      obscureText: !_isPasswordVisible,
      decoration: InputDecoration(
        filled: true,
        fillColor: Theme.of(context).secondaryHeaderColor,
        labelText: label,
        labelStyle:
            TextStyle(color: Theme.of(context).textTheme.bodyLarge?.color),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Color(0xFF012868)),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Color(0xFF012868)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Color(0xFF012868), width: 2),
        ),
        suffixIcon: IconButton(
          icon: Icon(
            _isPasswordVisible ? Icons.visibility : Icons.visibility_off,
            color: Colors.grey,
          ),
          onPressed: () {
            setState(() {
              _isPasswordVisible = !_isPasswordVisible;
            });
          },
        ),
      ),
      validator:
          FormBuilderValidators.required(errorText: '$label is required'),
    );
  }
}
