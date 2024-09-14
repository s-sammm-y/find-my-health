import 'package:flutter/material.dart';

class CityHospitalList extends StatelessWidget {
  final String cityName; // The city name passed from the previous page

  const CityHospitalList({required this.cityName, super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        // Dynamically show the city name in the AppBar title
        title: Text('Hospitals in $cityName'),
        backgroundColor: Colors.lightBlue, // Customize as needed
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'List of hospitals in $cityName',
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const Padding(
              padding: EdgeInsets.all(16.0),
              child: Text(
                'Here will be the list of hospitals for the selected city.',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 16),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
