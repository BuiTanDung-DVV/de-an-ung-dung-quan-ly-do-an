import 'package:flutter/material.dart';

import '../models/users/user.dart';

class UserProfileScreen extends StatelessWidget {
  final User user;

  const UserProfileScreen({Key? key, required this.user}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Thông Tin Người Dùng'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: <Widget>[
            Card(
              elevation: 4,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children:
                  [
                    Center(
                      child: Image(image: AssetImage('lib/images/logo.jpg'), height: 100),
                    ),
                    const SizedBox(height: 20),
                    Center(
                      child: Text(
                        'Chức vụ: ${user.isTeacher ? 'Giảng viên' : 'Sinh viên'}',
                        style: const TextStyle(fontSize: 16),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20),
            _buildInfoCard(Icons.account_box, 'Id: ', user.userId.toString()),
            const SizedBox(height: 20),
            _buildInfoCard(Icons.email, 'Email', user.email),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoCard(IconData icon, String label, String info) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      child: ListTile(
        leading: Icon(icon, size: 30, color: Colors.deepPurple),
        title: Text(label, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
        subtitle: Text(info, style: const TextStyle(fontSize: 16)),
      ),
    );
  }
}
