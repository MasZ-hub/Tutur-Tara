import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../widgets/section_header.dart';
import '../widgets/recommendation_card.dart';
import '../widgets/continue_reading_card.dart';
import '../widgets/popular_story_tile.dart';
import 'stories_screen.dart';
import 'quiz_screen.dart';
import 'saved_screen.dart';
import 'story_detail_screen.dart';
import 'profile_screen.dart';
import '../data/story_data.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _currentIndex = 0;
  final Set<String> _bookmarkedTitles = {};
  final GlobalKey<ProfileScreenState> _profileKey = GlobalKey<ProfileScreenState>();
  List<Map<String, dynamic>> _recentlyReadStories = [];

  @override
  void initState() {
    super.initState();
    _loadBookmarks();
    _loadRecentlyRead();
  }

  Future<void> _loadRecentlyRead() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final email = prefs.getString('current_user_email') ?? '';
      final recentlyReadTitles = prefs.getStringList('recently_read_$email') ?? [];

      final List<Map<String, dynamic>> loaded = [];
      for (final title in recentlyReadTitles) {
        final story = StoryData.stories.firstWhere(
          (s) => s['title'] == title,
          orElse: () => {},
        );
        if (story.isNotEmpty) {
          final progress = prefs.getDouble('reading_progress_${email}_$title') ?? 0.0;
          loaded.add({
            'story': story,
            'progress': progress,
          });
        }
      }

      setState(() {
        _recentlyReadStories = loaded;
      });
    } catch (_) {}
  }

  List<Widget> _buildContinueReadingCards() {
    final List<Widget> cards = [];
    
    // Hanya tampilkan cerita yang benar-benar terakhir/pernah dibaca
    for (final item in _recentlyReadStories) {
      final story = item['story'] as Map<String, String>;
      final progress = item['progress'] as double;

      final durationStr = story['duration'] ?? '10 min';
      final totalMin = int.tryParse(durationStr.replaceAll(RegExp(r'[^0-9]'), '')) ?? 10;

      String label;
      String progressText;
      if (progress >= 0.99) {
        label = 'Selesai';
        progressText = 'Telah dibaca';
      } else if (progress <= 0.0) {
        label = 'Belum dibaca';
        progressText = '$durationStr tersisa';
      } else {
        label = 'Bab Terakhir';
        final minutesLeft = ((1.0 - progress) * totalMin).ceil();
        progressText = '$minutesLeft m tersisa';
      }

      cards.add(
        ContinueReadingCard(
          title: story['title']!,
          chapter: label,
          timeLeft: progressText,
          onTap: () => _navigateToDetail(story['title']!, story['region']!),
        ),
      );
      cards.add(const SizedBox(width: 12));
    }

    // Selalu tambahkan explore card di akhir
    cards.add(
      ContinueReadingCard(
        title: 'Cari Kisah Lainnya',
        chapter: '',
        timeLeft: '',
        isExploreCard: true,
        onTap: _navigateToStories,
      ),
    );
    cards.add(const SizedBox(width: 12));

    return cards;
  }

  Future<void> _loadBookmarks() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final email = prefs.getString('current_user_email') ?? '';
      final list = prefs.getStringList('bookmarked_titles_$email');
      if (list != null) {
        setState(() {
          _bookmarkedTitles.clear();
          _bookmarkedTitles.addAll(list);
        });
      } else {
        // Bookmarks benar-benar kosong saat awal penggunaan akun baru
        setState(() {
          _bookmarkedTitles.clear();
        });
        if (email.isNotEmpty) {
          await prefs.setStringList('bookmarked_titles_$email', []);
        }
      }
    } catch (_) {}
  }

  Future<void> _toggleBookmark(String title) async {
    setState(() {
      if (_bookmarkedTitles.contains(title)) {
        _bookmarkedTitles.remove(title);
      } else {
        _bookmarkedTitles.add(title);
      }
    });
    try {
      final prefs = await SharedPreferences.getInstance();
      final email = prefs.getString('current_user_email') ?? '';
      if (email.isNotEmpty) {
        await prefs.setStringList('bookmarked_titles_$email', _bookmarkedTitles.toList());
      }
    } catch (_) {}
  }



  void _navigateToStories() {
    setState(() => _currentIndex = 1);
  }

  void _navigateToDetail(String title, String region) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => StoryDetailScreen(
          title: title,
          region: region,
          isInitiallyBookmarked: _bookmarkedTitles.contains(title),
        ),
      ),
    ).then((result) {
      if (result != null && result is bool) {
        final isCurrentlyBookmarked = _bookmarkedTitles.contains(title);
        if (result != isCurrentlyBookmarked) {
          _toggleBookmark(title);
        }
      }
      _loadRecentlyRead();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: _currentIndex,
        children: [
          _buildHomeContent(),
          Scaffold(
            appBar: const PreferredSize(
              preferredSize: Size.fromHeight(kToolbarHeight),
              child: _CustomAppBar(title: 'Arsip Cerita'),
            ),
            body: StoriesScreen(
              bookmarkedTitles: _bookmarkedTitles,
              onBookmarkToggle: _toggleBookmark,
            ),
          ),
          const Scaffold(
            appBar: PreferredSize(
              preferredSize: Size.fromHeight(kToolbarHeight),
              child: _CustomAppBar(title: 'Kuis Nusantara'),
            ),
            body: QuizScreen(),
          ),
          Scaffold(
            appBar: const PreferredSize(
              preferredSize: Size.fromHeight(kToolbarHeight),
              child: _CustomAppBar(title: 'Koleksi Tersimpan'),
            ),
            body: SavedScreen(
              bookmarkedTitles: _bookmarkedTitles,
              onBookmarkToggle: _toggleBookmark,
            ),
          ),
          Scaffold(
            appBar: const PreferredSize(
              preferredSize: Size.fromHeight(kToolbarHeight),
              child: _CustomAppBar(title: 'Profil Saya'),
            ),
            body: ProfileScreen(key: _profileKey),
          ),
        ],
      ),

      // Bottom Navigation Bar
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: const Color(0xFF2D1810),
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(24),
            topRight: Radius.circular(24),
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.15),
              blurRadius: 12,
              offset: const Offset(0, -3),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(24),
            topRight: Radius.circular(24),
          ),
          child: Padding(
            padding: const EdgeInsets.only(top: 8, bottom: 12),
            child: BottomNavigationBar(
              currentIndex: _currentIndex,
              onTap: (index) {
                setState(() => _currentIndex = index);
                if (index == 4) {
                  _profileKey.currentState?.loadProfileData();
                }
              },
              backgroundColor: Colors.transparent,
              elevation: 0,
              type: BottomNavigationBarType.fixed,
              selectedItemColor: const Color(0xFFE8734A),
              unselectedItemColor: const Color(0xFFBFA48E),
              selectedFontSize: 11,
              unselectedFontSize: 11,
              selectedLabelStyle: const TextStyle(fontWeight: FontWeight.w600),
              items: const [
                BottomNavigationBarItem(
                  icon: Padding(
                    padding: EdgeInsets.only(bottom: 4),
                    child: Icon(Icons.home_rounded, size: 26),
                  ),
                  label: 'Home',
                ),
                BottomNavigationBarItem(
                  icon: Padding(
                    padding: EdgeInsets.only(bottom: 4),
                    child: Icon(Icons.auto_stories_rounded, size: 26),
                  ),
                  label: 'Stories',
                ),
                BottomNavigationBarItem(
                  icon: Padding(
                    padding: EdgeInsets.only(bottom: 4),
                    child: Icon(Icons.quiz_rounded, size: 26),
                  ),
                  label: 'Quiz',
                ),
                BottomNavigationBarItem(
                  icon: Padding(
                    padding: EdgeInsets.only(bottom: 4),
                    child: Icon(Icons.bookmark_rounded, size: 26),
                  ),
                  label: 'Saved',
                ),
                BottomNavigationBarItem(
                  icon: Padding(
                    padding: EdgeInsets.only(bottom: 4),
                    child: Icon(Icons.person_rounded, size: 26),
                  ),
                  label: 'Profil',
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHomeContent() {
    return SafeArea(
      child: CustomScrollView(
        slivers: [
          // App Bar
          SliverAppBar(
            floating: true,
            snap: true,
            backgroundColor: const Color(0xFFF5F0EB),
            elevation: 0,
            centerTitle: true,
            title: const Text(
              'Tutur-Tara',
              style: TextStyle(
                fontFamily: 'Georgia',
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Color(0xFF2D1810),
              ),
            ),

          ),

          // Content
          SliverPadding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            sliver: SliverList(
              delegate: SliverChildListDelegate([
                const SizedBox(height: 8),

                // --- Rekomendasi Hari Ini ---
                const SectionHeader(title: 'REKOMENDASI HARI INI'),
                const SizedBox(height: 12),
                RecommendationCard(
                  regionTag: 'Jawa Barat',
                  title: 'Legenda Sangkuriang',
                  description:
                      'Kisah epik tentang cinta yang terlarang, kemarahan, dan penciptaan Gunung...',
                  onTap: () => _navigateToDetail('Sangkuriang', 'Jawa Barat'),
                ),

                const SizedBox(height: 28),

                // --- Lanjutkan Membaca ---
                const SectionHeader(title: 'LANJUTKAN MEMBACA'),
                const SizedBox(height: 12),
              ]),
            ),
          ),

          // Horizontal scroll - Lanjutkan Membaca
          SliverToBoxAdapter(
            child: SizedBox(
              height: 195,
              child: ListView(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: 20),
                children: _buildContinueReadingCards(),
              ),
            ),
          ),

          // --- Kisah Terpopuler ---
          SliverPadding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            sliver: SliverList(
              delegate: SliverChildListDelegate([
                const SizedBox(height: 28),
                const SectionHeader(title: 'KISAH TERPOPULER'),
                const SizedBox(height: 12),
                PopularStoryTile(
                  title: 'Barong & Rangda',
                  description: 'Pertarungan abadi antara...',
                  regionTag: 'Bali',
                  onTap: () => _navigateToDetail('Barong & Rangda', 'Bali'),
                ),
                const SizedBox(height: 10),
                PopularStoryTile(
                  title: 'Roro Jonggrang',
                  description: 'Kutukan seribu candi dan...',
                  regionTag: 'Jawa Tengah',
                  onTap: () => _navigateToDetail('Roro Jonggrang', 'Jawa Tengah'),
                ),
                const SizedBox(height: 10),
                PopularStoryTile(
                  title: 'Timun Mas',
                  description: 'Pelarian dari raksasa serakah...',
                  regionTag: 'Jawa Tengah',
                  onTap: () => _navigateToDetail('Timun Mas', 'Jawa Tengah'),
                ),
                const SizedBox(height: 100),
              ]),
            ),
          ),
        ],
      ),
    );
  }
}

// Widget AppBar kustom untuk menyelaraskan dengan estetika Tutur-Tara
class _CustomAppBar extends StatelessWidget {
  final String title;

  const _CustomAppBar({required this.title});

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: Text(
        title,
        style: const TextStyle(
          fontFamily: 'Georgia',
          fontSize: 22,
          fontWeight: FontWeight.bold,
          color: Color(0xFF2D1810),
        ),
      ),
      backgroundColor: const Color(0xFFF5F0EB),
      elevation: 0,
      centerTitle: true,
    );
  }
}
