import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/document/documents_data.dart';
import '../models/users/user_data.dart';
import '../widgets/navigation_drawer.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    Provider.of<DocumentsData>(context, listen: false).fetchDocuments();
    final user = Provider.of<UserData>(context).user;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Trang Chủ'),
      ),
      drawer: CustomNavigationDrawer(user: user!,),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            const Text(
              'Thông báo mới!',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            Consumer<DocumentsData>(
              builder: (context, documentsData, child) {
                return Text(
                  'Tổng số tài liệu đã nộp: ${documentsData.documents.length}',
                  style: const TextStyle(fontSize: 16),
                );
              },
            ),
            const SizedBox(height: 10),
            const Text(
              'Tình trạng tài liệu: Đang chờ phê duyệt',
              style: TextStyle(fontSize: 16),
            ),
          ],
        ),
      ),
    );
  }
}
