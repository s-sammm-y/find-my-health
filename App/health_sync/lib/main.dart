import 'package:flutter/material.dart';
import 'package:health_sync/screens/general.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Supabase.initialize(
    url: 'https://gepgotvlyncedjrwzajq.supabase.co/', 
    anonKey: 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImdlcGdvdHZseW5jZWRqcnd6YWpxIiwicm9sZSI6ImFub24iLCJpYXQiOjE3MjUzMDA4NTMsImV4cCI6MjA0MDg3Njg1M30.5XUg1bhU6wD1mCjRCVuFdN2sIW58j9SHR699dZKaQKs',
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      // title: 'Flutter App',
      // theme: ThemeData(
      //   primarySwatch: Colors.blue,
      // ),
      home: GeneralScreen(),
            
    );
  }
}
