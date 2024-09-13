import 'package:flutter/material.dart';
// import 'package:supabase_flutter/supabase_flutter.dart';

class BookAmbulanceCard extends StatefulWidget {
  @override
  State<BookAmbulanceCard> createState() => _BookAmbulanceCardState();
}

class _BookAmbulanceCardState extends State<BookAmbulanceCard> {
  final _amformKey = GlobalKey<FormState>();
  String? selectedHospital;
  bool isRecording = false;
  String recordedTime = "0:00"; // Placeholder for the recording time
  String pickupLocation = '';
  String patientName = '';
  String problemDescription = '';

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

  void _submitForm() async {
    if (_amformKey.currentState!.validate()) {
      _amformKey.currentState!.save();

      // Prepare data to be inserted into the Supabase database
      // final data = {
      //   'hospital': selectedHospital,
      //   'pickup_location': pickupLocation,
      //   'patient_name': patientName,
      //   'problem': problemDescription,
      //   'recorded_time': recordedTime,
      // };

      // try {
        // final supabase = Supabase.instance.client;

        // Insert data into the table
        // ignore: unused_local_variable
        // final response = await supabase
        //     .from('patient_emergency_booking') // Replace with your table name
        //     .insert(data);
  
        // if (response.error == null) {
        //   // Show success message
        //    throw response.error!;
          
        // } else {
        //  ScaffoldMessenger.of(context).showSnackBar(
        //     SnackBar(content: Text('Ambulance booked successfully!')),
        //   );
        // }
      // } catch (error) {
      //   // Handle error
      //   ScaffoldMessenger.of(context).showSnackBar(
      //     SnackBar(content: Text('Failed to book ambulance: $error')),
      //   );
      // }
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
              const SizedBox(height: 5.0),
              DropdownButtonFormField<String>(
                value: selectedHospital,
                hint: const Text('Select Hospital'),
                onChanged: (value) {
                  setState(() {
                    selectedHospital = value;
                  });
                },
                items: <String>['Hospital A', 'Hospital B', 'Hospital C']
                    .map<DropdownMenuItem<String>>((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
                validator: (value) =>
                    value == null ? 'Please select a hospital' : null,
              ),
              const SizedBox(height: 16.0),
              TextFormField(
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                  labelText: 'Enter pickup location',
                ),
                onSaved: (value) {
                  pickupLocation = value!;
                },
                validator: (value) =>
                    value!.isEmpty ? 'Please enter a pickup location' : null,
              ),
              const SizedBox(height: 16.0),
              TextFormField(
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                  labelText: 'Write your Name',
                ),
                onSaved: (value) {
                  patientName = value!;
                },
                validator: (value) =>
                    value!.isEmpty ? 'Please enter your name' : null,
              ),
              SizedBox(height: 16.0),
              GestureDetector(
                onTap: () {
                  if (isRecording) {
                    _stopRecording();
                  } else {
                    _startRecording();
                  }
                },
                child: Container(
                  padding:
                      EdgeInsets.symmetric(vertical: 16.0, horizontal: 12.0),
                  decoration: BoxDecoration(
                    color: Colors.lightBlue[100],
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
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
                        style: TextStyle(
                          fontSize: 10.0,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(height: 8.0),
              Center(
                child: Text(
                  "OR",
                  style: TextStyle(
                    fontSize: 14.0,
                    color: Colors.black54,
                  ),
                ),
              ),
              SizedBox(height: 8.0),
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
              SizedBox(height: 16.0),
              ElevatedButton(
                onPressed: _submitForm,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.lightBlue,
                  minimumSize: Size(double.infinity, 48.0),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                ),
                child: Text(
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
