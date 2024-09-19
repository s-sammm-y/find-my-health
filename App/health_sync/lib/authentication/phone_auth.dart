

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:health_sync/authentication/otp_verification.dart';
import 'package:health_sync/screens/general.dart';

import 'package:supabase_flutter/supabase_flutter.dart';
 // Import Supabase config

// Phone Number Screen
class PhoneNumberScreen extends StatefulWidget {
  @override
  _PhoneNumberScreenState createState() => _PhoneNumberScreenState();
}

class _PhoneNumberScreenState extends State<PhoneNumberScreen> {
  final TextEditingController _phoneController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool _loading = false;

  // Function to send OTP using Supabase
  Future<void> _sendOtp() async {
    setState(() {
      _loading = true;
    });

    final phoneNumber = _phoneController.text;
    try {
      // Send OTP through Supabase
      await SupabaseConfig.client.auth.signInWithOtp(phone: phoneNumber);

      // If successful, navigate to OTP Screen
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => OtpScreen(phone: phoneNumber)),
      );
    } catch (error) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to send OTP: $error')),
      );
    } finally {
      setState(() {
        _loading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Phone Number Login"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Enter your phone number",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 20),
              TextFormField(
                controller: _phoneController,
                keyboardType: TextInputType.phone,
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: "Phone Number",
                   // Set your country code here
                ),
                inputFormatters: [
                  FilteringTextInputFormatter.digitsOnly,
                ],
                validator: (value) {
                  if (value == null || value.isEmpty || value.length < 10) {
                    return 'Please enter a valid phone number';
                  }
                  return null;
                },
              ),
              SizedBox(height: 20),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _loading ? null : _sendOtp,
                  child: _loading ? CircularProgressIndicator() : Text("Next"),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// OTP Screen
class OtpScreen extends StatefulWidget {
  final String phone;

  OtpScreen({required this.phone});

  @override
  _OtpScreenState createState() => _OtpScreenState();
}

class _OtpScreenState extends State<OtpScreen> {
  final TextEditingController _otpController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool _loading = false;

  // Function to verify OTP using Supabase
  Future<void> _verifyOtp() async {
    setState(() {
      _loading = true;
    });

    final otpCode = _otpController.text;
    try {
      // Verify OTP through Supabase
      final response = await SupabaseConfig.client.auth.verifyOTP(
        phone: widget.phone,
        token: otpCode,
        type: OtpType.sms,
      );

      if (response.session != null) {
        // OTP verified successfully
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('OTP Verified!')),
        );
         Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => GeneralScreen()), // Replace GeneralScreen with your main screen
      );
        // Navigate to the next page or dashboard
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('OTP verification failed')),
        );
      }
    } catch (error) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to verify OTP: $error')),
      );
    } finally {
      setState(() {
        _loading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Enter OTP"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Enter the OTP sent to ${widget.phone}",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 20),
              TextFormField(
                controller: _otpController,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: "OTP",
                ),
                inputFormatters: [
                  FilteringTextInputFormatter.digitsOnly,
                ],
                validator: (value) {
                  if (value == null || value.isEmpty || value.length != 6) {
                    return 'Please enter a valid 6-digit OTP';
                  }
                  return null;
                },
              ),
              SizedBox(height: 20),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _loading ? null : _verifyOtp,
                  child: _loading ? CircularProgressIndicator() : Text("Verify OTP"),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}