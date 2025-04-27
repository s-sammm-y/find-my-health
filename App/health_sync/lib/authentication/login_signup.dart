import 'package:flutter/material.dart';
import 'package:health_sync/screens/general.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:dart_ipify/dart_ipify.dart';
import 'dart:convert';
import 'package:crypto/crypto.dart';
import 'package:uuid/uuid.dart';

class LoginSignupScreen extends StatefulWidget {
  const LoginSignupScreen({super.key});

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

  String hashPassword(String password) {
    return sha256.convert(utf8.encode(password)).toString();
  }

  Future<void> _authenticateUser() async {
    if (_loading) return;
    setState(() => _loading = true);

    final String mobile = "+91${mobileController.text.trim()}";
    final String password = passwordController.text.trim();

    if (mobile.length < 12 || password.isEmpty) {
      _showMessage('Please enter valid mobile number and password');
      setState(() => _loading = false);
      return;
    }

    try {
      if (isSignup) {
        if (!isOtpSent) {
          await supabase.auth.signInWithOtp(phone: mobile);
          setState(() => isOtpSent = true);
          _showMessage('OTP Sent! Please enter the code.');
          return;
        }

        final String otp = otpController.text.trim();
        if (otp.isEmpty) {
          _showMessage('Please enter the OTP received.');
          return;
        }

        final AuthResponse res = await supabase.auth.verifyOTP(
          type: OtpType.sms,
          token: otp,
          phone: mobile,
        ).timeout(const Duration(seconds: 10));

        if (res.user == null) {
          _showMessage('Invalid OTP! Please try again.');
          return;
        }

        const uuid = Uuid();
        final String userId = uuid.v4();
        await supabase.from('users').insert({
          'user_id': userId,
          'mobile_no': mobile,
          'password': hashPassword(password),
        });

        _showMessage('Signup successful! Please log in.');
        setState(() {
          isSignup = false;
          isOtpSent = false;
          otpController.clear();
        });
      } else {
        final response = await supabase
            .from('users')
            .select('user_id')
            .eq('mobile_no', mobile)
            .eq('password', hashPassword(password))
            .maybeSingle();

        if (response != null) {
          final String userIp = await Ipify.ipv4();
          final String userId = response['user_id'];
          await supabase.from('logged_in_users').delete().eq('user_id', userId);
          await supabase.from('logged_in_users').insert({'ip': userIp, 'user_id': userId});

          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => const GeneralScreen()),
          );
        } else {
          _showMessage('Invalid login credentials');
        }
      }
    } catch (error) {
      _showMessage('Error: $error');
    } finally {
      setState(() => _loading = false);
    }
  }

  void _showMessage(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        behavior: SnackBarBehavior.floating,
        backgroundColor: Colors.black87,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          // Upper Part: Hero Image
          Expanded(
            flex: 4,
            child: Container(
              width: double.infinity,
              decoration: const BoxDecoration(
                image: DecorationImage(
                  image: NetworkImage(
                    'https://img.freepik.com/free-photo/young-man-being-ill-hospital-bed_23-2149017252.jpg',
                  ),
                  fit: BoxFit.cover,
                ),
              ),
              // child: Center(
              //   child: Text(
              //     "HealthSync",
              //     style: TextStyle(
              //       color: Colors.white,
              //       fontSize: 36,
              //       fontWeight: FontWeight.bold,
              //       shadows: [
              //         Shadow(
              //           blurRadius: 8.0,
              //           color: Colors.black45,
              //           offset: Offset(2, 2),
              //         ),
              //       ],
              //     ),
              //   ),
              // ),
            ),
          ),
          // Lower Part: Form
          Expanded(
            flex: 6,
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.vertical(top: Radius.circular(32)),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black12,
                    blurRadius: 10,
                    offset: Offset(0, -5),
                  ),
                ],
              ),
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      isSignup ? "Sign Up" : "Login",
                      style: const TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 24),
                    _buildTextField(
                      controller: mobileController,
                      label: "Mobile Number",
                      keyboardType: TextInputType.phone,
                    ),
                    const SizedBox(height: 16),
                    _buildTextField(
                      controller: passwordController,
                      label: "Password",
                      obscureText: true,
                    ),
                    if (isSignup && isOtpSent) ...[
                      const SizedBox(height: 16),
                      _buildTextField(
                        controller: otpController,
                        label: "Enter OTP",
                        keyboardType: TextInputType.number,
                      ),
                    ],
                    const SizedBox(height: 24),
                    _buildActionButton(),
                    const SizedBox(height: 16),
                    Center(
                      child: TextButton(
                        onPressed: () {
                          setState(() {
                            isSignup = !isSignup;
                            isOtpSent = false;
                            otpController.clear();
                          });
                        },
                        child: Text(
                          isSignup
                              ? "Already have an account? Login"
                              : "Don't have an account? Sign Up",
                          style: TextStyle(
                            color: Colors.teal.shade700,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    bool obscureText = false,
    TextInputType keyboardType = TextInputType.text,
  }) {
    return TextField(
      controller: controller,
      obscureText: obscureText,
      keyboardType: keyboardType,
      decoration: InputDecoration(
        labelText: label,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
        filled: true,
        fillColor: Colors.grey[100],
      ),
    );
  }

  Widget _buildActionButton() {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: _loading ? null : _authenticateUser,
        style: ElevatedButton.styleFrom(
          padding: const EdgeInsets.symmetric(vertical: 16),
          backgroundColor: Colors.teal.shade600,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        child: _loading
            ? const SizedBox(
                height: 24,
                width: 24,
                child: CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                  strokeWidth: 2,
                ),
              )
            : Text(
                isSignup ? (isOtpSent ? "Verify OTP" : "Send OTP") : "Login",
                style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
      ),
    );
  }

  @override
  void dispose() {
    mobileController.dispose();
    passwordController.dispose();
    otpController.dispose();
    super.dispose();
  }
}
