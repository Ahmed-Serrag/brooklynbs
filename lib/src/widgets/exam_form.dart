import 'package:brooklynbs/src/model/exam.dart';
import 'package:brooklynbs/src/provider/user_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:calendar_date_picker2/calendar_date_picker2.dart';
import 'package:intl/intl.dart';

class BookingExamForm extends ConsumerStatefulWidget {
  final String courseTitle; // Course title
  final String courseCode; // Course code

  const BookingExamForm({
    Key? key,
    required this.courseCode,
    required this.courseTitle,
  }) : super(key: key);

  @override
  ConsumerState<BookingExamForm> createState() => _BookingExamFormState();
}

class _BookingExamFormState extends ConsumerState<BookingExamForm> {
  final _formKey = GlobalKey<FormBuilderState>();

  // Track which steps are completed
  bool _isBranchSelected = false;
  bool _isDateTimeSelected = false;

  String? _selectedBranch;
  DateTime? _selectedDate;
  String? _selectedTime;

  // Branch-specific availability data
  final Map<String, Map<String, dynamic>> branchAvailability = {
    'Ramses': {
      'availableDates': _generateDates(),
      'availableTimes': [
        '1:00 PM',
        '2:00 PM',
        '3:00 PM',
        '4:00 PM',
        '5:00 PM',
      ],
    },
    'Fifth Settlement': {
      'availableDates': _generateDates(),
      'availableTimes': [
        '1:00 PM',
        '2:00 PM',
        '3:00 PM',
        '4:00 PM',
        '5:00 PM',
      ],
    },
    'Abasiya': {
      'availableDates': _generateDates(),
      'availableTimes': [
        '1:00 PM',
        '2:00 PM',
        '3:00 PM',
        '4:00 PM',
        '5:00 PM',
      ],
    },
    'Online(Outside Egypt)': {
      'availableDates': _generateDates(),
      'availableTimes': [
        '1:00 PM',
        '2:00 PM',
        '3:00 PM',
        '4:00 PM',
        '5:00 PM',
      ],
    },
    'Alexandria': {
      'availableDates': _generateDates(),
      'availableTimes': [
        '1:00 PM',
        '2:00 PM',
        '3:00 PM',
        '4:00 PM',
        '5:00 PM',
      ],
    },
  };

  static List<DateTime> _generateDates() {
    return [
      for (DateTime date = DateTime.now();
          date.isBefore(DateTime.now().add(const Duration(days: 365)));
          date = date.add(const Duration(days: 1)))
        if (date.weekday != DateTime.friday) date
    ];
  }

