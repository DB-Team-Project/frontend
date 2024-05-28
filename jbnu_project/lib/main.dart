import 'package:flutter/material.dart';
import 'find_in_map.dart';
import 'find_in_category.dart';
import 'login.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: const [
        Locale('ko', 'KR'),
        Locale('en', 'US'),
      ],
      home: LoginPage(),
    );
  }
}
class MyHomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "제휴 좋아",
          style: TextStyle(
            fontFamily: 'elec',
            fontWeight: FontWeight.bold,
            color: Color(0xFF2862AA),
            fontSize: 40,
          ),
          ),
        centerTitle: true,
        backgroundColor: Color.fromARGB(255, 255, 255, 255),
      ),
      body: Container(
        decoration: BoxDecoration(
          color: Colors.white,
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
                height: 250,
                padding: EdgeInsets.all(20),
                decoration: BoxDecoration(
                  border: Border.all(
                    color: Color(0xFF2862AA),
                    width: 5,
                  ),
                ),
                child: Row(
                  children: [
                    Image.asset(
                      'assets/images/category.png',
                      width: 180,
                      height: 180,
                    ),
                    Expanded(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: const [
                          Text(" 카테고리별",
                              style:
                                  TextStyle(
                                    fontFamily: 'elec',
                                    fontWeight: FontWeight.bold,
                                    color: Color(0xFF2862AA), fontSize: 26),),
                          Text("제휴 찾기",
                              style:
                                  TextStyle(
                                    fontFamily: 'elec',
                                    fontWeight: FontWeight.bold,
                                    color: Color(0xFF2862AA), fontSize: 30),),
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
                height: 250,
                padding: EdgeInsets.all(20),
                decoration: BoxDecoration(
                  border: Border.all(
                    color: Color(0xFF2862AA),
                    width: 5,
                  ),
                ),
                child: Row(
                  children: [
                    Image.asset(
                      'assets/images/category.png',
                      width: 180,
                      height: 180
                    ),
                    Expanded(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: const [
                          Text(" 내 주변",
                              style:
                                  TextStyle(
                                    fontFamily: 'elec',
                                    fontWeight: FontWeight.bold,
                                    color: Color(0xFF2862AA), fontSize: 30),
                                    ),
                          Text("제휴 찾기",
                              style:
                                  TextStyle(
                                    fontFamily: 'elec',
                                    fontWeight: FontWeight.bold,
                                    color: Color(0xFF2862AA), fontSize: 28),),
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
      bottomNavigationBar: BottomAppBar(
        color: Colors.white,
        child: Container(
          height: 50.0,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Image.asset(
                      'assets/images/title.png',
                      width: 150,
                      height: 150,
                    ),
            ],
          ),
        ),
      ),
    );
  }
}
