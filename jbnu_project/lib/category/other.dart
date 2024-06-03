import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'category_item.dart';

class OtherPage extends StatefulWidget {
  const OtherPage({super.key});

  @override
  _OtherPageState createState() => _OtherPageState();
}

class _OtherPageState extends State<OtherPage> {
  List<Map<String, dynamic>> _etc = [];
  List<Map<String, dynamic>> _filteredEtc = [];
  TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _fetchEtc();
    _searchController.addListener(_filterEtc);
  }

  @override
  void dispose() {
    _searchController.removeListener(_filterEtc);
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _fetchEtc() async {
    final response =
        await http.get(Uri.parse('http://localhost:8080/api/category/etc'));

    if (response.statusCode == 200) {
      final jsonString = utf8.decode(response.bodyBytes);
      final jsonData = json.decode(jsonString);
      setState(() {
        _etc = List<Map<String, dynamic>>.from(jsonData['stores']);
        _filteredEtc = _etc;
      });
    } else {
      throw Exception('Failed to load etc');
    }
  }

  void _filterEtc() {
    final query = _searchController.text.toLowerCase();
    setState(() {
      _filteredEtc = _etc.where((etc) {
        final name = etc['storeName'].toString().toLowerCase();
        return name.contains(query);
      }).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text(
          '기타',
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
      body: Column(
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: TextField(
              controller: _searchController,
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
                  borderSide: BorderSide(
                    color: Color(0xFF2862AA), // 테두리 색상 변경
                  ),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: BorderSide(
                    color: Color(0xFF2862AA), // 활성화 상태의 테두리 색상
                  ),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: BorderSide(
                    color: Color(0xFF2862AA), // 포커스 상태의 테두리 색상
                  ),
                ),
              ),
            ),
          ),
          Expanded(
            child: Container(
              color: Colors.white,
              child: ListView.builder(
                itemCount: _filteredEtc.length,
                itemBuilder: (context, index) {
                  final etc = _filteredEtc[index];
                  return Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: CategoryItem(
                      storeId: etc['storeId'],
                      storeName: etc['storeName'],
                      description: etc['description'],
                      storeImage: etc['storeImage'],
                      location: etc['location'],
                      categoryName: etc['categoryName'],
                    ),
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}
