import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:brooklynbs/src/services/auth.dart';
import 'package:brooklynbs/src/pages/home.dart';

class LoginPage extends ConsumerStatefulWidget {
  const LoginPage({super.key});

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends ConsumerState<LoginPage> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _idController = TextEditingController();
  bool _isLoading = false;

  Future<void> _handleLogin() async {
    final email = _emailController.text.trim();
    final password = _passwordController.text.trim();

    if (email.isEmpty || password.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Email and password cannot be empty')),
      );
      return;
    }

    setState(() {
      _isLoading = true;
    });

    final errorMessage = await AuthService().login(
      emailOrId: email,
      password: password,
      ref: ref,
    );

    setState(() {
      _isLoading = false;
    });

    if (errorMessage != null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(errorMessage)),
      );
    } else {
      // After login, navigate to home page
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const HomePageWithNav()),
      );
    }
  }

  void _showForgotPasswordDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Enter ID to Reset Password'),
          content: TextField(
            controller: _idController,
            decoration: const InputDecoration(hintText: "Enter your ID"),
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
              },
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                final id = _idController.text.trim();
                if (id.isNotEmpty) {
                  sendPasswordToUserEmail(id);
                  Navigator.of(context).pop(); // Close the dialog
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Password reset email sent!')),
                  );
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('ID cannot be empty')),
                  );
                }
              },
              child: const Text('Send Reset Email'),
            ),
          ],
        );
      },
    );
  }

  bool _isPasswordVisible = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset:
          true, // Adjust content when the keyboard is open
      backgroundColor:
          Theme.of(context).dialogBackgroundColor, // Background color
      body: SafeArea(
        child: Column(
          children: [
            // Logo Section (Fixed)
            Container(
              padding: const EdgeInsets.all(16.0),
              child: const Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image(
                    image: AssetImage('assets/images/logo.png'),
                    height: 150,
                  ),
                  SizedBox(height: 16),
                  Text(
                    'Brooklyn Business School',
                    style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF012868),
                    ),
                  ),
                  SizedBox(height: 8),
                ],
              ),
            ),

            // White container for Login Form and Footer
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(16.0),
                child: Container(
                  padding: const EdgeInsets.all(20.0),
                  decoration: BoxDecoration(
                    color: Theme.of(context).cardColor,
                    borderRadius: BorderRadius.circular(25),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.1),
                        spreadRadius: 5,
                        blurRadius: 7,
                        offset: const Offset(0, 3), // Shadow position
                      ),
                    ],
                  ),
                  child: Column(
                    children: [
                      // Email Field
                      TextField(
                        keyboardType: TextInputType.emailAddress,
                        controller: _emailController,
                        decoration: InputDecoration(
                          filled: true,
                          fillColor: Theme.of(context)
                              .secondaryHeaderColor, // Subtle background color
                          labelText: 'Email or ID', // Elegant label text
                          labelStyle: TextStyle(
                            color: Theme.of(context)
                                .primaryColorLight, // Use main text color
                            fontWeight: FontWeight.w500,
                            fontSize: 16,
                          ),
                          hintText:
                              'Enter your email or ID', // Elegant hint text
                          hintStyle: TextStyle(
                            color: Theme.of(context).primaryColorLight,
                            fontSize: 14,
                            fontWeight: FontWeight.w400,
                          ),
                          border: OutlineInputBorder(),
                          enabledBorder: OutlineInputBorder(
                            borderSide: const BorderSide(
                              color:
                                  Color(0xFFB0BEC5), // Light, soft border color
                              width:
                                  1.5, // Slightly thinner border for elegance
                            ),
                            borderRadius: BorderRadius.circular(
                                12), // Refined rounded corners
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderSide: const BorderSide(
                              color: Color(
                                  0xFF012868), // Focused color to stand out
                              width: 2.5, // Slightly thicker on focus
                            ),
                            borderRadius: BorderRadius.circular(
                                12), // Consistent corner radius
                          ),
                          contentPadding: EdgeInsets.symmetric(
                              vertical: 16, horizontal: 12),
                        ),
                      ),
                      const SizedBox(height: 16),

// Password Field
                      TextField(
                        controller: _passwordController,
                        obscureText: _isPasswordVisible,
                        decoration: InputDecoration(
                          filled: true,
                          fillColor: Theme.of(context)
                              .secondaryHeaderColor, // Subtle background color
                          labelText: 'Password', // Elegant label text
                          labelStyle: TextStyle(
                            color: Theme.of(context)
                                .primaryColorLight, // Main text color
                            fontWeight: FontWeight.w500,
                            fontSize: 16,
                          ),
                          hintText: 'Enter your password', // Elegant hint text
                          hintStyle: TextStyle(
                            color: Theme.of(context).primaryColorLight,
                            fontSize: 14,
                            fontWeight: FontWeight.w400,
                          ),
                          border: OutlineInputBorder(),
                          enabledBorder: OutlineInputBorder(
                            borderSide: const BorderSide(
                              color:
                                  Color(0xFFB0BEC5), // Light, soft border color
                              width:
                                  1.5, // Slightly thinner border for elegance
                            ),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderSide: const BorderSide(
                              color: Color(
                                  0xFF012868), // Focused color to stand out
                              width: 2.5, // Slightly thicker on focus
                            ),
                            borderRadius: BorderRadius.circular(
                                12), // Consistent corner radius
                          ),
                          contentPadding: EdgeInsets.symmetric(
                              vertical: 16, horizontal: 12),
                          suffixIcon: IconButton(
                            icon: Icon(
                              _isPasswordVisible
                                  ? Icons.visibility
                                  : Icons.visibility_off,
                              color: Colors.grey,
                            ),
                            onPressed: () {
                              setState(() {
                                _isPasswordVisible = !_isPasswordVisible;
                              });
                            },
                          ),
                        ),
                      ),

                      const SizedBox(height: 20),

                      // Sign In Button
                      GestureDetector(
                        onTap: _isLoading ? null : _handleLogin,
                        child: Container(
                          width: double.infinity,
                          height: 50,
                          decoration: BoxDecoration(
                            color: const Color(0xFF012868),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Center(
                            child: _isLoading
                                ? const CircularProgressIndicator(
                                    valueColor:
                                        AlwaysStoppedAnimation(Colors.white),
                                  )
                                : const Text(
                                    "Sign In",
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),

                      // Forgot Password Link
                      GestureDetector(
                        onTap: _showForgotPasswordDialog,
                        child: Text(
                          'Forgot Password?',
                          style: TextStyle(
                            color: Theme.of(context).primaryColorLight,
                            fontWeight: FontWeight.bold,
                            decoration: TextDecoration.underline,
                          ),
                        ),
                      ),
                      SizedBox(height: 20),
                      Text(
                        'Copyright 2024',
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.grey,
                        ),
                      ),
                      Text(
                        '© Brooklyn Academy',
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.grey,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
