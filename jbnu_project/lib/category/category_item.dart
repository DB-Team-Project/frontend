import 'package:flutter/material.dart';
import 'detail.dart';

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
    return GestureDetector(
      onTap: () {
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => DetailPage(
              storeName: storeName,
              description: description,
              location: location,
              storeImage: storeImage,
            ),
          ),
        );
      },
      child: Container(
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
      ),
    );
  }
}
