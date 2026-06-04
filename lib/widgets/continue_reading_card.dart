import 'package:flutter/material.dart';

class ContinueReadingCard extends StatelessWidget {
  final String title;
  final String chapter;
  final String timeLeft;
  final bool isExploreCard;
  final VoidCallback? onTap;

  const ContinueReadingCard({
    super.key,
    required this.title,
    required this.chapter,
    required this.timeLeft,
    this.isExploreCard = false,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    if (isExploreCard) {
      return _buildExploreCard();
    }
    return _buildReadingCard();
  }

  Widget _buildReadingCard() {
    return GestureDetector(
      onTap: onTap,
      child: SizedBox(
        width: 130,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Thumbnail
            Container(
              height: 120,
              width: 130,
              decoration: BoxDecoration(
                color: const Color(0xFFE8E0D8),
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: const Color(0xFF8B4513).withValues(alpha: 0.08),
                    blurRadius: 8,
                    offset: const Offset(0, 3),
                  ),
                ],
              ),
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.image_outlined,
                      size: 36,
                      color: Colors.grey.shade500,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'No image',
                      style: TextStyle(
                        color: Colors.grey.shade500,
                        fontSize: 11,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 10),

            // Title
            Text(
              title,
              style: const TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w700,
                color: Color(0xFF2D1810),
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(height: 3),

            // Chapter & time
            Text(
              '$chapter • $timeLeft',
              style: const TextStyle(
                fontSize: 11,
                color: Color(0xFF9C8474),
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildExploreCard() {
    return GestureDetector(
      onTap: onTap,
      child: SizedBox(
        width: 130,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              height: 120,
              width: 130,
              decoration: BoxDecoration(
                color: const Color(0xFF8B4513).withValues(alpha: 0.08),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: const Color(0xFFD4C5B5),
                  width: 1.2,
                ),
              ),
              child: const Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.explore_rounded,
                      size: 32,
                      color: Color(0xFF8B4513),
                    ),
                    SizedBox(height: 6),
                    Text(
                      'Cari Kisah\nLainnya',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFF8B4513),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
