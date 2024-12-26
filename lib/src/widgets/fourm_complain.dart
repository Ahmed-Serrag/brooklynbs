import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_validators/form_builder_validators.dart';


class ReusableForm extends StatefulWidget {
  final void Function(Map<String, dynamic> formData) onSubmit;

  const ReusableForm({Key? key, required this.onSubmit}) : super(key: key);

  @override
  _ReusableFormState createState() => _ReusableFormState();
}

class _ReusableFormState extends State<ReusableForm> {
  final _formKey = GlobalKey<FormBuilderState>();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: FormBuilder(
        key: _formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Name Field
            FormBuilderTextField(
              name: 'name',
              decoration: const InputDecoration(
                labelText: 'Name',
                border: OutlineInputBorder(),
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
              decoration: const InputDecoration(
                labelText: 'Email',
                border: OutlineInputBorder(),
              ),
              validator: FormBuilderValidators.compose([
                FormBuilderValidators.required(errorText: 'Email is required'),
                FormBuilderValidators.email(errorText: 'Invalid email address'),
              ]),
            ),
            const SizedBox(height: 16),

            // Phone Field
            FormBuilderTextField(
              name: 'phone',
              decoration: const InputDecoration(
                labelText: 'Phone',
                border: OutlineInputBorder(),
              ),
              validator: FormBuilderValidators.compose([
                FormBuilderValidators.required(errorText: 'Phone is required'),
                FormBuilderValidators.numeric(errorText: 'Must be numeric'),
                FormBuilderValidators.minLength(10, errorText: 'Min 10 digits'),
              ]),
            ),
            const SizedBox(height: 16),

            // Gender Dropdown
            FormBuilderDropdown<String>(
              name: 'gender',
              decoration: const InputDecoration(
                labelText: 'Gender',
                border: OutlineInputBorder(),
              ),
              items: ['Male', 'Female', 'Other']
                  .map((gender) => DropdownMenuItem(
                        value: gender,
                        child: Text(gender),
                      ))
                  .toList(),
              validator: FormBuilderValidators.required(
                  errorText: 'Gender is required'),
            ),
            const SizedBox(height: 16),

            // Submit Button
            ElevatedButton(
              onPressed: () {
                if (_formKey.currentState?.saveAndValidate() ?? false) {
                  final formData = _formKey.currentState!.value;
                  widget.onSubmit(formData);
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Validation failed!')),
                  );
                }
              },
              child: const Text('Submit'),
            ),
          ],
        ),
      ),
    );
  }
}
