import 'package:flutter/material.dart';

class DetailPage extends StatelessWidget {
  final String storeName;
  final String description;
  final String location;
  final String? storeImage;

  const DetailPage({
    Key? key,
    required this.storeName,
    required this.description,
    required this.location,
    this.storeImage,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          storeName,
          style: const TextStyle(
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
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Container(
              width: double.infinity,
              height: 200,
              color: Colors.grey[300],
              child: storeImage != null && storeImage!.isNotEmpty
                  ? Image.network(
                      storeImage!,
                      fit: BoxFit.cover,
                    )
                  : const Center(child: Text("이미지 없음")),
            ),
            const SizedBox(height: 16),
            Text(
              description,
              style: const TextStyle(
                fontFamily: 'elec',
                fontWeight: FontWeight.bold,
                color: Color(0xFF5FC6D4),
                fontSize: 20,
              ),
            ),
            const SizedBox(height: 16),
            Text(
              'Location: $location',
              style: const TextStyle(
                fontFamily: 'elec',
                fontWeight: FontWeight.bold,
                color: Color(0xFF5FC6D4),
                fontSize: 20,
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              decoration: InputDecoration(
                hintText: '리뷰를 작성하세요',
                border: OutlineInputBorder(),
              ),
              maxLines: 4,
            ),
            const SizedBox(height: 16),
            Expanded(
              child: ListView.builder(
                itemCount: 10, // 임시 리뷰 개수
                itemBuilder: (context, index) {
                  return ListTile(
                    title: Text('리뷰 제목 $index'),
                    subtitle: Text('리뷰 내용 $index'),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
