import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:health_sync/hospital_list/time_select.dart';
import 'package:supabase_flutter/supabase_flutter.dart'; // Import Supabase

class RegistrationForm extends StatefulWidget {
  final String doctorName;
  final String cityName; // Add cityName as a parameter
  final String hospitalName; // Add hospitalName as a parameter

  const RegistrationForm({
    Key? key,
    required this.doctorName,
    required this.cityName,
    required this.hospitalName,
  }) : super(key: key);

  @override
  _RegistrationFormState createState() => _RegistrationFormState();
}

class _RegistrationFormState extends State<RegistrationForm> {
  final _formKey = GlobalKey<FormState>(); // Key for form validation
  String? _selectedGender;
  String? _selectedCountry;
  String? _selectedState;
  String? _selectedDistrict;

  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _aadharController = TextEditingController();
  final TextEditingController _dobController = TextEditingController();

  final List<String> countries = ['India', 'USA', 'Canada'];
  final List<String> states = ['State 1', 'State 2', 'State 3'];
  final List<String> districts = ['District 1', 'District 2', 'District 3'];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.doctorName),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey, // Assign the GlobalKey to the Form widget
          child: ListView(
            children: [
              const Text(
                'Book Your next Appointment',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 10),
              TextFormField(
                controller: _nameController,
                decoration: InputDecoration(
                  filled: true,
                  fillColor: Colors.lightBlue[100],
                  hintText: 'Name',
                  hintStyle: const TextStyle(
                    color: Colors.grey,
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10.0),
                    borderSide: BorderSide.none,
                  ),
                  contentPadding: const EdgeInsets.symmetric(
                      horizontal: 16.0, vertical: 16.0),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your name';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 20),
              const Text(
                'Gender',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 10),
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: [
                    _buildGenderRadioButton('Male', 'Male'),
                    _buildGenderRadioButton('Female', 'Female'),
                    _buildGenderRadioButton('Transgender', 'Transgender'),
                    _buildGenderRadioButton('Other', 'Other'),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              TextFormField(
                controller: _phoneController,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  filled: true,
                  fillColor: Colors.lightBlue[100],
                  hintText: 'Mobile No',
                  hintStyle: const TextStyle(
                    color: Colors.grey,
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10.0),
                    borderSide: BorderSide.none,
                  ),
                  contentPadding: const EdgeInsets.symmetric(
                      horizontal: 16.0, vertical: 16.0),
                ),
                inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your phone number';
                  }
                  if (value.length < 10) {
                    return 'Phone number must be at least 10 digits';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 20),
              TextFormField(
                controller: _dobController,
                readOnly: true,
                decoration: InputDecoration(
                  filled: true,
                  fillColor: Colors.lightBlue[100],
                  hintText: 'Year of Birth',
                  hintStyle: const TextStyle(
                    color: Colors.grey,
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10.0),
                    borderSide: BorderSide.none,
                  ),
                  contentPadding: const EdgeInsets.symmetric(
                      horizontal: 16.0, vertical: 16.0),
                ),
                onTap: () async {
                  DateTime? pickedDate = await showDatePicker(
                    context: context,
                    initialDate: DateTime.now(),
                    firstDate: DateTime(1900),
                    lastDate: DateTime.now(),
                  );

                  if (pickedDate != null) {
                    String formattedDate =
                        "${pickedDate.year}-${pickedDate.month}-${pickedDate.day}";
                    setState(() {
                      _dobController.text = formattedDate;
                    });
                  }
                },
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please select your date of birth';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 20),
              TextFormField(
                controller: _aadharController,
                keyboardType: TextInputType.number,
                maxLength: 12,
                decoration: InputDecoration(
                  filled: true,
                  fillColor: Colors.lightBlue[100],
                  hintText: 'Aadhaar No',
                  hintStyle: const TextStyle(
                    color: Colors.grey,
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10.0),
                    borderSide: BorderSide.none,
                  ),
                  contentPadding: const EdgeInsets.symmetric(
                      horizontal: 16.0, vertical: 16.0),
                ),
                inputFormatters: [
                  FilteringTextInputFormatter.digitsOnly,
                  LengthLimitingTextInputFormatter(12),
                ],
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your Aadhaar number';
                  }
                  if (value.length != 12) {
                    return 'Aadhaar number must be 12 digits';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 20),
              DropdownButtonFormField<String>(
                value: _selectedCountry,
                hint: const Text('Country'),
                decoration: InputDecoration(
                  filled: true,
                  fillColor: Colors.lightBlue[100],
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10.0),
                    borderSide: BorderSide.none,
                  ),
                ),
                items: countries.map((country) {
                  return DropdownMenuItem<String>(
                    value: country,
                    child: Text(country),
                  );
                }).toList(),
                onChanged: (newValue) {
                  setState(() {
                    _selectedCountry = newValue;
                  });
                },
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please select a country';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 20),
              DropdownButtonFormField<String>(
                value: _selectedState,
                hint: const Text('State'),
                decoration: InputDecoration(
                  filled: true,
                  fillColor: Colors.lightBlue[100],
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10.0),
                    borderSide: BorderSide.none,
                  ),
                ),
                items: states.map((state) {
                  return DropdownMenuItem<String>(
                    value: state,
                    child: Text(state),
                  );
                }).toList(),
                onChanged: (newValue) {
                  setState(() {
                    _selectedState = newValue;
                  });
                },
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please select a state';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 20),
              DropdownButtonFormField<String>(
                value: _selectedDistrict,
                hint: const Text('District'),
                decoration: InputDecoration(
                  filled: true,
                  fillColor: Colors.lightBlue[100],
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10.0),
                    borderSide: BorderSide.none,
                  ),
                ),
                items: districts.map((district) {
                  return DropdownMenuItem<String>(
                    value: district,
                    child: Text(district),
                  );
                }).toList(),
                onChanged: (newValue) {
                  setState(() {
                    _selectedDistrict = newValue;
                  });
                },
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please select a district';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 30), // Space before the button

              // Select Time Button
              ElevatedButton(
                onPressed: () async {
                  // Validate the form fields before proceeding
                  if (_formKey.currentState?.validate() ?? false) {
                    // Collect the data from the form fields
                    final registrationData = {
                      'name': _nameController.text,
                      'phone': _phoneController.text,
                      'dob': _dobController.text,
                      'aadhar_number': _aadharController.text,
                      'gender': _selectedGender,
                      'country': _selectedCountry,
                      'state': _selectedState,
                      'district': _selectedDistrict,
                      'city': widget.cityName,
                      'hospital': widget.hospitalName,
                      'doctor': widget.doctorName,
                      'appointment_time': '', // Placeholder for time selection
                    };

                    // Navigate to TimeSelect with registration data
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => TimeSelect(
                          registrationData: registrationData,
                          onAppointmentSelected: (String appointmentDate, int selectedToken) {
                            // Handle appointment confirmation here
                            print('Appointment confirmed for date: $appointmentDate, token: $selectedToken');
                          },
                        ),
                      ),
                    );
                  }
                },
                child: const Text('Select Time'),
                style: ElevatedButton.styleFrom(
                  foregroundColor: Colors.white,
                  backgroundColor: Colors.lightBlue, // Button text color
                  padding: const EdgeInsets.symmetric(
                      vertical: 16.0), // Padding inside the button
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(
                        10.0), // Rounded corners for the button
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Helper method to build the gender radio buttons
  Widget _buildGenderRadioButton(String label, String value) {
    return Row(
      children: [
        Radio<String>(
          value: value,
          groupValue: _selectedGender,
          onChanged: (String? newValue) {
            setState(() {
              _selectedGender = newValue;
            });
          },
          activeColor: Colors.lightBlue, // Color for the selected radio button
        ),
        Text(
          label,
          style: const TextStyle(fontSize: 16),
        ),
        const SizedBox(width: 10), // Space between each radio button
      ],
    );
  }
}
