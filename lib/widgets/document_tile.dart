import 'package:flutter/material.dart';
import '../models/document/document.dart';
import '../models/document/documents_data.dart';
import '../screens/add_document_screen/document_detail_screen.dart';

class DocumentTile extends StatelessWidget {
  final Document document;
  final DocumentsData documentsData;

  const DocumentTile({super.key, required this.document, required this.documentsData});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        title: GestureDetector(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => DocumentDetailScreen(document: document),
              ),
            );
          },
          child: Text(
            document.title,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w500,
              fontFamily: 'Roboto',
            ),
          ),
        ),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            IconButton(
              icon: const Icon(Icons.delete),
              onPressed: () {
                _showDeleteConfirmationDialog(context);
              },
            ),
          ],
        ),
      ),
    );
  }

  void _showDeleteConfirmationDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Xác nhận xóa'),
          content: const Text('Bạn có chắc chắn muốn xóa tài liệu này không?'),
          actions: <Widget>[
            TextButton(
              child: const Text('Không'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: const Text('Có'),
              onPressed: () async {
                await documentsData.deleteDocument(document);
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
}
