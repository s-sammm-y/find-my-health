import 'package:flutter/material.dart';
import 'package:health_sync/authentication/login_signup.dart';
import 'package:health_sync/screens/general.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:dart_ipify/dart_ipify.dart'; 
import 'package:health_sync/Profile/drawer_slider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load(fileName: "assets/.env");
  

  final String? supabaseUrl = dotenv.env['supabaseUrl'];
  final String? supabaseKey = dotenv.env['supabaseKey'];

  if (supabaseUrl == null || supabaseKey == null) {
    throw Exception("Missing Supabase URL or Key.");
  }

  await Supabase.initialize(
    url: supabaseUrl,
    anonKey: supabaseKey,
  );

  await UserData.fetchUserData();

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
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => GeneralScreen()),
        );
      } else {
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
