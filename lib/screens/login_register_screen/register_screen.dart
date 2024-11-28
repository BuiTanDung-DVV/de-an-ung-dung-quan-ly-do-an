import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import '../../services/globals.dart';
import 'login_screen.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({Key? key}) : super(key: key);

  @override
  _RegisterScreenState createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController = TextEditingController();
  bool _isLoading = false;
  bool isTeacher = false;
  bool isStudent = true;


  Future<void> _handleRegister() async {
    String email = _emailController.text;
    String password = _passwordController.text;
    String confirmPassword = _confirmPasswordController.text;

    if (password != confirmPassword) {
      _showErrorDialog("Mật khẩu và xác nhận mật khẩu không khớp.");
      return;
    }

    setState(() {
      _isLoading = true;
    });

    // Gửi yêu cầu đăng ký đến API
    final response = await http.post(
      Uri.parse(isTeacher ? '$baseURL/teachers/register' : '$baseURL/users/register'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, String>{
        'email': email,
        'password': password,
      }),
    );

    setState(() {
      _isLoading = false;
    });

    if (response.statusCode == 200) {
      showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: const Text('Thành công'),
            content: const Text('Đăng ký thành công. Bạn có thể đăng nhập.'),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (context) => const LoginScreen()),
                  );
                },
                child: const Text('Đăng nhập'),
              ),
            ],
          );
        },
      );
    } else {
      final Map<String, dynamic> responseBody = json.decode(response.body);

      // Kiểm tra xem có lỗi liên quan đến email trùng lặp không
      if (response.statusCode == 409) {
        _showErrorDialog('Email đã được sử dụng, vui lòng chọn email khác.');
      } else {
        String errorMessage = responseBody['message'] ?? 'Có lỗi xảy ra, vui lòng thử lại.';
        _showErrorDialog(errorMessage);
      }
    }
  }

    void _showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Lỗi'),
          content: Text(message),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('OK'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Đăng Ký'),
        backgroundColor: Colors.deepPurple,
      ),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Image.asset(
                'lib/images/logo.jpg',
                height: 100,
              ),
              const SizedBox(height: 40),
              const Text(
                'Tạo tài khoản mới',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 20),
              TextField(
                controller: _emailController,
                decoration: const InputDecoration(
                  prefixIcon: Icon(Icons.email),
                  labelText: 'Email',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 20),
              TextField(
                controller: _passwordController,
                obscureText: true,
                decoration: const InputDecoration(
                  prefixIcon: Icon(Icons.lock),
                  labelText: 'Mật Khẩu',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 20),
              TextField(
                controller: _confirmPasswordController,
                obscureText: true,
                decoration: const InputDecoration(
                  prefixIcon: Icon(Icons.lock_outline),
                  labelText: 'Xác Nhận Mật Khẩu',
                  border: OutlineInputBorder(),
                ),
              ),
              Text("Đăng nhập với tư cách là:"),
              CheckboxListTile(
                title: const Text('Giáo viên'),
                value: isTeacher,
                onChanged: (bool? value) {
                  setState(() {
                    isTeacher = value ?? false;
                    if (isTeacher) isStudent = false;
                  });
                },
              ),
              CheckboxListTile(
                title: const Text('Sinh viên'),
                value: isStudent,
                onChanged: (bool? value) {
                  setState(() {
                    isStudent = value ?? false;
                    if (isStudent) isTeacher = false;
                  });
                },
              ),
              const SizedBox(height: 20),
              _isLoading
                  ? const CircularProgressIndicator()
                  : ElevatedButton(
                onPressed: _handleRegister,
                style: ElevatedButton.styleFrom(
                  minimumSize: const Size(double.infinity, 50),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                  backgroundColor: Colors.deepPurple,
                ),
                child: const Text(
                  'Đăng Ký',
                  style: TextStyle(fontSize: 18, color: Colors.white),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
