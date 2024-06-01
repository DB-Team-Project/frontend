import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:jbnu_project/AuthProvider.dart';
import 'package:provider/provider.dart';
import 'register.dart'; // RegisterPage를 임포트합니다.
import 'package:http/http.dart' as http;
import 'main.dart'; // MyHomePage를 임포트합니다.

class LoginPage extends StatelessWidget {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  void onLoginSuccess(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('로그인 성공'),
          content: Text('로그인이 성공적으로 완료되었습니다.'),
          actions: <Widget>[
            TextButton(
              child: Text('확인'),
              onPressed: () {
                Navigator.of(context).pop(); // 팝업 닫기
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => MyHomePage()),
                ); // MyHomePage로 이동
              },
            ),
          ],
        );
      },
    );
  }

  void onLoginFailure(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('로그인 실패'),
          content: Text('아이디 또는 비밀번호가 잘못되었습니다.'),
          actions: <Widget>[
            TextButton(
              child: Text('확인'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  Future<void> loginUser(String username, String password, BuildContext context) async {
    final url = Uri.parse('http://localhost:8080/api/login');
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
      // 로그인 성공 처리
      final userId = json.decode(response.body);
      Provider.of<AuthProvider>(context, listen: false).setUserId(userId);
      onLoginSuccess(context);
    } else {
      // 로그인 실패 처리
      onLoginFailure(context);
    }
  }

  void _login(BuildContext context) {
    final username = _usernameController.text;
    final password = _passwordController.text;
    loginUser(username, password, context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Login'),
        centerTitle: true,
        backgroundColor: Color(0xFF2862AA),
      ),
      body: Container(
        color: Color(0xFF2862AA),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              SizedBox(height: MediaQuery.of(context).size.height / 6),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 16.0),
                child: Column(
                  children: [
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
                    SizedBox(height: 20),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        ElevatedButton(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => RegisterPage()),
                            );
                          },
                          style: ElevatedButton.styleFrom(
                            minimumSize: Size(150, 50), // 버튼 크기 조정
                            backgroundColor: Colors.white, // 버튼 색상
                            shadowColor:
                            Color.fromARGB(255, 90, 90, 90), // 그림자 색상
                            elevation: 5, // 그림자 높이
                          ),
                          child: Text(
                            '회원가입',
                            style: TextStyle(
                                color: Color(0xFF2862AA),
                                fontSize: 16,
                                fontWeight: FontWeight.bold),
                          ),
                        ),
                        SizedBox(width: 20), // 두 버튼 사이의 간격 조정
                        ElevatedButton(
                          onPressed: () => _login(context),
                          style: ElevatedButton.styleFrom(
                            minimumSize: Size(150, 50), // 버튼 크기 조정
                            backgroundColor: Colors.white, // 버튼 색상
                            shadowColor:
                            const Color.fromARGB(255, 90, 90, 90), // 그림자 색상
                            elevation: 5, // 그림자 높이
                          ),
                          child: Text(
                            '로그인',
                            style: TextStyle(
                                color: Color(0xFF2862AA),
                                fontSize: 16,
                                fontWeight: FontWeight.bold),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
