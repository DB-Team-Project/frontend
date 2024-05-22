import 'package:flutter/material.dart';

class OtherPage extends StatelessWidget {
  const OtherPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("기타"),
      ),
      body: Center(
        child: Text("기타 페이지 내용"),
      ),
    );
  }
}
