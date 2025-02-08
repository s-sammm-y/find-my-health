import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:geolocator/geolocator.dart';
import 'package:uuid/uuid.dart';
import 'package:health_sync/Profile/drawer_slider.dart'; // Import drawer_slyder.dart to access static userId

class BookAmbulanceCard extends StatefulWidget {
  @override
  State<BookAmbulanceCard> createState() => _BookAmbulanceCardState();
}

class _BookAmbulanceCardState extends State<BookAmbulanceCard> {
  final _amformKey = GlobalKey<FormState>();
  bool isRecording = false;
  String recordedTime = "0:00";
  String pickupLocation = 'Not detected';
  String name = '';
  String problemDescription = '';
  bool isLoadingLocation = false;

  // void _startRecording() {
  //   setState(() {
  //     isRecording = true;
  //     recordedTime = "2:30";
  //   });
  // }

  // void _stopRecording() {
  //   setState(() {
  //     isRecording = false;
  //   });
  // }

  Future<void> _getLocation() async {
    setState(() {
      isLoadingLocation = true;
    });

    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Location services are disabled.')),
      );
      setState(() {
        isLoadingLocation = false;
      });
      return;
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Location permissions are denied.')),
        );
        setState(() {
          isLoadingLocation = false;
        });
        return;
      }
    }

    if (permission == LocationPermission.deniedForever) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Location permissions are permanently denied.')),
      );
      setState(() {
        isLoadingLocation = false;
      });
      return;
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
      setState(() {
        isLoadingLocation = false;
      });
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
    };

    try {
      final supabase = Supabase.instance.client;
      await supabase.from('emergency_booking').insert(data);

      ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Emergency booked successfully!')),
      );
    } catch (error) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $error')),
      );
    }
  }
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
                'Book Ambulance',
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
                decoration: InputDecoration(
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(8.0)),
                  labelText: 'State your Problem',
                ),
                onSaved: (value) => problemDescription = value!,
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
