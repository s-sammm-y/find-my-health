import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart'; // Supabase package

class GeneralWardHospitalCard extends StatefulWidget {
  const GeneralWardHospitalCard({super.key});

  @override
  State<GeneralWardHospitalCard> createState() => _GeneralWardHospitalCardState();
}

class _GeneralWardHospitalCardState extends State<GeneralWardHospitalCard> {
  int availableBeds = 0;
  final int totalBeds = 200; // Fixed total beds count
  String errorMessage = '';
  final supabase = Supabase.instance.client;
  @override
  void initState() {
    super.initState();
    fetchBedData();
    listenToBedTable();
  }
  void listenToBedTable() {
    supabase
        .from('bed')
        .stream(primaryKey: ['bed_id'])
        .eq('ward_id', 'general')
        .listen((List<Map<String, dynamic>> beds) {
      fetchBedData();    
      print("Updated bed data: $beds");
    });
  }
  Future<void> fetchBedData() async {
    try {

      final availableBedsResponse = await supabase
          .from('bed')
          .select('bed_id')
          .eq('empty', true)
          .eq('ward_id', 'general');

      setState(() {
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
                      'General Ward',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 20.0,
                      ),
                    ),
                  ],
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
