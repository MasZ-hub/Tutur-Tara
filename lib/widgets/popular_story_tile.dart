import 'package:flutter/material.dart';

class PopularStoryTile extends StatelessWidget {
  final String title;
  final String description;
  final String regionTag;
  final VoidCallback? onTap;

  const PopularStoryTile({
    super.key,
    required this.title,
    required this.description,
    required this.regionTag,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.white,
      borderRadius: BorderRadius.circular(14),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(14),
        child: Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: Colors.transparent,
            borderRadius: BorderRadius.circular(14),
            boxShadow: [
              BoxShadow(
                color: const Color(0xFF8B4513).withValues(alpha: 0.06),
                blurRadius: 10,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Row(
            children: [
              // Thumbnail
              Container(
                height: 52,
                width: 52,
                decoration: BoxDecoration(
                  color: const Color(0xFFE8E0D8),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Center(
                  child: Icon(
                    Icons.image_outlined,
                    size: 22,
                    color: Colors.grey.shade500,
                  ),
                ),
              ),
              const SizedBox(width: 14),

              // Text content
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w700,
                        color: Color(0xFF2D1810),
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 3),
                    Text(
                      description,
                      style: const TextStyle(
                        fontSize: 12,
                        color: Color(0xFF9C8474),
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 10),

              // Play button
              Container(
                height: 36,
                width: 36,
                decoration: BoxDecoration(
                  color: const Color(0xFFF5F0EB),
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: const Color(0xFFD4C5B5),
                    width: 0.8,
                  ),
                ),
                child: const Icon(
                  Icons.play_arrow_rounded,
                  size: 20,
                  color: Color(0xFF5C4033),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
