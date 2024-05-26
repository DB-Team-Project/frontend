import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class RicePage extends StatefulWidget {
  const RicePage({super.key});

  @override
  _RicePageState createState() => _RicePageState();
}

class _RicePageState extends State<RicePage> {
  List<dynamic> _restaurants = [];

  @override
  void initState() {
    super.initState();
    _fetchRestaurants();
  }

  Future<void> _fetchRestaurants() async {
    final response =
        await http.get(Uri.parse('http://your-backend-url.com/restaurants'));

    if (response.statusCode == 200) {
      setState(() {
        _restaurants = json.decode(response.body);
      });
    } else {
      throw Exception('Failed to load restaurants');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('밥집'),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
      ),
      body: Column(
        children: <Widget>[
          Padding(
            padding: EdgeInsets.all(16.0),
            child: TextField(
              decoration: InputDecoration(
                prefixIcon: Icon(Icons.search),
                hintText: '검색창',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: _restaurants.length,
              itemBuilder: (context, index) {
                final restaurant = _restaurants[index];
                return Padding(
                  padding: EdgeInsets.all(8.0),
                  child: CategoryItem(
                    title: restaurant['name'],
                    imageUrl: restaurant['image'],
                    description: restaurant['description'],
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class CategoryItem extends StatelessWidget {
  final String title;
  final String? imageUrl;
  final String description;

  const CategoryItem({
    required this.title,
    this.imageUrl,
    required this.description,
  });

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
            child: imageUrl != null
                ? Image.network(imageUrl!, fit: BoxFit.cover)
                : Center(child: Text("그림")),
          ),
          SizedBox(width: 20),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(fontSize: 24),
                ),
                SizedBox(height: 8),
                Text(description),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
