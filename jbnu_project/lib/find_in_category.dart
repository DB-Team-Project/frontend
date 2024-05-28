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
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: const Text(
          "카테고리 별",
          style: TextStyle(
            fontFamily: 'elec',
            fontWeight: FontWeight.bold,
            color: Color(0xFF2862AA),
            fontSize: 30,
          ),
        ),
        centerTitle: true,
        backgroundColor: Color.fromARGB(255, 255, 255, 255),
      ),
      body: Container(
        decoration: const BoxDecoration(
          color: Colors.white,
        ),
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Expanded(
              child: GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const RicePage()),
                  );
                },
                child: const CategoryItem(
                  title: "밥집",
                  imagePath: 'assets/images/rice.png',
                ),
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
                child: const CategoryItem(
                  title: "카페",
                  imagePath: 'assets/images/cafe.png',
                ),
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
                child: const CategoryItem(
                  title: "술집",
                  imagePath: 'assets/images/alcohol.png',
                ),
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
                child: const CategoryItem(
                  title: "기타",
                  imagePath: 'assets/images/other.png',
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

class CategoryItem extends StatelessWidget {
  final String title;
  final String imagePath;
  const CategoryItem({required this.title, required this.imagePath});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 5),
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        border: Border.all(
          color: Color(0xFF2862AA),
          width: 5,
        ),
      ),
      child: Row(
        children: [
          Container(
            width: 150,
            height: 150,
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage(imagePath),
                fit: BoxFit.cover,
              ),
            ),
          ),
          const SizedBox(width: 20),
          Expanded(
            child: Text(
              title,
              style: const TextStyle(
                fontFamily: 'elec',
                fontWeight: FontWeight.bold,
                color: Color(0xFF2862AA),
                fontSize: 30,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
