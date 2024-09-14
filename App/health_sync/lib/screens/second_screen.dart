import 'package:flutter/material.dart';
import 'package:health_sync/widgets/book_ambulance.dart';

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
                      '🔴 Live Bed Status',
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

              // Add the radio buttons
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
                    title: const Text('Govt. Requisitioned Pvt. Hospital'),
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
                    title: const Text('Private Hospital'),
                  ),
                ],
              ),

              // Add the hospital information card
              const SizedBox(height: 20),
              Container(
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
                    const Row(
                      children: [
                        Icon(Icons.local_hospital, color: Colors.lightBlue, size: 30),
                        SizedBox(width: 10),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
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
                    const Row(
                      children: [
                        Icon(Icons.location_on, color: Colors.lightBlue, size: 20),
                        SizedBox(width: 5),
                        Expanded(
                          child: Text(
                            '32 Gora Chand Road, Beniapukur, Kolkata, West Bengal 700014, KOLKATA METROPOLITAN AREA',
                            style: TextStyle(color: Colors.black54, fontSize: 10.0),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),

                    // Beds Information
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        const Column(
                          children: [
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
                              '216',
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
                        const Column(
                          children: [
                            Text(
                              'Available Beds',
                              style: TextStyle(
                                color: Colors.lightBlue,
                                fontSize: 14.0,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            SizedBox(height: 5),
                            Text(
                              '150',
                              style: TextStyle(
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
              ),
            ],
          ),
        ),
      ),
    );
  }
}