  @override
  Widget build(BuildContext context) {
    final user = ref.watch(userStateProvider);

    if (user == null) {
      return const Center(
        child: CircularProgressIndicator(),
      );
    }

    return Scaffold(
      backgroundColor: Theme.of(context).secondaryHeaderColor,
      appBar: AppBar(
        backgroundColor: Theme.of(context).secondaryHeaderColor,
        title: const Text('Book Exam'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: FormBuilder(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                _buildTitle('Course: ${widget.courseTitle}'),
                const SizedBox(height: 20),

                // Step 1: Branch Selection
                _buildStepCard(
                  title: 'Step 1: Select Branch',
                  child: _buildBranchSelection(),
                ),

                // Step 2: Date Picker
                if (_isBranchSelected)
                  _buildStepCard(
                    title: 'Step 2: Pick a Date',
                    child: _buildDatePicker(),
                  ),

                // Step 3: Time Picker
                if (_selectedDate != null)
                  _buildStepCard(
                    title: 'Step 3: Pick a Time',
                    child: _buildTimePicker(),
                  ),

                // Step 4: Additional Notes
                if (_isDateTimeSelected)
                  _buildStepCard(
                    title: 'Step 4: Additional Notes',
                    child: _buildNotesSection(),
                  ),

                const SizedBox(height: 20),

                // Submit Button
                if (_isDateTimeSelected) _buildSubmitButton(user),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTitle(String title) {
    return Text(
      title,
      style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
    );
  }

  Widget _buildStepCard({required String title, required Widget child}) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 10),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _buildTitle(title),
            const SizedBox(height: 10),
            child,
          ],
        ),
      ),
    );
  }

  Widget _buildBranchSelection() {
    return FormBuilderDropdown<String>(
      name: 'branch',
      focusColor: const Color.fromRGBO(118, 118, 135, 1),
      decoration: InputDecoration(
        labelText: 'Select Branch',
        border: const OutlineInputBorder(),
        enabledBorder: OutlineInputBorder(
          borderSide: const BorderSide(
            color: Color.fromRGBO(118, 118, 135, 1),
          ),
          borderRadius: BorderRadius.circular(12),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: const BorderSide(
            color: Colors.grey,
            width: 2.0,
          ),
          borderRadius: BorderRadius.circular(12),
        ),
      ),
      items: branchAvailability.keys
          .map((branch) => DropdownMenuItem(value: branch, child: Text(branch)))
          .toList(),
      validator: FormBuilderValidators.required(
        errorText: 'Branch selection is required',
      ),
      onChanged: (value) {
        setState(() {
          _selectedBranch = value;
          _isBranchSelected = value != null;
        });
      },
    );
  }

  Widget _buildDatePicker() {
    final availableDates = _selectedBranch != null
        ? branchAvailability[_selectedBranch!]!['availableDates']
        : [];

    return ElevatedButton(
      style: _buttonStyle(),
      onPressed: () => _showCalendarDatePickerDialog(availableDates),
      child: Text(
        _selectedDate == null
            ? 'Choose Date'
            : DateFormat('dd/MM/yyyy').format(_selectedDate!),
      ),
    );
  }

  void _showCalendarDatePickerDialog(List<DateTime> availableDates) async {
    final selectedDates = await showCalendarDatePicker2Dialog(
      context: context,
      config: CalendarDatePicker2WithActionButtonsConfig(
        calendarType: CalendarDatePicker2Type.single,
        selectableDayPredicate: (date) =>
            date.isAfter(DateTime.now().subtract(const Duration(days: 1))) &&
            date.isBefore(DateTime.now().add(const Duration(days: 365))) &&
            date.weekday != DateTime.friday,
        selectedDayHighlightColor: Colors.blue,
      ),
      dialogSize: const Size(355, 400),
      value: _selectedDate != null ? [_selectedDate!] : [],
    );

    if (selectedDates != null && selectedDates.isNotEmpty) {
      setState(() {
        _selectedDate = selectedDates.first;
        _isDateTimeSelected = _selectedDate != null && _selectedTime != null;
      });
    }
  }

  Widget _buildTimePicker() {
    final availableTimes = _selectedBranch != null
        ? (branchAvailability[_selectedBranch!]!['availableTimes']
                as List<dynamic>)
            .cast<String>()
        : <String>[]; // Default to an empty list if no branch is selected

    return FormBuilderDropdown<String>(
      name: 'time',
      decoration: const InputDecoration(
        labelText: 'Select Time',
        border: OutlineInputBorder(),
      ),
      items: availableTimes
          .map((time) =>
              DropdownMenuItem<String>(value: time, child: Text(time)))
          .toList(),
      validator: FormBuilderValidators.required(
        errorText: 'Time selection is required',
      ),
      onChanged: (value) {
        setState(() {
          _selectedTime = value; // Directly assign the string value
          _isDateTimeSelected = _selectedDate != null && _selectedTime != null;
        });
      },
    );
  }

  Widget _buildNotesSection() {
    return FormBuilderTextField(
      name: 'notes',
      decoration: const InputDecoration(
        labelText: 'Enter any additional notes',
        border: OutlineInputBorder(),
      ),
      maxLines: 5,
    );
  }

  Widget _buildSubmitButton(dynamic user) {
    final isFormComplete = _selectedBranch != null &&
        _selectedDate != null &&
        _selectedTime != null;

    return ElevatedButton(
      style: _buttonStyle(),
      onPressed: isFormComplete
          ? () async {
              if (_formKey.currentState?.saveAndValidate() ?? false) {
                final formData = _formKey.currentState!.value;

                // Ensure all required fields are selected
                if (_selectedBranch == null ||
                    _selectedDate == null ||
                    _selectedTime == null) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                        content: Text('Please complete all selections.')),
                  );
                  return;
                }

                final row = {
                  BookExam.ID: user.stID.toString(),
                  BookExam.Group: widget.courseCode.toString(),
                  BookExam.Module: widget.courseTitle.toString(),
                  BookExam.Date:
                      '${_selectedDate!.year}-${_selectedDate!.month}-${_selectedDate!.day}',
                  BookExam.Time: _selectedTime, // Use the string directly
                  BookExam.Branch: _selectedBranch ?? '',
                  BookExam.Notes: formData['notes'] ?? '',
                };

                // Insert booking row (API or logic to handle booking here)
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Exam Booked Successfully!')),
                );
                Navigator.pop(context);
              }
            }
          : null, // Disable button if form is incomplete
      child: const Text('Submit'),
    );
  }

  ButtonStyle _buttonStyle() {
    return ElevatedButton.styleFrom(
      backgroundColor: const Color.fromRGBO(118, 118, 135, 1),
      foregroundColor: Colors.white,
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 24),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
    );
  }
}
