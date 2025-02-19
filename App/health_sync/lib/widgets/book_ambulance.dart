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

class _BookAmbulanceCardState extends State<BookAmbulanceCard> {
  final _amformKey = GlobalKey<FormState>();
  String pickupLocation = 'Not detected';
  String name = '';
  String problemDescription = '';
  bool isLoadingLocation = false;
  
  stt.SpeechToText _speechToText = stt.SpeechToText();
  bool _isListening = false;
  TextEditingController _problemController = TextEditingController();
  
  @override
  void initState() {
    super.initState();
    _initializeSpeech();
    _initializeNotifications();
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
          SnackBar(content: Text('Location permissions are permanently denied.')),
        );
        setState(() => isLoadingLocation = false);
        return;
      }
    }
    try {
      Position position = await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.best);
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
      final int? userId = UserData.userId;
      final data = {
        'userid': userId,
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

  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
  
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
      'emergency_channel', 'Emergency Alerts',
      importance: Importance.high,
      priority: Priority.high,
    );
    const NotificationDetails platformChannelSpecifics =
        NotificationDetails(android: androidPlatformChannelSpecifics);
    await flutterLocalNotificationsPlugin.show(
      0, '🚨 Emergency Booking Alert', 'Problem: $problem | Name: $name',
      platformChannelSpecifics,
    );
  }
  @override
  Widget build(BuildContext context) {
    return Form(
      key: _amformKey,
      child: Card(
        color: Colors.white,
        margin: const EdgeInsets.all(5.0),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8.0),
        ),
        elevation: 4.0,
        child: Padding(
          padding: const EdgeInsets.all(15.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Emergency Booking',
                style: TextStyle(
                  fontSize: 17.0,
                  fontWeight: FontWeight.bold,
                  color: Colors.lightBlue,
                ),
              ),
              const SizedBox(height: 16.0),
              GestureDetector(
                onTap: _getLocation,
                child: Container(
                  padding: const EdgeInsets.symmetric(vertical: 16.0, horizontal: 12.0),
                  decoration: BoxDecoration(
                    color: Colors.lightBlue[100],
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Pickup Location: $pickupLocation',
                        style: const TextStyle(fontSize: 14.0, color: Colors.white),
                      ),
                      if (isLoadingLocation)
                        const CircularProgressIndicator(valueColor: AlwaysStoppedAnimation<Color>(Colors.white))
                      else
                        const Icon(Icons.location_on, color: Colors.white),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 16.0),
              TextFormField(
                keyboardType: TextInputType.name,
                decoration: InputDecoration(
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(8.0)),
                  labelText: 'Enter your Name',
                ),
                onSaved: (value) => name = value!,
                validator: (value) =>
                    (value == null || value.trim().split(' ').length < 2) ? 'Please enter your full name' : null,
              ),
              const SizedBox(height: 16.0),
              TextFormField(
                controller: _problemController,
                decoration: InputDecoration(
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(8.0)),
                  labelText: 'State your Problem',
                  suffixIcon: IconButton(
                    icon: Icon(_isListening ? Icons.mic_off : Icons.mic),
                    onPressed: _isListening ? _stopListening : _startListening,
                  ),
                ),
                onSaved: (value) => problemDescription = value!, // Still needed for form submission
                validator: (value) => value!.isEmpty ? 'Please describe the problem' : null,
              ),
              const SizedBox(height: 16.0),
              ElevatedButton(
                onPressed: _submitForm,
                style: ElevatedButton.styleFrom(backgroundColor: Colors.lightBlue),
                child: const Text('Book Now', style: TextStyle(color: Colors.white)),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
