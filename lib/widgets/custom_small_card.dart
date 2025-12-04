import 'package:flutter/material.dart';

class CustomSmallCard extends StatelessWidget {
  const CustomSmallCard({
    super.key,
    required this.title,
    required this.imagePath,
  });

  final String imagePath;
  final String title;

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 5,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
      child: Container(
        width: 160,
        padding: EdgeInsets.all(10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: AspectRatio(
                aspectRatio: 16 / 10, // responsive image
                child: Image.network(imagePath, fit: BoxFit.cover),
              ),
            ),
            SizedBox(height: 8),
            Text(
              title,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 15,
                color: Color.fromARGB(183, 0, 0, 0),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
