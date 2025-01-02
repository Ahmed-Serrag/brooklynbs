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
  bool _isInitialized = false;
  // Track which steps are completed
  bool _isBranchSelected = false;
  bool _isDateTimeSelected = false;

  String? _selectedBranch;
  DateTime? _selectedDate;
  TimeOfDay? _selectedTime;

  @override
  void initState() {
    super.initState();
    _initializeGoogleSheets();
  }

  void _initializeGoogleSheets() async {
    final success = await BookExamAPI.init();
    setState(() {
      _isInitialized = success;
    });
    if (!success) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Failed to initialize Google Sheets.')),
      );
    }
  }

  // Branch-specific availability data
  final Map<String, Map<String, dynamic>> branchAvailability = {
    'Ramses': {
      'availableDates': _generateDates(),
      'timeRange': {
        'from': TimeOfDay(hour: 13, minute: 0),
        'to': TimeOfDay(hour: 19, minute: 0)
      },
    },
    'Fifth Settlement': {
      'availableDates': _generateDates(),
      'timeRange': {
        'from': TimeOfDay(hour: 13, minute: 0),
        'to': TimeOfDay(hour: 19, minute: 0)
      },
    },
    'Abasiya': {
      'availableDates': _generateDates(),
      'timeRange': {
        'from': TimeOfDay(hour: 13, minute: 0),
        'to': TimeOfDay(hour: 19, minute: 0)
      },
    },
    'Online(Outside Egypt)': {
      'availableDates': _generateDates(),
      'timeRange': {
        'from': TimeOfDay(hour: 13, minute: 0),
        'to': TimeOfDay(hour: 19, minute: 0)
      },
    },
  };

  static List<DateTime> _generateDates() {
    return [
      for (DateTime date = DateTime.now();
          date.isBefore(DateTime.now().add(Duration(days: 365)));
          date = date.add(Duration(days: 1)))
        if (date.weekday != DateTime.friday) date
    ];
  }

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
      });
    }
  }

  Widget _buildTimePicker() {
    return ElevatedButton(
      style: _buttonStyle(),
      onPressed: () => _pickTime(context),
      child: Text(
        _selectedTime == null
            ? 'Choose Time'
            : 'Selected Time: ${_selectedTime!.format(context)}',
      ),
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
    return ElevatedButton(
      style: _buttonStyle(),
      onPressed: _isInitialized
          ? () async {
              if (_formKey.currentState?.saveAndValidate() ?? false) {
                final formData = _formKey.currentState!.value;

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
                  BookExam.Time:
                      '${_selectedTime!.hour}:${_selectedTime!.minute}',
                  BookExam.Branch: _selectedBranch ?? '',
                  BookExam.Notes: formData['notes'] ?? '',
                };

                await BookExamAPI.insert([row]);

                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Exam Booked Successfully!')),
                );
                Navigator.pop(context);
              }
            }
          : null, // Disable button if not initialized
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
