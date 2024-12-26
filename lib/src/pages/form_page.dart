import 'package:clean_one/src/widgets/fourm_complain.dart';
import 'package:flutter/material.dart';


class FormPage extends StatelessWidget {
  const FormPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
      backgroundColor: Colors.white,
        title: const Text('Fill Out the Form'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ReusableForm(
          onSubmit: (formData) {
            Navigator.of(context).pop(); // Go back to the previous page
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('Form Submitted: ${formData['name']}')),
            );
          },
        ),
      ),
    );
  }
}