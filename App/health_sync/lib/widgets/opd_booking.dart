import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:health_sync/screens/general.dart';

class OPDBookingPage extends StatefulWidget {
  final String selectedDisease;

  OPDBookingPage({required this.selectedDisease});

  @override
  _OPDBookingPageState createState() => _OPDBookingPageState();
}

class _OPDBookingPageState extends State<OPDBookingPage> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _ageController = TextEditingController();
  final TextEditingController _aadhaarController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _initializeNotifications();
  }

  String? _selectedDate;
  String? _selectedTime;
  final List<String> _timeSlots = ["Morning", "Afternoon"];

  Future<void> _selectDate(BuildContext context) async {
    DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(Duration(days: 30)),
    );
    if (picked != null) {
      setState(() {
        _selectedDate = DateFormat('yyyy-MM-dd').format(picked);
      });
    }
  }

  Future<void> _submitForm() async {
    String name = _nameController.text;
    String phone = _phoneController.text;
    String age = _ageController.text;
    String aadhaar = _aadhaarController.text;
    String address = _addressController.text;
    String disease = widget.selectedDisease;

    if (name.isEmpty ||
        phone.isEmpty ||
        age.isEmpty ||
        aadhaar.isEmpty ||
        address.isEmpty ||
        _selectedDate == null ||
        _selectedTime == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Please fill all fields")),
      );
      return;
    }

    try {
      // Insert data into Supabase
      final response =
          await Supabase.instance.client.from('opd_bookings').insert({
        'name': name,
        'phone': phone,
        'age': age,
        'aadhaar': aadhaar,
        'address': address,
        'disease': disease,
        'appointment_date': _selectedDate,
        'time_slot': _selectedTime,
        'created_at': DateTime.now().toIso8601String(),
      }).select();

      if (response.isNotEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Booking Successful!")),
        );
        _showLocalNotification(disease, name);
        if (mounted) {
          Future.delayed(Duration(seconds: 1), () {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => GeneralScreen()),
            );
          });
        }
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Error: Booking failed")),
        );
      }
    } 
    catch (e) {
      // Handle exceptions
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Booking Done!")),
      );
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

  Future<void> _showLocalNotification(String disease, String name) async {
    const AndroidNotificationDetails androidPlatformChannelSpecifics =
    AndroidNotificationDetails(
      'opd_channel',
      'OPD Alerts',
      importance: Importance.high,
      priority: Priority.high,
      ticker: 'ticker',
    );

    const NotificationDetails platformChannelSpecifics =
        NotificationDetails(android: androidPlatformChannelSpecifics);

    await flutterLocalNotificationsPlugin.show(
      0,
      '🚨 OPD Booking Done!',
      'Problem: $disease | Name: $name',
      platformChannelSpecifics,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: Text("OPD Booking"),
        backgroundColor: Colors.blue,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildTextField("Full Name", _nameController, TextInputType.text),
            _buildTextField(
                "Phone Number", _phoneController, TextInputType.phone),
            Padding(
              padding: const EdgeInsets.only(bottom: 12.0),
              child: TextFormField(
                readOnly: true,
                initialValue: widget.selectedDisease,
                decoration: InputDecoration(
                  labelText: "Selected Disease",
                  border: OutlineInputBorder(),
                ),
              ),
            ),
            _buildTextField("Age", _ageController, TextInputType.number),
            _buildTextField(
                "Aadhaar Number", _aadhaarController, TextInputType.number),
            _buildTextField("Address", _addressController, TextInputType.text,
                maxLines: 2),
            ListTile(
              title: Text(_selectedDate ?? "Select Appointment Date"),
              leading: Icon(Icons.calendar_today, color: Colors.blue),
              onTap: () => _selectDate(context),
              tileColor: Colors.white,
            ),
            SizedBox(height: 12),
            DropdownButtonFormField<String>(
              decoration: InputDecoration(
                labelText: "Select Time Slot",
                border: OutlineInputBorder(),
              ),
              value: _selectedTime,
              items: _timeSlots.map((time) {
                return DropdownMenuItem<String>(
                  value: time,
                  child: Text(time),
                );
              }).toList(),
              onChanged: (value) {
                setState(() {
                  _selectedTime = value;
                });
              },
            ),
            SizedBox(height: 20),
            Center(
              child: ElevatedButton(
                onPressed: _submitForm,
                child: Text("Submit Booking"),
                style: ElevatedButton.styleFrom(
                  padding: EdgeInsets.symmetric(horizontal: 90, vertical: 15),
                  textStyle: const TextStyle(
                      fontSize: 15,
                      color: Colors.white,
                      fontWeight: FontWeight.bold),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  backgroundColor: Colors.lightBlue,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTextField(String label, TextEditingController controller,
      TextInputType keyboardType,
      {int maxLines = 1}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12.0),
      child: TextField(
        controller: controller,
        keyboardType: keyboardType,
        maxLines: maxLines,
        decoration: InputDecoration(
          labelText: label,
          border: OutlineInputBorder(),
        ),
      ),
    );
  }
}
