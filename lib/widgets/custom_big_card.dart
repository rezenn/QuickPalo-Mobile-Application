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
    return LayoutBuilder(
      builder: (context, constraints) {
        final double maxW = constraints.maxWidth;

        // Make responsive sizes
        final double cardWidth = maxW * 0.45;
        final double cardHeight = cardWidth * 1;

        return Container(
          width: cardWidth,
          height: cardHeight,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Colors.grey.shade600),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.1),
                blurRadius: 7,
                offset: const Offset(0, 3),
              ),
            ],
          ),
          child: Padding(
            padding: const EdgeInsets.fromLTRB(10, 10, 10, 5),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: SizedBox(
                    width: cardWidth * 2,
                    height: cardHeight * 1.6,
                    child: Image.network(imagePath, fit: BoxFit.cover),
                  ),
                ),

                const SizedBox(height: 8),

                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                  ),
                ),

                Row(
                  children: [
                    const Icon(Icons.location_pin, color: Colors.red, size: 13),
                    const SizedBox(width: 5),
                    Expanded(
                      child: Text(
                        location,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.w500,
                          color: Color.fromARGB(200, 0, 0, 0),
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 5),
                Row(
                  children: [
                    const Icon(Icons.access_time, color: Colors.grey, size: 13),
                    const SizedBox(width: 5),
                    Expanded(
                      child: Text(
                        time,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.w500,
                          color: Color.fromARGB(200, 0, 0, 0),
                        ),
                      ),
                    ),
                  ],
                ),
                Divider(height: 10, thickness: 1),
                Expanded(
                  child: Text(
                    description,
                    maxLines: 4,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(fontSize: 12),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
