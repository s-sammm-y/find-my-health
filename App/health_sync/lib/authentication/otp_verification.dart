import 'package:supabase_flutter/supabase_flutter.dart';

class SupabaseConfig {
  static const String supabaseUrl = 'https://gepgotvlyncedjrwzajq.supabase.co/'; // Replace with your Supabase URL
  static const String supabaseAnonKey = 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImdlcGdvdHZseW5jZWRqcnd6YWpxIiwicm9sZSI6ImFub24iLCJpYXQiOjE3MjUzMDA4NTMsImV4cCI6MjA0MDg3Njg1M30.5XUg1bhU6wD1mCjRCVuFdN2sIW58j9SHR699dZKaQKs'; // Replace with your anon key

  static Future<void> initSupabase() async {
    await Supabase.initialize(
      url: supabaseUrl,
      anonKey: supabaseAnonKey,
    );
  }

  static SupabaseClient get client => Supabase.instance.client;
}