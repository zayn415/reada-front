import 'package:flutter/material.dart';

class BookCard extends StatelessWidget {
  final String? coverUrl;
  final String title;
  final double progress;

  const BookCard({
    super.key,
    required this.coverUrl,
    required this.title,
    this.progress = 0.0,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: double.infinity,
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 封面图片
            ConstrainedBox(
              constraints: BoxConstraints(maxHeight: 180),
              child: AspectRatio(
                aspectRatio: 3 / 4,
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(6),
                      child: Container(
                        width: double.infinity,
                        height: double.infinity,
                        color: Colors.grey[300],
                        child:
                            coverUrl != null
                                ? Image.network(
                                  coverUrl!,
                                  fit: BoxFit.cover,
                                  errorBuilder:
                                      (_, __, ___) => _buildPlaceholder(),
                                )
                                : _buildPlaceholder(),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 4),
            // 书名
            Padding(
              padding: const EdgeInsets.only(left: 4),
              child: Text(
                title,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(fontSize: 14),
              ),
            ),
            // 进度
            if (progress > 0)
              Padding(
                padding: const EdgeInsets.only(bottom: 4, left: 4),
                child: Text(
                  '已读 ${(progress * 100).toInt()}%',
                  style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildPlaceholder() {
    return const Icon(Icons.book, size: 40, color: Colors.grey);
  }
}
