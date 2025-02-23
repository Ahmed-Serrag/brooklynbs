import 'package:brooklynbs/src/pages/home.dart';
import 'package:brooklynbs/src/provider/loading_state.dart';
import 'package:brooklynbs/src/provider/user_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../constants/end_points.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CombinedForm extends ConsumerStatefulWidget {
  final dynamic user;

  const CombinedForm({Key? key, required this.user}) : super(key: key);

  @override
  _CombinedFormState createState() => _CombinedFormState();
}

class _CombinedFormState extends ConsumerState<CombinedForm> {
  final _formKey = GlobalKey<FormBuilderState>();
  String? selectedType;
  bool isStepTwoVisible = false;
  SharedPreferences? prefs;

  final List<String> dropdownOptions = [
    'Material',
    'Payment',
    'Information',
    'Instructor',
    'Online',
    'Accreditation',
    'Other',
  ];

  @override
  void initState() {
    super.initState();
    _initPrefs();
  }

  Future<void> _initPrefs() async {
    prefs = await SharedPreferences.getInstance();
    setState(() {}); // Update UI once SharedPreferences is ready
  }

  Future<void> _submitForm() async {
    if (prefs == null) {
      await _initPrefs(); // Ensure prefs is initialized
    }

    if (_formKey.currentState?.saveAndValidate() ?? false) {
      final formData = _formKey.currentState!.value;
      final token = prefs?.getString('st_token') ?? '';
      final loader = ref.read(loadingStateProvider);

      final requestData = {
        "type": formData['type'].toString(),
        "field": formData['selection'].toString(),
        "value": selectedType == 'Complaint'
            ? formData['complain_details'].toString()
            : formData['request_details'].toString(),
      };

      try {
        loader.startLoader(context);
        final response = await http.post(
          Uri.parse(Endpoints.request),
          headers: {
            'Content-Type': 'application/json',
            'Authorization': 'Bearer $token',
          },
          body: json.encode(requestData),
        );

        if (response.statusCode == 201) {
          loader.stopLoader(context);
          await showDialog(
            context: context,
            builder: (BuildContext context) => AlertDialog(
              title: const Text('Submitted Successfully'),
              content: const Text('Your submission was successful!'),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.pop(context); // Close dialog

                    // 🔹 Update Riverpod's selected index to 0 (Home)
                    ref.read(selectedIndexProvider.notifier).state = 0;

                    // 🔹 Navigate back to HomePage
                    Navigator.pushAndRemoveUntil(
                      context,
                      MaterialPageRoute(
                          builder: (context) =>
                              HomePageWithNav()), // Home with navigation bar
                      (route) => false, // Remove all previous screens
                    );
                  },
                  child: const Text('OK'),
                ),
              ],
            ),
          );
        } else {
          debugPrint('Failed to submit request: ${response.body}');
        }
      } catch (e) {
        debugPrint("Error: $e");
      } finally {}
    } else {
      debugPrint('Validation failed');
    }
  }

  @override
  Widget build(BuildContext context) {
    final currentTheme = Theme.of(context);
    final textColor = Theme.of(context).textTheme.bodyLarge?.color;
    return Container(
      decoration: BoxDecoration(
        color: currentTheme.secondaryHeaderColor, // Card background color
        borderRadius: BorderRadius.circular(26), // Rounded corners
        // boxShadow: [
        //   BoxShadow(
        //     color: Colors.black, // Light shadow
        //     blurRadius: 10,
        //     offset: const Offset(0, 4),
        //   ),
        // ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0), // Padding inside the card
        child: SingleChildScrollView(
          child: AnimatedSize(
            duration: const Duration(
                milliseconds: 300), // Animation for content resizing
            curve: Curves.easeInOut,
            child: Column(
              mainAxisSize: MainAxisSize.min, // Ensures dynamic height
              children: [
                Text(
                  'Request Form',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Theme.of(context).primaryColor,
                  ),
                ),
                const SizedBox(height: 16),
                FormBuilder(
                  key: _formKey,
                  child: Column(
                    children: [
                      FormBuilderDropdown<String>(
                        name: 'type',
                        decoration: InputDecoration(
                          labelText: 'Select Type of Request',
                          labelStyle:
                              TextStyle(color: textColor), // Label text color
                          border: const OutlineInputBorder(),
                          enabledBorder: OutlineInputBorder(
                            borderSide: const BorderSide(
                              color: Color(0xFF012868), // Enabled border color
                            ),
                            borderRadius: BorderRadius.circular(
                                12), // Match the rounded corners
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderSide: const BorderSide(
                              color: Color(0xFF012868), // Selected border color
                              width: 4, // Thickness of the selected border
                            ),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          errorBorder: OutlineInputBorder(
                            borderSide: const BorderSide(
                              color: Colors.red, // Error border color
                              width: 2,
                            ),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          focusedErrorBorder: OutlineInputBorder(
                            borderSide: const BorderSide(
                              color: Colors
                                  .redAccent, // Focused error border color
                              width: 3,
                            ),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          filled: true,
                          fillColor: Theme.of(context)
                              .secondaryHeaderColor, // Background color
                        ),
                        style:
                            TextStyle(color: textColor), // Dropdown text color
                        items: [
                          'complain',
                          'request',
                        ] // 🔥 Added more options
                            .map((option) => DropdownMenuItem(
                                  value: option,
                                  child: Text(option),
                                ))
                            .toList(),
                        initialValue: null, // Optional: Set default value
                        validator: FormBuilderValidators.compose([
                          FormBuilderValidators.required(
                              errorText: 'This field is required'),
                        ]),
                        onChanged: (value) {
                          setState(() {
                            selectedType = value;
                            isStepTwoVisible = value != null;
                          });
                        },
                        // onSaved: (value) {
                        //   print(
                        //       'Dropdown value saved: $value'); // Debugging/logging
                        // },
                        dropdownColor: Theme.of(context)
                            .secondaryHeaderColor, // Background color of dropdown list
                        icon: const Icon(Icons.arrow_drop_down,
                            color: Color(0xFF012868)), // Custom dropdown icon
                        iconSize: 30, // Size of the dropdown icon
                        // elevation: 3, // Dropdown menu shadow
                        menuMaxHeight: 300, // Max height of dropdown list
                        isExpanded:
                            true, // Ensures dropdown expands to full width
                        autofocus: false, // Disable autofocus on dropdown
                      ),
                      const SizedBox(height: 16),
                      if (isStepTwoVisible) ...[
                        FormBuilderDropdown<String>(
                          name: 'selection',
                          decoration: InputDecoration(
                            labelText: selectedType == 'complain'
                                ? 'Complaint About'
                                : 'Request About',
                            labelStyle:
                                TextStyle(color: textColor), // Label text color
                            border: const OutlineInputBorder(),
                            enabledBorder: OutlineInputBorder(
                              borderSide: const BorderSide(
                                color:
                                    Color(0xFF012868), // Enabled border color
                              ),
                              borderRadius: BorderRadius.circular(
                                  12), // Match the rounded corners
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderSide: const BorderSide(
                                color:
                                    Color(0xFF012868), // Selected border color
                                width: 4, // Thickness of the selected border
                              ),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            errorBorder: OutlineInputBorder(
                              borderSide: const BorderSide(
                                color: Colors.red, // Error border color
                                width: 2,
                              ),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            focusedErrorBorder: OutlineInputBorder(
                              borderSide: const BorderSide(
                                color: Colors
                                    .redAccent, // Focused error border color
                                width: 3,
                              ),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            filled: true,
                            fillColor: Theme.of(context)
                                .secondaryHeaderColor, // Background color
                          ),
                          style: TextStyle(
                              color: textColor), // Dropdown text color
                          items: dropdownOptions
                              .map((option) => DropdownMenuItem(
                                    value: option,
                                    child: Text(option),
                                  ))
                              .toList(),
                          validator: FormBuilderValidators.required(
                              errorText: 'Please select an option'),
                          dropdownColor: Theme.of(context)
                              .secondaryHeaderColor, // Background color of dropdown list
                          icon: const Icon(Icons.arrow_drop_down,
                              color: Color(0xFF012868)), // Custom dropdown icon
                          iconSize: 30, // Size of the dropdown icon
                          elevation: 3, // Dropdown menu shadow
                          menuMaxHeight: 300, // Max height of dropdown list
                          isExpanded:
                              true, // Ensures dropdown expands to full width
                          autofocus: false, // Disable autofocus on dropdown
                        ),
                        const SizedBox(height: 16),
                        FormBuilderTextField(
                          name: selectedType == 'Complaint'
                              ? 'complain_details'
                              : 'request_details',
                          decoration: InputDecoration(
                            labelText: selectedType == 'Complaint'
                                ? 'Complaint Details'
                                : 'Request Details',
                            labelStyle:
                                TextStyle(color: textColor), // Label text color
                            border: const OutlineInputBorder(),
                            enabledBorder: OutlineInputBorder(
                              borderSide: const BorderSide(
                                color:
                                    Color(0xFF012868), // Enabled border color
                              ),
                              borderRadius:
                                  BorderRadius.circular(12), // Rounded corners
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderSide: const BorderSide(
                                color:
                                    Color(0xFF012868), // Focused border color
                                width: 4, // Thickness of focused border
                              ),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            errorBorder: OutlineInputBorder(
                              borderSide: const BorderSide(
                                color: Colors.red, // Error border color
                                width: 2,
                              ),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            focusedErrorBorder: OutlineInputBorder(
                              borderSide: const BorderSide(
                                color: Colors
                                    .redAccent, // Focused error border color
                                width: 3,
                              ),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            filled: true,
                            fillColor: Theme.of(context)
                                .secondaryHeaderColor, // Background color
                          ),
                          maxLines:
                              null, // Allow unlimited lines for dynamic resizing
                          expands:
                              false, // Do not expand to fill the parent by default
                          keyboardType:
                              TextInputType.multiline, // Enable multiline input
                          validator: FormBuilderValidators.required(
                              errorText: 'This field is required'),
                          style: TextStyle(
                              color: textColor), // Ensure text color is visible
                          textAlignVertical:
                              TextAlignVertical.top, // Align text at the top
                          minLines: 5,
                        ),
                        const SizedBox(height: 16),
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Theme.of(context)
                                .cardColor, // Button background color
                            foregroundColor:
                                Theme.of(context).cardColor, // Text color
                            padding: const EdgeInsets.symmetric(
                                horizontal: 32, vertical: 16),
                            shape: RoundedRectangleBorder(
                              borderRadius:
                                  BorderRadius.circular(12), // Rounded corners
                            ),
                          ),
                          onPressed: _submitForm,
                          child: Text('Submit',
                              style: TextStyle(
                                  color: Theme.of(context).primaryColor)),
                        ),
                      ],
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
