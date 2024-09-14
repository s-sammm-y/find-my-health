import 'package:flutter/material.dart';
import 'package:health_sync/first_screen_widgets/city_hospital_list.dart';
 // Import the CityHospitalList page

class FirstScreen extends StatefulWidget {
  const FirstScreen({super.key});

  @override
  State<FirstScreen> createState() => _FirstScreenState();
}

class _FirstScreenState extends State<FirstScreen> {
  int? selectedButtonIndex;

  void _onButtonTap(int index) {
    setState(() {
      selectedButtonIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      child: SingleChildScrollView(
        child: Column(
          children: [
            const Padding(
              padding: EdgeInsets.symmetric(vertical: 20.0),
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    SizedBox(width: 20),
                    CityOption(iconLabel: 'Nearby'),
                    SizedBox(width: 10),
                    CityOption(iconLabel: 'Delhi'),
                    SizedBox(width: 10),
                    CityOption(iconLabel: 'Kolkata'),
                    SizedBox(width: 10),
                    CityOption(iconLabel: 'Bangalore'),
                    SizedBox(width: 10),
                    CityOption(iconLabel: 'Mumbai'),
                    SizedBox(width: 10),
                    CityOption(iconLabel: 'Chennai'),
                    SizedBox(width: 10),
                    CityOption(iconLabel: 'Hyderabad'),
                    SizedBox(width: 10),
                    CityOption(iconLabel: 'Ahmedabad'),
                    SizedBox(width: 20),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 5),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 20.0),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'Top Hospitals in India',
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                    color: Colors.lightBlue,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 20),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: GridView.count(
                shrinkWrap: true,
                crossAxisCount: 2,
                crossAxisSpacing: 10,
                mainAxisSpacing: 10,
                physics: const NeverScrollableScrollPhysics(),
                children: [
                  _buildSelectableButton('Govt Hospital', 0),
                  _buildSelectableButton('Pvt Hospital', 1),
                  _buildSelectableButton('Diagnostic Centre', 2),
                  _buildSelectableButton('Nursing Home', 3),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSelectableButton(String label, int index) {
    bool isSelected = selectedButtonIndex == index;
    return GestureDetector(
      onTap: () => _onButtonTap(index),
      child: Container(
        decoration: BoxDecoration(
          color: isSelected ? Colors.lightBlue : Colors.white,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: Colors.lightBlue),
        ),
        alignment: Alignment.center,
        padding: const EdgeInsets.all(16.0),
        child: Text(
          label,
          style: TextStyle(
            fontSize: 16,
            color: isSelected ? Colors.white : Colors.black,
            fontWeight: FontWeight.w500,
          ),
          textAlign: TextAlign.center,
        ),
      ),
    );
  }
}

// Custom widget to represent each city option
class CityOption extends StatelessWidget {
  final String iconLabel;

  const CityOption({required this.iconLabel, super.key});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        // Navigate to the CityHospitalList page for any selected city
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => CityHospitalList(cityName: iconLabel),
          ),
        );
      },
      child: Column(
        children: [
          const CircleAvatar(
            radius: 30,
            backgroundColor: Colors.grey,
          ),
          const SizedBox(height: 8),
          Text(
            iconLabel,
            style: const TextStyle(fontSize: 12, color: Colors.lightBlue),
          ),
        ],
      ),
    );
  }
}
