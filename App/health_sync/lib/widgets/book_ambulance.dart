import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:geolocator/geolocator.dart';
import 'package:uuid/uuid.dart';
import 'package:health_sync/Profile/drawer_slider.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt;

class BookAmbulanceCard extends StatefulWidget {
  @override
  State<BookAmbulanceCard> createState() => _BookAmbulanceCardState();
}

class _BookAmbulanceCardState extends State<BookAmbulanceCard>
    with SingleTickerProviderStateMixin {
  // Add mixin
  final _amformKey = GlobalKey<FormState>();
  String pickupLocation = 'Not detected';
  String name = '';
  String problemDescription = '';
  bool isLoadingLocation = false;

  stt.SpeechToText _speechToText = stt.SpeechToText();
  bool _isListening = false;
  TextEditingController _problemController = TextEditingController();

  // Animation variables
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _initializeSpeech();
    _initializeNotifications();

    // Initialize animation
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this,
    );
    _fadeAnimation = CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeIn,
    );

    _animationController.forward(); // Start animation
  }

  @override
  void dispose() {
    _animationController.dispose(); // Dispose controller
    _problemController.dispose();
    // _speechToText.stop(); // Consider stopping speech if active on dispose
    super.dispose();
  }

  Future<void> _initializeSpeech() async {
    bool available = await _speechToText.initialize(
      onError: (error) => print("Speech error: $error"),
      onStatus: (status) => print("Speech status: $status"),
    );
    if (!available) {
      print("Speech recognition not available");
    }
  }

  void _startListening() async {
    if (!_speechToText.isAvailable) {
      print("Speech recognition is not available");
      return;
    }
    if (!_speechToText.isListening) {
      await _speechToText.listen(
        onResult: (result) {
          setState(() {
            _problemController.text = result.recognizedWords;
          });
        },
        listenFor: Duration(seconds: 10),
        pauseFor: Duration(seconds: 3),
        cancelOnError: false,
      );
      setState(() => _isListening = true);
    }
  }

  void _stopListening() {
    if (_speechToText.isListening) {
      _speechToText.stop();
      setState(() => _isListening = false);
    }
  }

  Future<void> _getLocation() async {
    setState(() => isLoadingLocation = true);
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Location services are disabled.')),
      );
      setState(() => isLoadingLocation = false);
      return;
    }
    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.deniedForever) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
              content: Text('Location permissions are permanently denied.')),
        );
        setState(() => isLoadingLocation = false);
        return;
      }
    }
    try {
      Position position = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.best);
      setState(() {
        pickupLocation = '${position.latitude}, ${position.longitude}';
        isLoadingLocation = false;
      });
    } catch (error) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error getting location: $error')),
      );
      setState(() => isLoadingLocation = false);
    }
  }

  void _submitForm() async {
    if (_amformKey.currentState!.validate()) {
      _amformKey.currentState!.save();
      final uuid = Uuid();
      final String emergencyId = uuid.v4();
      final String? userId = UserData.userId;
      final data = {
        'user_id': userId,
        'emergency_id': emergencyId,
        'problem': problemDescription,
        'name': name,
        'created_at': DateTime.now().toIso8601String()
      };
      try {
        final supabase = Supabase.instance.client;
        await supabase.from('emergency_booking').insert(data);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('🚨 Emergency booked successfully!')),
        );
        _showLocalNotification(problemDescription, name);
      } catch (error) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: $error')),
        );
      }
    }
  }

  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  Future<void> _initializeNotifications() async {
    const AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings('@mipmap/ic_launcher');
    final InitializationSettings initializationSettings =
        InitializationSettings(android: initializationSettingsAndroid);
    await flutterLocalNotificationsPlugin.initialize(initializationSettings);
  }

  Future<void> _showLocalNotification(String problem, String name) async {
    const AndroidNotificationDetails androidPlatformChannelSpecifics =
        AndroidNotificationDetails(
      'emergency_channel',
      'Emergency Alerts',
      importance: Importance.high,
      priority: Priority.high,
    );
    const NotificationDetails platformChannelSpecifics =
        NotificationDetails(android: androidPlatformChannelSpecifics);
    await flutterLocalNotificationsPlugin.show(
      0,
      '🚨 Emergency Booking Alert',
      'Problem: $problem | Name: $name',
      platformChannelSpecifics,
    );
  }

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: _fadeAnimation,
      child: Form(
        key: _amformKey,
        child: Card(
          color: Colors.white,
          margin: const EdgeInsets.all(10.0),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12.0),
          ),
          elevation: 5.0,
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Emergency Booking',
                  style: TextStyle(
                    fontSize: 20.0,
                    fontWeight: FontWeight.bold,
                    color: Colors.teal,
                  ),
                ),
                const SizedBox(height: 24.0),
                GestureDetector(
                  onTap: _getLocation,
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                        vertical: 16.0, horizontal: 12.0),
                    decoration: BoxDecoration(
                      color: Colors.teal[50],
                      borderRadius: BorderRadius.circular(8.0),
                      border: Border.all(color: Colors.teal.shade100),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Text(
                            'Pickup Location: $pickupLocation',
                            style: const TextStyle(
                              fontSize: 14.0,
                              color: Colors.teal,
                            ),
                          ),
                        ),
                        const SizedBox(width: 10),
                        if (isLoadingLocation)
                          const SizedBox(
                            height: 20,
                            width: 20,
                            child: CircularProgressIndicator(
                              valueColor:
                                  AlwaysStoppedAnimation<Color>(Colors.teal),
                            ),
                          )
                        else
                          const Icon(Icons.location_on, color: Colors.teal),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 20.0),
                TextFormField(
                  keyboardType: TextInputType.name,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.teal, width: 2.0),
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                    labelText: 'Enter your Full Name',
                    labelStyle: TextStyle(color: Colors.grey[600]),
                  ),
                  onSaved: (value) => name = value!,
                  validator: (value) => (value == null || value.trim().isEmpty)
                      ? 'Please enter your name'
                      : null,
                ),
                const SizedBox(height: 20.0),
                TextFormField(
                  controller: _problemController,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.teal, width: 2.0),
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                    labelText: 'State your Problem',
                    labelStyle: TextStyle(color: Colors.grey[600]),
                    suffixIcon: IconButton(
                      icon: Icon(
                        _isListening ? Icons.mic : Icons.mic_off,
                        color: Colors.teal,
                      ),
                      onPressed:
                          _isListening ? _stopListening : _startListening,
                    ),
                  ),
                  onSaved: (value) => problemDescription = value!,
                  validator: (value) =>
                      value!.isEmpty ? 'Please describe the problem' : null,
                  maxLines: 3,
                ),
                const SizedBox(height: 24.0),
                Center(
                  child: Container(
                    decoration: BoxDecoration(
                      boxShadow: [
                        BoxShadow(
                          color: Colors.teal.withOpacity(0.5),
                          spreadRadius: 2,
                          blurRadius: 10,
                          offset: const Offset(0, 3),
                        ),
                      ],
                      borderRadius: BorderRadius.circular(30.0),
                    ),
                    child: ElevatedButton(
                      onPressed: _submitForm,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.teal,
                        padding: const EdgeInsets.symmetric(
                            horizontal: 100, vertical: 15),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30.0),
                        ),
                        elevation: 3.0,
                      ),
                      child: const Text(
                        'Book Now',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 16.0,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
