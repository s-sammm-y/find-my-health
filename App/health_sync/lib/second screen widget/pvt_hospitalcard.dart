 import 'package:flutter/material.dart';

class PrivateHospitalCard extends StatelessWidget {
  const PrivateHospitalCard({super.key});

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
              const Icon(Icons.local_hospital, color: Colors.lightBlue, size: 30),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: const [
                    Text(
                      'Private Hospital Name',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16.0,
                      ),
                    ),
                    Text(
                      '(Private Hospital)',
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
                  'Hospital Address for Private Hospital',
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
                    '250',
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
                children: const [
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
                    '120',
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
    );
  }
}
