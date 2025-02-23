import 'package:brooklynbs/src/provider/loading_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import '../constants/end_points.dart';

class ReusableForm extends ConsumerStatefulWidget {
  final dynamic user;

  const ReusableForm({super.key, required this.user});

  @override
  _ReusableFormState createState() => _ReusableFormState();
}

class _ReusableFormState extends ConsumerState<ReusableForm> {
  final _formKey = GlobalKey<FormBuilderState>();
  bool _isPasswordVisible = false;
  Set<String> _editableFields =
      {}; // Tracks which fields are currently editable

  Future<void> _submitEditRequests(Map<String, dynamic> updatedFields) async {
    final loader = ref.read(loadingStateProvider);
    loader.startLoader(context);

    try {
      final prefs = await SharedPreferences.getInstance();
      final String? stToken = prefs.getString('st_token');

      if (stToken == null) throw Exception('Token not found');

      List<Map<String, dynamic>> editRequests = [];

      // Loop through selected fields & create individual requests
      updatedFields.forEach((field, value) {
        if (field == 'password') {
          if (value['new'] != value['confirm']) {
            throw Exception("Passwords do not match");
          }
          editRequests.add({
            "type": "edit",
            "field": field,
            "value": value['new'],
          });
        } else {
          editRequests.add({
            "type": "edit",
            "field": field,
            "value": value,
          });
        }
      });

      for (var request in editRequests) {
        final response = await http.post(
          Uri.parse(Endpoints.request),
          headers: {
            'Content-Type': 'application/json',
            'Authorization': 'Bearer $stToken',
          },
          body: jsonEncode(request),
        );

        if (response.statusCode != 201) {
          throw Exception(
              "Failed to update ${request['field']}: ${response.body}");
        }
      }

      // Show success dialog if all requests succeed
      if (mounted) {
        loader.stopLoader(context);
        Navigator.of(context).pop();
        await showDialog(
          context: context,
          barrierDismissible: false, // Prevent accidental closing
          builder: (context) {
            return AlertDialog(
              title: const Text('Update Successful'),
              content: const Text('Your changes have been saved.'),
              actions: [
                TextButton(
                  onPressed: () => Navigator.of(context).pop(),
                  child: const Text('OK'),
                ),
              ],
            );
          },
        );
      }
    } catch (e) {
      print("Error: $e");
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(e.toString())),
        );
      }
    } finally {
      loader.stopLoader(context);
    }
  }

  void _submitChanges() {
    if (!_formKey.currentState!.saveAndValidate()) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please correct the errors in the form")),
      );
      return;
    }

    Map<String, dynamic> updatedFields = {};

    final formData = _formKey.currentState!.value;

    if (_editableFields.contains('email') &&
        formData["email"] != widget.user.email) {
      updatedFields["email"] = formData["email"];
    }

    if (_editableFields.contains('name') &&
        formData["name"] != widget.user.name) {
      updatedFields["name"] = formData["name"];
    }

    if (_editableFields.contains('phone') &&
        formData["phone"] != widget.user.phone) {
      updatedFields["phone"] = formData["phone"];
    }

    // Handle password separately
    if (_editableFields.contains('password') &&
        formData["password"] != null &&
        formData["password"].isNotEmpty &&
        formData["confirm_password"] != null &&
        formData["confirm_password"].isNotEmpty) {
      if (formData["password"] == formData["confirm_password"]) {
        updatedFields["password"] = {
          "new": formData["password"],
          "confirm": formData["confirm_password"],
        };
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Passwords do not match")),
        );
        return;
      }
    }

    if (updatedFields.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("No changes detected")),
      );
      return;
    }

    _submitEditRequests(updatedFields);
  }

  @override
  Widget build(BuildContext context) {
    final backgroundColor = Theme.of(context).cardColor;
    final textColor = Theme.of(context).textTheme.bodyLarge?.color;

    return PopScope(
        canPop: true,
        child: GestureDetector(
          onTap: () => FocusScope.of(context).unfocus(),
          child: Container(
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
                        FormBuilderValidators.required(
                            errorText: 'Name is required'),
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
                        FormBuilderValidators.numeric(
                            errorText: 'Must be numeric'),
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
                        if (value != null &&
                            value.isNotEmpty &&
                            value.length < 3) {
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
                            _formKey.currentState?.fields['password']?.value ??
                                '';
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
                      onPressed: _submitChanges,
                      child: const Text(
                        'Update',
                        style: TextStyle(fontSize: 16),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ));
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
