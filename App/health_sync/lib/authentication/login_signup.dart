import 'package:flutter/material.dart';
import 'package:health_sync/screens/general.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:dart_ipify/dart_ipify.dart';
import 'dart:convert';
import 'package:crypto/crypto.dart';

class LoginSignupScreen extends StatefulWidget {
  @override
  _LoginSignupScreenState createState() => _LoginSignupScreenState();
}

class _LoginSignupScreenState extends State<LoginSignupScreen> {
  final SupabaseClient supabase = Supabase.instance.client;
  final TextEditingController mobileController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController otpController = TextEditingController();
  
  bool isSignup = false;
  bool _loading = false;
  bool isOtpSent = false;

  /// Hashes the password using SHA256
  String hashPassword(String password) {
    return sha256.convert(utf8.encode(password)).toString();
  }

  /// Handles OTP-based signup and login
  Future<void> _authenticateUser() async {
  if (_loading) return; // Prevent multiple taps

  setState(() => _loading = true);

  final String mobile = "+91" + mobileController.text.trim();
  final String password = passwordController.text.trim();

  if (mobile.isEmpty || password.isEmpty) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Please enter all fields')),
    );
    setState(() => _loading = false);
    return;
  }

  try {
    if (isSignup) {
      if (!isOtpSent) {
        // Send OTP
        await supabase.auth.signInWithOtp(phone: mobile);
        setState(() => isOtpSent = true);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('OTP Sent! Please enter the code.')),
        );
        return;
      }

      // Verify OTP
      final String otp = otpController.text.trim();
      if (otp.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Please enter the OTP received.')),
        );
        return;
      }

      print("Verifying OTP for: $mobile, OTP: $otp");

      final AuthResponse res = await supabase.auth.verifyOTP(
        type: OtpType.sms,
        token: otp,
        phone: mobile,
      ).timeout(const Duration(seconds: 10)); // Prevent indefinite waiting

      if (res.user == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Invalid OTP! Please try again.')),
        );
        return;
      }

      // Check user count & generate user_id
      final userCountResponse = await supabase.from('users').select('user_id');
      final int userCount = (userCountResponse as List).length;
      final int newUserId = userCount + 1;

      // Insert new user
      await supabase.from('users').insert({
        'user_id': newUserId,
        'mobile_no': mobile,
        'password': hashPassword(password),
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Signup successful! Please log in.')),
      );

      setState(() {
        isSignup = false;
        isOtpSent = false;
        otpController.clear();
      });

    } else {
      // **LOGIN LOGIC**
      final response = await supabase
          .from('users')
          .select()
          .eq('mobile_no', mobile)
          .eq('password', hashPassword(password))
          .maybeSingle();

      if (response != null) {
        final String userIp = await Ipify.ipv4();
        final user = await supabase
            .from('users')
            .select('user_id')
            .eq('mobile_no', mobile)
            .single();
        final int userId = user['user_id'];

        await supabase.from('logged_in_users').insert({'ip': userIp, 'userid': userId});

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
  } finally {
    setState(() => _loading = false); // Ensure loading stops in all cases
  }
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
            if (isSignup && isOtpSent) ...[
              SizedBox(height: 10),
              TextField(
                controller: otpController,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: "Enter OTP",
                ),
              ),
            ],
            SizedBox(height: 20),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _loading ? null : _authenticateUser,
                child: _loading
                    ? CircularProgressIndicator()
                    : Text(isSignup ? (isOtpSent ? "Verify OTP" : "Send OTP") : "Login"),
              ),
            ),
            SizedBox(height: 10),
            TextButton(
              onPressed: () {
                setState(() {
                  isSignup = !isSignup;
                  isOtpSent = false;
                  otpController.clear();
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
