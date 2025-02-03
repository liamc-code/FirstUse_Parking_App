import 'package:flutter/material.dart';
import 'package:reactive_forms/reactive_forms.dart';
import '../models/user.dart';
import '../services/database_helper.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'map.dart'; // Import the map screen

class MyReactiveForm extends StatefulWidget {
  const MyReactiveForm({super.key});

  @override
  State<MyReactiveForm> createState() => MyReactiveFormState();
}

class MyReactiveFormState extends State<MyReactiveForm> {
  final DatabaseHelper dbHelper = DatabaseHelper();

  // String variables
  String firstName = '';
  String lastName = '';
  String email = '';
  String telephone = '';
  String licensePlate = '';
  DateTime startDate = DateTime.now();
  int nightsRemaining = 15;
  String selectedAddress = 'No location selected'; // Default value
  String displayMsg = ''; // Message for dialog confirmation

  User newUser = User('', '', '', '', DateTime.now(), 15, '', 0);

  final formGroup = FormGroup({
    'firstName':
        FormControl<String>(value: '', validators: [Validators.required]),
    'lastName':
        FormControl<String>(value: '', validators: [Validators.required]),
    'email': FormControl<String>(
        value: '', validators: [Validators.required, Validators.email]),
    'telephone': FormControl<String>(
        value: '',
        validators: [Validators.required, Validators.pattern(r'^\d{10}$')]),
    'licensePlate':
        FormControl<String>(value: '', validators: [Validators.required]),
    'startDate': FormControl<DateTime>(value: DateTime.now()),
    'numberOfNights': FormControl<int>(value: 1),
    'parkingLocation': FormControl<String>(value: 'No location selected'),
  });

  void setFormValues() {
    if (formGroup.valid) {
      firstName = formGroup.control('firstName').value;
      lastName = formGroup.control('lastName').value;
      email = formGroup.control('email').value;
      telephone = formGroup.control('telephone').value;
      licensePlate = formGroup.control('licensePlate').value;
      startDate = formGroup.control('startDate').value;
      nightsRemaining = formGroup.control('numberOfNights').value;

      newUser = User(firstName, lastName, email, telephone, startDate,
          nightsRemaining, licensePlate, 0);
    }
  }

