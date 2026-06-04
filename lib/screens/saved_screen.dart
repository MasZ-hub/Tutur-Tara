import 'package:flutter/material.dart';
import 'story_detail_screen.dart';
import '../data/story_data.dart';

class SavedScreen extends StatefulWidget {
  final Set<String> bookmarkedTitles;
  final ValueChanged<String> onBookmarkToggle;

  const SavedScreen({
    super.key,
    required this.bookmarkedTitles,
    required this.onBookmarkToggle,
  });

  @override
  State<SavedScreen> createState() => _SavedScreenState();
}

class _SavedScreenState extends State<SavedScreen> {
  int _selectedRegion = 0;
  int _selectedCategory = 0;

  final List<String> _regions = StoryData.regions;
  final List<String> _categories = StoryData.categories;
  final List<Map<String, String>> _allStories = StoryData.stories;

  List<Map<String, String>> get _filteredSavedItems {
    // 1. Ambil cerita yang di-bookmark saja
    final bookmarked = _allStories.where((story) {
      return widget.bookmarkedTitles.contains(story['title']);
    }).toList();

    // 2. Filter berdasarkan daerah
    return bookmarked.where((story) {
      final selectedRegionName = _regions[_selectedRegion];
      final matchesRegion = _selectedRegion == 0 ||
          story['region']!.toLowerCase().contains(selectedRegionName.toLowerCase());

      // 3. Filter berdasarkan kategori/tipe cerita
      final selectedCategoryName = _categories[_selectedCategory];
      final matchesCategory = _selectedCategory == 0 ||
          story['category']!.toLowerCase() == selectedCategoryName.toLowerCase();

      return matchesRegion && matchesCategory;
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    final savedItems = _filteredSavedItems;

    return Column(
      children: [
        // Region filter chips (Horizontal)
        Padding(
          padding: const EdgeInsets.only(top: 8.0),
          child: SizedBox(
            height: 38,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 20),
              itemCount: _regions.length,
              itemBuilder: (context, index) {
                final isSelected = _selectedRegion == index;
                return Padding(
                  padding: const EdgeInsets.only(right: 8),
                  child: GestureDetector(
                    onTap: () => setState(() => _selectedRegion = index),
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 200),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 14,
                        vertical: 8,
                      ),
                      decoration: BoxDecoration(
                        color: isSelected
                            ? const Color(0xFF2D1810)
                            : Colors.white,
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(
                          color: isSelected
                              ? const Color(0xFF2D1810)
                              : const Color(0xFFD4C5B5),
                          width: 1,
                        ),
                      ),
                      child: Text(
                        _regions[index],
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight:
                              isSelected ? FontWeight.w600 : FontWeight.w400,
                          color: isSelected
                              ? Colors.white
                              : const Color(0xFF5C4033),
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ),

        const SizedBox(height: 10),

        // Category filter chips (Horizontal)
        SizedBox(
          height: 38,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 20),
            itemCount: _categories.length,
            itemBuilder: (context, index) {
              final isSelected = _selectedCategory == index;
              return Padding(
                padding: const EdgeInsets.only(right: 8),
                child: GestureDetector(
                  onTap: () => setState(() => _selectedCategory = index),
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 14,
                      vertical: 8,
                    ),
                    decoration: BoxDecoration(
                      color: isSelected
                          ? const Color(0xFFE8734A)
                          : Colors.white,
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(
                        color: isSelected
                            ? const Color(0xFFE8734A)
                            : const Color(0xFFD4C5B5),
                        width: 1,
                      ),
                    ),
                    child: Text(
                      _categories[index],
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight:
                            isSelected ? FontWeight.w600 : FontWeight.w400,
                        color: isSelected
                            ? Colors.white
                            : const Color(0xFF5C4033),
                      ),
                    ),
                  ),
                ),
              );
            },
          ),
        ),

        const SizedBox(height: 16),

        // Saved items list
        Expanded(
          child: savedItems.isEmpty
              ? _buildEmptyState()
              : ListView.builder(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  itemCount: savedItems.length,
                  itemBuilder: (context, index) {
                    final item = savedItems[index];
                    return _buildSavedTile(item);
                  },
                ),
        ),
      ],
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(
            Icons.bookmark_border_rounded,
            size: 56,
            color: Color(0xFFD4C5B5),
          ),
          const SizedBox(height: 16),
          const Text(
            'Belum ada yang disimpan',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: Color(0xFF9C8474),
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            'Simpan cerita favoritmu dari menu Arsip Cerita',
            style: TextStyle(fontSize: 13, color: Color(0xFFBFA48E)),
          ),
        ],
      ),
    );
  }

  Widget _buildSavedTile(Map<String, String> story) {
    final title = story['title']!;

    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => StoryDetailScreen(
              title: title,
              region: story['region']!,
              isInitiallyBookmarked: true,
            ),
          ),
        ).then((result) {
          if (result != null && result is bool) {
            final currentlyBookmarked = widget.bookmarkedTitles.contains(title);
            if (result != currentlyBookmarked) {
              widget.onBookmarkToggle(title);
            }
          }
        });
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(14),
          boxShadow: [
            BoxShadow(
              color: const Color(0xFF8B4513).withValues(alpha: 0.05),
              blurRadius: 10,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          children: [
            // Thumbnail
            Container(
              height: 68,
              width: 68,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                gradient: const LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    Color(0xFF8B4513),
                    Color(0xFF2D1810),
                  ],
                ),
              ),
              child: const Center(
                child: Icon(
                  Icons.menu_book_rounded,
                  size: 24,
                  color: Color(0xFFF5F0EB),
                ),
              ),
            ),
            const SizedBox(width: 14),

            // Content
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Tags
                  Row(
                    children: [
                      // Category/Type tag
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 3,
                        ),
                        decoration: BoxDecoration(
                          color: const Color(0xFFE8734A),
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: Text(
                          story['category']!,
                          style: const TextStyle(
                            fontSize: 10,
                            fontWeight: FontWeight.w600,
                            color: Colors.white,
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      // Region tag
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 3,
                        ),
                        decoration: BoxDecoration(
                          color: const Color(0xFFF5F0EB),
                          borderRadius: BorderRadius.circular(4),
                          border: Border.all(
                            color: const Color(0xFFD4C5B5),
                            width: 0.5,
                          ),
                        ),
                        child: Text(
                          story['region']!,
                          style: const TextStyle(
                            fontSize: 10,
                            fontWeight: FontWeight.w500,
                            color: Color(0xFF5C4033),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 6),

                  // Title
                  Text(
                    title,
                    style: const TextStyle(
                      fontFamily: 'Georgia',
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF2D1810),
                    ),
                  ),
                  const SizedBox(height: 4),

                  // Description
                  Text(
                    story['description']!,
                    style: const TextStyle(
                      fontSize: 12,
                      color: Color(0xFF8C7B6B),
                      height: 1.4,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
            const SizedBox(width: 8),

            // Bookmark icon (filled, tapping it removes from bookmark list)
            GestureDetector(
              onTap: () {
                widget.onBookmarkToggle(title);
                ScaffoldMessenger.of(context).clearSnackBars();
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Cerita dihapus dari koleksi.', style: TextStyle(fontFamily: 'Georgia')),
                    backgroundColor: Color(0xFF2D1810),
                  ),
                );
              },
              child: const Icon(
                Icons.bookmark_rounded,
                size: 24,
                color: Color(0xFFE8734A),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
