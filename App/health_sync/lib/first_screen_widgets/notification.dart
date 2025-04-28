import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:health_sync/Profile/drawer_slider.dart';

class NotificationScreen extends StatefulWidget {
   const NotificationScreen({Key? key}) : super(key: key);

  static bool hasNotifications() {
    // TODO: Replace this with your real notification check
    return true; 
  }
  @override
   Widget build(BuildContext context) {
    return Scaffold(
      // Your notification screen UI
    );
  }
  _NotificationScreenState createState() => _NotificationScreenState();
}


class _NotificationScreenState extends State<NotificationScreen> {
  List<Map<String, dynamic>> notifications = [];
  final supabase = Supabase.instance.client;
  static Set<String> dismissedNotifications_OPD = {};
  static Set<String> dismissedNotifications_emergency = {};

  @override
  void initState() {
    super.initState();
    _listenForNewEmergencyBookings();
    _listenForNewOPDBookings();
  }

  void _listenForNewEmergencyBookings() {
    supabase
        .from('emergency_booking')
        .stream(primaryKey: ['emergency_id'])
        .order('created_at', ascending: false)
        .limit(1)
        .listen((data) {
      if (data.isNotEmpty && mounted) {
      final latestBooking = data.first; 
      
      if (latestBooking['user_id'].toString() == UserData.userId.toString() &&
          !dismissedNotifications_emergency.contains(latestBooking['emergency_id'])) {
        
        setState(() {
          notifications.add(latestBooking);
        });

        _showStackableNotifications([latestBooking]);
      }
    }
    });
  }

  void _listenForNewOPDBookings() {
    supabase
        .from('opd_bookings')
        .stream(primaryKey: ['id'])
        .order('created_at', ascending: false)
        .limit(1)
        .listen((data) {
      if (data.isNotEmpty && mounted) {
        final newNotifications = data.where((notification) =>
            ("+91"+notification['phone'].toString() == UserData.userMobile.toString()) &&
            !dismissedNotifications_OPD.contains(notification['id'].toString())).toList();
        
        setState(() {
          notifications.addAll(newNotifications);
        });
        _showStackableNotifications(newNotifications);
      }
    });
  }

  void _showStackableNotifications(List<Map<String, dynamic>> newNotifications) async {
    for (var notification in newNotifications) {
      if (notification.containsKey('problem') && dismissedNotifications_emergency.contains(notification['emergency_id'])) {
        continue;
      }
      await Future.delayed(Duration(seconds: 2));
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(notification.containsKey('problem')
              ? '🚨 Emergency booked: ${notification['problem']}'
              : '📅 OPD booked for ${notification['appointment_date']}'),
          action: SnackBarAction(
            label: 'Dismiss',
            onPressed: () {
              setState(() {
                if (notification.containsKey('problem')) {
                  dismissedNotifications_emergency.add(notification['emergency_id']);
                } else {
                  dismissedNotifications_OPD.add(notification['id'].toString());
                }
                notifications.remove(notification);
              });
            },
          ),
          duration: Duration(seconds: 3),
        ),
      );
    }
  }

  void _clearNotification(int index) {
    setState(() {
      final notification = notifications[index];
      if (notification.containsKey('problem')) {
        dismissedNotifications_emergency.add(notification['emergency_id']);
      } else {
        dismissedNotifications_OPD.add(notification['id'].toString());
      }
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
                final isEmergency = notification.containsKey('problem');
                return Dismissible(
                  key: Key(notification['emergency_id']?.toString() ?? notification['id']?.toString() ?? UniqueKey().toString()),
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
                    elevation: 4,
                    child: ListTile(
                      contentPadding: const EdgeInsets.all(12),
                      leading: Icon(
                        Icons.notifications_active,
                        color: isEmergency ? Colors.red : Colors.blue,
                        size: 30,
                      ),
                      title: Text(
                        isEmergency ? 'Emergency Booking Done!' : 'OPD Booking Confirmed!',
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
                            isEmergency ? 'Problem: ${notification['problem']}' : 'Appointment Date: ${notification['appointment_date']}',
                            style: const TextStyle(fontSize: 14, color: Colors.black87),
                          ),
                          Text(
                            'Booking ID: ${notification['emergency_id'] ?? notification['id']}',
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
