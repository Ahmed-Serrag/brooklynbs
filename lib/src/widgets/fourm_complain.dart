import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../constants/end_points.dart';

class ReusableForm extends StatefulWidget {
  final dynamic user; // Expecting the full user object

  const ReusableForm({Key? key, required this.user}) : super(key: key);

  @override
  _ReusableFormState createState() => _ReusableFormState();
}

class _ReusableFormState extends State<ReusableForm> {
  final _formKey = GlobalKey<FormBuilderState>();
  bool _isPasswordVisible = false;

  Future<void> _submitUpdate() async {
    if (_formKey.currentState?.saveAndValidate() ?? false) {
      final formData = _formKey.currentState!.value;

      final Map<String, dynamic> updatedFields = {};
      if (formData['name'] != null && formData['name'] != widget.user.name) {
        updatedFields['name'] = formData['name'];
      }
      if (formData['email'] != null && formData['email'] != widget.user.email) {
        updatedFields['email'] = formData['email'];
      }
      if (formData['phone'] != null && formData['phone'] != widget.user.phone) {
        updatedFields['phone'] = formData['phone'];
      }
      if (formData['password'] != null && formData['password'].isNotEmpty) {
        updatedFields['password'] = formData['password'];
      }

      // Final request data
      final requestData = {
        "data": {
          "student_num": widget.user.stID, // Always include this
          ...updatedFields, // Include only updated fields
        },
      };
      if (updatedFields.isEmpty) {
        await showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: const Text('No Changes'),
              content: const Text('No changes were made to the form.'),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: const Text('OK'),
                ),
              ],
            );
          },
        );
        return; // Exit the method without submitting
      }

      try {
        final response = await http.post(
          Uri.parse(Endpoints.userUpdate),
          headers: {
            'Content-Type': 'application/json',
            'Authorization': 'Bearer ${Endpoints.reqToken}',
          },
          body: jsonEncode(requestData),
        );

        if (response.statusCode == 200) {
          await showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                title: const Text('Success'),
                content: const Text(
                    'Your updates were successful! \n will be updated after checking.'),
                actions: [
                  TextButton(
                    onPressed: () {
                      Navigator.pop(context);
                      Navigator.pop(context);
                    },
                    child: const Text('OK'),
                  ),
                ],
              );
            },
          );
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Submission failed: ${response.body}')),
          );
        }
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: $e')),
        );
      }
    } else {
      debugPrint('Validation failed');
    }
  }

  @override
  Widget build(BuildContext context) {
    final backgroundColor = Theme.of(context).cardColor;
    final textColor = Theme.of(context).textTheme.bodyLarge?.color;

    return Container(
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 10,
            offset: Offset(0, 5),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: FormBuilder(
          key: _formKey,
          initialValue: {
            'name': widget.user.name ?? '',
            'email': widget.user.email ?? '',
            'phone': widget.user.phone ?? '',
          },
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Title
              Text(
                'Edit Profile',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: textColor,
                ),
              ),
              const SizedBox(height: 16),

              // Name Field
              FormBuilderTextField(
                name: 'name',
                decoration: InputDecoration(
                  filled: true,
                  fillColor: Theme.of(context).secondaryHeaderColor,
                  labelText: 'Name',
                  labelStyle: TextStyle(color: textColor),
                  border: const OutlineInputBorder(),
                  enabledBorder: OutlineInputBorder(
                    borderSide: const BorderSide(
                      color: const Color(0xFF012868),
                    ),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: const BorderSide(
                      color: Color(0xFF012868), // Selected border color
                      width: 4, // Thickness of the selected border
                    ),
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                validator: FormBuilderValidators.compose([
                  FormBuilderValidators.required(errorText: 'Name is required'),
                  FormBuilderValidators.minLength(3,
                      errorText: 'Min 3 characters'),
                ]),
              ),
              const SizedBox(height: 16),

              // Email Field
              FormBuilderTextField(
                name: 'email',
                decoration: InputDecoration(
                  filled: true,
                  fillColor: Theme.of(context).secondaryHeaderColor,
                  labelText: 'Email',
                  labelStyle: TextStyle(color: textColor),
                  border: const OutlineInputBorder(),
                  enabledBorder: OutlineInputBorder(
                    borderSide: const BorderSide(
                      color: const Color(0xFF012868),
                    ),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: const BorderSide(
                      color: Color(0xFF012868), // Selected border color
                      width: 4, // Thickness of the selected border
                    ),
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                validator: FormBuilderValidators.compose([
                  FormBuilderValidators.required(
                      errorText: 'Email is required'),
                  FormBuilderValidators.email(
                      errorText: 'Invalid email address'),
                ]),
              ),
              const SizedBox(height: 16),

              // Phone Field
              FormBuilderTextField(
                name: 'phone',
                decoration: InputDecoration(
                  filled: true,
                  fillColor: Theme.of(context).secondaryHeaderColor,
                  labelText: 'Phone',
                  labelStyle: TextStyle(color: textColor),
                  border: const OutlineInputBorder(),
                  enabledBorder: OutlineInputBorder(
                    borderSide: const BorderSide(
                      color: const Color(0xFF012868),
                    ),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: const BorderSide(
                      color: Color(0xFF012868), // Selected border color
                      width: 4, // Thickness of the selected border
                    ),
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                validator: FormBuilderValidators.compose([
                  FormBuilderValidators.required(
                      errorText: 'Phone is required'),
                  FormBuilderValidators.numeric(errorText: 'Must be numeric'),
                  FormBuilderValidators.minLength(10,
                      errorText: 'Min 10 digits'),
                ]),
              ),
              const SizedBox(height: 16),

              // Password Field
              FormBuilderTextField(
                name: 'password',
                decoration: InputDecoration(
                  filled: true,
                  fillColor: Theme.of(context).secondaryHeaderColor,
                  labelText: 'Password',
                  labelStyle: TextStyle(
                      color: Theme.of(context).textTheme.bodyLarge?.color),
                  border: const OutlineInputBorder(),
                  enabledBorder: OutlineInputBorder(
                    borderSide: const BorderSide(
                      color: const Color(0xFF012868),
                    ),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: const BorderSide(
                      color: Color(0xFF012868), // Selected border color
                      width: 4, // Thickness of the selected border
                    ),
                    borderRadius: BorderRadius.circular(12),
                  ),
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
                obscureText: !_isPasswordVisible,
                validator: (value) {
                  if (value != null && value.isNotEmpty && value.length < 3) {
                    return 'Password must be at least 8 characters long';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              FormBuilderTextField(
                name: 'confirm_password',
                decoration: InputDecoration(
                  filled: true,
                  fillColor: Theme.of(context).secondaryHeaderColor,
                  labelText: 'Re-Type Password',
                  labelStyle: TextStyle(
                      color: Theme.of(context).textTheme.bodyLarge?.color),
                  border: const OutlineInputBorder(),
                  enabledBorder: OutlineInputBorder(
                    borderSide: const BorderSide(
                      color: const Color(0xFF012868),
                    ),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: const BorderSide(
                      color: Color(0xFF012868), // Selected border color
                      width: 4, // Thickness of the selected border
                    ),
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                obscureText: !_isPasswordVisible,
                onChanged: (value) {
                  _formKey.currentState?.fields['confirm_password']?.validate();
                },
                validator: (value) {
                  final passwordValue =
                      _formKey.currentState?.fields['password']?.value ?? '';
                  if (passwordValue.isNotEmpty) {
                    if (value == null || value.isEmpty) {
                      return 'Please re-type your password';
                    } else if (value != passwordValue) {
                      return 'Passwords do not match';
                    }
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),

              // Submit Button
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(
                      vertical: 14.0, horizontal: 32.0),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                onPressed: _submitUpdate,
                child: const Text(
                  'Update',
                  style: TextStyle(fontSize: 16),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
