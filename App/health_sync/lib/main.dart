import 'package:flutter/material.dart';
import 'package:health_sync/authentication/login_signup.dart';
import 'package:health_sync/screens/general.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:dart_ipify/dart_ipify.dart'; // To get user IP

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Initialize Supabase
  await Supabase.initialize(
    url: 'https://aeouxmudgmiawyqnwsic.supabase.co',
    anonKey: 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImFlb3V4bXVkZ21pYXd5cW53c2ljIiwicm9sZSI6ImFub24iLCJpYXQiOjE3Mzg3ODA0MzAsImV4cCI6MjA1NDM1NjQzMH0.wK9aPGh5Myh62Mjs1pfHKc6PoFLaj35thvmMpy8qJ1s',
  );

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: AuthCheckScreen(),
    );
  }
}

// Check if user's IP exists in 'logged_in_users'
class AuthCheckScreen extends StatefulWidget {
  const AuthCheckScreen({super.key});

  @override
  _AuthCheckScreenState createState() => _AuthCheckScreenState();
}

class _AuthCheckScreenState extends State<AuthCheckScreen> {
  final SupabaseClient supabase = Supabase.instance.client;

  @override
  void initState() {
    super.initState();
    _checkUserLoginStatus();
  }

  Future<void> _checkUserLoginStatus() async {
    try {
      final String userIp = await Ipify.ipv4();
      final response = await supabase
          .from('logged_in_users')
          .select('ip')
          .eq('ip', userIp)
          .maybeSingle();

      if (response != null) {
        // If IP is found, navigate to home screen
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => GeneralScreen()),
        );
      } else {
        // If IP is not found, navigate to login/signup screen
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => LoginSignupScreen()),
        );
      }
    } catch (error) {
      print('Error checking user IP: $error');
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => LoginSignupScreen()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(child: CircularProgressIndicator()),
    );
  }
}
