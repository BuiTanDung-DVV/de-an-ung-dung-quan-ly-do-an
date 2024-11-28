import 'package:flutter/material.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  _SettingsPageState createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  bool _isDarkMode = false;

  void _toggleDarkMode(bool value) {
    setState(() {
      _isDarkMode = value;
    });
  }

  void _logout(BuildContext context) {
    Navigator.pushReplacementNamed(context, '/login');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Cài Đặt'),
        backgroundColor: _isDarkMode ? Colors.black : Colors.deepPurple,
        titleTextStyle: TextStyle(
          color: _isDarkMode ? Colors.white : Colors.black,
        ),
        iconTheme: const IconThemeData(
          color: Colors.white,
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            const Text(
              'Cài đặt',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),

            SwitchListTile(
              title: const Text('Chế độ tối'),
              value: _isDarkMode,
              onChanged: _toggleDarkMode,
            ),
            const SizedBox(height: 20),
            // Nút đăng xuất
            ElevatedButton(
              onPressed: () => _logout(context),
              child: const Text('Đăng xuất'),
            ),
          ],
        ),
      ),
    );
  }
}