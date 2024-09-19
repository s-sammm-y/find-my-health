import 'package:flutter/material.dart';
import 'package:health_sync/screens/general.dart';
import 'package:intl/intl.dart';
import 'package:supabase_flutter/supabase_flutter.dart'; //aniruddha is a donkey

class TimeSelect extends StatefulWidget {
  final Map<String, dynamic> registrationData;
  final void Function(String, int) onAppointmentSelected;

  const TimeSelect({
    Key? key,
    required this.registrationData,
    required this.onAppointmentSelected,
  }) : super(key: key);

  @override
  _TimeSelectState createState() => _TimeSelectState();
}

class _TimeSelectState extends State<TimeSelect> {
  DateTime selectedDate = DateTime.now();
  final TextEditingController dateController = TextEditingController();
  List<int> bookedTokens = [];
  bool isMorningSelected = true;
  int selectedToken = -1;

  @override
  void initState() {
    super.initState();
    dateController.text = DateFormat('dd/MM/yyyy').format(selectedDate);
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: selectedDate,
      firstDate: DateTime.now(),
      lastDate: DateTime(selectedDate.year, selectedDate.month + 1, 0),
    );

    if (pickedDate != null && pickedDate != selectedDate) {
      setState(() {
        selectedDate = pickedDate;
        dateController.text = DateFormat('dd/MM/yyyy').format(selectedDate);
        bookedTokens.clear(); // Clear booked tokens for a new date
      });
    }
  }

  Future<void> _saveAppointment(String date, int token) async {
    final response =
        await Supabase.instance.client.from('appointments').insert({
      'date': date,
      'token': token,
      'time_slot': isMorningSelected ? 'morning' : 'afternoon',
      'user_data': widget.registrationData,
    });

    if (response.error == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Appointment saved successfully!')),
      );
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (context) => const GeneralScreen()),
      );
      setState(() {
        bookedTokens.add(token);
      });
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
            content:
                Text('Failed to save appointment: ${response.error!.message}')),
      );
    }
  }

  void _showBookingDialog(int token) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Confirm Booking'),
          content: Text('Do you want to confirm booking for token $token?'),
          actions: [
            TextButton(
              child: const Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: const Text('Confirm'),
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
                setState(() {
                  selectedToken = token;
                });
                widget.onAppointmentSelected(
                    dateController.text, selectedToken);
                _saveAppointment(
                    dateController.text, selectedToken); // Save to Supabase
              },
            ),
          ],
        );
      },
    );
  }

  List<String> _generateTimeSlots() {
    List<String> slots = [];
    DateTime startTime;
    DateTime endTime;

    if (isMorningSelected) {
      startTime = DateTime(
          selectedDate.year, selectedDate.month, selectedDate.day, 8, 0);
      endTime = DateTime(
          selectedDate.year, selectedDate.month, selectedDate.day, 12, 50);
    } else {
      startTime = DateTime(
          selectedDate.year, selectedDate.month, selectedDate.day, 13, 0);
      endTime = DateTime(
          selectedDate.year, selectedDate.month, selectedDate.day, 17, 50);
    }

    while (startTime.isBefore(endTime)) {
      slots.add(DateFormat('hh:mm a').format(startTime));
      startTime = startTime.add(Duration(minutes: 10));
    }
    return slots;
  }

  @override
  Widget build(BuildContext context) {
    List<String> timeSlots = _generateTimeSlots();
    return Scaffold(
      appBar: AppBar(
        title: const Text("Select Time"),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: TextField(
              controller: dateController,
              readOnly: true,
              decoration: const InputDecoration(
                labelText: "Select Date",
                border: OutlineInputBorder(),
              ),
              onTap: () {
                _selectDate(context);
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                GestureDetector(
                  onTap: () {
                    setState(() {
                      isMorningSelected = true;
                    });
                  },
                  child: Container(
                    decoration: BoxDecoration(
                      color: isMorningSelected ? Colors.blue : Colors.grey[300],
                      borderRadius:
                          BorderRadius.circular(12), // Increased border radius
                    ),
                    padding: const EdgeInsets.all(16.0), // Increased padding
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: const [
                        Text(
                          'Morning',
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 22), // Increased font size
                        ),
                        Text(
                          '8:00 AM - 12:50 PM',
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 14), // Increased font size
                        ),
                      ],
                    ),
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    setState(() {
                      isMorningSelected = false;
                    });
                  },
                  child: Container(
                    decoration: BoxDecoration(
                      color:
                          !isMorningSelected ? Colors.blue : Colors.grey[300],
                      borderRadius:
                          BorderRadius.circular(12), // Increased border radius
                    ),
                    padding: const EdgeInsets.all(16.0), // Increased padding
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: const [
                        Text(
                          'Afternoon',
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 22), // Increased font size
                        ),
                        Text(
                          '1:00 PM - 5:50 PM',
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 14), // Increased font size
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: GridView.builder(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 4, // Increased to 4 for larger items
                  childAspectRatio:
                      1, // Adjusted aspect ratio to make items square
                  crossAxisSpacing: 12,
                  mainAxisSpacing: 12,
                ),
                itemCount: timeSlots.length,
                itemBuilder: (context, index) {
                  String timeSlot = timeSlots[index];
                  int tokenNumber = index + 1;
                  bool isBooked = bookedTokens.contains(tokenNumber);

                  return GestureDetector(
                    onTap: !isBooked
                        ? () {
                            _showBookingDialog(tokenNumber);
                          }
                        : null,
                    child: Container(
                      decoration: BoxDecoration(
                        color: isBooked
                            ? Colors.red
                            : (selectedToken == tokenNumber
                                ? Colors.green
                                : Colors.blue),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: FittedBox(
                        fit: BoxFit.scaleDown,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              '$tokenNumber',
                              style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 30,
                                  fontWeight:
                                      FontWeight.bold), // Bold token number
                            ),
                            Text(
                              timeSlot,
                              style: const TextStyle(
                                  color: Colors.white, fontSize: 16),
                              textAlign: TextAlign.center,
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}
//check github
