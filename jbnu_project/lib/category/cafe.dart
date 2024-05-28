import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class CafePage extends StatefulWidget {
  const CafePage({super.key});

  @override
  _CafePageState createState() => _CafePageState();
}

class _CafePageState extends State<CafePage> {
  List<Map<String, dynamic>> _cafe = [];

  @override
  void initState() {
    super.initState();
    _fetchRestaurants();
  }

  Future<void> _fetchRestaurants() async {
    final response =
        await http.get(Uri.parse('http://localhost:8080/api/category/cafe'));

    if (response.statusCode == 200) {
      final jsonString = utf8.decode(response.bodyBytes);
      final jsonData = json.decode(jsonString);
      setState(() {
        _cafe = List<Map<String, dynamic>>.from(jsonData['stores']);
      });
    } else {
      throw Exception('Failed to load cafe');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white, // 배경색 흰색으로 설정
      appBar: AppBar(
        title: const Text(
          '카페',
          style: TextStyle(
            fontFamily: 'elec',
            fontWeight: FontWeight.bold,
            color: Color(0xFF2862AA),
            fontSize: 30,
          ),
        ),
        centerTitle: true,
        backgroundColor: Colors.white,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
      ),
      body: Container(
        color: Colors.white, // body 배경색 흰색으로 설정
        child: Column(
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: TextField(
                decoration: InputDecoration(
                  prefixIcon: const Icon(
                    Icons.search,
                    color: Color(0xFF2862AA), // 아이콘 색상 변경
                  ),
                  hintText: '검색창',
                  hintStyle: TextStyle(
                    color: Color(0xFF2862AA), // 힌트 텍스트 색상 변경
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: const BorderSide(
                      color: Color(0xFF2862AA), // 테두리 색상 변경
                    ),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: const BorderSide(
                      color: Color(0xFF2862AA), // 활성화 상태의 테두리 색상
                    ),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: const BorderSide(
                      color: Color(0xFF2862AA), // 포커스 상태의 테두리 색상
                    ),
                  ),
                ),
              ),
            ),
            Expanded(
              child: Container(
                color: Colors.white, // ListView 배경색 흰색으로 설정
                child: ListView.builder(
                  itemCount: _cafe.length,
                  itemBuilder: (context, index) {
                    final restaurant = _cafe[index];
                    return Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: CategoryItem(
                          storeId: restaurant['storeId'],
                          storeName: restaurant['storeName'],
                          description: restaurant['description'],
                          storeImage: restaurant['storeImage'],
                          location: restaurant['location']),
                    );
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class CategoryItem extends StatelessWidget {
  final int storeId;
  final String storeName;
  final String? storeImage;
  final String description;
  final String location;

  const CategoryItem({
    Key? key,
    required this.storeId,
    required this.storeName,
    required this.description,
    required this.location,
    this.storeImage,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 5),
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: Colors.white, // 배경색 흰색으로 설정
        border: Border.all(
          color: const Color(0xFF2862AA),
          width: 5,
        ),
      ),
      child: Row(
        children: [
          Container(
            width: 100,
            height: 100,
            color: Colors.white,
            child: storeImage != null && storeImage!.isNotEmpty
                ? Image.network(
                    storeImage!,
                    fit: BoxFit.cover,
                    loadingBuilder: (context, child, loadingProgress) {
                      if (loadingProgress == null) {
                        return child;
                      }
                      return Center(
                        child: CircularProgressIndicator(
                          value: loadingProgress.expectedTotalBytes != null
                              ? loadingProgress.cumulativeBytesLoaded /
                                  loadingProgress.expectedTotalBytes!
                              : null,
                        ),
                      );
                    },
                    errorBuilder: (context, error, stackTrace) {
                      return const Center(
                        child: Text('Error loading image'),
                      );
                    },
                  )
                : const Center(child: Text("그림")),
          ),
          const SizedBox(width: 20),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  storeName,
                  style: const TextStyle(
                    fontFamily: 'elec',
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF2862AA),
                    fontSize: 30,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  description,
                  style: const TextStyle(
                    fontFamily: 'elec',
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF5FC6D4),
                    fontSize: 15,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Location: $location',
                  style: const TextStyle(
                    fontFamily: 'elec',
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF5FC6D4),
                    fontSize: 15,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
