import 'package:flutter/material.dart';
import 'package:health_sync/authentication/login_signup.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:dart_ipify/dart_ipify.dart';

class CustomDrawer extends StatefulWidget {
  const CustomDrawer({super.key});

  @override
  _CustomDrawerState createState() => _CustomDrawerState();
}

class _CustomDrawerState extends State<CustomDrawer> {
  String userName = "Fetching...";
  String userMobile = "Fetching...";

  @override
  void initState() {
    super.initState();
    _fetchUserData();
  }

  Future<void> _fetchUserData() async {
    try {
      final String userIp = await Ipify.ipv4();
      final supabase = Supabase.instance.client;

      final loggedInUser = await supabase
          .from('logged_in_users')
          .select('userid')
          .eq('ip', userIp)
          .maybeSingle();

      if (loggedInUser != null) {
        int userId = loggedInUser['userid'];

        final user = await supabase
            .from('users')
            .select('user_id, mobile_no')
            .eq('user_id', userId)
            .maybeSingle();

        if (user != null) {
          setState(() {
            userName = "User ID: ${user['user_id']}";
            userMobile = user['mobile_no'];
          });
        }
      }
    } catch (error) {
      print("Error fetching user data: $error");
    }
  }

  Future<void> _signOut(BuildContext context) async {
  try {
    final String userIp = await Ipify.ipv4();

    await Supabase.instance.client
        .from('logged_in_users')
        .delete()
        .eq('ip', userIp);

    await Supabase.instance.client.auth.signOut();

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
              accountName: Text(userName),
              accountEmail: Text(userMobile),
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
