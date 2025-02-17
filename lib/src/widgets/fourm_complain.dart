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
  Set<String> _editableFields =
      {}; // Tracks which fields are currently editable

  Future<void> _submitUpdate() async {
    if (_formKey.currentState?.saveAndValidate() ?? false) {
      final formData = _formKey.currentState!.value;

      final Map<String, dynamic> updatedFields = {};
      if (_editableFields.contains('name') &&
          formData['name'] != widget.user.name) {
        updatedFields['name'] = formData['name'];
      } else if (_editableFields.contains('name')) {
        updatedFields['name'] = null; // Set to null if not changed
      }

      if (_editableFields.contains('email') &&
          formData['email'] != widget.user.email) {
        updatedFields['email'] = formData['email'];
      } else if (_editableFields.contains('email')) {
        updatedFields['email'] = null; // Set to null if not changed
      }

      if (_editableFields.contains('phone') &&
          formData['phone'] != widget.user.phone) {
        updatedFields['phone'] = formData['phone'];
      } else if (_editableFields.contains('phone')) {
        updatedFields['phone'] = null; // Set to null if not changed
      }

      if (_editableFields.contains('password') &&
          formData['password'].isNotEmpty) {
        updatedFields['password'] = formData['password'];
      } else if (_editableFields.contains('password')) {
        updatedFields['password'] = null; // Set to null if not changed
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
              _buildEditableField(
                context,
                fieldName: 'name',
                label: 'Name',
                validator: FormBuilderValidators.compose([
                  FormBuilderValidators.required(errorText: 'Name is required'),
                  FormBuilderValidators.minLength(3,
                      errorText: 'Min 3 characters'),
                ]),
              ),
              const SizedBox(height: 16),

              // Email Field
              _buildEditableField(
                context,
                fieldName: 'email',
                label: 'Email',
                validator: FormBuilderValidators.compose([
                  FormBuilderValidators.required(
                      errorText: 'Email is required'),
                  FormBuilderValidators.email(
                      errorText: 'Invalid email address'),
                ]),
              ),
              const SizedBox(height: 16),

              // Phone Field
              _buildEditableField(
                context,
                fieldName: 'phone',
                label: 'Phone',
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
              _buildEditableField(
                context,
                fieldName: 'password',
                label: 'Password',
                obscureText: !_isPasswordVisible,
                validator: (value) {
                  if (value != null && value.isNotEmpty && value.length < 3) {
                    return 'Password must be at least 8 characters long';
                  }
                  return null;
                },
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
              const SizedBox(height: 16),

              // Confirm Password Field
              FormBuilderTextField(
                name: 'confirm_password',
                decoration: InputDecoration(
                  filled: true,
                  fillColor: Theme.of(context).secondaryHeaderColor,
                  labelText: 'Confirm Password',
                  labelStyle: TextStyle(color: textColor),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: const BorderSide(
                      color: Color(0xFF012868),
                    ),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: const BorderSide(
                      color: Color(0xFF012868),
                    ),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: const BorderSide(
                      color: Color(0xFF012868),
                      width: 2,
                    ),
                  ),
                  suffixIcon: Icon(
                    _isPasswordVisible
                        ? Icons.visibility
                        : Icons.visibility_off,
                    color: Colors.grey,
                  ),
                ),
                obscureText: !_isPasswordVisible,
                enabled: _editableFields.contains('password'),
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

  Widget _buildEditableField(
    BuildContext context, {
    required String fieldName,
    required String label,
    FormFieldValidator<String>? validator,
    bool obscureText = false,
    Widget? suffixIcon,
  }) {
    return Row(
      children: [
        Expanded(
          child: FormBuilderTextField(
            name: fieldName,
            decoration: InputDecoration(
              filled: true,
              fillColor: Theme.of(context).secondaryHeaderColor,
              labelText: label,
              labelStyle: TextStyle(
                  color: Theme.of(context).textTheme.bodyLarge?.color),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: const BorderSide(
                  color: Color(0xFF012868),
                ),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: const BorderSide(
                  color: Color(0xFF012868),
                ),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: const BorderSide(
                  color: Color(0xFF012868),
                  width: 2,
                ),
              ),
              suffixIcon:
                  suffixIcon, // For additional icons (e.g., password visibility toggle)
            ),
            obscureText: obscureText,
            enabled: _editableFields
                .contains(fieldName), // Enable the field only when editing
            validator: validator,
          ),
        ),
        const SizedBox(
            width: 8), // Add spacing between the field and the edit button
        IconButton(
          icon: Icon(
            _editableFields.contains(fieldName) ? Icons.check : Icons.edit,
            color: Colors.blue,
          ),
          onPressed: () {
            setState(() {
              if (_editableFields.contains(fieldName)) {
                _editableFields
                    .remove(fieldName); // Disable editing for this field
              } else {
                _editableFields.add(fieldName); // Enable editing for this field
              }
            });
          },
        ),
      ],
    );
  }
}
