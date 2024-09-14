import 'package:flutter/material.dart';

class GovernmentHospitalCard extends StatefulWidget {
  const GovernmentHospitalCard({super.key});

  @override
  State<GovernmentHospitalCard> createState() => _GovernmentHospitalCardState();
}

class _GovernmentHospitalCardState extends State<GovernmentHospitalCard> {
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
    );
  }
}
