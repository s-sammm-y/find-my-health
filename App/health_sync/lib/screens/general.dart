import 'package:flutter/material.dart';
import 'package:health_sync/Profile/drawer_slider.dart';
import 'package:health_sync/chatbot/chatbot_page.dart';

import 'package:health_sync/first_screen_widgets/notification.dart';
import 'package:health_sync/screens/first_screen.dart';
import 'package:health_sync/screens/second_screen.dart';
import 'package:health_sync/widgets/opd_book_ticket.dart';
import 'package:supabase_flutter/supabase_flutter.dart'; 

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
        preferredSize:
            Size.fromHeight(130.0), // Adjusting height to fit the search bar
        child: TopBar(), // Adding the custom top bar
      ),
      drawer: const CustomDrawer(),
      body: _buildBody(),

      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Navigate to the Chatbot page when the button is clicked
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => ChatbotPage()),
          );
        },
        
        backgroundColor: Colors.blue,
        child: const Icon(Icons.chat),
      ),

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
            label: 'Bookings',
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
        return OPDBookTicket(supabase: Supabase.instance.client); // Pass Supabase client here
      default:
        return const FirstScreen();
    }
  }

}

// Top bar implementation
class TopBar extends StatefulWidget {
  const TopBar({super.key});

  @override
  State<TopBar> createState() => _TopBarState();
}

class _TopBarState extends State<TopBar> {
  final TextEditingController _searchController =
      TextEditingController(); // To control the input text
  final SupabaseClient _supabase =
      Supabase.instance.client; // Initialize Supabase client

  // Function to check if the city is available in Supabase
  Future<bool> _isCityAvailable(String cityName) async {
  try {
    final response = await _supabase
        .from('cities')
        .select('*') // Selecting all columns to see what's returned
        .eq('city', cityName)
        .single(); // Fetch a single result if available, or return null

    // Print the response for debugging
    print('Response: $response');

    // ignore: unnecessary_null_comparison
    if (response == null) {
      print('City not found');
      return false;
    }

    print('City found: ${response['name']}');
    return true;
  } catch (error) {
    print('Error fetching city: $error');
    return false;
  }
}


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
                icon:
                    const Icon(Icons.person, color: Colors.lightBlue, size: 28),
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
                icon: const Icon(Icons.notifications,
                    color: Colors.lightBlue, size: 28),
                onPressed: () {
                  Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => NotificationScreen(),
          ),
        );
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
                border:
                    Border.all(color: Colors.grey.withOpacity(0.5), width: 1.0),
              ),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 15.0),
                child: TextField(
                  controller:
                      _searchController, // Attach the controller to capture user input
                  decoration: InputDecoration(
                    hintText: 'Search your Disease',
                    hintStyle:
                        TextStyle(color: Colors.lightBlue.withOpacity(0.5)),
                    border: InputBorder.none,
                    icon: const Icon(Icons.search, color: Colors.lightBlue),
                  ),
                  onSubmitted: (String cityName) async {
                    if (cityName.isNotEmpty) {
                      // Show a loading indicator while searching
                      showDialog(
                        context: context, 
                        barrierDismissible: false,
                        builder: (BuildContext context) {
                          return const Center(
                              child: CircularProgressIndicator());
                        },
                      );

                      // Check if the city is available in Supabase
                      // ignore: unused_local_variable
                      bool isAvailable = await _isCityAvailable(cityName);

                      // Hide the loading indicator after the check
                      Navigator.pop(context);

                      // If available, navigate to CityHospitalList page
                      
                    }
                  },
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
