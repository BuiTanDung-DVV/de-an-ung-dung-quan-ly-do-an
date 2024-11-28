import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_pdfview/flutter_pdfview.dart';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';
import '../../models/document/document.dart';

class DocumentDetailScreen extends StatelessWidget {
  final Document document;

  const DocumentDetailScreen({super.key, required this.document});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Chi Tiết Tài Liệu'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: <Widget>[
            Text(
              document.title,
              style: Theme.of(context).textTheme.titleLarge?.copyWith(fontFamily: 'Roboto'),
            ),
            const SizedBox(height: 16),
            _buildDetailText(context, 'ID: ${document.id}'),
            _buildDetailText(context, 'Người hướng dẫn: ${document.advisor}'),
            _buildDetailText(context, 'Tác giả: ${document.author}'),
            _buildDetailText(context, 'Năm tốt nghiệp: ${document.graduationYear}'),
            _buildDetailText(context, 'Dạng tài liệu: ${document.type}'),
            _buildDetailText(context, 'Chuyên ngành: ${document.specialization}'),
            _buildDetailText(context, 'Tóm tắt: ${document.abstractText}'),
            _buildDetailText(context, 'Ngôn ngữ: ${document.language}'),
            _buildDetailText(context, 'Nhà xuất bản: ${document.publisher}'),
            _buildDetailText(context, 'Từ khóa: ${document.keywords}'),
            _buildDetailText(context, 'Tên tệp PDF: ${document.pdfFileName}'),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () => _navigateToPdfViewer(context, document.pdfUrl),
              child: const Text('Mở PDF'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDetailText(BuildContext context, String text) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Text(
        text,
        style: Theme.of(context).textTheme.bodyMedium?.copyWith(fontFamily: 'Roboto'),
      ),
    );
  }

  void _navigateToPdfViewer(BuildContext context, String pdfUrl) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => PdfViewerScreen(pdfUrl: pdfUrl),
      ),
    );
  }
}

class PdfViewerScreen extends StatelessWidget {
  final String pdfUrl;

  const PdfViewerScreen({super.key, required this.pdfUrl});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Xem PDF'),
      ),
      body: FutureBuilder<String>(
        future: fetchPdf(pdfUrl),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Lỗi: ${snapshot.error}'));
          } else {
            return PDFView(
              filePath: snapshot.data!,
              enableSwipe: true,
              swipeHorizontal: false,
              autoSpacing: false,
              pageFling: false,
              pageSnap: true,
              onPageChanged: (page, total) {
              },
            );
          }
        },
      ),
    );
  }

  Future<String> fetchPdf(String url) async {
    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      // Lưu file PDF vào bộ nhớ tạm thời
      final Directory tempDir = await getTemporaryDirectory();
      final File file = File('${tempDir.path}/temp.pdf');
      await file.writeAsBytes(response.bodyBytes);
      return file.path;
    } else {
      throw Exception('Không thể tải PDF từ URL: ${response.statusCode}');
    }
  }
}
