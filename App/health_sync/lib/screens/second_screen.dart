import 'package:flutter/material.dart';
import 'package:health_sync/second%20screen%20widget/gov_aided_cards.dart';
import 'package:health_sync/second%20screen%20widget/goverment_cards.dart';
import 'package:health_sync/second%20screen%20widget/pvt_hospitalcard.dart';
import 'package:health_sync/widgets/book_ambulance.dart';
 // Import the cards

class SecondScreen extends StatefulWidget {
  const SecondScreen({super.key});

  @override
  State<SecondScreen> createState() => _SecondScreenState();
}

class _SecondScreenState extends State<SecondScreen> {
  int _selectedHospitalType = 1;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              BookAmbulanceCard(),
              const SizedBox(height: 16,),
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 20.0),
                child: Column(
                  children: <Widget>[
                    Text(
                      'Book Ambulance',
                      textAlign: TextAlign.left,
                      style: TextStyle(
                        color: Colors.lightBlue,
                        fontSize: 15.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 10,),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12.0),
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(30.0),
                    border: Border.all(
                        color: Colors.grey.withOpacity(0.5), width: 1.0),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 15.0),
                    child: TextField(
                      decoration: InputDecoration(
                        hintText: 'Search...',
                        hintStyle: TextStyle(
                          color: Colors.lightBlue.withOpacity(0.5),
                        ),
                        border: InputBorder.none,
                        icon: const Icon(Icons.search, color: Colors.lightBlue),
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 10,),

              // Radio buttons for hospital type selection
              Column(
                children: <Widget>[
                  ListTile(
                    leading: Radio<int>(
                      value: 1,
                      groupValue: _selectedHospitalType,
                      activeColor: Colors.lightBlue,
                      onChanged: (int? value) {
                        setState(() {
                          _selectedHospitalType = value!;
                        });
                      },
                    ),
                    title: const Text('Government Hospitals'),
                  ),
                  ListTile(
                    leading: Radio<int>(
                      value: 2,
                      groupValue: _selectedHospitalType,
                      activeColor: Colors.lightBlue,
                      onChanged: (int? value) {
                        setState(() {
                          _selectedHospitalType = value!;
                        });
                      },
                    ),
                    title: const Text('Govt. Requisitioned Pvt. Hospitals'),
                  ),
                  ListTile(
                    leading: Radio<int>(
                      value: 3,
                      groupValue: _selectedHospitalType,
                      activeColor: Colors.lightBlue,
                      onChanged: (int? value) {
                        setState(() {
                          _selectedHospitalType = value!;
                        });
                      },
                    ),
                    title: const Text('Private Hospitals'),
                  ),
                ],
              ),

              const SizedBox(height: 10,),

              // Display corresponding card based on selected radio button
              if (_selectedHospitalType == 1) const GovernmentHospitalCard(),
              if (_selectedHospitalType == 2) const GovtRequisitionedHospitalCard(),
              if (_selectedHospitalType == 3) const PrivateHospitalCard(),
            ],
          ),
        ),
      ),
    );
  }
}
