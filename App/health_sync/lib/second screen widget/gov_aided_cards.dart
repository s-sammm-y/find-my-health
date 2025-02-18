import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class CardioWardHospitalCard extends StatefulWidget {
  const CardioWardHospitalCard({super.key});

  @override
  _CardioWardHospitalCardState createState() =>
      _CardioWardHospitalCardState();
}

class _CardioWardHospitalCardState
    extends State<CardioWardHospitalCard> {
  final SupabaseClient supabase = Supabase.instance.client;
  int availableBeds = 0;

  @override
  void initState() {
    super.initState();
    fetchAvailableBeds();
  }

  Future<void> fetchAvailableBeds() async {
    final response = await supabase
        .from('bed')
        .select('empty')
        .eq('ward_id', 'cough'); // Fetch only 'Cardiac Ward' beds

    if (response.isNotEmpty) {
      int count = response.where((bed) => bed['empty'] == true).length;
      setState(() {
        availableBeds = count;
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
              const Icon(Icons.local_hospital,
                  color: Colors.lightBlue, size: 30),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: const [
                    Text(
                      'Cardio Ward',
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
              Column(
                children: const [
                  Text(
                    'Total Beds',
                    style: TextStyle(
                      color: Colors.lightBlue,
                      fontSize: 14.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 5),
                  Text(
                    '180', // Keep total beds static or fetch from database if needed
                    style: TextStyle(
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
                    '$availableBeds', // Dynamic data from Supabase
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 28.0,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}
