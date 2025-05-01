import 'package:flutter/material.dart';
import 'package:health_sync/Profile/drawer_slider.dart';
import 'package:health_sync/chatbot/chatbot_page.dart';
// import 'package:health_sync/first_screen_widgets/notification.dart';
import 'package:health_sync/main.dart';
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

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const TopBar(), // 👈 Add TopBar here!
      drawer: const CustomDrawer(),
      body: _buildBody(),
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Colors.white,
        type: BottomNavigationBarType.fixed,
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'OPD',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.local_hospital),
            label: 'Emergency',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.sync),
            label: 'Sync AI',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.document_scanner),
            label: 'Bookings',
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.teal,
        unselectedItemColor: Colors.grey[600],
        onTap: _onItemTapped,
      ),
    );
  }

  Widget _buildBody() {
    switch (_selectedIndex) {
      case 0:
        return FirstScreen(onTabChange: (int index) {
          setState(() {
            _selectedIndex = index;
          });
        });
      case 1:
        return const SecondScreen();
      case 3:
        return OPDBookTicket(supabase: Supabase.instance.client);
      case 2:
        return ChatBotScreen();
      default:
        return const FirstScreen();
    }
  }
}
