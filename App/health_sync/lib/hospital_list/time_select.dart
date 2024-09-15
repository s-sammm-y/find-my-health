import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class TimeSelect extends StatefulWidget {
  const TimeSelect({Key? key}) : super(key: key);

  @override
  _TimeSelectState createState() => _TimeSelectState();
}

class _TimeSelectState extends State<TimeSelect> {
  DateTime selectedDate = DateTime.now();
  final TextEditingController dateController = TextEditingController();

  // State for selecting morning or afternoon
  bool isMorningSelected = true;
  int selectedToken = -1; // To track which token is selected

  @override
  void initState() {
    super.initState();
    // Initialize the date in the TextField with the current date
    dateController.text = DateFormat('dd/MM/yyyy').format(selectedDate);
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: selectedDate,
      firstDate: DateTime(selectedDate.year, selectedDate.month, 1),
      lastDate: DateTime(selectedDate.year, selectedDate.month + 1, 0),
    );

    if (pickedDate != null && pickedDate != selectedDate) {
      setState(() {
        selectedDate = pickedDate;
        dateController.text = DateFormat('dd/MM/yyyy').format(selectedDate);
      });
    }
  }

  void _showBookingDialog(int token) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Confirm Booking'),
          content: const Text('Do you want to confirm booking for this token?'),
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
                // Handle booking confirmation here
                Navigator.of(context).pop();
                setState(() {
                  selectedToken = token; // Mark the token as selected
                });
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Select Time"),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Date picker field
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: TextField(
              controller: dateController,
              readOnly: true,
              decoration: InputDecoration(
                labelText: "Select Date",
                border: OutlineInputBorder(),
              ),
              onTap: () {
                _selectDate(context);
              },
            ),
          ),
          
          // Morning and Afternoon buttons directly under the date picker
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                // Morning button
                GestureDetector(
                  onTap: () {
                    setState(() {
                      isMorningSelected = true;
                    });
                  },
                  child: Container(
                    decoration: BoxDecoration(
                      color: isMorningSelected ? Colors.blue : Colors.grey[300],
                      borderRadius: BorderRadius.circular(8),
                    ),
                    padding: const EdgeInsets.all(12.0),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: const [
                        Text(
                          'Morning',
                          style: TextStyle(color: Colors.white, fontSize: 18),
                        ),
                        Text(
                          '8:00 AM - 11:59 AM',
                          style: TextStyle(color: Colors.white, fontSize: 10),
                        ),
                      ],
                    ),
                  ),
                ),
                
                // Afternoon button
                GestureDetector(
                  onTap: () {
                    setState(() {
                      isMorningSelected = false;
                    });
                  },
                  child: Container(
                    decoration: BoxDecoration(
                      color: !isMorningSelected ? Colors.blue : Colors.grey[300],
                      borderRadius: BorderRadius.circular(8),
                    ),
                    padding: const EdgeInsets.all(12.0),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: const [
                        Text(
                          'Afternoon',
                          style: TextStyle(color: Colors.white, fontSize: 18),
                        ),
                        Text(
                          '12:00 PM - 11:00 PM',
                          style: TextStyle(color: Colors.white, fontSize: 10),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          
          // Token grid (Morning = 50 tokens, Afternoon = 30 tokens)
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: GridView.builder(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 5,
                  childAspectRatio: 1,
                  crossAxisSpacing: 10,
                  mainAxisSpacing: 10,
                ),
                itemCount: isMorningSelected ? 50 : 30,
                itemBuilder: (context, index) {
                  int tokenNumber = index + 1;
                  return GestureDetector(
                    onTap: () {
                      _showBookingDialog(tokenNumber);
                    },
                    child: Container(
                      decoration: BoxDecoration(
                        color: selectedToken == tokenNumber
                            ? Colors.green // Highlight selected token
                            : Colors.blue,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Center(
                        child: Text(
                          tokenNumber.toString(),
                          style: const TextStyle(color: Colors.white, fontSize: 16),
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
