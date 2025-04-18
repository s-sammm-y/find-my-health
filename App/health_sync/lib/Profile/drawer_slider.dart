import 'dart:io';
import 'package:flutter/material.dart';
import 'package:health_sync/authentication/login_signup.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:dart_ipify/dart_ipify.dart';
import 'package:health_sync/screens/pdf_viewer_screen.dart';
import 'package:path_provider/path_provider.dart';
import 'package:http/http.dart' as http;

/// Static class to hold user details globally.
class UserData {
  static String? userId;
  static String? userName;
  static String? userMobile;

  static Future<void> fetchUserData() async {
    try {
      final String userIp = await Ipify.ipv4();
      final supabase = Supabase.instance.client;

      final loggedInUser = await supabase
          .from('logged_in_users')
          .select('user_id')
          .eq('ip', userIp)
          .maybeSingle();
      if (loggedInUser == null || loggedInUser.isEmpty) {
        print("No logged-in user found for this IP.");
        return;
      }

      String userId = loggedInUser['user_id'];

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
      UserData.userName = "User ID: ${user['user_id'].split('-')[0]}";
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

  void _showprescription(BuildContext context, String? userId) async {
    try {
      String USERID = userId ?? "007";
      final List<dynamic> response = await Supabase.instance.client
        .from('user_prescription_details')
        .select('pdf')
        .eq('user_id', USERID);

      if (response.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('No prescriptions found')),
        );
        return;
      }

      List<String> pdfFileNames = response.map((entry) => entry['pdf'] as String).toList();

      List<String> pdfUrls = await Future.wait(pdfFileNames.map((pdfFileName) async {
        String filePath = pdfFileName.startsWith('user_$USERID/') 
            ? pdfFileName 
            : 'user_$USERID/$pdfFileName';

        return await Supabase.instance.client.storage
            .from('prescriptions')
            .createSignedUrl(filePath, 3600);
      }));

      print("Generated PDF URLs: $pdfUrls");

      final tempDir = await getTemporaryDirectory();
      List<String> downloadedPdfPaths = [];

      for (int i = 0; i < pdfUrls.length; i++) {
        String pdfUrl = pdfUrls[i];
        String pdfFileName = pdfUrl.split('/').last.split('?').first;

        final pdfPath = '${tempDir.path}/$pdfFileName';
        File localPdfFile = File(pdfPath);

        if (!localPdfFile.parent.existsSync()) {
          await localPdfFile.parent.create(recursive: true);
        }

        final responsePdf = await http.get(Uri.parse(pdfUrl));
        
        if (responsePdf.statusCode == 200) {
          await localPdfFile.writeAsBytes(responsePdf.bodyBytes);
          downloadedPdfPaths.add(pdfPath);
        } else {
          print("Failed to download PDF: $pdfUrl");
        }
      }
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => PDFViewerScreen(
            pdfPaths: downloadedPdfPaths, 
            initialIndex: 0,
          ),
        ),
      );
    } catch (e) {
      print('Error fetching prescription: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to load prescription')),
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
              title: const Text('Prescriptions'),
              subtitle: const Text('All your doctor Prescriptions'),
              onTap: () => _showprescription(context, UserData.userId),
            ),
            ListTile(
              title: const Text('Sign Out'),
              subtitle: const Text('Login from another number'),
              onTap: () =>  _signOut(context),
            ),
            const Divider(),
            // ListTile(
            //   title: const Text('Change Language'),
            //   onTap: () {},
            // ),
          ],
        ),
      ),
    );
  }
}
