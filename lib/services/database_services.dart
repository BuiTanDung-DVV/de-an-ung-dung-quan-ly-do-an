import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';
import '../models/document/document.dart';
import '../models/users/user.dart';
import '../services/globals.dart';
import 'package:mime/mime.dart';
import 'package:path/path.dart';

import 'globals.dart';

class DatabaseServices {
  static Future<List<Document>> getDocuments(int userId) async {
    var url = Uri.parse('$baseURL/documents?userId=$userId');
    var response = await http.get(url, headers: headers);

    if (response.statusCode == 200) {
      List<dynamic> body = jsonDecode(utf8.decode(response.bodyBytes));
      List<Document> documents =
          body.map((dynamic item) => Document.fromMap(item)).toList();
      return documents;
    } else {
      throw Exception('Failed to load documents');
    }
  }

  static Future<Document> addDocument(int userId ,Document document, File pdfFile) async {
    var url = Uri.parse('$baseURL/documents/add');
    var request = http.MultipartRequest('POST', url);
    request.headers.addAll(headers);
    // Thêm thông tin Id người dùng vào request fields
    request.fields['userId'] = userId.toString();
    // Thêm thông tin tài liệu vào request fields
    request.files.add(
      http.MultipartFile.fromString(
        'document',
        jsonEncode({
          'advisor': document.advisor,
          'author': document.author,
          'graduationYear': document.graduationYear.toString(),
          'type': document.type,
          'specialization': document.specialization,
          'abstractText': document.abstractText,
          'language': document.language,
          'publisher': document.publisher,
          'title': document.title,
          'keywords': document.keywords,
        }),
        contentType: MediaType('application', 'json'), // Định dạng document là JSON
      ),
    );
    // Thêm file PDF vào request
    var mimeType = lookupMimeType(pdfFile.path);
    var fileStream = http.ByteStream(pdfFile.openRead());
    var length = await pdfFile.length();
    request.files.add(
      http.MultipartFile(
        'file',
        fileStream,
        length,
        filename: basename(pdfFile.path),
        contentType: mimeType != null ? MediaType.parse(mimeType) : MediaType('application', 'pdf'),
      ),
    );

    var response = await request.send();

    if (response.statusCode == 201) {
      var responseData = await http.Response.fromStream(response);
      return Document.fromMap(jsonDecode(responseData.body));
    } else {
      throw Exception('Failed to add document');
    }
  }

  static Future<void> deleteDocument(int id) async {
    var url = Uri.parse('$baseURL/documents/delete/$id');
    var response = await http.delete(url, headers: headers);

    if (response.statusCode == 200) {
      return;
    } else {
      throw Exception('Failed to delete document');
    }
  }
}
