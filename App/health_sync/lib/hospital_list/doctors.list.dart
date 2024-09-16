import 'package:flutter/material.dart';
import 'package:health_sync/hospital_list/registration_form.dart'; // Import the registration form

class DoctorsList extends StatelessWidget {
  final String hospitalName;
  final String cityName; // Add cityName as a parameter

  const DoctorsList({
    Key? key,
    required this.hospitalName,
    required this.cityName, // Receive cityName in the constructor
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('$hospitalName'),
      ),
      body: ListView(
        children: [
          _buildDoctorTile(context, 'Dr. John Doe', 'Cardiologist'),
          _buildDoctorTile(context, 'Dr. Jane Smith', 'Neurologist'),
          // Add more doctor tiles here as needed
        ],
      ),
    );
  }

  // Widget to build a single doctor tile
  Widget _buildDoctorTile(BuildContext context, String doctorName, String specialization) {
    return ListTile(
      title: Text(doctorName),
      subtitle: Text(specialization),
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => RegistrationForm(
              doctorName: doctorName,
              hospitalName: hospitalName, // Pass hospitalName
              cityName: cityName, // Pass cityName
            ),
          ),
        );
      },
    );
  }
}
