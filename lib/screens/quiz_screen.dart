import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'quiz_play_screen.dart';

class QuizScreen extends StatefulWidget {
  const QuizScreen({super.key});

  @override
  State<QuizScreen> createState() => _QuizScreenState();
}

class _QuizScreenState extends State<QuizScreen> {
  late List<Map<String, dynamic>> _quizSeries;

  @override
  void initState() {
    super.initState();
    _quizSeries = [
      {
        'title': 'Seri Tanah Jawa',
        'description':
            'Menguji pengetahuan tentang epos Mahabarata lokal, kisah Wali Songo, dan legenda Gunung Merapi.',
        'questions': '10 Pertanyaan',
        'difficulty': 'Menengah',
        'difficultyIcon': Icons.trending_up_rounded,
        'progress': 0.0,
        'color': const Color(0xFF8B4513),
      },
      {
        'title': 'Seri Sumatera',
        'description':
            'Kisah Malin Kundang, legenda Danau Toba, dan asal-usul Minangkabau.',
        'questions': '10 Pertanyaan',
        'difficulty': 'Mudah',
        'difficultyIcon': Icons.trending_down_rounded,
        'progress': 0.0,
        'color': const Color(0xFF4CAF50),
      },
      {
        'title': 'Bali & Nusa Tenggara',
        'description':
            'Pertempuran Barong, mitos Komodo, dan legenda Mandalika.',
        'questions': '10 Pertanyaan',
        'difficulty': 'Sulit',
        'difficultyIcon': Icons.warning_amber_rounded,
        'progress': 0.0,
        'color': const Color(0xFFE8734A),
      },
      {
        'title': 'Kalimantan Mistis',
        'description':
            'Legenda sungai Mahakam, mitos dayak, dan kisah kerajaan Kutai.',
        'questions': '10 Pertanyaan',
        'difficulty': 'Menengah',
        'difficultyIcon': Icons.trending_up_rounded,
        'progress': 0.0,
        'color': const Color(0xFF9C8474),
      },
      {
        'title': 'Legenda Sulawesi',
        'description':
            'Petualangan pahlawan Bugis Sawerigading mengarungi samudra menuju Tiongkok.',
        'questions': '10 Pertanyaan',
        'difficulty': 'Menengah',
        'difficultyIcon': Icons.trending_up_rounded,
        'progress': 0.0,
        'color': const Color(0xFF673AB7),
      },
      {
        'title': 'Ramayana & Asia Selatan',
        'description':
            'Kisah cinta abadi Sri Rama dan Dewi Sinta melawan raja raksasa Rahwana.',
        'questions': '10 Pertanyaan',
        'difficulty': 'Mudah',
        'difficultyIcon': Icons.trending_down_rounded,
        'progress': 0.0,
        'color': const Color(0xFFFF9800),
      },
    ];
    _loadQuizProgress();
  }

  Future<void> _loadQuizProgress() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final email = prefs.getString('current_user_email') ?? '';
      setState(() {
        for (var quiz in _quizSeries) {
          final title = quiz['title'] as String;
          quiz['progress'] = prefs.getDouble('quiz_progress_${email}_$title') ?? 0.0;
        }
      });
    } catch (_) {}
  }

  Future<void> _updateQuizProgress(Map<String, dynamic> quiz, double progress) async {
    setState(() {
      quiz['progress'] = progress;
    });
    try {
      final prefs = await SharedPreferences.getInstance();
      final email = prefs.getString('current_user_email') ?? '';
      if (email.isNotEmpty) {
        await prefs.setDouble('quiz_progress_${email}_${quiz['title']}', progress);
      }
    } catch (_) {}
  }

  void _showResetDialog(Map<String, dynamic> quiz) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: const Color(0xFFF5F0EB),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          title: Text(
            quiz['title'] as String,
            style: const TextStyle(
              fontFamily: 'Georgia',
              fontWeight: FontWeight.bold,
              color: Color(0xFF2D1810),
            ),
          ),
          content: const Text(
            'Anda telah menyelesaikan kuis ini. Apakah Anda ingin mengulang kuis ini untuk meningkatkan skor Anda?',
            style: TextStyle(color: Color(0xFF3D2E22)),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text(
                'Batal',
                style: TextStyle(color: Color(0xFF9C8474)),
              ),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
                _updateQuizProgress(quiz, 0.0);
                _startQuiz(quiz);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF2D1810),
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: const Text('Ulangi Kuis'),
            ),
          ],
        );
      },
    );
  }

  void _startQuiz(Map<String, dynamic> quiz) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => QuizPlayScreen(
          seriesTitle: quiz['title'] as String,
        ),
      ),
    ).then((result) {
      if (result != null && result is double) {
        _updateQuizProgress(quiz, result);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      padding: const EdgeInsets.fromLTRB(20, 8, 20, 100),
      itemCount: _quizSeries.length,
      itemBuilder: (context, index) {
        final quiz = _quizSeries[index];
        return _buildQuizCard(context, quiz);
      },
    );
  }

  Widget _buildQuizCard(BuildContext context, Map<String, dynamic> quiz) {
    final progress = quiz['progress'] as double;
    final isCompleted = progress >= 1.0;

    return GestureDetector(
      onTap: () {
        if (isCompleted) {
          _showResetDialog(quiz);
        } else {
          _startQuiz(quiz);
        }
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 16),
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: const Color(0xFF8B4513).withValues(alpha: 0.06),
              blurRadius: 12,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Title
            Text(
              quiz['title'] as String,
              style: const TextStyle(
                fontFamily: 'Georgia',
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Color(0xFF2D1810),
              ),
            ),
            const SizedBox(height: 8),

            // Description
            Text(
              quiz['description'] as String,
              style: const TextStyle(
                fontSize: 13,
                color: Color(0xFF8C7B6B),
                height: 1.5,
              ),
            ),
            const SizedBox(height: 14),

            // Meta info row
            Row(
              children: [
                // Questions count
                const Icon(
                  Icons.description_outlined,
                  size: 15,
                  color: Color(0xFF9C8474),
                ),
                const SizedBox(width: 5),
                Text(
                  quiz['questions'] as String,
                  style: const TextStyle(
                    fontSize: 12,
                    color: Color(0xFF9C8474),
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(width: 20),

                // Difficulty
                Icon(
                  quiz['difficultyIcon'] as IconData,
                  size: 15,
                  color: const Color(0xFF9C8474),
                ),
                const SizedBox(width: 5),
                Text(
                  quiz['difficulty'] as String,
                  style: const TextStyle(
                    fontSize: 12,
                    color: Color(0xFF9C8474),
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 14),

            // Progress bar
            Row(
              children: [
                Expanded(
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(4),
                    child: LinearProgressIndicator(
                      value: progress,
                      minHeight: 5,
                      backgroundColor: const Color(0xFFE8E0D8),
                      valueColor: AlwaysStoppedAnimation<Color>(
                        quiz['color'] as Color,
                      ),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),

            // Progress text
            Align(
              alignment: Alignment.centerRight,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  if (isCompleted)
                    const Padding(
                      padding: EdgeInsets.only(right: 6),
                      child: Icon(
                        Icons.check_circle_rounded,
                        color: Color(0xFF4CAF50),
                        size: 16,
                      ),
                    ),
                  Text(
                    isCompleted ? 'Selesai' : '${(progress * 100).toInt()}% Selesai',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: isCompleted
                          ? const Color(0xFF4CAF50)
                          : const Color(0xFF5C4033),
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
}
