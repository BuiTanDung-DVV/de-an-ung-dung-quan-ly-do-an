import 'package:flutter/material.dart';
import '../models/users/user.dart';
import '../screens/user_screen/settings_screen.dart';
import '../screens/user_screen/support_screen.dart';

class CustomNavigationDrawer extends StatelessWidget {
  final User user;

  const CustomNavigationDrawer({super.key, required this.user});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[
          UserAccountsDrawerHeader(
            accountName: Text('ID: ${user.userId}'),
            accountEmail: Text(user.email),
            currentAccountPicture: const CircleAvatar(
              backgroundImage: AssetImage('lib/images/logo.jpg'),
            ),
            decoration: const BoxDecoration(
              color: Colors.deepPurple,
            ),
          ),
          ListTile(
            leading: const Icon(Icons.settings),
            title: const Text('Cài đặt'),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const SettingsPage()),
              );
            },
          ),
          ListTile(
            leading: const Icon(Icons.support),
            title: const Text('Hỗ trợ'),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const SupportPage()),
              );
            },
          ),
        ],
      ),
    );
  }
}