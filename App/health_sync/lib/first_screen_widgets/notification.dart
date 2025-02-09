import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class NotificationScreen extends StatefulWidget {
  @override
  _NotificationScreenState createState() => _NotificationScreenState();
}

class _NotificationScreenState extends State<NotificationScreen> {
  List<Map<String, dynamic>> notifications = [];
  final supabase = Supabase.instance.client;

  @override
  void initState() {
    super.initState();
    _listenForNewEmergencyBookings();
  }

  void _listenForNewEmergencyBookings() {
    supabase
        .from('emergency_booking')
        .stream(primaryKey: ['emergency_id'])
        .order('created_at', ascending: false)
        .listen((data) {
      if (data.isNotEmpty) {
        setState(() {
          notifications.insert(0, data.first);
        });

        // Show a Snackbar notification
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
                '🚨 Emergency booked: ${data.first['problem']}'),
            action: SnackBarAction(
              label: 'Dismiss',
              onPressed: () {},
            ),
          ),
        );
      }
    });
  }

  void _clearNotification(int index) {
    setState(() {
      notifications.removeAt(index);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Notifications"),
        actions: [
          if (notifications.isNotEmpty)
            IconButton(
              icon: const Icon(Icons.clear_all),
              onPressed: () {
                setState(() {
                  notifications.clear();
                });
              },
            ),
        ],
      ),
      body: notifications.isEmpty
          ? const Center(child: Text('No notifications yet'))
          : ListView.builder(
              itemCount: notifications.length,
              itemBuilder: (context, index) {
                final notification = notifications[index];
                return Dismissible(
                  key: Key(notification['emergency_id']),
                  onDismissed: (direction) => _clearNotification(index),
                  background: Container(
                    color: Colors.red,
                    alignment: Alignment.centerRight,
                    padding: const EdgeInsets.only(right: 20.0),
                    child: const Icon(Icons.delete, color: Colors.white),
                  ),
                  child: ListTile(
                    title: const Text('Emergency Booking Alert 🚨'),
                    subtitle: Text(
                      'Problem: ${notification['problem']} | Name: ${notification['name']}',
                    ),
                  ),
                );
              },
            ),
    );
  }
}
