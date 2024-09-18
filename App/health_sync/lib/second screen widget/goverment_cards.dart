import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart'; // Supabase package

class GovernmentHospitalCard extends StatefulWidget {
  const GovernmentHospitalCard({super.key});

  @override
  State<GovernmentHospitalCard> createState() => _GovernmentHospitalCardState();
}

class _GovernmentHospitalCardState extends State<GovernmentHospitalCard> {
  int availableBeds = 0;
  int totalBeds = 0;
  String errorMessage = '';

  @override
  void initState() {
    super.initState();
    fetchAvailableBeds(); // Fetch the bed data when the widget is initialized
  }

  Future<void> fetchAvailableBeds() async {
    try {
      final response = await Supabase.instance.client
          .from('bed')
          .select('bed_id')
          .eq('empty', true); // Query for beds where empty is true

      if (response.isNotEmpty) {
        // Count the number of true rows
        setState(() {
          availableBeds =
              response.length; // Update availableBeds with count of true
        });
      } else {
        // If there's an error in the response
        setState(() {
          errorMessage = 'Error fetching bed data: $response';
        });
      }
    } catch (e) {
      // Catch any exceptions that occur during the query
      setState(() {
        errorMessage = 'An unexpected error occurred: $e';
      });
    }
    try {
      final response2 = await Supabase.instance.client.from('bed').select('*');

      if (response2.isNotEmpty) {
        // Count the number of true rows
        setState(() {
          totalBeds =
              response2.length; // Update totalBeds with count of all beds
        });
      } else {
        // If there's an error in the response
        setState(() {
          errorMessage = 'Error fetching bed data: $response2';
        });
      }
    } catch (e) {
      // Catch any exceptions that occur during the query
      setState(() {
        errorMessage = 'An unexpected error occurred: $e';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10.0),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.3),
            spreadRadius: 2,
            blurRadius: 5,
            offset: const Offset(0, 3), // changes position of shadow
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Hospital Name and Type
          Row(
            children: [
              const Icon(Icons.local_hospital,
                  color: Colors.lightBlue, size: 30),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: const [
                    Text(
                      'Calcutta National Medical College and Hospital',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16.0,
                      ),
                    ),
                    Text(
                      '(Government Hospital)',
                      style: TextStyle(
                        color: Colors.grey,
                        fontSize: 14.0,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),

          // Address
          Row(
            children: const [
              Icon(Icons.location_on, color: Colors.lightBlue, size: 20),
              SizedBox(width: 5),
              Expanded(
                child: Text(
                  '32 Gora Chand Road, Beniapukur, Kolkata, West Bengal 700014, KOLKATA METROPOLITAN AREA',
                  style: TextStyle(color: Colors.black54, fontSize: 14.0),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),

          // Beds Information
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Column(
                children: [
                  const Text(
                    'Total Beds',
                    style: TextStyle(
                      color: Colors.lightBlue,
                      fontSize: 14.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 5),
                  Text(
                    '$totalBeds', // Replace this with dynamic value
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 28.0,
                    ),
                  ),
                ],
              ),
              Container(
                height: 50,
                width: 1.0,
                color: Colors.grey.withOpacity(0.5),
              ),
              Column(
                children: [
                  const Text(
                    'Available Beds',
                    style: TextStyle(
                      color: Colors.lightBlue,
                      fontSize: 14.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 5),
                  Text(
                    '$availableBeds', // Display available beds fetched from Supabase
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 28.0,
                    ),
                  ),
                ],
              ),
            ],
          ),

          // Show error message if there's any
          if (errorMessage.isNotEmpty) ...[
            const SizedBox(height: 10),
            Text(
              errorMessage,
              style: const TextStyle(color: Colors.red),
            ),
          ],
        ],
      ),
    );
  }
}
