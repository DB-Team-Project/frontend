import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'login.dart'; // 로그인 페이지 import

class RegisterPage extends StatefulWidget {
  @override
  _RegisterPageState createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();
  bool _isUsernameAvailable = true;

  void onRegisterSuccess(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('회원가입 성공'),
          content: Text('회원가입이 성공적으로 완료되었습니다.'),
          actions: <Widget>[
            TextButton(
              child: Text('확인'),
              onPressed: () {
                Navigator.of(context).pop(); // 팝업 닫기
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => LoginPage()),
                ); // 로그인 페이지로 이동
              },
            ),
          ],
        );
      },
    );
  }

  void onRegisterFailure(BuildContext context, String message) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('회원가입 실패'),
          content: Text(message),
          actions: <Widget>[
            TextButton(
              child: Text('확인'),
              onPressed: () {
                Navigator.of(context).pop(); // 팝업 닫기
              },
            ),
          ],
        );
      },
    );
    _usernameController.clear();
    _passwordController.clear();
    _confirmPasswordController.clear();
  }

  Future<void> registerUser(String username, String password) async {
    final url = Uri.parse('http://192.168.242.51:8080/api/signup');
    final response = await http.post(
      url,
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, String>{
        'userId': username,
        'password': password,
      }),
    );

    if (response.statusCode == 200) {
      // 회원가입 성공 처리
      onRegisterSuccess(context);
    } else if (response.statusCode == 409) {
      // 회원가입 실패 - 이미 존재하는 사용자
      onRegisterFailure(context, '이미 존재하는 회원입니다.');
    } else {
      // 기타 오류 처리
      print('Failed to register user');
      onRegisterFailure(context, '회원가입에 실패했습니다. 다시 시도해주세요.');
    }
  }

  Future<void> checkUsernameAvailability(String username) async {
    final response = await http.get(
        Uri.parse('http://192.168.242.51:8080/check-username?username=$username'));

    if (response.statusCode == 200) {
      final users = json.decode(response.body) as List;
      setState(() {
        _isUsernameAvailable = users.isEmpty;
      });
    } else {
      throw Exception('Failed to check username availability');
    }
  }

  void _register() {
    if (_passwordController.text == _confirmPasswordController.text) {
      final username = _usernameController.text;
      final password = _passwordController.text;
      registerUser(username, password);
    } else {
      // 비밀번호 불일치 처리
      print('Passwords do not match');
      onRegisterFailure(context, '비밀번호가 일치하지 않습니다.');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'register',
          style: TextStyle(color: Colors.white),
        ),
        centerTitle: true,
        backgroundColor: Color(0xFF2862AA),
      ),
      body: Container(
        decoration: BoxDecoration(
          color: Color(0xFF2862AA),
        ),
        child: Center(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                TextField(
                  controller: _usernameController,
                  decoration: InputDecoration(
                    labelText: 'Username',
                    enabledBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.white),
                    ),
                    focusedBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.white),
                    ),
                    labelStyle: TextStyle(color: Colors.white),
                  ),
                  style: TextStyle(color: Colors.white),
                ),
                TextField(
                  controller: _passwordController,
                  decoration: InputDecoration(
                    labelText: 'Password',
                    enabledBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.white),
                    ),
                    focusedBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.white),
                    ),
                    labelStyle: TextStyle(color: Colors.white),
                  ),
                  obscureText: true,
                  style: TextStyle(color: Colors.white),
                ),
                TextField(
                  controller: _confirmPasswordController,
                  decoration: InputDecoration(
                    labelText: 'Confirm Password',
                    enabledBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.white),
                    ),
                    focusedBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.white),
                    ),
                    labelStyle: TextStyle(color: Colors.white),
                  ),
                  obscureText: true,
                  style: TextStyle(color: Colors.white),
                ),
                SizedBox(height: 20),
                ElevatedButton(
                  onPressed: _register,
                  style: ElevatedButton.styleFrom(
                    minimumSize: Size(150, 50), // 버튼 크기 조정
                    backgroundColor: Colors.white, // 버튼 색상
                    shadowColor: Color.fromARGB(255, 90, 90, 90), // 그림자 색상
                    elevation: 5, // 그림자 높이
                  ),
                  child: Text(
                    '회원가입',
                    style: TextStyle(
                      color: Color(0xFF2862AA),
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
