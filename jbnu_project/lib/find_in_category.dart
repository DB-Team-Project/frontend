import 'package:flutter/material.dart';
import 'category/rice.dart';
import 'category/alcohol.dart';
import 'category/cafe.dart';
import 'category/other.dart';

class FindInCategoryPage extends StatelessWidget {
  const FindInCategoryPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: Text("카테고리 별"),
      ),
      body: Column(
        children: [
          Expanded(
            child: GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const RicePage()),
                );
              },
              child: CategoryItem(title: "밥"),
            ),
          ),
          Expanded(
            child: GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const CafePage()),
                );
              },
              child: CategoryItem(title: "카페"),
            ),
          ),
          Expanded(
            child: GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const AlcoholPage()),
                );
              },
              child: CategoryItem(title: "술"),
            ),
          ),
          Expanded(
            child: GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const OtherPage()),
                );
              },
              child: CategoryItem(title: "기타"),
            ),
          ),
        ],
      ),
    );
  }
}

class CategoryItem extends StatelessWidget {
  final String title;
  const CategoryItem({required this.title});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 5),
      padding: EdgeInsets.all(10),
      decoration: BoxDecoration(
        border: Border.all(),
      ),
      child: Row(
        children: [
          Container(
            width: 100,
            height: 100,
            color: Colors.grey, // Placeholder for image
            child: Center(child: Text("그림")),
          ),
          SizedBox(width: 20),
          Expanded(
            child: Text(
              title,
              style: TextStyle(fontSize: 24),
            ),
          ),
        ],
      ),
    );
  }
}
