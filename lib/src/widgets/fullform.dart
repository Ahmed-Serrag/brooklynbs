import 'package:brooklynbs/src/services/auth.dart';
import 'package:brooklynbs/src/widgets/text_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../constants/end_points.dart';

class CompleteForm extends StatefulWidget {
  final String type;
  final dynamic user;

  const CompleteForm({Key? key, required this.type, required this.user})
      : super(key: key);

  @override
  State<CompleteForm> createState() => _CompleteFormState();
}

class _CompleteFormState extends State<CompleteForm> {
  final _formKey = GlobalKey<FormBuilderState>();

  final List<String> dropdownOptions = [
    'Material',
    'Payment',
    'Information',
    'Instructor',
    'Online',
    'Accreditation',
    'Other',
  ];

  Future<void> _submitForm() async {
    final token = await AuthService().getToken();
    if (_formKey.currentState?.saveAndValidate() ?? false) {
      final formData = _formKey.currentState!.value;

      // Combine form data with user data
      final requestData = {
        "data": {
          "student_num": widget.user.stID, // Example user property
          "name": widget.user.name,
          "message": widget.type == 'Complaint'
              ? formData['complain_details']
              : formData['request_details'],
          "type": widget.type,
          "Email": widget.user.email,
          "phone": widget.user.phone,
          "GroupID": formData['selection'],
        },
      };

      try {
        // Post the data to your API endpoint
        final response = await http.post(
          Uri.parse(Endpoints.request), // Replace with your API URL
          headers: {
            'Content-Type': 'application/json',
            'Authorization': 'Bearer $token',
          },
          body: jsonEncode(requestData),
        );

        if (response.statusCode == 200) {
          await showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                title: const Text('Success'),
                content: const Text('Your submission was successful!'),
                actions: [
                  TextButton(
                    onPressed: () {
                      Navigator.pop(context); // Close the dialog
                      Navigator.pop(context); // Close the form
                    },
                    child: const Text('OK'),
                  ),
                ],
              );
            },
          );
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('Submission failed: ${response.body}')));
          print('Submission failed: ${response.body} ');
        }
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: $e')),
        );
        print('Error: $e');
      }
    } else {
      debugPrint('Validation failed');
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context); // Fetch theme for consistent styling

    return Scaffold(
      backgroundColor: Theme.of(context).secondaryHeaderColor,
      appBar: AppBar(
        backgroundColor: Theme.of(context).secondaryHeaderColor,
        title: Text(
          widget.type == 'Complaint'
              ? 'Submit a Complaint'
              : 'Submit a Request',
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 30),
        child: FormBuilder(
          key: _formKey,
          onChanged: () {
            _formKey.currentState?.save();
          },
          autovalidateMode: AutovalidateMode.disabled,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Title
              Text(
                'Please fill out the form below',
                style: theme.textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 20),

              // Name Field
              // FormBuilderTextField(
              //   name: 'name',
              //   initialValue: widget.user.name, // Auto-fill with user name
              //   decoration: InputDecoration(
              //     labelText: 'Name',
              //     hintText: 'Enter your name',
              //     prefixIcon: const Icon(Icons.person_outline),
              //     border: OutlineInputBorder(
              //       borderRadius: BorderRadius.circular(12),
              //     ),
              //     filled: true,
              //     fillColor: theme.cardColor,
              //   ),
              //   validator: FormBuilderValidators.required(
              //       errorText: 'Name is required'),
              // ),
              const SizedBox(height: 16),

              // Student ID Field
              // FormBuilderTextField(
              //   name: 'student_id',
              //   initialValue: widget.user.stID, // Auto-fill with user ID
              //   decoration: InputDecoration(
              //     labelText: 'Student ID',
              //     hintText: 'Enter your student ID',
              //     prefixIcon: const Icon(Icons.credit_card),
              //     border: OutlineInputBorder(
              //       borderRadius: BorderRadius.circular(12),
              //     ),
              //     filled: true,
              //     fillColor: theme.cardColor,
              //   ),
              //   validator: FormBuilderValidators.required(
              //       errorText: 'Student ID is required'),
              // ),
              const SizedBox(height: 16),

              // Email Field
              // FormBuilderTextField(
              //   name: 'email',
              //   initialValue: widget.user.email, // Auto-fill with user email
              //   decoration: InputDecoration(
              //     labelText: 'Email',
              //     hintText: 'Enter your email',
              //     prefixIcon: const Icon(Icons.email_outlined),
              //     border: OutlineInputBorder(
              //       borderRadius: BorderRadius.circular(12),
              //     ),
              //     filled: true,
              //     fillColor: theme.cardColor,
              //   ),
              //   validator: FormBuilderValidators.compose([
              //     FormBuilderValidators.required(
              //         errorText: 'Email is required'),
              //     FormBuilderValidators.email(
              //         errorText: 'Enter a valid email address'),
              //   ]),
              // ),
              const SizedBox(height: 16),

              // Phone Field
              // FormBuilderTextField(
              //   name: 'phone',
              //   initialValue: widget.user.phone, // Auto-fill with user phone
              //   decoration: InputDecoration(
              //     labelText: 'Phone',
              //     hintText: 'Enter your phone number',
              //     prefixIcon: const Icon(Icons.phone_outlined),
              //     border: OutlineInputBorder(
              //       borderRadius: BorderRadius.circular(12),
              //     ),
              //     filled: true,
              //     fillColor: theme.cardColor,
              //   ),
              //   validator: FormBuilderValidators.compose([
              //     FormBuilderValidators.required(
              //         errorText: 'Phone number is required'),
              //     FormBuilderValidators.numeric(
              //         errorText: 'Enter a valid phone number'),
              //     FormBuilderValidators.minLength(10,
              //         errorText: 'Minimum 10 digits required'),
              //   ]),
              // ),
              // const SizedBox(height: 16),

              // Dropdown Field
              FormBuilderDropdown<String>(
                name: 'selection',
                style: TextStyle(color: theme.textTheme.bodyMedium?.color),
                decoration: InputDecoration(
                  labelText: widget.type == 'Complaint'
                      ? 'Complaint About'
                      : 'Request About',
                  filled: true,
                  fillColor: theme
                      .secondaryHeaderColor, // Matches the solid white background
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(
                        color: Colors.grey.shade300), // Subtle border
                  ),
                  contentPadding:
                      const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                ),
                items: dropdownOptions
                    .map((option) => DropdownMenuItem(
                          value: option,
                          child: Text(option),
                        ))
                    .toList(),
                validator: FormBuilderValidators.required(
                    errorText: 'Please select an option'),
              ),
              const SizedBox(height: 16),

              // Complain or Request Details Field
              if (widget.type == 'Complaint') ...[
                ElegantMultiLineTextField(
                  name: 'complain_details',
                  labelText: 'Complain Details',
                  hintText: 'Type your complain details here...',
                ),
              ] else ...[
                ElegantMultiLineTextField(
                  name: 'request_details',
                  labelText: 'Request Details',
                  hintText: 'Type your request details here...',
                ),
              ],
              const SizedBox(height: 16),

              // Preferred Date Field

              const SizedBox(height: 30),

              // Submit and Reset Buttons
              Row(
                children: <Widget>[
                  Expanded(
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      onPressed: _submitForm,
                      child: const Text(
                        'Submit',
                        style: TextStyle(fontSize: 16),
                      ),
                    ),
                  ),
                  const SizedBox(width: 20),
                  Expanded(
                    child: OutlinedButton(
                      style: OutlinedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        side: BorderSide(color: theme.primaryColor),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      onPressed: () {
                        _formKey.currentState?.reset();
                      },
                      child: const Text(
                        'Reset',
                        style: TextStyle(fontSize: 16),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
