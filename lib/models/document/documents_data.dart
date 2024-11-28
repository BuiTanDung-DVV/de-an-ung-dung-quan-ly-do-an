import 'dart:io';

import 'package:flutter/material.dart';
import '../../services/database_services.dart';
import '../users/user.dart';
import 'document.dart';


class DocumentsData extends ChangeNotifier {
  List<Document> _documents = [];
  int userId;

  DocumentsData(this.userId);
  List<Document> get documents => _documents;

  Future<void> fetchDocuments() async {
    _documents = await DatabaseServices.getDocuments(userId);
    notifyListeners();
  }

  Future<void> addDocument(int userId, Document document, File pdfFile) async {
    Document newDocument = await DatabaseServices.addDocument(userId , document, pdfFile);
    _documents.add(newDocument);
    await fetchDocuments();
    notifyListeners();
  }

  Future<void> deleteDocument(Document document) async {
    if (document.id != null) {
      await DatabaseServices.deleteDocument(document.id!);
      await fetchDocuments();
      notifyListeners();
    }
  }
}
