// Import required Flutter and third-party packages
import 'package:flutter/material.dart';
import 'package:health_sync/Profile/profile_screen.dart';
import 'package:health_sync/authentication/login_signup.dart';
import 'package:health_sync/first_screen_widgets/notification.dart';
import 'package:health_sync/screens/general.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:dart_ipify/dart_ipify.dart';
import 'package:health_sync/Profile/drawer_slider.dart';

// Main entry point of the application
void main() async {
  // Ensure Flutter bindings are initialized
  WidgetsFlutterBinding.ensureInitialized();

  // Load environment variables from .env file
  await dotenv.load(fileName: "assets/.env");

  // Get Supabase credentials from environment variables
  final String? supabaseUrl = dotenv.env['supabaseUrl'];
  final String? supabaseKey = dotenv.env['supabaseKey'];

  // Validate Supabase credentials
  if (supabaseUrl == null || supabaseKey == null) {
    throw Exception("Missing Supabase URL or Key.");
  }

  // Initialize Supabase client with credentials
  await Supabase.initialize(
    url: supabaseUrl,
    anonKey: supabaseKey,
  );

  // Fetch initial user data
  await UserData.fetchUserData();

  // Launch the application
  runApp(const MyApp());
}

// Root widget of the application
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.teal,
        primaryColor: Colors.teal,
        scaffoldBackgroundColor: Colors.white,
        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.teal,
          foregroundColor: Colors.white,
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.teal,
            foregroundColor: Colors.white,
          ),
        ),
        floatingActionButtonTheme: const FloatingActionButtonThemeData(
          backgroundColor: Colors.teal,
          foregroundColor: Colors.white,
        ),
      ),
      home: const AuthCheckScreen(), // Start with authentication check
    );
  }
}

// Screen to check user's authentication status
class AuthCheckScreen extends StatefulWidget {
  const AuthCheckScreen({super.key});

  @override
  _AuthCheckScreenState createState() => _AuthCheckScreenState();
}

class _AuthCheckScreenState extends State<AuthCheckScreen> {
  // Initialize Supabase client instance
  final SupabaseClient supabase = Supabase.instance.client;

  @override
  void initState() {
    super.initState();
    _checkUserLoginStatus(); // Check login status when screen initializes
  }

  // Check if user is logged in by verifying IP in database
  Future<void> _checkUserLoginStatus() async {
    try {
      // Get user's IP address
      final String userIp = await Ipify.ipv4();

      // Query Supabase to check if IP exists in logged_in_users table
      final response = await supabase
          .from('logged_in_users')
          .select('ip')
          .eq('ip', userIp)
          .maybeSingle();

      // Navigate based on login status
      if (response != null) {
        // User is logged in, go to main screen
        Navigator.pushReplacement(
  context,
  MaterialPageRoute(
    builder: (context) => const GeneralScreen(), // 👈 ONLY GeneralScreen, nothing else
  ),
);

      } else {
        // User is not logged in, go to login screen
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => LoginSignupScreen()),
        );
      }
    } catch (error) {
      // Handle any errors by redirecting to login screen
      print('Error checking user IP: $error');
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => LoginSignupScreen()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    // Show loading indicator while checking authentication
    return Scaffold(
      body: Center(child: CircularProgressIndicator()),
    );
  }
}

// TopBar Widget
// TopBar Widget (converted into a proper AppBar)
class TopBar extends StatefulWidget implements PreferredSizeWidget {
  const TopBar({super.key});

  @override
  Size get preferredSize => const Size.fromHeight(70.0); // Proper AppBar height

  @override
  _TopBarState createState() => _TopBarState();
}

class _TopBarState extends State<TopBar> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<Offset> _slideAnimation;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 1200),
      vsync: this,
    );
    _slideAnimation = Tween<Offset>(
      begin: const Offset(-1.0, 0.0),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeOut,
    ));
    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeIn,
    ));
    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: Colors.white,
      elevation: 0,
      title: SlideTransition(
        position: _slideAnimation,
        child: FadeTransition(
          opacity: _fadeAnimation,
          child: const Text(
            'Health Sync',
            style: TextStyle(
              color: Colors.teal,
              fontSize: 25,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
      actions: [
        IconButton(
          icon: const Icon(Icons.person, color: Colors.teal, size: 25),
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const ProfileScreen()),
            );
          },
        ),
        IconButton(
          icon: const Icon(Icons.notifications, color: Colors.teal, size: 25),
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => NotificationScreen()),
            );
          },
        ),
      ],
      iconTheme: const IconThemeData(color: Colors.teal),
    );
  }
}
