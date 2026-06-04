import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class StoryDetailScreen extends StatefulWidget {
  final String title;
  final String region;
  final bool isInitiallyBookmarked;

  const StoryDetailScreen({
    super.key,
    required this.title,
    required this.region,
    this.isInitiallyBookmarked = false,
  });

  @override
  State<StoryDetailScreen> createState() => _StoryDetailScreenState();
}

class _StoryDetailScreenState extends State<StoryDetailScreen> {
  late bool _isBookmarked;
  late ScrollController _scrollController;
  double _readingProgress = 0.0;
  double _fontSize = 16.0;

  @override
  void initState() {
    super.initState();
    _isBookmarked = widget.isInitiallyBookmarked;
    _scrollController = ScrollController();
    _scrollController.addListener(_updateProgress);
    _loadReadingProgress();
  }

  void _updateProgress() {
    if (!_scrollController.hasClients) return;
    final maxScroll = _scrollController.position.maxScrollExtent;
    final currentScroll = _scrollController.position.pixels;
    if (maxScroll > 0) {
      final progress = (currentScroll / maxScroll).clamp(0.0, 1.0);
      setState(() {
        _readingProgress = progress;
      });
      _saveReadingProgress(progress);
    }
  }

  Future<void> _loadReadingProgress() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final email = prefs.getString('current_user_email') ?? '';
      if (email.isEmpty) return;

      final savedProgress = prefs.getDouble('reading_progress_${email}_${widget.title}') ?? 0.0;
      setState(() {
        _readingProgress = savedProgress;
      });

