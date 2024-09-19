import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart'; // Supabase package
import 'package:geolocator/geolocator.dart'; // For location access

class BookAmbulanceCard extends StatefulWidget {
  @override
  State<BookAmbulanceCard> createState() => _BookAmbulanceCardState();
}

class _BookAmbulanceCardState extends State<BookAmbulanceCard> {
  final _amformKey = GlobalKey<FormState>();
  bool isRecording = false;
  String recordedTime = "0:00"; // Placeholder for the recording time
  String pickupLocation = 'Not detected';
  String phoneNumber = '';
  String problemDescription = '';
  bool isLoadingLocation = false; // To show loading when fetching location

  // Start and stop recording functions (as per your current logic)
  void _startRecording() {
    setState(() {
      isRecording = true;
      recordedTime = "2:30"; // Simulated recording time
    });
  }

  void _stopRecording() {
    setState(() {
      isRecording = false;
    });
  }

  // Function to get the location
  Future<void> _getLocation() async {
    setState(() {
      isLoadingLocation = true; // Show loading indicator
    });

    // Check for location permissions
    bool serviceEnabled;
    LocationPermission permission;

    // Check if location services are enabled
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

    // Check for location permission
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

    // If all permissions are granted, get the current location
    Position position = await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);

    setState(() {
      pickupLocation = '${position.latitude}, ${position.longitude}'; // Set the location as latitude and longitude
      isLoadingLocation = false; // Hide loading indicator
    });
    try {
    // ignore: deprecated_member_use
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

      // Prepare data to be inserted into the Supabase database
      final data = {
        'pickup_location': pickupLocation,
        'phone_number': phoneNumber,
        'problem': problemDescription,
        'recorded_time': recordedTime,
      };

      try {
        final supabase = Supabase.instance.client;

        // Insert data into the table
        final response = await supabase
            .from('patient_emergency_booking') // Replace with your table name
            .insert(data);

        if (response.error == null) {
          // Show success message
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Ambulance booked successfully!')),
          );
        } else {
          throw response.error!;
        }
      } catch (error) {
        // Handle error
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

              // Location Button (Detect Location)
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
                        style: const TextStyle(
                          fontSize: 14.0,
                          color: Colors.white,
                        ),
                      ),
                      if (isLoadingLocation)
                        const CircularProgressIndicator(
                          valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                        )
                      else
                        const Icon(
                          Icons.location_on,
                          color: Colors.white,
                        ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 16.0),
              TextFormField(
                keyboardType: TextInputType.phone,
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                  labelText: 'Enter your Phone Number',
                ),
                onSaved: (value) {
                  phoneNumber = value!;
                },
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Please enter your phone number';
                  } else if (value.length != 10) {
                    return 'Phone number must be 10 digits';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16.0),
              GestureDetector(
                onTap: () {
                  if (isRecording) {
                    _stopRecording();
                  } else {
                    _startRecording();
                  }
                },
                child: Container(
                  padding: const EdgeInsets.symmetric(vertical: 16.0, horizontal: 12.0),
                  decoration: BoxDecoration(
                    color: Colors.lightBlue[100],
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: const [
                          Icon(
                            Icons.mic,
                            color: Colors.white,
                          ),
                          SizedBox(width: 8.0),
                          Text(
                            'Click & tell your Problem',
                            style: TextStyle(
                              fontSize: 12.0,
                              color: Colors.white,
                            ),
                          ),
                        ],
                      ),
                      Text(
                        recordedTime,
                        style: const TextStyle(
                          fontSize: 10.0,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 8.0),
              const Center(
                child: Text(
                  "OR",
                  style: TextStyle(
                    fontSize: 14.0,
                    color: Colors.black54,
                  ),
                ),
              ),
              const SizedBox(height: 8.0),
              TextFormField(
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                  labelText: 'State your Problem',
                ),
                onSaved: (value) {
                  problemDescription = value!;
                },
                validator: (value) =>
                    value!.isEmpty ? 'Please describe the problem' : null,
              ),
              const SizedBox(height: 16.0),
              ElevatedButton(
                onPressed: _submitForm,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.lightBlue,
                  minimumSize: const Size(double.infinity, 48.0),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                ),
                child: const Text(
                  'Book Now',
                  style: TextStyle(
                    fontSize: 16.0,
                    color: Colors.white,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
