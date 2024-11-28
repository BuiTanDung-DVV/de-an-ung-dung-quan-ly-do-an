import 'dart:convert';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../models/users/user.dart';
import '../../models/users/user_data.dart';
import '../../services/database_services.dart';
import '../../models/document/document.dart';
import '../../models/document/documents_data.dart';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';
import '../../services/globals.dart';

class AddDocumentScreen extends StatefulWidget {

  const AddDocumentScreen({super.key});

  @override
  _AddDocumentScreenState createState() => _AddDocumentScreenState();
}

class _AddDocumentScreenState extends State<AddDocumentScreen> {
  bool _agreementChecked = false;
  bool _isSubmitted = false;
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _abstractController = TextEditingController();
  final TextEditingController _keywordsController = TextEditingController();
  final TextEditingController _advisorController = TextEditingController();
  final TextEditingController _authorController = TextEditingController();
  final TextEditingController _yearController = TextEditingController();
  String _selectedType = 'Chuyên đề tốt nghiệp';
  String? _selectedMajor;
  String _selectedLanguage = 'Tiếng Việt';
  final String _selectedPublisher = 'Nhà xuất bản Đại Học Kinh Tế Quốc Dân';
  String _pdfFileName = '';
  String _pdfUrl = '';
  bool _isUploading = false;
  File? _pdfFile;