      // Jump to last scroll position after layout completes
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (_scrollController.hasClients) {
          final maxScroll = _scrollController.position.maxScrollExtent;
          if (maxScroll > 0) {
            _scrollController.jumpTo(savedProgress * maxScroll);
          }
        }
      });
    } catch (_) {}
  }

  Future<void> _saveReadingProgress(double progress) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final email = prefs.getString('current_user_email') ?? '';
      if (email.isEmpty) return;

      await prefs.setDouble('reading_progress_${email}_${widget.title}', progress);

      // Update list recently read
      final List<String> recentlyRead = prefs.getStringList('recently_read_$email') ?? [];
      recentlyRead.remove(widget.title);
      recentlyRead.insert(0, widget.title);
      if (recentlyRead.length > 5) {
        recentlyRead.removeLast();
      }
      await prefs.setStringList('recently_read_$email', recentlyRead);
    } catch (_) {}
  }

  @override
  void dispose() {
    _scrollController.removeListener(_updateProgress);
    _scrollController.dispose();
    super.dispose();
  }

  void _showFontSizeDialog() {
    showModalBottomSheet(
      context: context,
      backgroundColor: const Color(0xFFF5F0EB),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setModalState) {
            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Ukuran Teks',
                        style: TextStyle(
                          fontFamily: 'Georgia',
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF2D1810),
                        ),
                      ),
                      IconButton(
                        icon: const Icon(Icons.close_rounded, color: Color(0xFF2D1810)),
                        onPressed: () => Navigator.pop(context),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      const Text(
                        'A',
                        style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF5C4033),
                        ),
                      ),
                      Expanded(
                        child: Slider(
                          value: _fontSize,
                          min: 13.0,
                          max: 24.0,
                          divisions: 11,
                          activeColor: const Color(0xFFE8734A),
                          inactiveColor: const Color(0xFFD4C5B5),
                          onChanged: (value) {
                            setModalState(() {
                              _fontSize = value;
                            });
                            setState(() {
                              _fontSize = value;
                            });
                          },
                        ),
                      ),
                      const Text(
                        'A',
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF5C4033),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Center(
                    child: Text(
                      'Pratinjau Teks (${_fontSize.toInt()} px)',
                      style: TextStyle(
                        fontSize: _fontSize,
                        color: const Color(0xFF3D2E22),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                ],
              ),
            );
          },
        );
      },
    );
  }

  void _shareStory() {
    showModalBottomSheet(
      context: context,
      backgroundColor: const Color(0xFFF5F0EB),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Bagikan Cerita',
                style: TextStyle(
                  fontFamily: 'Georgia',
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF2D1810),
                ),
              ),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  _buildShareOption(
                    icon: Icons.link_rounded,
                    label: 'Salin Tautan',
                    onTap: () {
                      Navigator.pop(context);
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Tautan cerita berhasil disalin!', style: TextStyle(fontFamily: 'Georgia')),
                          backgroundColor: Color(0xFF2D1810),
                        ),
                      );
                    },
                  ),
                  _buildShareOption(
                    icon: Icons.chat_bubble_outline_rounded,
                    label: 'WhatsApp',
                    onTap: () {
                      Navigator.pop(context);
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Membuka WhatsApp...', style: TextStyle(fontFamily: 'Georgia')),
                          backgroundColor: Color(0xFF2D1810),
                        ),
                      );
                    },
                  ),
                  _buildShareOption(
                    icon: Icons.camera_alt_outlined,
                    label: 'Instagram',
                    onTap: () {
                      Navigator.pop(context);
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Membuka Instagram Stories...', style: TextStyle(fontFamily: 'Georgia')),
                          backgroundColor: Color(0xFF2D1810),
                        ),
                      );
                    },
                  ),
                ],
              ),
              const SizedBox(height: 12),
            ],
          ),
        );
      },
    );
  }

  Widget _buildShareOption({
    required IconData icon,
    required String label,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              height: 50,
              width: 50,
              decoration: const BoxDecoration(
                color: Color(0xFFE8E0D8),
                shape: BoxShape.circle,
              ),
              child: Icon(
                icon,
                color: const Color(0xFF2D1810),
                size: 24,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              label,
              style: const TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w500,
                color: Color(0xFF5C4033),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    // Wrap with PopScope to pass the bookmark state back when popping (e.g. system back button)
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) {
        if (didPop) return;
        Navigator.pop(context, _isBookmarked);
      },
      child: Scaffold(
        backgroundColor: const Color(0xFFF5F0EB),
        body: SafeArea(
          child: Stack(
            children: [
              CustomScrollView(
                controller: _scrollController,
                slivers: [
                  // App bar with back button and actions
                  SliverAppBar(
                    floating: true,
                    snap: true,
                    backgroundColor: const Color(0xFFF5F0EB),
                    elevation: 0,
                    centerTitle: true,
                    leading: GestureDetector(
                      onTap: () => Navigator.pop(context, _isBookmarked),
                      child: const Padding(
                        padding: EdgeInsets.all(12),
                        child: Icon(
                          Icons.arrow_back_rounded,
                          color: Color(0xFF2D1810),
                        ),
                      ),
                    ),
                    title: const Text(
                      'Tutur-Tara',
                      style: TextStyle(
                        fontFamily: 'Georgia',
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF2D1810),
                      ),
                    ),
                    actions: [
                      IconButton(
                        icon: const Icon(Icons.format_size_rounded, color: Color(0xFF2D1810)),
                        onPressed: _showFontSizeDialog,
                        tooltip: 'Ukuran Font',
                      ),
                      IconButton(
                        icon: const Icon(Icons.share_rounded, color: Color(0xFF2D1810)),
                        onPressed: _shareStory,
                        tooltip: 'Bagikan Cerita',
                      ),
                      IconButton(
                        icon: Icon(
                          _isBookmarked ? Icons.bookmark_rounded : Icons.bookmark_border_rounded,
                          color: _isBookmarked ? const Color(0xFFE8734A) : const Color(0xFF2D1810),
                        ),
                        onPressed: () {
                          setState(() {
                            _isBookmarked = !_isBookmarked;
                          });
                          ScaffoldMessenger.of(context).clearSnackBars();
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(
                                _isBookmarked
                                    ? 'Cerita berhasil disimpan ke koleksi!'
                                    : 'Cerita dihapus dari koleksi.',
                                style: const TextStyle(fontFamily: 'Georgia'),
                              ),
                              backgroundColor: const Color(0xFF2D1810),
                              duration: const Duration(seconds: 2),
                            ),
                          );
                        },
                        tooltip: 'Simpan Cerita',
                      ),
                      const SizedBox(width: 8),
                    ],
                  ),

                  SliverToBoxAdapter(
                    child: Column(
                      children: [
                        // Stylized Cover Image
                        _buildHeroImage(),

                        const SizedBox(height: 24),

                        // Title
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 28),
                          child: Text(
                            _getFullTitle(),
                            textAlign: TextAlign.center,
                            style: const TextStyle(
                              fontFamily: 'Georgia',
                              fontSize: 26,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF2D1810),
                              height: 1.3,
                            ),
                          ),
                        ),

                        const SizedBox(height: 16),

                        // Ornamental divider
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Container(
                              width: 40,
                              height: 1.5,
                              decoration: const BoxDecoration(
                                gradient: LinearGradient(
                                  colors: [Colors.transparent, Color(0xFF8B4513)],
                                ),
                              ),
                            ),
                            const SizedBox(width: 8),
                            const Text(
                              '◆',
                              style: TextStyle(
                                  fontSize: 8, color: Color(0xFF8B4513)),
                            ),
                            const SizedBox(width: 8),
                            Container(
                              width: 40,
                              height: 1.5,
                              decoration: const BoxDecoration(
                                gradient: LinearGradient(
                                  colors: [Color(0xFF8B4513), Colors.transparent],
                                ),
                              ),
                            ),
                          ],
                        ),

                        const SizedBox(height: 28),

                        // Article body with drop cap
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 24),
                          child: _buildArticleBody(),
                        ),

                        const SizedBox(height: 100),
                      ],
                    ),
                  ),
                ],
              ),

              // Reading progress bar at the very top
              Positioned(
                top: 0,
                left: 0,
                right: 0,
                child: Container(
                  height: 3,
                  color: const Color(0xFFE8E0D8).withValues(alpha: 0.5),
                  alignment: Alignment.centerLeft,
                  child: FractionallySizedBox(
                    widthFactor: _readingProgress,
                    child: Container(
                      color: const Color(0xFFE8734A),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeroImage() {
    return Container(
      height: 240,
      width: double.infinity,
      margin: const EdgeInsets.symmetric(horizontal: 20),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Color(0xFF8B4513),
            Color(0xFF2D1810),
          ],
        ),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF2D1810).withValues(alpha: 0.2),
            blurRadius: 15,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Stack(
        children: [
          // Background watermark icon
          Positioned(
            right: -20,
            bottom: -20,
            child: Opacity(
              opacity: 0.08,
              child: const Icon(
                Icons.auto_stories_rounded,
                size: 200,
                color: Colors.white,
              ),
            ),
          ),
          // Content overlay
          Center(
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.12),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.menu_book_rounded,
                      size: 40,
                      color: Color(0xFFF5F0EB),
                    ),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    widget.region.toUpperCase(),
                    style: const TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 2.0,
                      color: Color(0xFFE8734A),
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    widget.title,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontFamily: 'Georgia',
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
            ),
          ),
          // Inner decorative frame
          Positioned.fill(
            child: Container(
              margin: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: Colors.white.withValues(alpha: 0.12),
                  width: 1,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  String _getFullTitle() {
    switch (widget.title) {
      case 'Sangkuriang':
        return 'Sangkuriang:\nLegenda Tangkuban Perahu';
      case 'Roro Jonggrang':
        return 'Roro Jonggrang:\nSeribu Candi Prambanan';
      case 'Malin Kundang':
        return 'Malin Kundang:\nSi Anak Durhaka';
      case 'Barong & Rangda':
        return 'Barong & Rangda:\nPertarungan Abadi';
      case 'Gatotkaca':
        return 'Gatotkaca:\nSatria Pringgadani';
      case 'Timun Mas':
        return 'Timun Mas:\nPelarian dari Raksasa';
      case 'Calon Arang':
        return 'Calon Arang:\nLegenda Leak Bali';
      case 'Ramayana':
        return 'Ramayana:\nSri Rama & Dewi Sinta';
      case 'Pesut Mahakam':
        return 'Pesut Mahakam:\nLegenda Lumba-Lumba Air Tawar';
      case 'Sawerigading':
        return 'Sawerigading:\nEpos La Galigo';
      default:
        return widget.title;
    }
  }

  Widget _buildArticleBody() {
    final dropCapStyle = TextStyle(
      fontFamily: 'Georgia',
      fontSize: _fontSize * 3.25,
      fontWeight: FontWeight.bold,
      color: const Color(0xFF2D1810),
      height: 1.0,
    );

    final bodyStyle = TextStyle(
      fontSize: _fontSize,
      color: const Color(0xFF3D2E22),
      height: 1.8,
    );

    final quoteStyle = TextStyle(
      fontFamily: 'Georgia',
      fontSize: _fontSize + 1,
      fontStyle: FontStyle.italic,
      color: const Color(0xFF2D1810),
      height: 1.6,
    );

    final firstParagraph = _getFirstParagraph();
    final String dropCap = firstParagraph.isNotEmpty ? firstParagraph[0].toUpperCase() : '';
    final String remainingText = firstParagraph.length > 1 ? firstParagraph.substring(1) : '';

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // First paragraph with drop cap
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (dropCap.isNotEmpty)
              Padding(
                padding: const EdgeInsets.only(right: 6, top: 2),
                child: Text(
                  dropCap,
                  style: dropCapStyle,
                ),
              ),
            Expanded(
              child: Text(
                remainingText,
                style: bodyStyle,
              ),
            ),
          ],
        ),

        const SizedBox(height: 20),

        // Second paragraph
        Text(
          _getSecondParagraph(),
          style: bodyStyle,
        ),

        const SizedBox(height: 28),

        // Blockquote
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            border: const Border(
              left: BorderSide(
                color: Color(0xFF8B4513),
                width: 3,
              ),
            ),
            color: const Color(0xFF8B4513).withValues(alpha: 0.04),
          ),
          child: Text(
            _getBlockquote(),
            style: quoteStyle,
          ),
        ),

        const SizedBox(height: 28),

        // Third paragraph
        Text(
          _getThirdParagraph(),
          style: bodyStyle,
        ),

        const SizedBox(height: 24),
        const Divider(color: Color(0xFFD4C5B5), thickness: 0.8),
        const SizedBox(height: 12),
        Text(
          'Referensi Sumber:\n${_getStorySource()}',
          style: TextStyle(
            fontSize: _fontSize - 2,
            fontStyle: FontStyle.italic,
            color: const Color(0xFF8C7B6B),
            height: 1.5,
          ),
        ),
      ],
    );
  }

  String _getStorySource() {
    switch (widget.title) {
      case 'Sangkuriang':
        return 'Buku Cerita Rakyat Jawa Barat (Kementerian Pendidikan dan Kebudayaan RI)';
      case 'Roro Jonggrang':
        return 'Legenda Candi Prambanan & Ratu Boko (Balai Pelestarian Cagar Budaya Jawa Tengah)';
      case 'Malin Kundang':
        return 'Cerita Rakyat Minangkabau (Dinas Kebudayaan Provinsi Sumatera Barat)';
      case 'Barong & Rangda':
        return 'Mitologi Bali dan Pementasan Seni Budaya (Kementerian Pariwisata dan Ekonomi Kreatif)';
      case 'Timun Mas':
        return 'Cerita Rakyat Jawa Tengah: Timun Mas (Balai Bahasa Provinsi Jawa Tengah)';
      case 'Calon Arang':
        return 'Serat Calon Arang (Transliterasi Dinas Kebudayaan Provinsi Bali / Perpustakaan Nasional RI)';
      case 'Ramayana':
        return 'Epos Ramayana karya Walmiki (Terjemahan Sanskerta oleh Departemen Agama RI)';
      case 'Pesut Mahakam':
        return 'Legenda Pesut Mahakam dalam Cerita Rakyat Kalimantan Timur (Kantor Bahasa Provinsi Kalimantan Timur)';
      case 'Sawerigading':
        return 'Naskah Kuno La Galigo (Sureq Galigo) - Warisan Memori Dunia UNESCO (Dinas Perpustakaan dan Kearsipan Provinsi Sulawesi Selatan)';
      default:
        return 'Kumpulan Cerita Rakyat dan Legenda Nusantara (Direktorat Jenderal Kebudayaan RI)';
    }
  }

  String _getFirstParagraph() {
    switch (widget.title) {
      case 'Gatotkaca':
        return 'Dalam bayang-bayang perang besar Bharatayuddha, lahirlah seorang ksatria yang ditakdirkan menjadi perisai utama Pandawa. Ia adalah Gatotkaca, putra dari Bima dan raksasi Arimbi. Sejak kelahirannya, takdirnya telah dituliskan dengan darah dan baja di atas lembaran sejarah nusantara. Tali pusat yang tak bisa dipotong senjata biasa, akhirnya putus oleh sarung pusaka Konta Wijayandanu, yang kemudian menyatu dalam tubuhnya—menjadi kekuatan sekaligus kelemahannya yang paling mematikan.';
      case 'Sangkuriang':
        return 'Di sebuah kerajaan kuno di tanah Sunda, hiduplah seorang puteri cantik bernama Dayang Sumbi yang memiliki kecerdasan luar biasa. Pada suatu hari, saat ia sedang menenun, alat tenunnya jatuh ke bawah. Ia berjanji akan menikahi siapapun yang mengembalikannya, tanpa mengetahui takdir yang menanti.';
      case 'Roro Jonggrang':
        return 'Pada masa lampau, berdirilah Kerajaan Pengging yang dipimpin oleh raja yang kejam. Pangeran Pengging, Bandung Bondowoso, yang sakti mandraguna berhasil menaklukkan Kerajaan Keraton Boko dan membunuh rajanya. Di sana, ia terpesona oleh kecantikan putri sang raja yang bernama Roro Jonggrang dan berniat mempersuntingnya.';
      case 'Malin Kundang':
        return 'Di pesisir pantai Sumatera Barat, hiduplah seorang janda miskin bersama anak laki-lakinya yang bernama Malin Kundang. Malin adalah anak yang rajin dan sangat menyayangi ibunya. Karena terhimpit kemiskinan, Malin memutuskan untuk merantau menaiki kapal saudagar besar dengan harapan dapat merubah nasib mereka berdua.';
      case 'Barong & Rangda':
        return 'Dalam kosmos kepercayaan masyarakat Bali, terdapat pertarungan spiritual yang tidak akan pernah menemui garis akhir. Pertempuran suci ini melibatkan Barong, perwujudan kekuatan bajik dan pelindung kemanusiaan, melawan Rangda, ratu kebatinan hitam dan pemimpin para leak yang melambangkan kejahatan dan kehancuran.';
      case 'Timun Mas':
        return 'Di sebuah desa terpencil, hiduplah seorang janda tua bernama Mbok Srini yang mendambakan kehadiran seorang anak untuk menemani masa tuanya. Suatu hari, seorang raksasa hijau yang menakutkan bernama Buto Ijo mendengarkan doanya dan memberinya sebutir biji mentimun ajaib dengan syarat anak itu harus diserahkan kepadanya saat berusia 17 tahun.';
      case 'Calon Arang':
        return 'Pada masa pemerintahan Prabu Airlangga di Jawa Timur, hiduplah seorang janda sakti bernama Calon Arang di desa Girah. Ia menguasai ilmu hitam tingkat tinggi dan memiliki seorang putri cantik jelita bernama Ratna Manggali. Namun, karena ketakutan penduduk desa terhadap Calon Arang, tidak ada satu pun pemuda yang berani melamar Ratna Manggali.';
      case 'Ramayana':
        return 'Di Kerajaan Kosala yang makmur, lahirlah Sri Rama, putra mahkota yang bijaksana dan titisan Dewa Wisnu. Setelah memenangkan sayembara mengangkat busur Siwa, Rama mempersunting Dewi Sinta yang cantik jelita. Namun, intrik istana memaksa Rama dibuang ke hutan Dandaka selama 14 tahun bersama istri tercinta dan adiknya, Laksmana.';
      case 'Pesut Mahakam':
        return 'Di sebuah desa terpencil di tepi Sungai Mahakam, Kalimantan Timur, hiduplah sepasang suami istri yang hidup bahagia dengan dua anak mereka yang rajin. Namun, badai duka menerpa saat sang ibu meninggal karena sakit keras. Setelah beberapa lama menduda, sang ayah memutuskan menikah lagi dengan harapan anak-anaknya mendapat kasih sayang seorang ibu.';
      case 'Sawerigading':
        return 'Dalam mitologi Bugis yang tertulis di naskah kuno Sureq Galigo, hiduplah seorang pangeran bernama Sawerigading dari Kerajaan Luwu. Lahir sebagai putra mahkota yang gagah berani, ia tumbuh dewasa tanpa mengetahui bahwa dirinya memiliki saudara kembar perempuan cantik jelita bernama We Tenriabeng yang dibesarkan terpisah di puncak istana.';
      default:
        return 'Dalam dunia nusantara yang kaya akan cerita rakyat, terdapat banyak kisah yang telah diturunkan dari generasi ke generasi. Setiap cerita membawa pesan moral dan kebijaksanaan yang masih relevan hingga kini.';
    }
  }

  String _getSecondParagraph() {
    switch (widget.title) {
      case 'Gatotkaca':
        return 'Tumbuh besar di kawah Candradimuka, digembaleng oleh para dewa. Gatotkaca menjelma menjadi sosok tak tertandingi. Ototnya kawat, tulangnya besi, dan dadanya menghantarkan kekuatan magis yang membuatnya mampu terbang membelah awan tanpa sayap. Di dadanya tersimpan bintang Arureja, melambangkan keberanian yang tak pernah redup, bahkan di hadapan dewa sekalipun. Setiap hembusan napasnya adalah badai, dan setiap langkahnya mengguncang bumi.';
      case 'Sangkuriang':
        return 'Seekor anjing jantan bernama Tumang yang mengembalikan alat tenun tersebut. Tanpa mengetahui bahwa Tumang sebenarnya adalah titisan dewa sekaligus suaminya yang dikutuk, Dayang Sumbi menepati janjinya. Mereka dikaruniai seorang anak laki-laki bernama Sangkuriang yang tumbuh gagah dan gemar berburu di hutan.';
      case 'Roro Jonggrang':
        return 'Roro Jonggrang yang tidak ingin menikahi pembunuh ayahnya memutar otak. Ia mengajukan syarat yang mustahil: membangun seribu candi dalam waktu semalam. Bandung Bondowoso menyetujui syarat tersebut dan memanggil pasukan jin untuk membantunya membangun candi dengan kecepatan luar biasa.';
      case 'Malin Kundang':
        return 'Di tanah rantau, kerja keras Malin membuahkan hasil. Ia menjadi saudagar kaya raya yang memiliki banyak kapal dagang dan memperistri seorang putri bangsawan yang cantik. Kabar kesuksesan Malin akhirnya terdengar sampai ke telinga ibunya yang terus menunggu di pelabuhan dengan cemas setiap hari.';
      case 'Barong & Rangda':
        return 'Kehadiran Rangda membawa teror, penyakit, dan kegelapan ke seluruh pelosok negeri. Untuk melindungi rakyatnya, Barong memimpin barisan ksatria suci melawan kekuatan hitam Rangda. Pertarungan berlangsung sengit, di mana Rangda merasuki para ksatria pengikut Barong agar menikam diri mereka sendiri menggunakan keris sakti.';
      case 'Timun Mas':
        return 'Mbok Srini menanam biji tersebut, yang kemudian tumbuh menjadi mentimun emas berukuran sangat besar. Di dalamnya, ia menemukan bayi perempuan yang sangat cantik dan diberi nama Timun Mas. Timun Mas tumbuh menjadi gadis yang cerdas dan baik hati. Ketika hari ulang tahunnya yang ke-17 tiba, Buto Ijo datang untuk menagih janji.';
      case 'Calon Arang':
        return 'Mengetahui putrinya tidak laku nikah karena ketakutan orang-orang, Calon Arang murka. Ia melakukan ritual menyeramkan mempersembahkan korban kepada Dewi Durga dan menebarkan wabah penyakit mematikan ke seluruh negeri. Prabu Airlangga yang cemas kemudian mengutus Empu Bharadah untuk mengatasi bencana sihir tersebut.';
      case 'Ramayana':
        return 'Di dalam hutan rimba, raja raksasa angkara murka Rahwana terpesona oleh kecantikan Sinta. Dengan tipu muslihat menyamar sebagai kijang emas dan seorang pertapa tua, Rahwana berhasil menculik Sinta dan membawanya terbang ke Kerajaan Alengka. Rama yang kehilangan istrinya segera melakukan pencarian besar-besaran, dibantu oleh pasukan kera pimpinan Sugriwa.';
      case 'Pesut Mahakam':
        return 'Namun, ibu tiri mereka ternyata berwatak kejam. Ketika sang ayah pergi bekerja ke hutan, anak-anak itu dipaksa bekerja keras dan kelaparan. Suatu hari, sang ibu tiri menyuruh mereka mencari kayu bakar di hutan dan tidak boleh pulang sebelum terkumpul sangat banyak. Karena kelelahan dan kelaparan, kedua anak itu jatuh pingsan di pondok hutan.';
      case 'Sawerigading':
        return 'Ketika Sawerigading akhirnya bertemu dengan We Tenriabeng, ia langsung jatuh cinta karena tidak menyadari bahwa wanita itu adalah saudara kembarnya sendiri. Meskipun dilarang keras adat karena ancaman bencana dahsyat, Sawerigading bersikeras menikahinya. Untuk mencegah malapetaka, We Tenriabeng memberikan sehelai rambutnya dan menyuruh Sawerigading berlayar mencari putri Tiongkok, We Cudai, yang sangat mirip dengannya.';
      default:
        return 'Setiap daerah memiliki versi ceritanya sendiri, diwarnai oleh budaya, adat istiadat, dan kepercayaan setempat. Melalui cerita-cerita ini, kita dapat memahami keragaman dan kekayaan warisan budaya Indonesia.';
    }
  }

  String _getBlockquote() {
    switch (widget.title) {
      case 'Gatotkaca':
        return '"Otot kawat, tulang besi. Ia bukan sekadar manusia, melainkan badai yang menjelma pelindung kebenaran."';
      case 'Sangkuriang':
        return '"Gunung dan danau menjadi saksi cinta yang terlarang, mengabadikan kisah yang tak pernah berakhir."';
      case 'Roro Jonggrang':
        return '"Kecerdasan mengalahkan kekuatan kasar; namun janji yang dikhianati membawa kutukan abadi."';
      case 'Malin Kundang':
        return '"Restu ibu adalah rida Tuhan; durhaka padanya adalah kehancuran yang tak terelakkan."';
      case 'Barong & Rangda':
        return '"Keseimbangan semesta terjaga bukan karena kejahatan musnah, melainkan karena kebaikan selalu ada untuk menandinginya."';
      case 'Timun Mas':
        return '"Keberanian dan usaha yang tiada henti akan membukakan jalan keluar dari ancaman terbesar sekalipun."';
      case 'Calon Arang':
        return '"Kemurkaan yang dibakar oleh dendam hanya akan mendatangkan malapetaka bagi diri sendiri dan sesama."';
      case 'Ramayana':
        return '"Dharma akan selalu menang melawan Adharma; cinta suci dan kesetiaan melintasi lautan untuk kembali."';
      case 'Pesut Mahakam':
        return '"Keserakahan dan kekejaman menghancurkan kehangatan keluarga; kasih sayang sejati tak lekang oleh wujud fisik."';
      case 'Sawerigading':
        return '"Kepatuhan pada hukum alam menjaga harmoni semesta; takdir menuntun langkah melintasi samudra demi cinta yang sejati."';
      default:
        return '"Di balik setiap legenda, tersimpan pesan yang melampaui waktu dan ruang."';
    }
  }

  String _getThirdParagraph() {
    switch (widget.title) {
      case 'Gatotkaca':
        return 'Sebagai penguasa Pringgadani, ia bukan hanya seorang pejuang, melainkan juga pelindung. Ketika malam turun dan musuh-musuh Pandawa mengintai dalam gelap, bayangannya melayang di langit laksana burung garuda, menjaga keseimbangan dan kehormatan keluarganya. Namun, di balik kekuatannya yang tak tertembuskan, tersimpan kesadaran penuh akan takdir tragis yang menantinya di Padang Kurukshetra. Sebuah takdir yang harus ia tanggung demi memastikan fajar kemenangan menyingsing bagi kemanusiaan.';
      case 'Sangkuriang':
        return 'Suatu hari, Sangkuriang membunuh Tumang karena marah anjing itu gagal membantunya berburu. Mengetahui hal itu, Dayang Sumbi murka lalu memukul kepala Sangkuriang hingga terluka dan mengusirnya. Bertahun-tahun kemudian, Sangkuriang kembali sebagai pemuda sakti dan jatuh cinta pada Dayang Sumbi tanpa menyadari bahwa wanita awet muda itu adalah ibunya. Dayang Sumbi pun memberikan syarat mustahil membuat danau dan perahu dalam satu malam untuk menggagalkan pernikahan mereka.';
      case 'Roro Jonggrang':
        return 'Melihat candi hampir selesai sebelum fajar, Roro Jonggrang panik. Ia mengumpulkan para dayang untuk menumbuk padi dan membakar jerami agar langit tampak terang dan ayam berkokok. Para jin ketakutan dan pergi meninggalkan Bandung Bondowoso. Mengetahui dirinya dicurangi, pangeran murka dan mengutuk Roro Jonggrang menjadi candi yang keseribu guna melengkapi candi tersebut.';
      case 'Malin Kundang':
        return 'Suatu hari, kapal megah Malin merapat di pantai kelahirannya. Sang ibu berlari memeluk Malin, namun karena malu pada istrinya yang cantik, Malin mendorong ibunya hingga jatuh dan menyangkal bahwa wanita tua renta berpakaian compang-camping itu adalah ibunya. Dengan hati hancur, sang ibu berdoa menuntut keadilan, memohon agar anaknya dikutuk menjadi batu jika dia benar-benar Malin Kundang. Seketika badai dahsyat datang menghancurkan kapalnya, dan Malin bersimpuh membeku menjadi batu.';
      case 'Barong & Rangda':
        return 'Namun, berkat sihir pelindung dari Barong, keris para ksatria tidak dapat melukai tubuh mereka sendiri, melahirkan tarian mistis Calonarang yang penuh magis. Pertarungan antara Barong dan Rangda terus berlangsung tanpa pemenang mutlak, mengingatkan manusia bahwa kebaikan dan kejahatan (Rua Bhineda) akan selalu berdampingan untuk menjaga harmoni kehidupan di bumi.';
      case 'Timun Mas':
        return 'Mbok Srini tidak rela kehilangan anaknya, ia memberikan empat kantong ajaib berisi biji mentimun, jarum, garam, dan terasi kepada Timun Mas sebelum menyuruhnya melarikan diri. Saat dikejar Buto Ijo, Timun Mas melemparkan isi kantong satu per satu. Garam berubah menjadi lautan luas, jarum menjadi hutan bambu berduri, biji timun menjadi ladang menjalar yang menjerat raksasa, dan terasi berubah menjadi lautan lumpur mendidih yang akhirnya menenggelamkan Buto Ijo.';
      case 'Calon Arang':
        return 'Empu Bharadah mengutus muridnya, Empu Bahula, untuk menikahi Ratna Manggali secara pura-pura agar bisa menyelidiki kelemahan Calon Arang. Dengan bantuan Ratna Manggali, Empu Bahula berhasil mencuri kitab sihir hitam milik Calon Arang. Kitab tersebut diserahkan kepada Empu Bharadah yang akhirnya berhasil mengalahkan Calon Arang dan menyembuhkan seluruh rakyat dari kutukan penyakit.';
      case 'Ramayana':
        return 'Panglima kera Hanoman yang gagah berani diutus menyeberangi lautan ke Alengka untuk memastikan keadaan Sinta. Setelah membakar kota Alengka, Hanoman kembali membawa kabar baik. Rama bersama pasukan kera membangun jembatan batu menuju Alengka, meluncurkan perang besar, dan akhirnya mengalahkan Rahwana untuk membesarkan Sinta.';
      case 'Pesut Mahakam':
        return 'Sang ayah yang pulang mendapati pondok kosong segera mencari mereka ke hutan. Ketika ditemukan, anak-anak itu sedang memakan pisang ketan di kuali karena sangat lapar. Seketika suhu tubuh mereka naik drastis. Karena kepanasan, mereka berlari ke Sungai Mahakam dan melompat ke air. Ajaibnya, wujud mereka berubah menjadi sepasang lumba-lumba air tawar (Pesut) yang terus berenang bebas menjaga sungai tersebut.';
      case 'Sawerigading':
        return 'Sawerigading pun menebang pohon Welengreng yang sakti untuk dibuat menjadi perahu besar bernama Waka Apporeng. Setelah mengarungi badai dahsyat dan menaklukkan berbagai rintangan di lautan luas, ia akhirnya tiba di negeri Tiongkok. Di sana, ia berhasil memenangkan hati We Cudai dan menetap bersamanya, mewujudkan takdir kepahlawanan yang melegenda di seluruh tanah Sulawesi.';
      default:
        return 'Dengan melestarikan cerita-cerita ini, kita turut menjaga identitas bangsa dan memberikan warisan yang berharga kepada generasi mendatang. Setiap kisah adalah jendela menuju masa lalu yang penuh hikmah.';
    }
  }
}
