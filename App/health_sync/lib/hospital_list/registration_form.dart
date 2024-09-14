import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class RegistrationForm extends StatefulWidget {
  final String doctorName;

  const RegistrationForm({Key? key, required this.doctorName}) : super(key: key);

  @override
  _RegistrationFormState createState() => _RegistrationFormState();
}

class _RegistrationFormState extends State<RegistrationForm> {
  String? _selectedGender; // To store the selected gender
  String? _selectedCountry; // To store the selected country
  String? _selectedState; // To store the selected state
  String? _selectedDistrict; // To store the selected district

  final TextEditingController _nameController = TextEditingController(); // To control the name input
  final TextEditingController _phoneController = TextEditingController(); // To control the phone number input
  final TextEditingController _aadharController = TextEditingController(); // To control the Aadhar number input
  final TextEditingController _dobController = TextEditingController(); // To display the selected date of birth

  // Lists of dummy data for the dropdowns (you can replace these with real data)
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
        padding: const EdgeInsets.all(16.0), // Adds padding around the form
        child: ListView(
          children: [
            const Text(
              'Book Your next Appointment',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 10), // Adds space between the title and the text field
            TextField(
              controller: _nameController, // Connect the controller to capture user input
              decoration: InputDecoration(
                filled: true,
                fillColor: Colors.lightBlue[100], // Light blue background for the text field
                hintText: 'Name',
                hintStyle: const TextStyle(
                  color: Colors.grey, // Light grey text color for the placeholder
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10.0), // Rounded corners for the text field
                  borderSide: BorderSide.none, // No border
                ),
                contentPadding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 16.0),
              ),
            ),
            const SizedBox(height: 20), // Adds space between the text field and gender section
            const Text(
              'Gender',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 10), // Space between label and radio buttons
            SingleChildScrollView(
              scrollDirection: Axis.horizontal, // Horizontal scrolling for radio buttons
              child: Row(
                children: [
                  _buildGenderRadioButton('Male', 'Male'),
                  _buildGenderRadioButton('Female', 'Female'),
                  _buildGenderRadioButton('Transgender', 'Transgender'),
                  _buildGenderRadioButton('Other', 'Other'),
                ],
              ),
            ),
            const SizedBox(height: 20), // Space before the phone number section
            TextField(
              controller: _phoneController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                filled: true,
                fillColor: Colors.lightBlue[100], // Light blue background for the text field
                hintText: 'Mobile No',
                hintStyle: const TextStyle(
                  color: Colors.grey, // Light grey text color for the placeholder
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10.0), // Rounded corners for the text field
                  borderSide: BorderSide.none, // No border
                ),
                contentPadding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 16.0),
              ),
              inputFormatters: [FilteringTextInputFormatter.digitsOnly], // Accept only digits
            ),
            const SizedBox(height: 20), // Space before the Date of Birth section
            TextField(
              controller: _dobController,
              readOnly: true, // Makes the field read-only
              decoration: InputDecoration(
                filled: true,
                fillColor: Colors.lightBlue[100], // Light blue background for the text field
                hintText: 'Year of Birth',
                hintStyle: const TextStyle(
                  color: Colors.grey, // Light grey text color for the placeholder
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10.0), // Rounded corners for the text field
                  borderSide: BorderSide.none, // No border
                ),
                contentPadding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 16.0),
              ),
              onTap: () async {
                DateTime? pickedDate = await showDatePicker(
                  context: context,
                  initialDate: DateTime.now(),
                  firstDate: DateTime(1900), // Earliest selectable date
                  lastDate: DateTime.now(), // Latest selectable date
                );

                if (pickedDate != null) {
                  String formattedDate = "${pickedDate.year}-${pickedDate.month}-${pickedDate.day}";
                  setState(() {
                    _dobController.text = formattedDate; // Display the selected date
                  });
                }
              },
            ),
            const SizedBox(height: 20), // Space before the Aadhar number section
            TextField(
              controller: _aadharController,
              keyboardType: TextInputType.number,
              maxLength: 12, // Limiting to 12 digits
              decoration: InputDecoration(
                filled: true,
                fillColor: Colors.lightBlue[100], // Light blue background for the text field
                hintText: 'Aadhaar No',
                hintStyle: const TextStyle(
                  color: Colors.grey, // Light grey text color for the placeholder
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10.0), // Rounded corners for the text field
                  borderSide: BorderSide.none, // No border
                ),
                contentPadding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 16.0),
              ),
              inputFormatters: [
                FilteringTextInputFormatter.digitsOnly, // Accept only digits
                LengthLimitingTextInputFormatter(12), // Limit input to 12 characters
              ],
            ),
            const SizedBox(height: 20), // Space before the dropdown menus

            // Country Dropdown
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
            ),
            const SizedBox(height: 20), // Space before the state dropdown

            // State Dropdown
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
            ),
            const SizedBox(height: 20), // Space before the district dropdown

            // District Dropdown
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
            ),
            const SizedBox(height: 30), // Space before the button

            // Select Time Button
            ElevatedButton(
              onPressed: () {
                // Add your button action here
              },
              child: const Text('Select Time'),
              
              style: ElevatedButton.styleFrom(
                foregroundColor: Colors.white, backgroundColor: Colors.lightBlue, // Button text color
                padding: const EdgeInsets.symmetric(vertical: 16.0), // Padding inside the button
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10.0), // Rounded corners for the button
                ),
              ),
            ),
          ],
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
