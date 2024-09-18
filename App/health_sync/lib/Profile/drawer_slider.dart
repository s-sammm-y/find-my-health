import 'package:flutter/material.dart';
import 'package:health_sync/authentication/phone_auth.dart';
import 'package:supabase_flutter/supabase_flutter.dart'; // Import Supabase
 // Assuming this is where your login screen is

class CustomDrawer extends StatelessWidget {
  const CustomDrawer({super.key});

  // Function to handle user sign out
  Future<void> _signOut(BuildContext context) async {
    try {
      // Call Supabase sign out method
      await Supabase.instance.client.auth.signOut();

      // Navigate to the Phone Number Login screen after sign out
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => PhoneNumberScreen()),
      );
    } catch (error) {
      // Show an error message if sign out fails
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Sign out failed: $error')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 250, // Set your desired width here
      child: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            const UserAccountsDrawerHeader(
              accountName: Text('Aniruddha Pal'),
              accountEmail: Text('+91-9831209756'),
              currentAccountPicture: CircleAvatar(
                backgroundColor: Colors.white,
                child: Icon(Icons.person, size: 50, color: Colors.lightBlue),
              ),
              decoration: BoxDecoration(
                color: Colors.lightBlue,
              ),
            ),
            ListTile(
              title: const Text('Sign Out'),
              subtitle: const Text('login from another Number'),
              onTap: () {
                // Call the sign out function when the Sign Out tile is tapped
                _signOut(context);
              },
            ),
            const Divider(),
            ListTile(
              title: const Text('Change Language'),
              onTap: () {
                // Add your functionality here
              },
            ),
          ],
        ),
      ),
    );
  }
}