  void sendData() async {
    if (formGroup.valid) {
      final url = 'https://jsonplaceholder.typicode.com/posts';
      setFormValues();
      setState(() {
        displayMsg = '''
First Name: $firstName
Last Name: $lastName
Email: $email
Telephone: $telephone
License Plate: $licensePlate
Parking Date and Time: $startDate
Nights Remaining: $nightsRemaining
Parking Location: $selectedAddress''';
      });
      final body = {
        'firstName': firstName,
        'lastName': lastName,
        'email': email,
        'telephone': telephone,
        'licensePlate': licensePlate,
        'startDate': startDate.toString(),
        'nightsRemaining': nightsRemaining,
        'parkingLocation': selectedAddress,
      };

      final response = await http.post(
        Uri.parse(url),
        body: jsonEncode(body),
        headers: {'Content-Type': 'application/json'},
      );

      if(!mounted) return;

      if (response.statusCode == 201) {
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: const Text(
              'Registration Successful',
              textAlign: TextAlign.center,
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            content: SingleChildScrollView(
              child: Text(
                displayMsg,
                style: const TextStyle(
                  fontSize: 16,
                  height: 1.5,
                  fontFamily: 'monospace',
                ),
              ),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(),
                child: const Text('OK'),
              ),
            ],
          ),
        );
      } else {
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: const Text('Registration Failed'),
            content: Text(displayMsg),
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: ReactiveForm(
            formGroup: formGroup,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // App Title and Logo
                Center(
                  child: Column(
                    children: [
                      const Text(
                        'FU Parking',
                        style: TextStyle(
                          fontSize: 48,
                          color: Color(0xFF8B9EFF),
                          fontWeight: FontWeight.w900,
                        ),
                      ),
                      const SizedBox(height: 16),
                      Image.asset(
                        'assets/images/minimalcar.png',
                        height: 100,
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 32),

                // Form Fields
                ReactiveTextField(
                  formControlName: 'firstName',
                  decoration: const InputDecoration(labelText: 'First Name'),
                  validationMessages: {
                    ValidationMessage.required: (_) => 'First name is required',
                  },
                ),
                const SizedBox(height: 16),
                ReactiveTextField(
                  formControlName: 'lastName',
                  decoration: const InputDecoration(labelText: 'Last Name'),
                  validationMessages: {
                    ValidationMessage.required: (_) => 'Last name is required',
                  },
                ),
                const SizedBox(height: 16),
                ReactiveTextField(
                  formControlName: 'email',
                  decoration: const InputDecoration(labelText: 'Email'),
                  keyboardType: TextInputType.emailAddress,
                  validationMessages: {
                    ValidationMessage.required: (_) => 'Email is required',
                    ValidationMessage.email: (_) => 'Enter a valid email',
                  },
                ),
                const SizedBox(height: 16),
                ReactiveTextField(
                  formControlName: 'telephone',
                  decoration: const InputDecoration(labelText: 'Telephone'),
                  keyboardType: TextInputType.phone,
                  validationMessages: {
                    ValidationMessage.required: (_) => 'Telephone is required',
                    ValidationMessage.pattern: (_) =>
                        'Enter a valid 10-digit telephone number',
                  },
                ),
                const SizedBox(height: 16),
                ReactiveTextField(
                  formControlName: 'licensePlate',
                  decoration: const InputDecoration(labelText: 'License Plate'),
                  textCapitalization: TextCapitalization.characters,
                  validationMessages: {
                    ValidationMessage.required: (_) =>
                        'License plate is required',
                  },
                ),
                const SizedBox(height: 16),

                // Date Picker and Number of Nights
                Row(
                  children: [
                    Expanded(
                      flex: 60,
                      child: GestureDetector(
                        onTap: () async {
                          final form = ReactiveForm.of(context) as FormGroup?;
                          final DateTime? picked = await showDatePicker(
                            context: context,
                            initialDate: form?.control('startDate').value ??
                                DateTime.now(),
                            firstDate: DateTime(2024),
                            lastDate: DateTime.now().add(const Duration(
                                days: 365)), // Set last date to 1 year from now
                            helpText: 'Select Start Date for Overnight Parking',
                          );
                          if (picked != null) {
                            (form?.control('startDate') as FormControl).value =
                                DateTime(
                              picked.year,
                              picked.month,
                              picked.day,
                            );
                          }
                        },
                        child: ReactiveDatePicker<DateTime>(
                          formControlName: 'startDate',
                          firstDate: DateTime.now(),
                          lastDate:
                              DateTime.now().add(const Duration(days: 365)),
                          builder: (context, picker, child) {
                            return InputDecorator(
                              decoration: const InputDecoration(
                                labelText: 'Start Date',
                                suffixIcon: Icon(Icons.calendar_today),
                              ),
                              child: Text(
                                picker.value != null
                                    ? '${picker.value!.month.toString().padLeft(2, '0')}/${picker.value!.day.toString().padLeft(2, '0')}/${picker.value!.year}'
                                    : 'Select Date',
                              ),
                            );
                          },
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      flex: 40, // 40% width for nights dropdown
                      child: ReactiveDropdownField<int>(
                        formControlName: 'numberOfNights',
                        items: List.generate(15, (index) => index + 1)
                            .map((days) => DropdownMenuItem(
                                  value: days,
                                  child: Text('$days'),
                                ))
                            .toList(),
                        decoration: const InputDecoration(
                          labelText: 'Nights',
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),

                // Select Parking Location
                ElevatedButton(
                  onPressed: () async {
                    final result = await Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const MapScreen(),
                      ),
                    );
                    if (result != null) {
                      setState(() {
                        selectedAddress = result;
                        formGroup.control('parkingLocation').value = result;
                      });
                    }
                  },
                  child: const Text(
                    'Select Parking Location',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                ),
                const SizedBox(height: 16),

                // Display Selected Address
                Row(
                  children: [
                    const Icon(Icons.location_pin, color: Colors.red),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        selectedAddress,
                        style: const TextStyle(fontSize: 16),
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 32),

                // Register Button
                ReactiveFormConsumer(
                  builder: (context, form, child) {
                    return ElevatedButton(
                      onPressed: form.valid
                          ? () {
                              setFormValues();
                              sendData();
                            }
                          : null,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFFE69D72),
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      child: const Text(
                        'Register',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
