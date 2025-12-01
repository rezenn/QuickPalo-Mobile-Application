import 'package:flutter/material.dart';

class CustomBigCard extends StatelessWidget {
  const CustomBigCard({
    super.key,
    required this.imagePath,
    required this.title,
    required this.location,
    required this.time,
    required this.description,
  });
  final String imagePath;
  final String title;
  final String location;
  final String time;
  final String description;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 250,
      width: 175,
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
        padding: EdgeInsets.fromLTRB(10, 10, 10, 5),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: SizedBox(
                width: 170,
                height: 115,
                child: Image.network(imagePath, fit: BoxFit.cover),
              ),
            ),
            SizedBox(height: 5),
            Text(
              title,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              textAlign: TextAlign.left,
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
                color: Color.fromARGB(183, 0, 0, 0),
              ),
            ),
            Row(
              children: [
                Icon(Icons.location_pin, color: Colors.red, size: 12),
                SizedBox(width: 5),
                Text(
                  location,
                  style: TextStyle(fontSize: 10, fontWeight: FontWeight.w400),
                ),
              ],
            ),
            Row(
              children: [
                Icon(
                  Icons.access_time,
                  color: const Color.fromARGB(255, 65, 65, 65),
                  size: 12,
                ),
                SizedBox(width: 5),
                Text(
                  time,
                  style: TextStyle(fontSize: 10, fontWeight: FontWeight.w400),
                ),
              ],
            ),
            Divider(height: 10, color: const Color.fromARGB(255, 79, 78, 78)),
            Text(
              description,
              maxLines: 4,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                fontSize: 10,
                fontWeight: FontWeight.w400,
                color: const Color.fromARGB(183, 0, 0, 0),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
