// profile_screen.dart

import 'dart:io';
import 'package:flutter/material.dart';
import 'package:health_sync/authentication/login_signup.dart';
import 'package:health_sync/screens/pdf_viewer_screen.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:path_provider/path_provider.dart';
import 'package:http/http.dart' as http;
import 'package:dart_ipify/dart_ipify.dart';
import 'drawer_slider.dart'; // For accessing UserData class

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  @override
  void initState() {
    super.initState();
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

      UserData.userId = null;
      UserData.userName = null;
      UserData.userMobile = null;

      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => LoginSignupScreen()),
        (route) => false,
      );
    } catch (error) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Sign out failed: $error')),
      );
    }
  }

  void _showPrescription(BuildContext context, String? userId) async {
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
    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile'),
      ),
      body: ListView(
        children: [
          UserAccountsDrawerHeader(
            accountName: Text(UserData.userName ?? "Fetching..."),
            accountEmail: Text(UserData.userMobile ?? "Fetching..."),
            currentAccountPicture: const CircleAvatar(
              backgroundColor: Colors.white,
              child: Icon(Icons.person, size: 50, color: Colors.teal),
            ),
            decoration: const BoxDecoration(
              color: Colors.teal,
            ),
          ),
          ListTile(
            title: const Text('Prescriptions'),
            subtitle: const Text('All your doctor Prescriptions'),
            onTap: () => _showPrescription(context, UserData.userId),
          ),
          ListTile(
            title: const Text('Sign Out'),
            subtitle: const Text('Login from another number'),
            onTap: () => _signOut(context),
          ),
          const Divider(),
        ],
      ),
    );
  }
}
