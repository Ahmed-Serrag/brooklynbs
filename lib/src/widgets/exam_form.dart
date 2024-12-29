import 'package:clean_one/src/model/exam.dart';
import 'package:clean_one/src/provider/user_provider.dart';
import 'package:clean_one/src/services/exam_booking.dart';
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
  TimeOfDay? _selectedTime;

  // Branch-specific availability data
  final Map<String, Map<String, dynamic>> branchAvailability = {
    'Ramses': {
      'availableDates': [
        for (DateTime date = DateTime.now();
            date.isBefore(DateTime.now().add(Duration(days: 365)));
            date = date.add(Duration(days: 1)))
          if (date.weekday != DateTime.friday) date
      ],
      'timeRange': {
        'from': TimeOfDay(hour: 13, minute: 0),
        'to': TimeOfDay(hour: 19, minute: 0),
      }
    },
    'Fifth Settlement': {
      'availableDates': [
        for (DateTime date = DateTime.now();
            date.isBefore(DateTime.now().add(Duration(days: 365)));
            date = date.add(Duration(days: 1)))
          if (date.weekday != DateTime.friday) date
      ],
      'timeRange': {
        'from': TimeOfDay(hour: 13, minute: 0),
        'to': TimeOfDay(hour: 19, minute: 0),
      }
    },
    'Abasiya': {
      'availableDates': [
        for (DateTime date = DateTime.now();
            date.isBefore(DateTime.now().add(Duration(days: 365)));
            date = date.add(Duration(days: 1)))
          if (date.weekday != DateTime.friday) date
      ],
      'timeRange': {
        'from': TimeOfDay(hour: 13, minute: 0),
        'to': TimeOfDay(hour: 19, minute: 0),
      }
    },
    'Online(Outside Egypt)': {
      'availableDates': [
        for (DateTime date = DateTime.now();
            date.isBefore(DateTime.now().add(Duration(days: 365)));
            date = date.add(Duration(days: 1)))
          if (date.weekday != DateTime.friday) date
      ],
      'timeRange': {
        'from': TimeOfDay(hour: 13, minute: 0),
        'to': TimeOfDay(hour: 19, minute: 0),
      }
    },
  };

  void _pickTime(BuildContext context) async {
    final branchData =
        _selectedBranch != null ? branchAvailability[_selectedBranch!] : null;
    final timeRange = branchData?['timeRange'];

    if (timeRange == null) return;

    final pickedTime = await showTimePicker(
      context: context,
      initialTime: timeRange['from']!,
    );

    if (pickedTime != null) {
      final from = timeRange['from']!;
      final to = timeRange['to']!;
      if ((pickedTime.hour > from.hour ||
              (pickedTime.hour == from.hour &&
                  pickedTime.minute >= from.minute)) &&
          (pickedTime.hour < to.hour ||
              (pickedTime.hour == to.hour && pickedTime.minute <= to.minute))) {
        setState(() {
          _selectedTime = pickedTime;
          _isDateTimeSelected = true;
        });
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
                'Time must be between ${from.format(context)} and ${to.format(context)}'),
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    // Watch user data using Riverpod
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
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Display the course name
                Text(
                  'Course: ${widget.courseTitle}',
                  style: const TextStyle(
                      fontSize: 16, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 20),

                // Step 1: Branch Selection
                _buildBranchSelection(),

                // Step 2: Date Picker
                if (_isBranchSelected) _buildDatePicker(),

                // Step 3: Time Picker
                if (_selectedDate != null) _buildTimePicker(),

                // Step 4: Additional Notes
                if (_isDateTimeSelected) _buildNotesSection(),

                const SizedBox(height: 20),

                // Submit Button
                if (_isDateTimeSelected)
                  ElevatedButton(
                    onPressed: () async {
                      if (_formKey.currentState?.saveAndValidate() ?? false) {
                        final formData = _formKey.currentState!.value;

                        // Validate final selections
                        if (_selectedBranch == null ||
                            _selectedDate == null ||
                            _selectedTime == null) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                                content:
                                    Text('Please complete all selections.')),
                          );
                          return;
                        }

                        final selectedDateTime = DateTime(
                          _selectedDate!.year,
                          _selectedDate!.month,
                          _selectedDate!.day,
                          _selectedTime!.hour,
                          _selectedTime!.minute,
                        );

                        final row = {
                          BookExam.ID: user.stID.toString(),
                          BookExam.Group: widget.courseCode.toString(),
                          BookExam.Module: widget.courseTitle.toString(),
                          BookExam.Date:
                              '${_selectedDate!.year}-${_selectedDate!.month}-${_selectedDate!.day}',
                          BookExam.Time:
                              '${_selectedTime!.hour}:${_selectedTime!.minute}',
                          BookExam.Branch: _selectedBranch ?? '',
                          BookExam.Notes: formData['notes'] ?? '', // Add notes
                        };

                        await BookExamAPI.init();
                        debugPrint('Row to Submit: $row');
                        await BookExamAPI.insert([row]);

                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                              content: Text('Exam Booked Successfully!')),
                        );
                        Navigator.pop(context);
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
              .map((branch) =>
                  DropdownMenuItem(value: branch, child: Text(branch)))
              .toList(),
          validator: FormBuilderValidators.required(
              errorText: 'Branch selection is required'),
          onChanged: (value) {
            setState(() {
              _selectedBranch = value;
              _isBranchSelected = value != null;
            });
          },
        ),
        const SizedBox(height: 20),
      ],
    );
  }

  Widget _buildDatePicker() {
    final branchData =
        _selectedBranch != null ? branchAvailability[_selectedBranch!] : null;
    final availableDates = branchData?['availableDates'] ?? [];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Step 2: Pick a Date',
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 10),
        ElevatedButton(
          onPressed: () {
            _showCalendarDatePickerDialog(availableDates);
          },
          child: Text(
            _selectedDate == null
                ? 'Choose Date'
                : DateFormat('dd/MM/yyyy').format(_selectedDate!),
          ),
        ),
        const SizedBox(height: 20),
      ],
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
      });
    }
  }

  Widget _buildTimePicker() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Step 3: Pick a Time',
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 10),
        ElevatedButton(
          onPressed: () => _pickTime(context),
          child: Text(
            _selectedTime == null
                ? 'Choose Time'
                : 'Selected Time: ${_selectedTime!.format(context)}',
          ),
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
          'Step 4: Additional Notes',
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
