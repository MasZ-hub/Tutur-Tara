import 'package:flutter/material.dart';

class QuizPlayScreen extends StatefulWidget {
  final String seriesTitle;

  const QuizPlayScreen({super.key, required this.seriesTitle});

  @override
  State<QuizPlayScreen> createState() => _QuizPlayScreenState();
}

class _QuizPlayScreenState extends State<QuizPlayScreen> {
  late List<Map<String, dynamic>> _questions;
  int _currentQuestion = 0;
  int? _selectedAnswer;
  bool _hasValidated = false;
  int _score = 0;
  bool _showResult = false;

  @override
  void initState() {
    super.initState();
    _questions = _getQuestionsForSeries();
  }

  List<Map<String, dynamic>> _getQuestionsForSeries() {
    if (widget.seriesTitle.contains('Jawa')) {
      return [
        {
          'question': 'Di manakah latar daerah terjadinya legenda cerita rakyat Sangkuriang?',
          'answers': ['Jawa Tengah', 'Jawa Timur', 'Jawa Barat', 'DKI Jakarta'],
          'correct': 2,
        },
        {
          'question': 'Siapakah nama ibu kandung Sangkuriang yang memiliki kecantikan awet muda?',
          'answers': ['Sinta', 'Dayang Sumbi', 'Ratna Manggali', 'Roro Jonggrang'],
          'correct': 1,
        },
        {
          'question': 'Siapakah sebenarnya Tumang, anjing pemburu peliharaan Dayang Sumbi?',
          'answers': ['Titisan dewa dan suami Dayang Sumbi', 'Siluman serigala hutan', 'Anjing penjaga biasa', 'Pangeran dari kerajaan tetangga'],
          'correct': 0,
        },
        {
          'question': 'Apa penyebab utama Sangkuriang diusir oleh ibunya saat masih kecil?',
          'answers': ['Membakar pondok tenun', 'Membunuh anjing Tumang', 'Mencuri pusaka kerajaan', 'Menolak belajar berburu'],
          'correct': 1,
        },
        {
          'question': 'Syarat mustahil apa yang diajukan Dayang Sumbi untuk menggagalkan lamaran Sangkuriang?',
          'answers': ['Membangun seribu candi', 'Membuat bendungan dan perahu besar dalam semalam', 'Mencari kijang emas di hutan', 'Menebang pohon Welengreng'],
          'correct': 1,
        },
        {
          'question': 'Pangeran sakti dari Pengging yang menaklukkan Keraton Boko adalah...',
          'answers': ['Bandung Bondowoso', 'Sangkuriang', 'Rama', 'Sawerigading'],
          'correct': 0,
        },
        {
          'question': 'Roro Jonggrang dikutuk menjadi candi yang keberapa untuk melengkapi syaratnya?',
          'answers': ['Candi ke-100', 'Candi ke-500', 'Candi ke-999', 'Candi ke-1000'],
          'correct': 3,
        },
        {
          'question': 'Bagaimana cara Roro Jonggrang mencurangi usaha pembuatan candi Bandung Bondowoso?',
          'answers': ['Merusak fondasi candi', 'Menyiram air suci ke para jin', 'Membakar jerami dan menumbuk padi agar tampak fajar', 'Meminta bantuan Empu Bharadah'],
          'correct': 2,
        },
        {
          'question': 'Siapakah raksasa hijau pemakan manusia dalam legenda Timun Mas?',
          'answers': ['Buto Ijo', 'Rahwana', 'Rangda', 'Tumang'],
          'correct': 0,
        },
        {
          'question': 'Di manakah janda tua Mbok Srini menemukan bayi perempuan Timun Mas?',
          'answers': ['Di dalam kawah gunung', 'Di dalam buah mentimun emas', 'Hutan bambu berduri', 'Di tepi Sungai Mahakam'],
          'correct': 1,
        },
      ];
    } else if (widget.seriesTitle.contains('Sumatera')) {
      return [
        {
          'question': 'Di pesisir daerah manakah latar kisah Malin Kundang diceritakan?',
          'answers': ['Sumatera Utara', 'Sumatera Selatan', 'Sumatera Barat', 'Lampung'],
          'correct': 2,
        },
        {
          'question': 'Malin Kundang dibesarkan oleh ibunya dalam keadaan sosial...',
          'answers': ['Keluarga saudagar kaya', 'Janda miskin yang serba kekurangan', 'Keluarga bangsawan istana', 'Nelayan modern'],
          'correct': 1,
        },
        {
          'question': 'Apa alasan utama Malin Kundang memutuskan pergi merantau menaiki kapal?',
          'answers': ['Melarikan diri dari musuh', 'Mencari ayahnya yang hilang', 'Mengubah nasib dan keluar dari kemiskinan', 'Menikahi putri bangsawan'],
          'correct': 2,
        },
        {
          'question': 'Pekerjaan atau status apa yang diraih Malin Kundang setelah sukses di tanah rantau?',
          'answers': ['Prajurit kerajaan', 'Saudagar kaya pemilik banyak kapal dagang', 'Pendeta Buddha', 'Petani kelapa sawit'],
          'correct': 1,
        },
        {
          'question': 'Siapakah yang dinikahi Malin Kundang di tanah rantaunya?',
          'answers': ['Putri bangsawan yang cantik', 'Gadis nelayan miskin', 'Dayang Sumbi', 'Ratna Manggali'],
          'correct': 0,
        },
        {
          'question': 'Tindakan kejam apa yang dilakukan Malin Kundang saat ibunya memeluknya di pelabuhan?',
          'answers': ['Menyuruh prajurit menangkapnya', 'Mendorong ibunya hingga jatuh dan menyangkalnya', 'Memberikan sekantong emas sambil marah', 'Berpura-pura lupa ingatan'],
          'correct': 1,
        },
        {
          'question': 'Mengapa Malin Kundang enggan mengakui ibu kandungnya sendiri?',
          'answers': ['Karena ibunya mengenakan pakaian compang-camping dan dia merasa malu pada istrinya', 'Karena ibunya telah memukul kepalanya', 'Karena ibunya dikutuk menjadi leak', 'Karena takut hartanya diminta'],
          'correct': 0,
        },
        {
          'question': 'Doa keadilan apa yang dipanjatkan oleh ibu Malin Kundang yang terluka hatinya?',
          'answers': ['Memohon kapal Malin tenggelam', 'Memohon agar Malin dikutuk menjadi batu jika dia benar anaknya', 'Meminta Malin jatuh miskin kembali', 'Memohon agar Malin dimaafkan para dewa'],
          'correct': 1,
        },
        {
          'question': 'Bencana alam apa yang menghancurkan kapal megah Malin sesaat sebelum kutukan terjadi?',
          'answers': ['Gempa bumi laut', 'Letusan gunung api', 'Badai dahsyat secara seketika', 'Serangan monster laut'],
          'correct': 2,
        },
        {
          'question': 'Dalam posisi bagaimanakah tubuh Malin Kundang membeku menjadi batu?',
          'answers': ['Berdiri menantang langit', 'Berbaring telentang', 'Bersimpuh memohon ampun', 'Duduk di singgasana kapalnya'],
          'correct': 2,
        },
      ];
    } else if (widget.seriesTitle.contains('Bali')) {
      return [
        {
          'question': 'Siapakah makhluk mitologis pelindung kemanusiaan yang mewakili kebajikan di Bali?',
          'answers': ['Rangda', 'Barong', 'Leak', 'Buto Ijo'],
          'correct': 1,
        },
        {
          'question': 'Siapakah ratu kebatinan hitam pemandu para leak yang melambangkan kejahatan?',
          'answers': ['Calon Arang', 'Ratna Manggali', 'Rangda', 'Dayang Sumbi'],
          'correct': 2,
        },
        {
          'question': 'Di desa manakah Calon Arang, sang janda sakti penganut sihir hitam, tinggal?',
          'answers': ['Desa Girah', 'Desa Boko', 'Desa Luwu', 'Desa Pengging'],
          'correct': 0,
        },
        {
          'question': 'Siapakah nama putri cantik jelita dari Calon Arang?',
          'answers': ['We Cudai', 'Dewi Sinta', 'Ratna Manggali', 'Roro Jonggrang'],
          'correct': 2,
        },
        {
          'question': 'Apa yang memicu Calon Arang melakukan ritual Durhaka dan menebar wabah penyakit?',
          'answers': ['Putrinya diculik musuh', 'Kemarahan karena tidak ada pemuda yang berani melamar putrinya', 'Perebutan takhta Kerajaan Airlangga', 'Sawahnya dirusak warga desa'],
          'correct': 1,
        },
        {
          'question': 'Raja Jawa Timur yang mengutus utusan sakti untuk menghentikan bencana sihir Calon Arang adalah...',
          'answers': ['Prabu Airlangga', 'Bandung Bondowoso', 'Sri Rama', 'Sawerigading'],
          'correct': 0,
        },
        {
          'question': 'Siapakah pendeta suci yang diutus untuk mengatasi Calon Arang?',
          'answers': ['Empu Bahula', 'Empu Bharadah', 'Hanoman', 'Laksmana'],
          'correct': 1,
        },
        {
          'question': 'Taktik apa yang digunakan murid pendeta bernama Empu Bahula untuk menyelidiki kelemahan Calon Arang?',
          'answers': ['Menantangnya bertarung langsung', 'Menyamar menjadi jin pelindung', 'Menikahi Ratna Manggali secara pura-pura untuk mencuri kitab sihir', 'Membakar desa Girah'],
          'correct': 2,
        },
        {
          'question': 'Apa keunikan efek sihir pelindung Barong terhadap ksatria pengikutnya yang kerasukan?',
          'answers': ['Mereka bisa terbang tinggi', 'Senjata keris yang ditikam ke tubuh sendiri tidak melukai mereka', 'Mereka berubah wujud menjadi pesut', 'Tubuh mereka membeku menjadi batu candi'],
          'correct': 1,
        },
        {
          'question': 'Konsep filosofis keseimbangan apa yang diajarkan lewat tarian pertempuran Barong & Rangda?',
          'answers': ['Dharma dan Adharma akan selalu berdampingan menjaga harmoni (Rua Bhineda)', 'Kejahatan pasti musnah selamanya', 'Kekuatan fisik mengalahkan segalanya', 'Hukum adat tidak dapat diubah'],
          'correct': 0,
        },
      ];
    } else if (widget.seriesTitle.contains('Kalimantan')) {
      return [
        {
          'question': 'Di tepi sungai manakah legenda Pesut Mahakam ini berkembang?',
          'answers': ['Sungai Kapuas', 'Sungai Mahakam', 'Sungai Barito', 'Sungai Kahayan'],
          'correct': 1,
        },
        {
          'question': 'Mengapa sang ayah dalam cerita Pesut Mahakam memutuskan untuk menikah lagi?',
          'answers': ['Karena istrinya menceraikannya', 'Agar anak-anaknya memiliki pengasuh/ibu baru setelah ibu kandung wafat', 'Karena paksaan raja setempat', 'Mencari kekayaan dari keluarga baru'],
          'correct': 1,
        },
        {
          'question': 'Bagaimana watak asli dari ibu tiri kedua anak tersebut?',
          'answers': ['Sangat baik hati dan dermawan', 'Kejam, serakah, dan menelantarkan anak tiri', 'Pemalu dan pendiam', 'Suka menenun pakaian tradisional'],
          'correct': 1,
        },
        {
          'question': 'Perintah kejam apa yang diberikan ibu tiri saat sang ayah pergi bekerja di hutan?',
          'answers': ['Menjual seluruh perahu di sungai', 'Mencari kayu bakar di hutan dan tidak boleh pulang sebelum terkumpul banyak', 'Menangkap pesut di sungai', 'Belajar ilmu hitam di desa'],
          'correct': 1,
        },
        {
          'question': 'Apa yang terjadi pada kedua anak itu di pondok hutan karena kelelahan?',
          'answers': ['Mereka diserang binatang buas', 'Mereka melarikan diri ke kota', 'Mereka jatuh pingsan karena kelaparan', 'Mereka ditolong seorang pertapa'],
          'correct': 2,
        },
        {
          'question': 'Makanan apa yang dimakan kedua anak tersebut di kuali sesampainya di pondok rumah?',
          'answers': ['Nasi goreng pedas', 'Pisang ketan yang sedang dimasak', 'Buah mentimun emas', 'Kue bolu karamel'],
          'correct': 1,
        },
        {
          'question': 'Apa efek fisik langsung setelah kedua anak memakan hidangan di kuali?',
          'answers': ['Tidur pulas seketika', 'Suhu tubuh naik drastis/sangat kepanasan', 'Tubuh mereka berubah menjadi batu', 'Mereka menjadi sakti mandraguna'],
          'correct': 1,
        },
        {
          'question': 'Ke manakah kedua anak itu berlari untuk meredakan panas di tubuh mereka?',
          'answers': ['Ke tengah hutan bambu', 'Melompat ke dalam Sungai Mahakam', 'Ke kawah Candradimuka', 'Ke dalam candi Prambanan'],
          'correct': 1,
        },
        {
          'question': 'Menjadi makhluk apakah kedua anak tersebut setelah melompat ke air sungai?',
          'answers': ['Sepasang lumba-lumba air tawar (Pesut)', 'Naga raksasa pelindung sungai', 'Ikan mas ajaib warna-warni', 'Burung garuda raksasa'],
          'correct': 0,
        },
        {
          'question': 'Apa pesan moral penting yang dapat diambil dari legenda Pesut Mahakam?',
          'answers': ['Jangan pernah berenang di sungai dalam', 'Keserakahan dan kekejaman menghancurkan keluarga; kasih sayang sejati tak lekang oleh wujud fisik', 'Patuhi perintah ibu tiri apa pun keadaannya', 'Berburu di hutan mendatangkan keberuntungan'],
          'correct': 1,
        },
      ];
    } else if (widget.seriesTitle.contains('Sulawesi')) {
      return [
        {
          'question': 'Siapakah pangeran legendaris dari Kerajaan Luwu yang dikisahkan dalam epos Sulawesi?',
          'answers': ['Sawerigading', 'Rama', 'Bandung Bondowoso', 'Sangkuriang'],
          'correct': 0,
        },
        {
          'question': 'Di dalam naskah kuno apakah kisah mitologi dan kepahlawanan Bugis ini tercatat?',
          'answers': ['Sureq Galigo (La Galigo)', 'Serat Centhini', 'Negarakertagama', 'Babad Tanah Jawi'],
          'correct': 0,
        },
        {
          'question': 'Siapakah nama saudara kembar perempuan dari Sawerigading?',
          'answers': ['We Tenriabeng', 'We Cudai', 'Ratna Manggali', 'Dewi Sinta'],
          'correct': 0,
        },
        {
          'question': 'Mengapa pernikahan antara Sawerigading dan saudara kembarnya dilarang keras?',
          'answers': ['Karena perbedaan status sosial', 'Larangan adat karena pertalian darah kembar yang dapat memicu bencana besar', 'Karena We Tenriabeng sudah bertunangan', 'Karena dipaksa berlayar'],
          'correct': 1,
        },
        {
          'question': 'Benda petunjuk apa yang diberikan We Tenriabeng kepada Sawerigading untuk mencari jodohnya?',
          'answers': ['Cincin permata emas', 'Keris pusaka kerajaan', 'Sehelai rambutnya', 'Kitab sihir kuno'],
          'correct': 2,
        },
        {
          'question': 'Ke negeri manakah Sawerigading diperintahkan berlayar untuk mencari jodohnya?',
          'answers': ['Negeri Jawa', 'Negeri Tiongkok', 'Alengka', 'Sumatera Barat'],
          'correct': 1,
        },
        {
          'question': 'Siapakah putri Tiongkok berwajah sangat mirip dengan We Tenriabeng yang dicari Sawerigading?',
          'answers': ['We Cudai', 'Dewi Sinta', 'Dayang Sumbi', 'Roro Jonggrang'],
          'correct': 0,
        },
        {
          'question': 'Pohon sakti apa yang ditebang oleh Sawerigading untuk membuat perahunya?',
          'answers': ['Pohon Welengreng', 'Pohon Dewaruci', 'Pohon Beringin Sakti', 'Pohon Kelapa kembar'],
          'correct': 0,
        },
        {
          'question': 'Apa nama perahu layar besar legendaris yang membawa Sawerigading mengarungi samudra?',
          'answers': ['Waka Apporeng', 'Perahu Phinisi', 'Bahtera Nuh', 'Konta Wijaya'],
          'correct': 0,
        },
        {
          'question': 'Apa makna moral utama dari epos petualangan Sawerigading?',
          'answers': ['Jangan menebang pohon sembarangan', 'Kepatuhan pada hukum alam menjaga harmoni semesta; takdir menuntun langkah melintasi samudra demi cinta yang sejati', 'Hindari berlayar saat musim badai', 'Keluarga adalah segalanya melebihi cinta'],
          'correct': 1,
        },
      ];
    } else {
      // Ramayana & Asia Selatan
      return [
        {
          'question': 'Sri Rama merupakan putra mahkota dari kerajaan makmur yang bernama...',
          'answers': ['Kerajaan Kosala', 'Kerajaan Alengka', 'Kerajaan Luwu', 'Kerajaan Boko'],
          'correct': 0,
        },
        {
          'question': 'Sayembara apakah yang dimenangkan oleh Rama untuk mempersunting Dewi Sinta?',
          'answers': ['Sayembara menunggangi gajah liar', 'Sayembara mengangkat dan membidik busur Dewa Siwa', 'Sayembara membuat seribu candi', 'Sayembara berlayar ke Tiongkok'],
          'correct': 1,
        },
        {
          'question': 'Di hutan manakah Rama dibuang selama 14 tahun bersama Sinta dan Laksmana?',
          'answers': ['Hutan Dandaka', 'Hutan Pringgadani', 'Hutan Welengreng', 'Hutan Girah'],
          'correct': 0,
        },
        {
          'question': 'Siapakah raja raksasa angkara murka dari Alengka yang menculik Dewi Sinta?',
          'answers': ['Rahwana', 'Buto Ijo', 'Rangda', 'Arimbi'],
          'correct': 0,
        },
        {
          'question': 'Taktik penyamaran apa yang digunakan Rahwana untuk menculik Sinta dari lingkar pelindung?',
          'answers': ['Menjelma menjadi kijang emas dan pertapa tua', 'Menyamar sebagai Laksmana', 'Menyamar menjadi anjing Tumang', 'Menggunakan sihir halimun'],
          'correct': 0,
        },
        {
          'question': 'Siapakah adik kandung Rama yang setia menemani di dalam hutan pembuangan?',
          'answers': ['Laksmana', 'Hanoman', 'Sugriwa', 'Bima'],
          'correct': 0,
        },
        {
          'question': 'Ke manakah Sinta dibawa pergi setelah berhasil diculik oleh Rahwana?',
          'answers': ['Kerajaan Alengka', 'Kerajaan Kosala', 'Keraton Boko', 'Desa Girah'],
          'correct': 0,
        },
        {
          'question': 'Siapakah ksatria kera putih sakti yang diutus menyeberangi lautan ke Alengka?',
          'answers': ['Hanoman', 'Sugriwa', 'Gatotkaca', 'Laksmana'],
          'correct': 0,
        },
        {
          'question': 'Tindakan legendaris apa yang dilakukan Hanoman setelah berhasil menemui Sinta di taman Alengka?',
          'answers': ['Membawa Sinta terbang kabur', 'Membakar kota Alengka', 'Membunuh Rahwana seketika', 'Mencuri busur Siwa'],
          'correct': 1,
        },
        {
          'question': 'Apa inti nilai moral perjuangan Rama melawan Rahwana dalam epos Ramayana?',
          'answers': ['Dharma (kebajikan) akan selalu menang melawan Adharma (keburukan)', 'Kekuatan raksasa tidak tertandingi oleh manusia', 'Sayembara adalah satu-satunya jalan mencari cinta', 'Hutan adalah tempat pembersihan dosa'],
          'correct': 0,
        },
      ];
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_showResult) {
      return Scaffold(
        backgroundColor: const Color(0xFFF5F0EB),
        body: SafeArea(child: _buildResultScreen()),
      );
    }

    final question = _questions[_currentQuestion];

    return Scaffold(
      backgroundColor: const Color(0xFFF5F0EB),
      body: SafeArea(
        child: Column(
          children: [
            // App bar
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(vertical: 18),
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [Color(0xFFE8E0D8), Color(0xFFF5F0EB)],
                ),
              ),
              child: Column(
                children: [
                  // Back button and title
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Row(
                      children: [
                        GestureDetector(
                          onTap: () => Navigator.pop(context),
                          child: const Icon(
                            Icons.arrow_back_rounded,
                            color: Color(0xFF2D1810),
                            size: 24,
                          ),
                        ),
                        Expanded(
                          child: Center(
                            child: Text(
                              'Tutur-Tara',
                              style: const TextStyle(
                                fontFamily: 'Georgia',
                                fontSize: 22,
                                fontWeight: FontWeight.bold,
                                color: Color(0xFF2D1810),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 24),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            // Series label
            Container(
              margin: const EdgeInsets.only(top: 4),
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
              decoration: BoxDecoration(
                color: const Color(0xFF2D1810),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Text(
                _getSeriesLabel(),
                style: const TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: Colors.white,
                  letterSpacing: 0.5,
                ),
              ),
            ),

            const SizedBox(height: 16),

            // Progress bar
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Row(
                children: [
                  Text(
                    '${_currentQuestion + 1}'.padLeft(2, '0'),
                    style: const TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF5C4033),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(4),
                      child: LinearProgressIndicator(
                        value: (_currentQuestion + 1) / _questions.length,
                        minHeight: 4,
                        backgroundColor: const Color(0xFFE8E0D8),
                        valueColor: const AlwaysStoppedAnimation<Color>(
                          Color(0xFFE8734A),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Text(
                    '${_questions.length}'.padLeft(2, '0'),
                    style: const TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF9C8474),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 28),

            // Question card
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.all(28),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: const Color(0xFF8B4513).withValues(alpha: 0.06),
                      blurRadius: 16,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    // Quote icon
                    const Text(
                      '❝',
                      style: TextStyle(
                        fontSize: 32,
                        color: Color(0xFFD4C5B5),
                        height: 1,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Text(
                      question['question'] as String,
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        fontFamily: 'Georgia',
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFF2D1810),
                        height: 1.5,
                      ),
                    ),
                    const SizedBox(height: 16),
                    // Decorative divider
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          width: 30,
                          height: 1,
                          color: const Color(0xFFD4C5B5),
                        ),
                        const SizedBox(width: 8),
                        const Icon(
                          Icons.diamond_outlined,
                          size: 10,
                          color: Color(0xFFD4C5B5),
                        ),
                        const SizedBox(width: 8),
                        Container(
                          width: 30,
                          height: 1,
                          color: const Color(0xFFD4C5B5),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 28),

            // Answer options
            Expanded(
              child: ListView.builder(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                itemCount: (question['answers'] as List).length,
                itemBuilder: (context, index) {
                  final answers = question['answers'] as List<String>;
                  final isSelected = _selectedAnswer == index;
                  final isCorrect = index == question['correct'];
                  final labels = ['A', 'B', 'C', 'D'];

                  Color cardBg = Colors.white;
                  Color borderColor = const Color(0xFFE8E0D8);
                  double borderWidth = 1.0;
                  Widget? suffixWidget;

                  if (_hasValidated) {
                    if (isCorrect) {
                      cardBg = const Color(0xFFE8F5E9); // Light green
                      borderColor = const Color(0xFF4CAF50);
                      borderWidth = 1.5;
                      suffixWidget = const Icon(
                        Icons.check_circle_rounded,
                        color: Color(0xFF4CAF50),
                        size: 20,
                      );
                    } else if (isSelected) {
                      cardBg = const Color(0xFFFFEBEE); // Light red
                      borderColor = const Color(0xFFEF5350);
                      borderWidth = 1.5;
                      suffixWidget = const Icon(
                        Icons.cancel_rounded,
                        color: Color(0xFFEF5350),
                        size: 20,
                      );
                    }
                  } else {
                    if (isSelected) {
                      cardBg = const Color(0xFFFFF8F0);
                      borderColor = const Color(0xFFE8734A);
                      borderWidth = 1.5;
                    }
                  }

                  return GestureDetector(
                    onTap: _hasValidated
                        ? null
                        : () => setState(() => _selectedAnswer = index),
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 200),
                      margin: const EdgeInsets.only(bottom: 12),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 16,
                      ),
                      decoration: BoxDecoration(
                        color: cardBg,
                        borderRadius: BorderRadius.circular(14),
                        border: Border.all(
                          color: borderColor,
                          width: borderWidth,
                        ),
                        boxShadow: isSelected && !_hasValidated
                            ? [
                                BoxShadow(
                                  color: const Color(0xFFE8734A).withValues(alpha: 0.1),
                                  blurRadius: 8,
                                  offset: const Offset(0, 2),
                                ),
                              ]
                            : [],
                      ),
                      child: Row(
                        children: [
                          // Label circle
                          Container(
                            width: 36,
                            height: 36,
                            decoration: BoxDecoration(
                              color: isSelected && !_hasValidated
                                  ? const Color(0xFFE8734A).withValues(alpha: 0.12)
                                  : (_hasValidated && isCorrect
                                      ? const Color(0xFF4CAF50).withValues(alpha: 0.12)
                                      : (_hasValidated && isSelected
                                          ? const Color(0xFFEF5350).withValues(alpha: 0.12)
                                          : const Color(0xFFF5F0EB))),
                              shape: BoxShape.circle,
                            ),
                            child: Center(
                              child: Text(
                                labels[index],
                                style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w700,
                                  color: isSelected && !_hasValidated
                                      ? const Color(0xFFE8734A)
                                      : (_hasValidated && isCorrect
                                          ? const Color(0xFF4CAF50)
                                          : (_hasValidated && isSelected
                                              ? const Color(0xFFEF5350)
                                              : const Color(0xFF9C8474))),
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(width: 14),

                          // Answer text
                          Expanded(
                            child: Text(
                              answers[index],
                              style: TextStyle(
                                fontSize: 15,
                                fontWeight: isSelected
                                    ? FontWeight.w600
                                    : FontWeight.w400,
                                color: const Color(0xFF2D1810),
                              ),
                            ),
                          ),

                          // Suffix icon
                          if (suffixWidget != null) ...[
                            const SizedBox(width: 8),
                            suffixWidget,
                          ],
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),

            // Next button
            Padding(
              padding: const EdgeInsets.fromLTRB(24, 8, 24, 20),
              child: SizedBox(
                width: double.infinity,
                height: 52,
                child: ElevatedButton(
                  onPressed: _selectedAnswer != null
                      ? () {
                          if (!_hasValidated) {
                            setState(() {
                              _hasValidated = true;
                              final isCorrect = _selectedAnswer == _questions[_currentQuestion]['correct'];
                              if (isCorrect) {
                                _score++;
                              }
                            });
                          } else {
                            if (_currentQuestion < _questions.length - 1) {
                              setState(() {
                                _currentQuestion++;
                                _selectedAnswer = null;
                                _hasValidated = false;
                              });
                            } else {
                              setState(() {
                                _showResult = true;
                              });
                            }
                          }
                        }
                      : null,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF2D1810),
                    disabledBackgroundColor:
                        const Color(0xFF2D1810).withValues(alpha: 0.4),
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                    elevation: 0,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        !_hasValidated
                            ? 'PERIKSA JAWABAN'
                            : (_currentQuestion < _questions.length - 1 ? 'LANJUT' : 'LIHAT HASIL'),
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w700,
                          letterSpacing: 1,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Icon(
                        !_hasValidated
                            ? Icons.verified_user_rounded
                            : (_currentQuestion < _questions.length - 1
                                ? Icons.arrow_forward_rounded
                                : Icons.emoji_events_rounded),
                        size: 18,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildResultScreen() {
    final percentage = _score / _questions.length;
    final displayScore = (percentage * 100).toInt();

    String feedbackTitle = 'Coba Lagi!';
    String feedbackSub = 'Ayo baca cerita rakyat lagi untuk menjawab dengan lebih baik.';
    IconData trophyIcon = Icons.stars_rounded;
    Color themeColor = const Color(0xFFE8734A);

    if (percentage == 1.0) {
      feedbackTitle = 'Sempurna!';
      feedbackSub = 'Luar biasa! Anda menguasai seluruh cerita rakyat di seri ini.';
      trophyIcon = Icons.emoji_events_rounded;
      themeColor = const Color(0xFF4CAF50);
    } else if (percentage >= 0.6) {
      feedbackTitle = 'Hebat!';
      feedbackSub = 'Hasil yang sangat baik! Anda memahami kisah nusantara dengan baik.';
      trophyIcon = Icons.thumb_up_rounded;
      themeColor = const Color(0xFF8B4513);
    }

    return Center(
      child: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.all(32),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(24),
            boxShadow: [
              BoxShadow(
                color: const Color(0xFF2D1810).withValues(alpha: 0.1),
                blurRadius: 20,
                offset: const Offset(0, 10),
              ),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Icon Badge
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: themeColor.withValues(alpha: 0.1),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  trophyIcon,
                  size: 64,
                  color: themeColor,
                ),
              ),
              const SizedBox(height: 24),

              // Series title
              Text(
                widget.seriesTitle.toUpperCase(),
                style: const TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 1.5,
                  color: Color(0xFF9C8474),
                ),
              ),
              const SizedBox(height: 8),

              // Feedback title
              Text(
                feedbackTitle,
                style: const TextStyle(
                  fontFamily: 'Georgia',
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF2D1810),
                ),
              ),
              const SizedBox(height: 12),

              // Feedback description
              Text(
                feedbackSub,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 14,
                  color: Color(0xFF8C7B6B),
                  height: 1.5,
                ),
              ),
              const SizedBox(height: 32),

              // Score Ring
              Stack(
                alignment: Alignment.center,
                children: [
                  SizedBox(
                    height: 130,
                    width: 130,
                    child: CircularProgressIndicator(
                      value: percentage,
                      strokeWidth: 8,
                      backgroundColor: const Color(0xFFE8E0D8),
                      valueColor: AlwaysStoppedAnimation<Color>(themeColor),
                    ),
                  ),
                  Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        '$displayScore',
                        style: const TextStyle(
                          fontFamily: 'Georgia',
                          fontSize: 40,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF2D1810),
                        ),
                      ),
                      const Text(
                        'SKOR',
                        style: TextStyle(
                          fontSize: 10,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 1.5,
                          color: Color(0xFF9C8474),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 24),

              // Detail
              Text(
                'Jawaban Benar: $_score dari ${_questions.length}',
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF5C4033),
                ),
              ),
              const SizedBox(height: 36),

              // Action Buttons
              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.pop(context, percentage);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF2D1810),
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    elevation: 0,
                  ),
                  child: const Text(
                    'KEMBALI KE MENU KUIS',
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 0.5,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 12),
              SizedBox(
                width: double.infinity,
                height: 50,
                child: OutlinedButton(
                  onPressed: () {
                    setState(() {
                      _currentQuestion = 0;
                      _selectedAnswer = null;
                      _hasValidated = false;
                      _score = 0;
                      _showResult = false;
                    });
                  },
                  style: OutlinedButton.styleFrom(
                    foregroundColor: const Color(0xFF2D1810),
                    side: const BorderSide(color: Color(0xFF2D1810), width: 1.5),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: const Text(
                    'ULANGI KUIS',
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 0.5,
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

  String _getSeriesLabel() {
    if (widget.seriesTitle.contains('Jawa')) return 'SERI JAWA';
    if (widget.seriesTitle.contains('Sumatera')) return 'SERI SUMATERA';
    if (widget.seriesTitle.contains('Bali')) return 'SERI BALI';
    if (widget.seriesTitle.contains('Kalimantan')) return 'SERI KALIMANTAN';
    return 'SERI QUIZ';
  }
}
