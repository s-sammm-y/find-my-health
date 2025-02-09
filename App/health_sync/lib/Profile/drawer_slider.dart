import 'package:flutter/material.dart';
import 'package:health_sync/authentication/login_signup.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:dart_ipify/dart_ipify.dart';

/// Static class to hold user details globally.
class UserData {
  static int? userId;
  static String? userName;
  static String? userMobile;

  static Future<void> fetchUserData() async {
    try {
      final String userIp = await Ipify.ipv4();
      final supabase = Supabase.instance.client;

      final loggedInUser = await supabase
          .from('logged_in_users')
          .select('userid')
          .eq('ip', userIp)
          .maybeSingle();
      if (loggedInUser == null || loggedInUser.isEmpty) {
        print("No logged-in user found for this IP.");
        return;
      }

      int userId = loggedInUser['userid'];

      final user = await supabase
          .from('users')
          .select('user_id, mobile_no')
          .eq('user_id', userId)
          .maybeSingle();
      if (user == null || user.isEmpty) {
        print("No user found with userId: $userId");
        return;
      }

      // Update static variables directly (no setState)
      UserData.userId = user['user_id'];
      UserData.userName = "User ID: ${user['user_id']}";
      UserData.userMobile = user['mobile_no'];

      print("User Data Loaded: ${UserData.userName}, ${UserData.userMobile}");
    } catch (error) {
      print("Error fetching user data: $error");
    }
  }
}

class CustomDrawer extends StatefulWidget {
  const CustomDrawer({super.key});

  @override
  _CustomDrawerState createState() => _CustomDrawerState();
}

class _CustomDrawerState extends State<CustomDrawer> {
  @override
  void initState() {
    super.initState();
    if (UserData.userName == null || UserData.userMobile == null) {
      UserData.fetchUserData();
    }
    _loadUserData();
  }
  void _loadUserData() async {
    await UserData.fetchUserData();
    setState(() {});
  }

  Future<void> _signOut(BuildContext context) async {
    try {
      final String userIp = await Ipify.ipv4();

      await Supabase.instance.client
          .from('logged_in_users')
          .delete()
          .eq('ip', userIp);

      await Supabase.instance.client.auth.signOut();

      // Reset UserData when signing out
      UserData.userId = null;
      UserData.userName = null;
      UserData.userMobile = null;

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => LoginSignupScreen()),
      );
    } catch (error) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Sign out failed: $error')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 250,
      child: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            UserAccountsDrawerHeader(
              accountName: Text(UserData.userName ?? "Fetching..."),
              accountEmail: Text(UserData.userMobile ?? "Fetching..."),
              currentAccountPicture: const CircleAvatar(
                backgroundColor: Colors.white,
                child: Icon(Icons.person, size: 50, color: Colors.lightBlue),
              ),
              decoration: const BoxDecoration(
                color: Colors.lightBlue,
              ),
            ),
            ListTile(
              title: const Text('Sign Out'),
              subtitle: const Text('Login from another number'),
              onTap: () => _signOut(context),
            ),
            const Divider(),
            ListTile(
              title: const Text('Change Language'),
              onTap: () {},
            ),
          ],
        ),
      ),
    );
  }
}
