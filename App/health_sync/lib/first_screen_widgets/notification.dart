import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class NotificationScreen extends StatefulWidget {
  @override
  _NotificationScreenState createState() => _NotificationScreenState();
}

class _NotificationScreenState extends State<NotificationScreen> {
  List<Map<String, dynamic>> notifications = [];
  bool _isLoading = true;
  @override
  void initState() {
    super.initState();
    _fetchNotifications();
  }

  Future<void> _fetchNotifications() async {
    try {
        final response = await Supabase.instance.client
        .from('appointments')
        .select()
        .order('id', ascending: false);

      if (response.isNotEmpty) {
        setState(() {
          notifications = response;
          _isLoading = false;
        });
      } else {
        
        print('No notifications found');
      }
    } catch (error) {
      print('Error fetching notifications: $error');
    }
    

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Notifications"),
      ),
      body: notifications.isEmpty
          ? const Center(child: Text('No notifications'))
          : _isLoading
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : ListView.builder(
              itemCount: notifications.length,
              itemBuilder: (context, index) {
                final appointment = notifications[index];
                return ListTile(
                  title: Text(
                    'Appointment Booked',
                  ),
                  subtitle: Text(
                    'Date: ${appointment['date']} | Time: ${appointment['time_slot']} | Token: ${appointment['token']}',
                  ),
                );
              },
            ),
    );
  }
}


