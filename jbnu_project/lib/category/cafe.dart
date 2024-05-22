import 'package:flutter/material.dart';

class CafePage extends StatelessWidget {
  const CafePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("카페"),
      ),
      body: Center(
        child: Text("카페 페이지 내용"),
      ),
    );
  }
}
