import 'package:flutter/material.dart';

class ChangeUserDetailsPopup extends StatefulWidget {
  const ChangeUserDetailsPopup({super.key});

  @override
  _ChangeUserDetailsPopupState createState() => _ChangeUserDetailsPopupState();
}

class _ChangeUserDetailsPopupState extends State<ChangeUserDetailsPopup> {
  int _currentStep = 0;
  bool? isEmailSelected;
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();

  Widget _buildSelectionStep() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        const Text(
          'What would you like to change?',
          style: TextStyle(
            fontSize: 18.0,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 20),
        RadioListTile<bool>(
          title: const Text('Change Email'),
          value: true,
          groupValue: isEmailSelected,
          onChanged: (bool? value) {
            setState(() {
              isEmailSelected = value ?? false;
            });
          },
        ),
        RadioListTile<bool>(
          title: const Text('Change Password'),
          value: false,
          groupValue: isEmailSelected,
          onChanged: (bool? value) {
            setState(() {
              isEmailSelected = value ?? true;
            });
          },
        ),
        const SizedBox(height: 20),
        ElevatedButton(
          onPressed: () {
            setState(() {
              _currentStep = 1;
            });
          },
          child: const Text('Next'),
        ),
      ],
    );
  }

  Widget _buildChangeDetailsStep() {
    // Helper to validate password matching
    bool isPasswordMatching() {
      return _passwordController.text == _confirmPasswordController.text;
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(
          'Enter your ${isEmailSelected == true ? 'Email' : 'Password'}:',
          style: const TextStyle(
            fontSize: 18.0,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 20),
        // Email Field (Single TextField)
        isEmailSelected == true
            ? TextField(
                controller: _emailController,
                decoration: const InputDecoration(
                  hintText: 'Enter new email address',
                ),
              )
            // Password Fields (New Password + Confirm Password)
            : Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  TextField(
                    controller: _passwordController,
                    obscureText: true,
                    decoration: const InputDecoration(
                      hintText: 'Enter new password',
                    ),
                  ),
                  const SizedBox(height: 20),
                  TextField(
                    controller: _confirmPasswordController,
                    obscureText: true,
                    decoration: const InputDecoration(
                      hintText: 'Confirm your new password',
                    ),
                  ),
                  const SizedBox(height: 20),
                  // Display error if passwords don't match
                  if (_passwordController.text.isNotEmpty &&
                      _confirmPasswordController.text.isNotEmpty &&
                      !isPasswordMatching())
                    const Text(
                      'Passwords do not match.',
                      style: TextStyle(color: Colors.red),
                    ),
                ],
              ),
        const SizedBox(height: 20),
        ElevatedButton(
          onPressed: () {
            if (isEmailSelected == true) {
              // Handle email request to admin
              Navigator.of(context).pop(); // Close the dialog after saving
            } else {
              // Check if passwords match before submitting
              if (isPasswordMatching()) {
                Navigator.of(context).pop(); // Close the dialog after saving
              } else {
                // Optionally show a snackbar or other feedback
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Please make sure the passwords match'),
                  ),
                );
              }
            }
          },
          child: const Text('Save'),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16.0),
      ),
      child: ConstrainedBox(
        constraints: const BoxConstraints(
          maxWidth: 400, // Maximum width for the dialog
          maxHeight: 400, // Maximum height for the dialog
        ),
        child: SingleChildScrollView(
          child: Container(
            padding: const EdgeInsets.all(20.0),
            child: _currentStep == 0
                ? _buildSelectionStep()
                : _buildChangeDetailsStep(),
          ),
        ),
      ),
    );
  }
}
