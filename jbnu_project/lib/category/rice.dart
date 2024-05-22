import 'package:flutter/material.dart';

class RicePage extends StatelessWidget {
  const RicePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("밥"),
      ),
      body: Center(
        child: Text("밥 페이지 내용"),
      ),
    );
  }
}
