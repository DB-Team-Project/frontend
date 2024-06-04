import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:provider/provider.dart';
import '../AuthProvider.dart';

class DetailPage extends StatefulWidget {
  final int storeId;
  final String storeName;
  final String description;
  final String location;
  final String? storeImage;
  final String categoryName;

  const DetailPage({
    Key? key,
    required this.storeId,
    required this.storeName,
    required this.description,
    required this.location,
    required this.categoryName,
    this.storeImage,
  }) : super(key: key);

  @override
  _DetailPageState createState() => _DetailPageState();
}

class _DetailPageState extends State<DetailPage> {
  Map<String, dynamic>? _storeDetails;
  List<dynamic> _reviews = [];
  bool _isLoading = true;
  double _rating = 0;
  final TextEditingController _commentController = TextEditingController();
  bool _isSubmitting = false;

  @override
  void initState() {
    super.initState();
    _fetchStoreDetails();
  }

  Future<void> _fetchStoreDetails() async {
    final response = await http.get(Uri.parse(
        'http://192.168.242.51:8080/api/category/${widget.categoryName}/${widget.storeId}'));

    if (response.statusCode == 200) {
      final jsonString = utf8.decode(response.bodyBytes);
      final jsonData = json.decode(jsonString);
      print('Fetched data: $jsonData'); // 데이터를 제대로 가져왔는지 확인하는 로그
      setState(() {
        _storeDetails = jsonData;
        _reviews = jsonData['reviews'];
        print('Reviews: $_reviews'); // 리뷰 데이터가 올바르게 파싱되는지 확인
        _isLoading = false;
      });
    } else {
      throw Exception('Failed to load store details');
    }
  }

