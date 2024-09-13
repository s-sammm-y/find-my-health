import 'package:flutter/material.dart';

class CustomDrawer extends StatelessWidget {
  const CustomDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 250, // Set your desired width here
      child: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            const UserAccountsDrawerHeader(
              accountName: Text('Aniruddha Pal'),
              accountEmail: Text('+91-9831209756'),
              currentAccountPicture: CircleAvatar(
                backgroundColor: Colors.white,
                child: Icon(Icons.person, size: 50, color: Colors.lightBlue),
              ),
              decoration: BoxDecoration(
                color: Colors.lightBlue,
              ),
            ),
            ListTile(
              title: const Text('Invite & Earn'),
              subtitle: const Text('Refer Health Sync and Earn'),
              onTap: () {
                // Add your functionality here
              },
            ),
            const Divider(),
            ListTile(
              title: const Text('Change Language'),
              onTap: () {
                // Add your functionality here
              },
            ),
          ],
        ),
      ),
    );
  }
}
