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
    fetchBedData();
  }

  Future<void> fetchBedData() async {
    try {
      final supabase = Supabase.instance.client;

      // Fetch total beds
      final totalBedsResponse = await supabase.from('bed').select('bed_id');
      // Fetch available beds where empty = true
      final availableBedsResponse =
          await supabase.from('bed').select('bed_id').eq('empty', true);

      setState(() {
        totalBeds = totalBedsResponse.length;
        availableBeds = availableBedsResponse.length;
      });
    } catch (e) {
      setState(() {
        errorMessage = 'Error fetching bed data: $e';
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
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Hospital Name and Type
          Row(
            children: [
              const Icon(Icons.local_hospital, color: Colors.lightBlue, size: 30),
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
              _buildBedInfoCard('Total Beds', totalBeds),
              Container(
                height: 50,
                width: 1.0,
                color: Colors.grey.withOpacity(0.5),
              ),
              _buildBedInfoCard('Available Beds', availableBeds),
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

  Widget _buildBedInfoCard(String title, int count) {
    return Column(
      children: [
        Text(
          title,
          style: const TextStyle(
            color: Colors.lightBlue,
            fontSize: 14.0,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 5),
        Text(
          '$count',
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 28.0,
          ),
        ),
      ],
    );
  }
}
