import 'package:flutter/material.dart';
import 'package:health_sync/authentication/phone_auth.dart';
 // Phone number login screen
import 'package:health_sync/screens/general.dart'; // Home screen after login
import 'package:supabase_flutter/supabase_flutter.dart'; // Supabase import

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Initialize Supabase
  await Supabase.initialize(
    url: 'https://gepgotvlyncedjrwzajq.supabase.co/',
<<<<<<< HEAD
    anonKey:
        'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImdlcGdvdHZseW5jZWRqcnd6YWpxIiwicm9sZSI6ImFub24iLCJpYXQiOjE3MjUzMDA4NTMsImV4cCI6MjA0MDg3Njg1M30.5XUg1bhU6wD1mCjRCVuFdN2sIW58j9SHR699dZKaQKs',
=======
    anonKey: 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImdlcGdvdHZseW5jZWRqcnd6YWpxIiwicm9sZSI6ImFub24iLCJpYXQiOjE3MjUzMDA4NTMsImV4cCI6MjA0MDg3Njg1M30.5XUg1bhU6wD1mCjRCVuFdN2sIW58j9SHR699dZKaQKs',
>>>>>>> 76fa5df7d0605e41ffe16d37306993aaab65e92d
  );

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
<<<<<<< HEAD
      // title: 'Flutter App',
      // theme: ThemeData(
      //   primarySwatch: Colors.blue,
      // ),
      home: GeneralScreen(),
=======
      home: AuthCheckScreen(),
>>>>>>> 76fa5df7d0605e41ffe16d37306993aaab65e92d
    );
  }
}

// Screen to check if user is already authenticated
class AuthCheckScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // Get the current session
    final session = Supabase.instance.client.auth.currentSession;

    if (session != null) {
      // If user is signed in, navigate to the home screen
      return GeneralScreen();
    } else {
      // If no session, show the Phone Number Login screen
      return PhoneNumberScreen();
    }
  }
}
