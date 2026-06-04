import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'login_screen.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => ProfileScreenState();
}

class ProfileScreenState extends State<ProfileScreen>
    with SingleTickerProviderStateMixin {
  String _userName = 'Penjelajah';
  int _avatarIndex = 0;
  int _totalBookmarks = 0;
  int _completedQuizzes = 0;
  final int _totalQuizzes = 6;
  List<_BadgeData> _badges = [];

  late AnimationController _animController;

  // Data avatar (sinkron dengan register_screen.dart)
  final List<Map<String, String>> _avatars = [
    {'name': 'Gatotkaca', 'initials': 'GK', 'color': '0xFF8B4513'},
    {'name': 'Sinta', 'initials': 'ST', 'color': '0xFFE8734A'},
    {'name': 'Rama', 'initials': 'RM', 'color': '0xFF2D1810'},
    {'name': 'Roro Jonggrang', 'initials': 'RJ', 'color': '0xFF9C8474'},
  ];

  // Judul kuis (sinkron dengan quiz_screen.dart)
  final List<String> _quizTitles = [
    'Seri Tanah Jawa',
    'Seri Sumatera',
    'Bali & Nusa Tenggara',
    'Kalimantan Mistis',
    'Legenda Sulawesi',
    'Ramayana & Asia Selatan',
  ];

  @override
  void initState() {
    super.initState();
    _animController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    );
    loadProfileData();
  }

  @override
  void dispose() {
    _animController.dispose();
    super.dispose();
  }

  Future<void> loadProfileData() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final email = prefs.getString('current_user_email') ?? '';

      final name = prefs.getString('user_name_$email') ?? 'Penjelajah';
      final avatar = prefs.getInt('user_avatar_$email') ?? 0;
      final bookmarks = prefs.getStringList('bookmarked_titles_$email') ?? [];

      // Hitung progres kuis
      int completed = 0;
      final Map<String, double> quizProgress = {};
      for (final title in _quizTitles) {
        final progress = prefs.getDouble('quiz_progress_${email}_$title') ?? 0.0;
        quizProgress[title] = progress;
        if (progress >= 1.0) completed++;
      }

      // Bangun daftar lencana budaya
      final badges = _buildBadges(
        bookmarkCount: bookmarks.length,
        quizProgress: quizProgress,
        completedQuizzes: completed,
      );

      setState(() {
        _userName = name;
        _avatarIndex = avatar.clamp(0, _avatars.length - 1);
        _totalBookmarks = bookmarks.length;
        _completedQuizzes = completed;
        _badges = badges;
      });

      _animController.forward();
    } catch (_) {}
  }

  List<_BadgeData> _buildBadges({
    required int bookmarkCount,
    required Map<String, double> quizProgress,
    required int completedQuizzes,
  }) {
    return [
      // --- Lencana Kuis Per Daerah ---
      _BadgeData(
        icon: Icons.temple_hindu_rounded,
        title: 'Penguasa Jawa',
        description: 'Selesaikan kuis Seri Tanah Jawa',
        isUnlocked: (quizProgress['Seri Tanah Jawa'] ?? 0) >= 1.0,
        color: const Color(0xFF8B4513),
      ),
      _BadgeData(
        icon: Icons.landscape_rounded,
        title: 'Penakluk Sumatera',
        description: 'Selesaikan kuis Seri Sumatera',
        isUnlocked: (quizProgress['Seri Sumatera'] ?? 0) >= 1.0,
        color: const Color(0xFF4CAF50),
      ),
      _BadgeData(
        icon: Icons.waves_rounded,
        title: 'Pengelana Nusa',
        description: 'Selesaikan kuis Bali & Nusa Tenggara',
        isUnlocked: (quizProgress['Bali & Nusa Tenggara'] ?? 0) >= 1.0,
        color: const Color(0xFFE8734A),
      ),
      _BadgeData(
        icon: Icons.forest_rounded,
        title: 'Penjaga Borneo',
        description: 'Selesaikan kuis Kalimantan Mistis',
        isUnlocked: (quizProgress['Kalimantan Mistis'] ?? 0) >= 1.0,
        color: const Color(0xFF9C8474),
      ),
      _BadgeData(
        icon: Icons.shield_rounded,
        title: 'Ksatria Luwu',
        description: 'Selesaikan kuis Legenda Sulawesi',
        isUnlocked: (quizProgress['Legenda Sulawesi'] ?? 0) >= 1.0,
        color: const Color(0xFF673AB7),
      ),
      _BadgeData(
        icon: Icons.star_rounded,
        title: 'Pencari Dharma',
        description: 'Selesaikan kuis Ramayana & Asia Selatan',
        isUnlocked: (quizProgress['Ramayana & Asia Selatan'] ?? 0) >= 1.0,
        color: const Color(0xFFFF9800),
      ),

      // --- Lencana Bookmark ---
      _BadgeData(
        icon: Icons.bookmark_added_rounded,
        title: 'Kolektor Pemula',
        description: 'Simpan 1 cerita ke koleksi',
        isUnlocked: bookmarkCount >= 1,
        color: const Color(0xFFD4A76A),
      ),
      _BadgeData(
        icon: Icons.collections_bookmark_rounded,
        title: 'Kurator Nusantara',
        description: 'Simpan 5 cerita ke koleksi',
        isUnlocked: bookmarkCount >= 5,
        color: const Color(0xFFC0763C),
      ),

      // --- Lencana Milestone ---
      _BadgeData(
        icon: Icons.military_tech_rounded,
        title: 'Cendekiawan',
        description: 'Selesaikan semua 6 seri kuis',
        isUnlocked: completedQuizzes >= 6,
        color: const Color(0xFFFFD700),
      ),
      _BadgeData(
        icon: Icons.auto_awesome_rounded,
        title: 'Maestro Budaya',
        description: 'Selesaikan semua kuis & simpan 5+ cerita',
        isUnlocked: completedQuizzes >= 6 && bookmarkCount >= 5,
        color: const Color(0xFFAB47BC),
      ),
    ];
  }

  Future<void> _handleLogout(BuildContext context) async {
    // Konfirmasi logout
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: const Color(0xFFF5F0EB),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Text(
          'Keluar dari Akun',
          style: TextStyle(
            fontFamily: 'Georgia',
            fontWeight: FontWeight.bold,
            color: Color(0xFF2D1810),
          ),
        ),
        content: const Text(
          'Apakah Anda yakin ingin keluar? Progres kuis dan koleksi cerita Anda akan tetap tersimpan.',
          style: TextStyle(color: Color(0xFF3D2E22), height: 1.5),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: const Text(
              'Batal',
              style: TextStyle(color: Color(0xFF9C8474)),
            ),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(ctx, true),
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFFEF5350),
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            child: const Text('Keluar'),
          ),
        ],
      ),
    );

    if (confirmed != true || !context.mounted) return;

    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool('is_logged_in', false);
      await prefs.setString('current_user_email', '');
      if (context.mounted) {
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (_) => const LoginScreen()),
          (_) => false,
        );
      }
    } catch (_) {}
  }

  @override
  Widget build(BuildContext context) {
    final avatar = _avatars[_avatarIndex];
    final avatarColor = Color(int.parse(avatar['color']!));
    final unlockedCount = _badges.where((b) => b.isUnlocked).length;

    return AnimatedBuilder(
      animation: _animController,
      builder: (context, child) {
        return ListView(
          padding: const EdgeInsets.fromLTRB(20, 8, 20, 100),
          children: [
            // === KARTU PROFIL ===
            _buildProfileHeader(avatar, avatarColor),

            const SizedBox(height: 20),

            // === STATISTIK RINGKAS ===
            _buildStatsRow(unlockedCount),

            const SizedBox(height: 28),

            // === LENCANA BUDAYA ===
            const Text(
              'LENCANA BUDAYA',
              style: TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.bold,
                letterSpacing: 1.5,
                color: Color(0xFF9C8474),
              ),
            ),
            const SizedBox(height: 4),
            Text(
              '$unlockedCount dari ${_badges.length} lencana terbuka',
              style: const TextStyle(
                fontSize: 13,
                color: Color(0xFF8C7B6B),
              ),
            ),
            const SizedBox(height: 16),

            // Grid Lencana
            _buildBadgeGrid(),

            const SizedBox(height: 28),

            // === TOMBOL LOGOUT ===
            _buildLogoutButton(),
          ],
        );
      },
    );
  }

  Widget _buildProfileHeader(Map<String, String> avatar, Color avatarColor) {
    final fadeIn = CurvedAnimation(
      parent: _animController,
      curve: const Interval(0.0, 0.5, curve: Curves.easeOut),
    );

    return FadeTransition(
      opacity: fadeIn,
      child: Container(
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              const Color(0xFF2D1810),
              const Color(0xFF3D2E22),
              avatarColor.withValues(alpha: 0.85),
            ],
          ),
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: const Color(0xFF2D1810).withValues(alpha: 0.3),
              blurRadius: 16,
              offset: const Offset(0, 6),
            ),
          ],
        ),
        child: Row(
          children: [
            // Avatar Circle
            Container(
              width: 68,
              height: 68,
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.15),
                shape: BoxShape.circle,
                border: Border.all(
                  color: Colors.white.withValues(alpha: 0.4),
                  width: 2.5,
                ),
              ),
              child: Center(
                child: Text(
                  avatar['initials']!,
                  style: const TextStyle(
                    fontFamily: 'Georgia',
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
            const SizedBox(width: 18),
            // Info
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    _userName,
                    style: const TextStyle(
                      fontFamily: 'Georgia',
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.15),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      avatar['name']!,
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.white.withValues(alpha: 0.9),
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatsRow(int unlockedBadges) {
    final slideIn = CurvedAnimation(
      parent: _animController,
      curve: const Interval(0.2, 0.7, curve: Curves.easeOut),
    );

    return SlideTransition(
      position: Tween<Offset>(
        begin: const Offset(0, 0.3),
        end: Offset.zero,
      ).animate(slideIn),
      child: FadeTransition(
        opacity: slideIn,
        child: Row(
          children: [
            _buildStatCard(
              icon: Icons.bookmark_rounded,
              value: '$_totalBookmarks',
              label: 'Tersimpan',
              color: const Color(0xFFD4A76A),
            ),
            const SizedBox(width: 10),
            _buildStatCard(
              icon: Icons.quiz_rounded,
              value: '$_completedQuizzes/$_totalQuizzes',
              label: 'Kuis Selesai',
              color: const Color(0xFF4CAF50),
            ),
            const SizedBox(width: 10),
            _buildStatCard(
              icon: Icons.emoji_events_rounded,
              value: '$unlockedBadges',
              label: 'Lencana',
              color: const Color(0xFFE8734A),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatCard({
    required IconData icon,
    required String value,
    required String label,
    required Color color,
  }) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 10),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(14),
          boxShadow: [
            BoxShadow(
              color: const Color(0xFF8B4513).withValues(alpha: 0.06),
              blurRadius: 10,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Column(
          children: [
            Icon(icon, color: color, size: 24),
            const SizedBox(height: 8),
            Text(
              value,
              style: const TextStyle(
                fontFamily: 'Georgia',
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Color(0xFF2D1810),
              ),
            ),
            const SizedBox(height: 4),
            Text(
              label,
              style: const TextStyle(
                fontSize: 11,
                color: Color(0xFF8C7B6B),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBadgeGrid() {
    final gridFade = CurvedAnimation(
      parent: _animController,
      curve: const Interval(0.4, 1.0, curve: Curves.easeOut),
    );

    return FadeTransition(
      opacity: gridFade,
      child: GridView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          mainAxisSpacing: 12,
          crossAxisSpacing: 12,
          childAspectRatio: 1.1,
        ),
        itemCount: _badges.length,
        itemBuilder: (context, index) {
          return _buildBadgeTile(_badges[index], index);
        },
      ),
    );
  }

  Widget _buildBadgeTile(_BadgeData badge, int index) {
    return GestureDetector(
      onTap: () => _showBadgeDetail(badge),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: badge.isUnlocked
              ? Colors.white
              : const Color(0xFFE8E0D8).withValues(alpha: 0.5),
          borderRadius: BorderRadius.circular(16),
          border: badge.isUnlocked
              ? Border.all(
                  color: badge.color.withValues(alpha: 0.3),
                  width: 1.5,
                )
              : null,
          boxShadow: badge.isUnlocked
              ? [
                  BoxShadow(
                    color: badge.color.withValues(alpha: 0.12),
                    blurRadius: 12,
                    offset: const Offset(0, 4),
                  ),
                ]
              : [],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Ikon lencana
            Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                color: badge.isUnlocked
                    ? badge.color.withValues(alpha: 0.12)
                    : const Color(0xFFD4C5B5).withValues(alpha: 0.3),
                shape: BoxShape.circle,
              ),
              child: Icon(
                badge.isUnlocked ? badge.icon : Icons.lock_rounded,
                color: badge.isUnlocked
                    ? badge.color
                    : const Color(0xFFBFA48E),
                size: 24,
              ),
            ),
            const SizedBox(height: 10),
            // Judul lencana
            Text(
              badge.isUnlocked ? badge.title : '???',
              style: TextStyle(
                fontFamily: 'Georgia',
                fontSize: 13,
                fontWeight: FontWeight.bold,
                color: badge.isUnlocked
                    ? const Color(0xFF2D1810)
                    : const Color(0xFFBFA48E),
              ),
              textAlign: TextAlign.center,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(height: 4),
            // Deskripsi singkat
            Text(
              badge.isUnlocked ? badge.description : 'Terkunci',
              style: TextStyle(
                fontSize: 10,
                color: badge.isUnlocked
                    ? const Color(0xFF8C7B6B)
                    : const Color(0xFFBFA48E),
              ),
              textAlign: TextAlign.center,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }

  void _showBadgeDetail(_BadgeData badge) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (ctx) {
        return Container(
          padding: const EdgeInsets.all(28),
          decoration: const BoxDecoration(
            color: Color(0xFFF5F0EB),
            borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Handle bar
              Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: const Color(0xFFD4C5B5),
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              const SizedBox(height: 24),
              // Ikon
              Container(
                width: 72,
                height: 72,
                decoration: BoxDecoration(
                  color: badge.isUnlocked
                      ? badge.color.withValues(alpha: 0.12)
                      : const Color(0xFFD4C5B5).withValues(alpha: 0.3),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  badge.isUnlocked ? badge.icon : Icons.lock_rounded,
                  color: badge.isUnlocked
                      ? badge.color
                      : const Color(0xFFBFA48E),
                  size: 36,
                ),
              ),
              const SizedBox(height: 18),
              // Nama lencana
              Text(
                badge.isUnlocked ? badge.title : 'Lencana Terkunci',
                style: const TextStyle(
                  fontFamily: 'Georgia',
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF2D1810),
                ),
              ),
              const SizedBox(height: 8),
              // Deskripsi
              Text(
                badge.description,
                style: const TextStyle(
                  fontSize: 14,
                  color: Color(0xFF8C7B6B),
                  height: 1.5,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 16),
              // Status
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 8,
                ),
                decoration: BoxDecoration(
                  color: badge.isUnlocked
                      ? const Color(0xFF4CAF50).withValues(alpha: 0.1)
                      : const Color(0xFFE8E0D8),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      badge.isUnlocked
                          ? Icons.check_circle_rounded
                          : Icons.lock_outline_rounded,
                      size: 16,
                      color: badge.isUnlocked
                          ? const Color(0xFF4CAF50)
                          : const Color(0xFF9C8474),
                    ),
                    const SizedBox(width: 6),
                    Text(
                      badge.isUnlocked ? 'Terbuka' : 'Belum Terbuka',
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                        color: badge.isUnlocked
                            ? const Color(0xFF4CAF50)
                            : const Color(0xFF9C8474),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 12),
            ],
          ),
        );
      },
    );
  }

  Widget _buildLogoutButton() {
    return SizedBox(
      width: double.infinity,
      height: 50,
      child: OutlinedButton.icon(
        onPressed: () => _handleLogout(context),
        icon: const Icon(Icons.logout_rounded, size: 20),
        label: const Text(
          'Keluar dari Akun',
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
          ),
        ),
        style: OutlinedButton.styleFrom(
          foregroundColor: const Color(0xFFEF5350),
          side: const BorderSide(color: Color(0xFFEF5350), width: 1.2),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14),
          ),
        ),
      ),
    );
  }
}

// Model data internal untuk lencana budaya
class _BadgeData {
  final IconData icon;
  final String title;
  final String description;
  final bool isUnlocked;
  final Color color;

  const _BadgeData({
    required this.icon,
    required this.title,
    required this.description,
    required this.isUnlocked,
    required this.color,
  });
}
