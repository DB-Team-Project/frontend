import 'package:flutter/material.dart';

class AlcoholPage extends StatelessWidget {
  const AlcoholPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("술"),
      ),
      body: Center(
        child: Text("술 페이지 내용"),
      ),
    );
  }
}
