import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/document/documents_data.dart';
import '../widgets/document_tile.dart';
import 'add_document_screen/add_document_screen.dart';

class DocumentListScreen extends StatefulWidget {
  final bool isTeacher;
  const DocumentListScreen({super.key, required this.isTeacher});

  @override
  _DocumentListScreenState createState() => _DocumentListScreenState();
}

class _DocumentListScreenState extends State<DocumentListScreen> {
  @override
  void initState() {
    super.initState();
    Provider.of<DocumentsData>(context, listen: false).fetchDocuments();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Danh Sách Tài Liệu'),
      ),
      body: Consumer<DocumentsData>(
        builder: (context, documentsData, child) {
          if (documentsData.documents.isEmpty) {
            return const Center(child: Text('Chưa có tài liệu nào được thêm'));
          } else {
            return ListView.builder(
              itemCount: documentsData.documents.length,
              itemBuilder: (context, index) {
                return DocumentTile(
                  document: documentsData.documents[index],
                  documentsData: documentsData,
                );
              },
            );
          }
        },
      ),
      floatingActionButton: widget.isTeacher
          ? null
          : FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => AddDocumentScreen()),
          );
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
