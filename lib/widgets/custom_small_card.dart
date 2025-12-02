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
    return Container(
      height: 155,
      width: 150,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade600),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 7,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: BorderRadiusGeometry.circular(12),
              child: SizedBox(
                height: 100,
                width: 140,
                child: Image.network(imagePath, fit: BoxFit.cover),
              ),
            ),
            SizedBox(height: 7),
            Text(
              title,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16,
                color: const Color.fromARGB(183, 0, 0, 0),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
