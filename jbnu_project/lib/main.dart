import 'package:flutter/material.dart';
import 'find_in_map.dart';
import 'find_in_category.dart';
import 'login.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: LoginPage(),
    );
  }
}

class MyHomePage extends StatelessWidget { 
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("앱이름"),
        centerTitle: true,
        backgroundColor: Color(0xFF2862AA), // 짙은 파랑
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFF2862AA), Color(0xFF5FC6D4)], // 배경 그라데이션
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const FindInCategoryPage()),
                );
              },
              child: Container(
                width: double.infinity,
                height: 200,
                padding: EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Color.fromARGB(80, 255, 255, 255),
                  borderRadius: BorderRadius.circular(10),
                  boxShadow: [
                    BoxShadow(
                      color: Color.fromARGB(66, 212, 212, 212),
                      blurRadius: 20,
                      offset: Offset(0, 5),
                    ),
                  ],
                ),
                child: Row(
                  children: [
                    Image.network(
                      'https://via.placeholder.com/200',
                      width: 200,
                      height: 200,
                    ),
                    Expanded(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: const [
                          Text("카테고리별",
                              style:
                                  TextStyle(color: Colors.black, fontSize: 24)),
                          Text("제휴찾기",
                              style:
                                  TextStyle(color: Colors.black, fontSize: 20)),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const NewPage2()),
                );
              },
              child: Container(
                width: double.infinity,
                height: 200,
                padding: EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Color.fromARGB(80, 255, 255, 255),
                  borderRadius: BorderRadius.circular(10),
                  boxShadow: [
                    BoxShadow(
                      color: Color.fromARGB(66, 212, 212, 212),
                      blurRadius: 20,
                      offset: Offset(0, 5),
                    ),
                  ],
                ),
                child: Row(
                  children: [
                    Image.network(
                      'https://via.placeholder.com/200',
                      width: 200,
                      height: 200,
                    ),
                    Expanded(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: const [
                          Text("내 주변",
                              style:
                                  TextStyle(color: Colors.black, fontSize: 28)),
                          Text("제휴 찾기",
                              style:
                                  TextStyle(color: Colors.black, fontSize: 20)),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
