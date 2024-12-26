import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_validators/form_builder_validators.dart';

class SimpleForm extends StatefulWidget {
  final void Function(String selectedOption) onSubmit;
  final dynamic user;

  const SimpleForm({Key? key, required this.onSubmit, this.user})
      : super(key: key);

  @override
  _SimpleFormState createState() => _SimpleFormState();
}

class _SimpleFormState extends State<SimpleForm> {
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
            FormBuilderDropdown<String>(
              name: 'type',
              decoration: const InputDecoration(
                labelText: 'Select Type',
                border: OutlineInputBorder(),
              ),
              items: ['Complain', 'Request']
                  .map((option) => DropdownMenuItem(
                        value: option,
                        child: Text(option),
                      ))
                  .toList(),
              validator: FormBuilderValidators.required(
                  errorText: 'This field is required'),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                if (_formKey.currentState?.saveAndValidate() ?? false) {
                  final selectedOption = _formKey.currentState?.value['type'];
                  widget.onSubmit(selectedOption!);
                }
              },
              child: const Text('Continue'),
            ),
          ],
        ),
      ),
    );
  }
}
