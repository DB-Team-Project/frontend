import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';

class DetailPage extends StatefulWidget {
  final int storeId; // storeId 추가
  final String storeName;
  final String description;
  final String location;
  final String? storeImage;

  const DetailPage({
    Key? key,
    required this.storeId, // storeId 추가
    required this.storeName,
    required this.description,
    required this.location,
    this.storeImage,
  }) : super(key: key);

  @override
  _DetailPageState createState() => _DetailPageState();
}

class _DetailPageState extends State<DetailPage> {
  final TextEditingController _commentController = TextEditingController();
  double _rating = 0;
  bool _isSubmitting = false;

  Future<void> _submitReview(
      BuildContext context, int storeId, double rating, String comment) async {
    setState(() {
      _isSubmitting = true;
    });

    final url = Uri.parse('http://localhost:8080/api/review');
    try {
      final response = await http.post(
        url,
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(<String, dynamic>{
          'memberId': 1, // 여기에 실제 사용자 ID를 넣어야 합니다.
          'storeId': storeId, // storeId를 Long 타입으로 전달
          'rating': rating,
          'comment': comment,
        }),
      );

      if (response.statusCode == 201) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('리뷰가 성공적으로 제출되었습니다.')),
        );
        _commentController.clear();
        setState(() {
          _rating = 0;
        });
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('리뷰 제출에 실패했습니다. 다시 시도해주세요.')),
        );
      }
    } catch (error) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('리뷰 제출 중 오류가 발생했습니다: $error')),
      );
    } finally {
      setState(() {
        _isSubmitting = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.storeName,
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
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: double.infinity,
              height: 200,
              color: Colors.grey[300],
              child: widget.storeImage != null && widget.storeImage!.isNotEmpty
                  ? Image.network(
                      widget.storeImage!,
                      fit: BoxFit.cover,
                    )
                  : const Center(child: Text("이미지 없음")),
            ),
            const SizedBox(height: 16),
            Text(
              widget.description,
              style: const TextStyle(
                fontFamily: 'elec',
                fontWeight: FontWeight.bold,
                color: Color(0xFF5FC6D4),
                fontSize: 20,
              ),
            ),
            const SizedBox(height: 16),
            Text(
              '위치: ${widget.location}',
              style: const TextStyle(
                fontFamily: 'elec',
                fontWeight: FontWeight.bold,
                color: Color(0xFF5FC6D4),
                fontSize: 16,
              ),
            ),
            const SizedBox(height: 16),
            const Divider(),
            const Text(
              '리뷰를 작성하세요',
              style: TextStyle(
                fontFamily: 'elec',
                fontWeight: FontWeight.bold,
                color: Colors.black,
                fontSize: 18,
              ),
            ),
            const SizedBox(height: 16),
            RatingBar.builder(
              initialRating: 0,
              minRating: 1,
              direction: Axis.horizontal,
              allowHalfRating: true,
              itemCount: 5,
              itemPadding: const EdgeInsets.symmetric(horizontal: 4.0),
              itemBuilder: (context, _) => const Icon(
                Icons.star,
                color: Colors.amber,
              ),
              onRatingUpdate: (rating) {
                setState(() {
                  _rating = rating;
                });
              },
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _commentController,
              decoration: const InputDecoration(
                labelText: '리뷰 내용',
              ),
              maxLines: 3,
            ),
            const SizedBox(height: 16),
            Center(
              child: _isSubmitting
                  ? CircularProgressIndicator()
                  : ElevatedButton(
                      onPressed: () {
                        _submitReview(
                          context,
                          widget.storeId, // 올바른 storeId 전달
                          _rating,
                          _commentController.text,
                        );
                      },
                      child: const Text('리뷰 제출'),
                    ),
            ),
            const SizedBox(height: 16),
            const Divider(),
            const Text(
              '리뷰 내용',
              style: TextStyle(
                fontFamily: 'elec',
                fontWeight: FontWeight.bold,
                color: Colors.black,
                fontSize: 18,
              ),
            ),
            // 여기에 리뷰 리스트를 추가할 수 있습니다.
          ],
        ),
      ),
    );
  }
}
