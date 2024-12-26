import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';

class ElegantMultiLineTextField extends StatelessWidget {
  final String name;
  final String labelText;
  final String? initialValue;
  final int minLines;
  final int maxLines;
  final String hintText;

  const ElegantMultiLineTextField({
    Key? key,
    required this.name,
    required this.labelText,
    this.initialValue,
    this.minLines = 3,
    this.maxLines = 8,
    this.hintText = 'Type your text here...',
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return FormBuilderTextField(
      name: name,
      initialValue: initialValue,
      minLines: minLines,
      maxLines: maxLines,
      keyboardType: TextInputType.multiline,
      decoration: InputDecoration(
        labelText: labelText,
        hintText: hintText,
        filled: true,
        fillColor: Colors.white, // Matches the solid white background
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.grey.shade300), // Subtle border
        ),
        contentPadding: const EdgeInsets.symmetric(
            vertical: 12, horizontal: 16), // Uniform padding
      ),
      style: const TextStyle(fontSize: 16, height: 1.5),
      validator: (value) {
        if (value == null || value.trim().isEmpty) {
          return 'This field is required';
        }
        return null;
      },
    );
  }
}
