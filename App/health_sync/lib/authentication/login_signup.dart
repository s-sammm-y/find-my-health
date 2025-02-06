import 'package:flutter/material.dart';
import 'package:health_sync/screens/general.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:dart_ipify/dart_ipify.dart';

class LoginSignupScreen extends StatefulWidget {
  @override
  _LoginSignupScreenState createState() => _LoginSignupScreenState();
}

class _LoginSignupScreenState extends State<LoginSignupScreen> {
  final SupabaseClient supabase = Supabase.instance.client;
  final TextEditingController mobileController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  bool isSignup = false;
  bool _loading = false;

  Future<void> _authenticateUser() async {
    setState(() {
      _loading = true;
    });

    final String mobile = mobileController.text.trim();
    final String password = passwordController.text.trim();

    if (mobile.isEmpty || password.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Please enter all fields')),
      );
      setState(() {
        _loading = false;
      });
      return;
    }

    try {
      if (isSignup) {
        // **SIGNUP LOGIC**
        final userCountResponse = await supabase.from('users').select('user_id');

        final int userCount = userCountResponse.length; // Get exact row count

        final int newUserId = userCount + 1; // Assign new user_id

        // Insert new user
        await supabase.from('users').insert({
          'user_id': newUserId,
          'mobile_no': mobile,
          'password': password, // Store passwords securely in real apps
        });

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Signup successful! Please log in.')),
        );
        setState(() {
          isSignup = false; // Switch back to login mode
        });
      } else {
        // **LOGIN LOGIC**
        final response = await supabase
            .from('users')
            .select()
            .eq('mobile_no', mobile)
            .eq('password', password)
            .maybeSingle();

        if (response != null) {
          // Get user IP
          final String userIp = await Ipify.ipv4();

          // Store IP in "logged_in_users" table
          final res = await supabase.from('users').select().eq('mobile_no', mobile).single();
          final int userid = res['userid'];
          await supabase.from('logged_in_users').insert({'ip': userIp,'userid':userid});

          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => GeneralScreen()),
          );
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Invalid login credentials')),
          );
        }
      }
    } catch (error) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $error')),
      );
    }

    setState(() {
      _loading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(isSignup ? 'Signup' : 'Login')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              isSignup ? "Create an account" : "Login to your account",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 20),
            TextField(
              controller: mobileController,
              keyboardType: TextInputType.phone,
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                labelText: "Mobile Number",
              ),
            ),
            SizedBox(height: 10),
            TextField(
              controller: passwordController,
              obscureText: true,
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                labelText: "Password",
              ),
            ),
            SizedBox(height: 20),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _loading ? null : _authenticateUser,
                child: _loading
                    ? CircularProgressIndicator()
                    : Text(isSignup ? "Sign Up" : "Login"),
              ),
            ),
            SizedBox(height: 10),
            TextButton(
              onPressed: () {
                setState(() {
                  isSignup = !isSignup;
                });
              },
              child: Text(isSignup
                  ? "Already have an account? Login"
                  : "Don't have an account? Sign Up"),
            ),
          ],
        ),
      ),
    );
  }
}
