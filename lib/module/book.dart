import 'package:flutter/material.dart';

class BookCard extends StatelessWidget {
  final String? coverUrl;
  final String title;
  final double progress;
  final bool showBadge;

  const BookCard({
    super.key,
    required this.coverUrl,
    required this.title,
    this.progress = 0.0,
    this.showBadge = false,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 100,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 封面图片
          AspectRatio(
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
                              errorBuilder: (_, __, ___) => _buildPlaceholder(),
                            )
                            : _buildPlaceholder(),
                  ),
                ),
                if (showBadge)
                  Container(
                    padding: const EdgeInsets.all(3),
                    decoration: BoxDecoration(
                      color: Colors.red,
                      shape: BoxShape.circle,
                    ),
                  ),
              ],
            ),
          ),
          const SizedBox(height: 8),
          // 书名
          Text(
            title,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(fontSize: 14),
          ),
          // 进度
          if (progress > 0)
            Padding(
              padding: const EdgeInsets.only(bottom: 4),
              child: Text(
                '已读 ${(progress * 100).toInt()}%',
                style: TextStyle(fontSize: 12, color: Colors.grey[600]),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildPlaceholder() {
    return const Icon(Icons.book, size: 40, color: Colors.grey);
  }
}
