import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../services/end_points.dart';

class CombinedForm extends StatefulWidget {
  final dynamic user;

  const CombinedForm({Key? key, required this.user}) : super(key: key);

  @override
  _CombinedFormState createState() => _CombinedFormState();
}

class _CombinedFormState extends State<CombinedForm> {
  final _formKey = GlobalKey<FormBuilderState>();
  String? selectedType;
  bool isStepTwoVisible = false;

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
    if (_formKey.currentState?.saveAndValidate() ?? false) {
      final formData = _formKey.currentState!.value;

      final requestData = {
        "data": {
          "student_num": widget.user.stID,
          "name": widget.user.name,
          "message": selectedType == 'Complaint'
              ? formData['complain_details']
              : formData['request_details'],
          "type": selectedType,
          "Email": widget.user.email,
          "phone": widget.user.phone,
          "GroupID": formData['selection'],
        },
      };

      try {
        final response = await http.post(
          Uri.parse(Endpoints.request),
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
                content: const Text('Your submission was successful!'),
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
              SnackBar(content: Text('Submission failed: ${response.body}')));
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
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: SingleChildScrollView(
        child: FormBuilder(
          key: _formKey,
          child: Column(
            children: [
              // Step 1: Type Selection
              FormBuilderDropdown<String>(
                name: 'type',
                decoration: const InputDecoration(
                  labelText: 'Select Type',
                  border: OutlineInputBorder(),
                ),
                items: ['Complaint', 'Request']
                    .map((option) => DropdownMenuItem(
                          value: option,
                          child: Text(option),
                        ))
                    .toList(),
                validator: FormBuilderValidators.required(
                    errorText: 'This field is required'),
                onChanged: (value) {
                  setState(() {
                    selectedType = value;
                    isStepTwoVisible = value != null;
                  });
                },
              ),
              const SizedBox(height: 16),

              // Step 2: Conditional Fields
              if (isStepTwoVisible) ...[
                FormBuilderDropdown<String>(
                  name: 'selection',
                  decoration: InputDecoration(
                    labelText: selectedType == 'Complaint'
                        ? 'Complaint About'
                        : 'Request About',
                    border: OutlineInputBorder(),
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
                if (selectedType == 'Complaint')
                  FormBuilderTextField(
                    name: 'complain_details',
                    decoration: const InputDecoration(
                      labelText: 'Complain Details',
                      border: OutlineInputBorder(),
                    ),
                    maxLines: 5,
                    validator: FormBuilderValidators.required(
                        errorText: 'This field is required'),
                  )
                else if (selectedType == 'Request')
                  FormBuilderTextField(
                    name: 'request_details',
                    decoration: const InputDecoration(
                      labelText: 'Request Details',
                      border: OutlineInputBorder(),
                    ),
                    maxLines: 5,
                    validator: FormBuilderValidators.required(
                        errorText: 'This field is required'),
                  ),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: _submitForm,
                  child: const Text('Submit'),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
