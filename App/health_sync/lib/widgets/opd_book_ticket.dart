import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:health_sync/Profile/drawer_slider.dart';

class OPDBookTicket extends StatelessWidget {
  final SupabaseClient supabase;

  OPDBookTicket({required this.supabase});

  Future<List<Map<String, dynamic>>> fetchOpdBookings() async {
    final response = await supabase.from('opd_bookings').select().eq('phone',UserData.userMobile.toString().substring(3));

    return List<Map<String, dynamic>>.from(response);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: FutureBuilder<List<Map<String, dynamic>>>(
        future: fetchOpdBookings(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(child: Text('No bookings available.'));
          } else {
            final bookings = snapshot.data!;
            return ListView.builder(
              padding: EdgeInsets.only(top: 32),
              itemCount: bookings.length,
              itemBuilder: (context, index) {
                final booking = bookings[index];
                return Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  child: Container(
                    padding: EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.grey[300],
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black12,
                          blurRadius: 10,
                          spreadRadius: 2,
                          offset: Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              width: 80,
                              height: 80,
                              decoration: BoxDecoration(
                                color: Colors.blue,
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                            SizedBox(width: 16),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  booking['name'] ?? 'N/A',
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                SizedBox(height: 4),
                                Text('Age : ${booking['age'] ?? 'N/A'}', style: TextStyle(fontSize: 12)),
                                Text('Booking for : ${booking['disease'] ?? 'N/A'}', style: TextStyle(fontSize: 12)),
                                Text('Token No : ${booking['id'] ?? 'N/A'}', style: TextStyle(fontSize: 12)),
                              ],
                            ),
                          ],
                        ),
                        SizedBox(height: 16),
                        // Text(
                        //   'Hospital : ${booking['hospital'] ?? 'N/A'}',
                        //   style: TextStyle(fontSize: 14),
                        // ),
                        SizedBox(height: 4),
                        Text(
                          'Date : ${booking['appointment_date'] ?? 'N/A'}',
                          style: TextStyle(fontSize: 14),
                        ),
                        SizedBox(height: 16),
                        Center(
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.blue,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                              padding: EdgeInsets.symmetric(vertical: 12, horizontal: 24),
                            ),
                            onPressed: () {},
                            child: Text(
                              'Your OPD ticket confirmed!!!',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            );
          }
        },
      ),
    );
  }
}
