import 'package:flutter/material.dart';

class FirstScreen extends StatefulWidget {
  const FirstScreen({super.key});

  @override
  State<FirstScreen> createState() => _FirstScreenState();
}

class _FirstScreenState extends State<FirstScreen> {
  int? selectedButtonIndex; // To track the selected button index (only one can be selected)

  // Method to handle button selection
  void _onButtonTap(int index) {
    setState(() {
      selectedButtonIndex = index; // Update the selected button index
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white, // Set background color to white
      child: SingleChildScrollView(
        child: Column(
          children: [
            // Circle Avatars Row
            const Padding(
              padding: EdgeInsets.symmetric(vertical: 20.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly, // Spacing between the items
                children: [
                  CityOption(iconLabel: 'Nearby'),
                  CityOption(iconLabel: 'Delhi'),
                  CityOption(iconLabel: 'Kolkata'),
                  CityOption(iconLabel: 'Bangalore'),
                ],
              ),
            ),
            const SizedBox(height: 5), // Add space between the two sections

            // Title for the Hospital Options
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
            const SizedBox(height: 20), // Space below the title

            // Hospital Options Buttons
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: GridView.count(
                shrinkWrap: true, // Needed to avoid unbounded height errors
                crossAxisCount: 2, // 2 buttons per row
                crossAxisSpacing: 10,
                mainAxisSpacing: 10,
                physics: const NeverScrollableScrollPhysics(), // Disable grid scrolling
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

  // Widget for building a selectable button
  Widget _buildSelectableButton(String label, int index) {
    bool isSelected = selectedButtonIndex == index; // Check if this button is selected
    return GestureDetector(
      onTap: () => _onButtonTap(index), // Handle button tap
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
    return Column(
      children: [
        const CircleAvatar(
          radius: 30, // Size of the circular avatar
          backgroundColor: Colors.grey, // Placeholder color
        ),
        const SizedBox(height: 8), // Space between the circle and the text
        Text(
          iconLabel,
          style: const TextStyle(fontSize: 12, color: Colors.lightBlue),
        ),
      ],
    );
  }
}