  Future<void> _submitReview(
      BuildContext context, int storeId, double rating, String comment) async {
    if (rating == 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('평점을 0점으로 제출할 수 없습니다.')),
      );
      return;
    }

    setState(() {
      _isSubmitting = true;
    });

    final memberId = Provider.of<AuthProvider>(context, listen: false).userId;
    final memberName =
        Provider.of<AuthProvider>(context, listen: false).userName;
    final url = Uri.parse('http://192.168.242.51:8080/api/review');
    try {
      final response = await http.post(
        url,
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(<String, dynamic>{
          'memberId': memberId,
          'storeId': storeId,
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
          _isSubmitting = false;
        });
        _fetchStoreDetails(); // 리뷰 제출 후 세부 정보 및 리뷰 목록 다시 가져오기
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('리뷰 제출에 실패했습니다. 다시 시도해주세요.')),
        );
        setState(() {
          _isSubmitting = false;
        });
      }
    } catch (error) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('리뷰 제출 중 오류가 발생했습니다: $error')),
      );
      setState(() {
        _isSubmitting = false;
      });
    }
  }

  Future<void> _deleteReview(int reviewId, int storeId) async {
    setState(() {
      _isSubmitting = true;
    });

    final memberId = Provider.of<AuthProvider>(context, listen: false).userId;
    final url = Uri.parse('http://192.168.242.51:8080/api/review/$reviewId');
    try {
      final response = await http.delete(
        url,
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(<String, dynamic>{
          'memberId': memberId,
          'storeId': storeId,
        }),
      );

      if (response.statusCode == 204) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('리뷰가 성공적으로 삭제되었습니다.')),
        );
        await _fetchStoreDetails(); // 리뷰 삭제 후 세부 정보 및 리뷰 목록 다시 가져오기
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('리뷰 삭제에 실패했습니다. 다시 시도해주세요.')),
        );
      }
    } catch (error) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('리뷰 삭제 중 오류가 발생했습니다: $error')),
      );
    } finally {
      setState(() {
        _isSubmitting = false;
      });
    }
  }

  Future<void> _updateReview(
      int reviewId, int storeId, double rating, String comment) async {
    setState(() {
      _isSubmitting = true;
    });

    final memberId = Provider.of<AuthProvider>(context, listen: false).userId;
    final url = Uri.parse('http://192.168.242.51:8080/api/review/$reviewId');
    try {
      final response = await http.put(
        url,
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(<String, dynamic>{
          'memberId': memberId,
          'storeId': storeId,
          'rating': rating,
          'comment': comment,
        }),
      );

      if (response.statusCode == 201) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('리뷰가 성공적으로 수정되었습니다.')),
        );
        _fetchStoreDetails(); // 리뷰 수정 후 세부 정보 및 리뷰 목록 다시 가져오기
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('리뷰 수정에 실패했습니다. 다시 시도해주세요.')),
        );
      }
    } catch (error) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('리뷰 수정 중 오류가 발생했습니다: $error')),
      );
    } finally {
      setState(() {
        _isSubmitting = false;
      });
    }
  }

  void _showEditDialog(
      int reviewId, int storeId, double initialRating, String initialComment) {
    double _newRating = initialRating;
    TextEditingController _newCommentController =
        TextEditingController(text: initialComment);

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('리뷰 수정'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              RatingBar.builder(
                initialRating: _newRating,
                minRating: 1,
                direction: Axis.horizontal,
                allowHalfRating: false,
                itemCount: 5,
                itemPadding: const EdgeInsets.symmetric(horizontal: 4.0),
                itemBuilder: (context, _) => const Icon(
                  Icons.star,
                  color: Colors.amber,
                ),
                onRatingUpdate: (rating) {
                  _newRating = rating;
                },
              ),
              TextField(
                controller: _newCommentController,
                decoration: const InputDecoration(labelText: '리뷰 내용'),
                maxLines: 2,
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('취소'),
            ),
            TextButton(
              onPressed: () {
                _updateReview(
                  reviewId,
                  storeId,
                  _newRating,
                  _newCommentController.text,
                );
                Navigator.of(context).pop();
              },
              child: const Text('저장'),
            ),
          ],
        );
      },
    );
  }

  void _showDeleteDialog(int reviewId, int storeId) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('리뷰 삭제'),
          content: Text('정말로 리뷰를 삭제하시겠습니까?'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('취소'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // 다이얼로그 닫기
                _deleteReview(reviewId, storeId); // 리뷰 삭제 함수 호출
              },
              child: const Text('삭제'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final memberId = Provider.of<AuthProvider>(context, listen: false).userId;

    return Scaffold(
      backgroundColor: Colors.white,
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
      body: _isLoading
          ? Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: double.infinity,
                    height: 400,
                    color: Colors.white,
                    padding: const EdgeInsets.all(20),
                    child: widget.storeImage != null &&
                            widget.storeImage!.isNotEmpty
                        ? Image.network(
                            widget.storeImage!,
                            fit: BoxFit.contain,
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
                  Text(
                    '평균 평점: ${_storeDetails!['avgRating']}',
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
                      color: Color(0xFF2862AA),
                      fontSize: 18,
                    ),
                  ),
                  const SizedBox(height: 16),
                  RatingBar.builder(
                    initialRating: _rating,
                    minRating: 1,
                    direction: Axis.horizontal,
                    allowHalfRating: false,
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
                      labelStyle: TextStyle(
                        fontFamily: 'elec',
                        color: Color(0xFF2862AA),
                      ),
                    ),
                    maxLines: 2,
                  ),
                  const SizedBox(height: 16),
                  Center(
                    child: _isSubmitting
                        ? CircularProgressIndicator()
                        : ElevatedButton(
                            onPressed: () {
                              if (_rating > 0) {
                                _submitReview(
                                  context,
                                  widget.storeId,
                                  _rating,
                                  _commentController.text,
                                ).then((_) {
                                  setState(() {
                                    _rating = 0; // 별점을 초기화
                                  });
                                });
                              } else {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text('평점을 입력하세요.'),
                                  ),
                                );
                              }
                            },
                            child: const Text(
                              '리뷰 제출',
                              style: TextStyle(color: Color(0xFF2862AA)),
                            ),
                          ),
                  ),
                  const SizedBox(height: 16),
                  const Divider(),
                  const Text(
                    '리뷰 목록',
                    style: TextStyle(
                      fontFamily: 'elec',
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF2862AA),
                      fontSize: 18,
                    ),
                  ),
                  ListView.builder(
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    itemCount: _reviews.length,
                    itemBuilder: (context, index) {
                      final review = _reviews[index];
                      print('Review: $review'); // 각 리뷰 데이터가 올바르게 전달되는지 확인
                      return Padding(
                        padding: const EdgeInsets.symmetric(vertical: 8.0),
                        child: ListTile(
                          title: Text(
                            '${review['memberName']}',
                            style: const TextStyle(
                              fontFamily: 'elec',
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF2862AA),
                            ),
                          ),
                          subtitle: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              RatingBar.builder(
                                initialRating: review['rating'].toDouble(),
                                minRating: 1,
                                direction: Axis.horizontal,
                                allowHalfRating: false,
                                ignoreGestures: true,
                                itemCount: 5,
                                itemSize: 20.0,
                                itemBuilder: (context, _) => const Icon(
                                  Icons.star,
                                  color: Colors.amber,
                                ),
                                onRatingUpdate: (rating) {
                                  // 이미 ignoreGestures가 true라 호출되지 않음
                                },
                              ),
                              const SizedBox(height: 4),
                              Text(
                                review['reviewText'],
                                style: const TextStyle(
                                  fontFamily: 'elec',
                                  color: Color(0xFF5FC6D4),
                                ),
                              ),
                              const SizedBox(height: 4),
                              if (review['memberId'] == memberId)
                                Row(
                                  children: [
                                    TextButton(
                                      onPressed: () {
                                        _showDeleteDialog(
                                            review['reviewId'], widget.storeId);
                                      },
                                      child: const Text(
                                        '삭제',
                                        style: TextStyle(color: Colors.red),
                                      ),
                                    ),
                                    TextButton(
                                      onPressed: () {
                                        _showEditDialog(
                                          review['reviewId'],
                                          widget.storeId,
                                          review['rating'].toDouble(),
                                          review['reviewText'],
                                        );
                                      },
                                      child: const Text(
                                        '수정',
                                        style: TextStyle(color: Colors.blue),
                                      ),
                                    ),
                                  ],
                                ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),
    );
  }
}