  Future<void> _uploadFile(Document document,int userId) async {
    if (_pdfFile != null) {
      var url = Uri.parse('$baseURL/documents/add');
      var request = http.MultipartRequest('POST', url);

      // Thêm userId vào request
      request.fields['userId'] = userId.toString();
      // Thêm thông tin tài liệu vào request
      request.fields['document'] = jsonEncode({
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
      });
      // Thêm file PDF vào request
      request.files.add(
        await http.MultipartFile.fromPath(
          'file',
          _pdfFile!.path,
          contentType: MediaType('application', 'pdf'),
        ),
      );
      setState(() {
        _isUploading = true;
      });
      try {
        // Gửi yêu cầu lên server
        var response = await request.send();
        // Kiểm tra trạng thái phản hồi từ server
        if (response.statusCode == 200) {
          var responseData = await http.Response.fromStream(response);
          _pdfUrl = responseData.body;
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Tải lên file thành công!')),
          );
        }
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Tải lên file thất bại: $e')),
        );
      } finally {
        setState(() {
          _isUploading = false;
        });
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Không có file PDF để tải lên.')),
      );
    }
  }

  Future<void> _submitDocument() async {
    final userId = Provider.of<UserData>(context, listen: false).user?.userId;
    if (userId == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Không tìm thấy thông tin người dùng.')),
      );
      return;
    }
    try {
      int? graduationYear;
      try {
        graduationYear = int.parse(_yearController.text);
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
              content: Text('Năm tốt nghiệp phải là số nguyên hợp lệ.')),
        );
        return;
      }
      // Kiểm tra nếu có bất kỳ trường nào bị thiếu thông tin
      if (_advisorController.text.isEmpty ||
          _authorController.text.isEmpty ||
          _titleController.text.isEmpty ||
          _abstractController.text.isEmpty ||
          _keywordsController.text.isEmpty ||
          _pdfFile == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
              content: Text(
                  'Vui lòng điền đầy đủ thông tin tài liệu và chọn file PDF.')),
        );
        return;
      }
      // Tạo đối tượng Document với tất cả thông tin
      Document document = Document(
        advisor: _advisorController.text,
        author: _authorController.text,
        graduationYear: graduationYear,
        type: _selectedType,
        specialization: _selectedMajor ?? '',
        abstractText: _abstractController.text,
        language: _selectedLanguage,
        publisher: _selectedPublisher,
        title: _titleController.text,
        keywords: _keywordsController.text,
        pdfFileName: _pdfFileName,
        pdfUrl: _pdfUrl,
      );
      // Gọi hàm tải lên và gửi thông tin document và file pdf
      await _uploadFile(document, userId);
      await DatabaseServices.addDocument(userId, document, _pdfFile!);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Nộp tài liệu thành công.')),
      );
      // Cập nhật danh sách tài liệu
      Provider.of<DocumentsData>(context, listen: false).fetchDocuments();
      // Quay về màn hình trước đó
      Navigator.pop(context);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Nộp tài liệu thất bại: $e')),
      );
    } finally {
      setState(() {
        _isSubmitted = false;
      });
    }
  }

  void _checkAndSubmit() {
    if (_advisorController.text.isEmpty ||
        _authorController.text.isEmpty ||
        _titleController.text.isEmpty ||
        _yearController.text.isEmpty ||
        _pdfFileName.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Vui lòng điền đầy đủ thông tin.')),
      );
      return;
    }
    setState(() {
      _isSubmitted = true;
    });
    _submitDocument();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Nộp tài liệu')),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              _buildTextField(
                controller: _advisorController,
                label: 'Người hướng dẫn',
              ),
              _buildTextField(
                controller: _authorController,
                label: 'Tác giả',
              ),
              _buildTextField(
                controller: _yearController,
                label: 'Năm tốt nghiệp',
                keyboardType: TextInputType.number,
              ),
              _buildDropdown(
                value: _selectedType,
                label: 'Dạng tài liệu',
                items: <String>[
                  'Chuyên đề tốt nghiệp',
                  'Luận văn thạc sĩ',
                  'Luận án tiến sĩ',
                ],
                onChanged: (String? newValue) {
                  setState(() {
                    _selectedType = newValue!;
                  });
                },
              ),
              _buildDropdown(
                value: _selectedMajor,
                label: 'Chuyên ngành',
                items: <String>[
                  'Kế toán và kiểm toán', 'Quản trị khách sạn', 'Thương mại điện tử', 'Marketing',
                  'Logistic và quản lý chuỗi cung ứng', 'Kinh doanh quốc tế', 'Kinh tế quốc tế',
                  'Quản trị nhân lực', 'Kinh doanh thương mại', 'Quản trị kinh doanh',
                  'Luật kinh tế', 'Khoa học máy tính', 'Công nghệ thông tin', 'Tài chính doanh nghiệp',
                  'Tài chính công', 'Ngân hàng', 'Thống kê kinh tế', 'Quản trị dịch vụ du lịch và lữ hành',
                  'Quản trị chất lượng và đổi mới', 'Khoa học dữ liệu trong kinh tế và kinh doanh', 'Định phí bảo hiểm và quản trị rủi ro',
                 'Quản lý công và chính sách', 'Quản trị điều hành thông tin', 'Công nghệ tài chính', 'Kế toán + Kiểm toán kết hợp chứng chỉ quốc tế',
                  'Kinh tế học tài chính', 'Phân tích kinh doanh', 'Kinh doanh số', 'Logistic và quản lý chuỗi cung ứng tích hợp chứng chỉ quốc tế',
                  'Quản trị khách sạn quốc tế', 'Đầu tư tài chính', 'Khởi nghiệp và phát triển kinh doanh'
                ],
                onChanged: (String? newValue) {
                  setState(() {
                    _selectedMajor = newValue;
                  });
                },
              ),
              _buildTextField(
                controller: _abstractController,
                label: 'Tóm tắt CĐTN',
                maxLines: 3,
              ),
              _buildDropdown(
                value: _selectedLanguage,
                label: 'Ngôn ngữ',
                items: <String>[
                  'Tiếng Việt',
                  'Tiếng Anh',
                ],
                onChanged: (String? newValue) {
                  setState(() {
                    _selectedLanguage = newValue!;
                  });
                },
              ),
              _buildDropdown(
                value: _selectedPublisher,
                label: 'Nhà xuất bản',
                items: <String>[
                  'Nhà xuất bản Đại Học Kinh Tế Quốc Dân',
                ],
                onChanged: (String? newValue) {},
              ),
              _buildTextField(
                controller: _titleController,
                label: 'Nhan đề',
              ),
              _buildTextField(
                controller: _keywordsController,
                label: 'Từ khóa',
                maxLines: 2,
              ),
              const SizedBox(height: 20),
              const Text('File đính kèm:', style: TextStyle(fontSize: 16)),
              TextButton(
                onPressed: () async {
                  FilePickerResult? result =
                      await FilePicker.platform.pickFiles(
                    type: FileType.custom,
                    allowedExtensions: ['pdf'],
                  );
                  if (result != null) {
                    String fileName = result.files.single.name;
                    RegExp regExp = RegExp(r'^\d+\.pdf$');
                  if (regExp.hasMatch(fileName)) {
                    setState(() {
                      _pdfFile = File(result.files.single.path!);
                      _pdfFileName = fileName;
                    });
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Tên của file phải có định dạng "number.pdf" ví dụ:123456.pdf.')),
                    );
                  }
                  }
                },
                child: const Text('Chọn file PDF'),
              ),
              Text(
                  'File đã chọn: $_pdfFileName',
                  style: const TextStyle(fontSize: 20, color: Colors.black),
                ),
              const SizedBox(height: 20),
              CheckboxListTile(
                value: _agreementChecked,
                onChanged: (bool? value) {
                  setState(() {
                    _agreementChecked = value!;
                  });
                },
                title: const Text(
                  'Tôi đồng ý cho Đại học Kinh tế Quốc dân toàn quyền sử dụng và khai thác tài liệu này.',
                  style: TextStyle(fontSize: 14),
                ),
              ),
              Center(
                child: ElevatedButton(
                  onPressed: _isUploading || !_agreementChecked || _isSubmitted
                      ? null
                      : _checkAndSubmit,
                  child: _isUploading
                      ? const SizedBox(
                          width: 24,
                          height: 24,
                          child: CircularProgressIndicator(strokeWidth: 2.0),
                        )
                      : const Text('Nộp tài liệu'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    int maxLines = 1,
    TextInputType keyboardType = TextInputType.text,
  }) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8.0),
      child: TextField(
        controller: controller,
        decoration: InputDecoration(labelText: label),
        maxLines: maxLines,
        keyboardType: keyboardType,
      ),
    );
  }

  Widget _buildDropdown({
    required String? value,
    required String label,
    required List<String> items,
    required ValueChanged<String?> onChanged,
  }) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8.0),
      child: DropdownButtonFormField<String>(
        value: value,
        isExpanded: true,
        decoration: InputDecoration(labelText: label),
        items: items.map((String item) {
          return DropdownMenuItem<String>(
            value: item,
            child: Text(item),
          );
        }).toList(),
        onChanged: onChanged,
      ),
    );
  }
}

