import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:health_sync/Profile/drawer_slider.dart';

class NotificationScreen extends StatefulWidget {
  @override
  _NotificationScreenState createState() => _NotificationScreenState();
}

class _NotificationScreenState extends State<NotificationScreen> {
  List<Map<String, dynamic>> notifications = [];
  final supabase = Supabase.instance.client;
  static Set<String> dismissedNotifications = {};

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
          notifications = data
              .where((notification) =>
                  notification['userid'] == UserData.userId &&
                  !dismissedNotifications.contains(notification['emergency_id']))
              .toList();
        });

        if (notifications.isNotEmpty) {
          final latest = notifications.first;
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('🚨 Emergency booked: ${latest['problem']}'),
              action: SnackBarAction(label: 'Dismiss', onPressed: () {}),
            ),
          );
        }
      }
    });
  }

  void _clearNotification(int index) {
    setState(() {
      dismissedNotifications.add(notifications[index]['emergency_id']); // Add to dismissed list
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
                child: Card(
                  margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                  elevation: 4, // Adds shadow effect
                  child: ListTile(
                    contentPadding: const EdgeInsets.all(12),
                    leading: const Icon(Icons.notifications_active, color: Colors.red, size: 30),
                    title: const Text(
                      'Emergency Booking Done!',
                      style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                    ),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: 5),
                        Text(
                          'Name: ${notification['name']}',
                          style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
                        ),
                        Text(
                          'Problem: ${notification['problem']}',
                          style: const TextStyle(fontSize: 14, color: Colors.black87),
                        ),
                        Text(
                          'Booking ID: ${notification['emergency_id']}',
                          style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                        ),
                      ],
                    ),
                    trailing: const Icon(Icons.arrow_forward_ios, color: Colors.grey, size: 18),
                  ),
                ),
              );
            },
          ),
    );
  }
}