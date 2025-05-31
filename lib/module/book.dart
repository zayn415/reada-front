import 'package:flutter/material.dart';

class BookCard extends StatelessWidget {
  final String? coverUrl;
  final String title;
  final double progress; // 0.0 ~ 1.0

  const BookCard({
    super.key,
    required this.coverUrl,
    required this.title,
    this.progress = 0.0,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 120,
      child: Column(
        children: [
          // 书本封面
          Stack(
            alignment: Alignment.bottomCenter,
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(6),
                child: Image.network(
                  coverUrl ?? '',
                  width: 110,
                  height: 140,
                  fit: BoxFit.cover,
                  errorBuilder:
                      (_, __, ___) => Container(
                        width: 110,
                        height: 150,
                        color: Colors.grey[300],
                        child: const Icon(Icons.book, size: 40),
                      ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          // 书本名称
          Text(
            title,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w500),
          ),
        ],
      ),
    );
  }
}
