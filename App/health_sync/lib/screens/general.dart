import 'package:flutter/material.dart';
import 'package:health_sync/Profile/drawer_slider.dart';
import 'package:health_sync/screens/first_screen.dart';
import 'package:health_sync/screens/second_screen.dart';

class GeneralScreen extends StatefulWidget {
  const GeneralScreen({super.key});

  @override
  State<GeneralScreen> createState() => _GeneralScreenState();
}

class _GeneralScreenState extends State<GeneralScreen> {
  int _selectedIndex = 0; // For BottomNavigationBar

  // Method to handle bottom bar taps
  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: const PreferredSize(
        preferredSize: Size.fromHeight(130.0), // Adjusting height to fit the search bar
        child: TopBar(), // Adding the custom top bar
      ),
      drawer: const CustomDrawer(),
      body: _buildBody(),

      // Bottom Bar Navigation Implementation

      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Colors.white,
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.local_hospital),
            label: 'Emergency',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.document_scanner),
            label: 'Docs',
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.lightBlue,
        onTap: _onItemTapped,
      ),
      
    );
  }
  Widget _buildBody() {
    switch (_selectedIndex) {
      case 0:
        return const FirstScreen();
      case 1:
        return const SecondScreen();
      case 2:
        return const Center(child: Text('Docs'));
      default:
        return const FirstScreen();
    }
  }
}

// Top bar implementation
class TopBar extends StatelessWidget {
  const TopBar({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 10.0),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.5),
            spreadRadius: 1,
            blurRadius: 7,
            offset: const Offset(0, 3), // changes position of shadow
          ),
        ],
      ),
      child: Column(
        children: [
          const SizedBox(height: 20),
          // Top Row with Icons and Title
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // Left icon (Profile Icon)
              IconButton(
                icon: const Icon(Icons.person, color: Colors.lightBlue, size: 28),
                onPressed: () {
                  Scaffold.of(context).openDrawer();
                },
              ),
              // Center Title
              const Text(
                'Health Sync',
                style: TextStyle(
                  color: Colors.lightBlue,
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                ),
              ),
              // Right icon (Notification Icon)
              IconButton(
                icon: const Icon(Icons.notifications, color: Colors.lightBlue, size: 28),
                onPressed: () {
                  // Add your functionality here
                },
              ),
            ],
          ),
          const SizedBox(height: 10), // Space between row and search bar

          // Search Bar
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12.0),
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(30.0),
                border: Border.all(color: Colors.grey.withOpacity(0.5), width: 1.0),
              ),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 15.0),
                child: TextField(
                  decoration: InputDecoration(
                    hintText: 'Search...',
                    hintStyle: TextStyle(color: Colors.lightBlue.withOpacity(0.5)),
                    border: InputBorder.none,
                    icon:const Icon(Icons.search, color: Colors.lightBlue),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}


