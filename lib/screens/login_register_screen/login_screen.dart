import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import 'dart:convert';
import '../../models/users/user.dart';
import '../../models/users/user_data.dart';
import '../../services/globals.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _isObscure = true;
  bool _isLoading = false;
  bool isTeacher = false;
  bool isStudent = true;

  Future<void> _handleLogin() async {
    setState(() {
      _isLoading = true;
    });

    String email = _emailController.text;
    String password = _passwordController.text;

    if (email.isEmpty || password.isEmpty) {
      _showErrorDialog('Vui lòng nhập email và mật khẩu.');
      setState(() {
        _isLoading = false;
      });
      return;
    }

    final response = await http.post(
      Uri.parse(isTeacher ? '$baseURL/teachers/login' : '$baseURL/users/login'),
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

    print('Response status: ${response.statusCode}');
    print('Response body: ${response.body}');

    if (response.statusCode == 200) {
      final responseBody = json.decode(response.body);
      if ((isTeacher && responseBody['teacherId'] != null) || (!isTeacher && responseBody['userId'] != null)) {
        User user = User(
          userId: isTeacher ? responseBody['teacherId'] : responseBody['userId'],
          email: email,
          password: password,
          isTeacher: isTeacher,
        );
        Provider.of<UserData>(context, listen: false).setUser(user);

        Navigator.pushReplacementNamed(context, '/main');
      }
    } else {
      String errorMessage;
      if (response.statusCode == 404) {
        errorMessage = 'Tài khoản không tồn tại.';
      } else if (response.statusCode == 401) {
        errorMessage = 'Sai email hoặc mật khẩu.';
      } else {
        final Map<String, dynamic> responseBody = json.decode(response.body);
        errorMessage = responseBody['message'] ?? 'Có lỗi xảy ra, vui lòng thử lại.';
      }

      _showErrorDialog(errorMessage);
    }
  }

  void _showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Lỗi đăng nhập'),
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
        title: const Text('Đăng Nhập'),
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
                'Chào mừng bạn đến với Quản lý đồ án',
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
                obscureText: _isObscure,
                decoration: InputDecoration(
                  prefixIcon: const Icon(Icons.lock),
                  labelText: 'Mật Khẩu',
                  border: const OutlineInputBorder(),
                  suffixIcon: IconButton(
                    icon: Icon(
                      _isObscure ? Icons.visibility : Icons.visibility_off,
                    ),
                    onPressed: () {
                      setState(() {
                        _isObscure = !_isObscure;
                      });
                    },
                  ),
                ),
              ),
              const SizedBox(height: 20),
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
                onPressed: _handleLogin,
                style: ElevatedButton.styleFrom(
                  minimumSize: const Size(double.infinity, 50),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                  backgroundColor: Colors.deepPurple,
                ),
                child: const Text(
                  'Đăng Nhập',
                  style: TextStyle(fontSize: 18, color: Colors.white),
                ),
              ),
              const SizedBox(height: 20),
              TextButton(
                onPressed: () {
                  Navigator.pushNamed(context, '/register');
                },
                child: const Text('Đăng ký tài khoản! '),
              ),
            ],
          ),
        ),
      ),
    );
  }
}