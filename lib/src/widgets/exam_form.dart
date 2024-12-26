import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_validators/form_builder_validators.dart';

class BookingExamForm extends StatefulWidget {
  final String course; // Pass the course name
  const BookingExamForm({Key? key, required this.course}) : super(key: key);

  @override
  State<BookingExamForm> createState() => _BookingExamFormState();
}

class _BookingExamFormState extends State<BookingExamForm> {
  final _formKey = GlobalKey<FormBuilderState>();

  // Track which steps are completed
  bool _isBranchSelected = false;
  bool _isDateTimeSelected = false;

  String? _selectedBranch;
  DateTime? _selectedDateTime;

  // Example data for branch-specific availability
  final Map<String, List<DateTime>> branchAvailability = {
    'Branch 1': [DateTime(2024, 1, 1, 9), DateTime(2024, 1, 1, 11)],
    'Branch 2': [DateTime(2024, 1, 2, 10), DateTime(2024, 1, 2, 14)],
    'Branch 3': [DateTime(2024, 1, 3, 12), DateTime(2024, 1, 3, 16)],
  };

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Book Exam'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: FormBuilder(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Display the course name
                Text(
                  'Course: ${widget.course}',
                  style: const TextStyle(
                      fontSize: 16, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 20),

                // Step 1: Branch Selection
                _buildBranchSelection(),

                // Step 2: Date and Time Picker
                if (_isBranchSelected) _buildDateTimePicker(),

                // Step 3: Additional Notes
                if (_isDateTimeSelected) _buildNotesSection(),

                const SizedBox(height: 20),

                // Submit Button
                if (_isDateTimeSelected)
                  ElevatedButton(
                    onPressed: () {
                      if (_formKey.currentState?.saveAndValidate() ?? false) {
                        final formData = _formKey.currentState!.value;
                        debugPrint(formData.toString());
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                              content: Text('Exam Booked Successfully!')),
                        );
                        Navigator.pop(context); // Go back to the previous page
                      }
                    },
                    child: const Text('Submit'),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildBranchSelection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Step 1: Select Branch',
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 10),
        FormBuilderDropdown<String>(
          name: 'branch',
          decoration: const InputDecoration(
            labelText: 'Select Branch',
            border: OutlineInputBorder(),
          ),
          items: branchAvailability.keys
              .map((branch) => DropdownMenuItem(
                    value: branch,
                    child: Text(branch),
                  ))
              .toList(),
          validator: FormBuilderValidators.required(
              errorText: 'Branch selection is required'),
          onChanged: (value) {
            setState(() {
              _selectedBranch = value; // Update the selected branch
              _isBranchSelected = value != null; // Mark step as completed
            });
          },
        ),
        const SizedBox(height: 20),
      ],
    );
  }

  Widget _buildDateTimePicker() {
    final availableDates =
        _selectedBranch != null ? branchAvailability[_selectedBranch!]! : [];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Step 2: Pick a Date and Time',
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 10),
        FormBuilderDateTimePicker(
          name: 'date_time',
          initialEntryMode: DatePickerEntryMode.calendar,
          inputType: InputType.both, // Allows date and time selection
          enabled: availableDates.isNotEmpty,
          firstDate: DateTime.now(),
          lastDate: DateTime(2024, 12, 31),
          decoration: const InputDecoration(
            labelText: 'Choose a Date and Time',
            border: OutlineInputBorder(),
          ),
          validator: FormBuilderValidators.required(
              errorText: 'Please pick a date and time'),
          onChanged: (value) {
            setState(() {
              _selectedDateTime = value;
              _isDateTimeSelected = value != null; // Mark step as completed
            });
          },
        ),
        const SizedBox(height: 20),
      ],
    );
  }

  Widget _buildNotesSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Step 3: Additional Notes',
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 10),
        FormBuilderTextField(
          name: 'notes',
          decoration: const InputDecoration(
            labelText: 'Enter any additional notes',
            border: OutlineInputBorder(),
          ),
          maxLines: 5,
        ),
        const SizedBox(height: 20),
      ],
    );
  }
}
