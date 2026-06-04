import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  
  int _selectedAvatarIndex = 0;
  bool _obscurePassword = true;
  bool _isLoading = false;

  final List<Map<String, String>> _avatars = [
    {
      'name': 'Gatotkaca',
      'role': 'Satria Pringgadani',
      'initials': 'GK',
      'color': '0xFF8B4513',
    },
    {
      'name': 'Sinta',
      'role': 'Putri Setia',
      'initials': 'ST',
      'color': '0xFFE8734A',
    },
    {
      'name': 'Rama',
      'role': 'Ksatria Dharma',
      'initials': 'RM',
      'color': '0xFF2D1810',
    },
    {
      'name': 'Roro Jonggrang',
      'role': 'Putri Seribu Candi',
      'initials': 'RJ',
      'color': '0xFF9C8474',
    },
  ];

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _handleRegister() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    try {
      final prefs = await SharedPreferences.getInstance();
      final email = _emailController.text.trim().toLowerCase();

      // Periksa apakah email sudah terdaftar
      final existingPassword = prefs.getString('user_password_$email');
      if (existingPassword != null) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Email sudah terdaftar. Silakan gunakan email lain atau masuk.', style: TextStyle(fontFamily: 'Georgia')),
              backgroundColor: Color(0xFFEF5350),
            ),
          );
        }
        return;
      }
      
      // Simpan data pendaftaran secara lokal dengan prefix email
      await prefs.setString('user_name_$email', _nameController.text.trim());
      await prefs.setString('user_email_$email', email);
      await prefs.setString('user_password_$email', _passwordController.text);
      await prefs.setInt('user_avatar_$email', _selectedAvatarIndex);
      
      // Tandai bahwa ada akun yang terdaftar
      await prefs.setBool('is_registered', true);

      // Tambahkan email ke daftar email terdaftar (opsional namun baik untuk pelacakan)
      final List<String> registeredEmails = prefs.getStringList('registered_emails') ?? [];
      if (!registeredEmails.contains(email)) {
        registeredEmails.add(email);
        await prefs.setStringList('registered_emails', registeredEmails);
      }

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Pendaftaran berhasil! Silakan masuk.', style: TextStyle(fontFamily: 'Georgia')),
            backgroundColor: Color(0xFF4CAF50),
          ),
        );
        Navigator.pop(context); // Kembali ke halaman Login
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Gagal mendaftar: $e'),
            backgroundColor: const Color(0xFFEF5350),
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F0EB),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Tombol Kembali
                GestureDetector(
                  onTap: () => Navigator.pop(context),
                  child: const Icon(
                    Icons.arrow_back_rounded,
                    color: Color(0xFF2D1810),
                    size: 26,
                  ),
                ),
                const SizedBox(height: 20),

                // Judul Halaman
                const Text(
                  'Buat Akun Baru',
                  style: TextStyle(
                    fontFamily: 'Georgia',
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF2D1810),
                  ),
                ),
                const SizedBox(height: 8),
                const Text(
                  'Mulai petualangan menjelajahi dongeng nusantara bersamamu.',
                  style: TextStyle(
                    fontSize: 14,
                    color: Color(0xFF8C7B6B),
                    height: 1.5,
                  ),
                ),
                const SizedBox(height: 28),

                // PEMILIHAN AVATAR TRADISIONAL
                const Text(
                  'PILIH AVATAR BUDAYA',
                  style: TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 1.0,
                    color: Color(0xFF9C8474),
                  ),
                ),
                const SizedBox(height: 12),
                SizedBox(
                  height: 100,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: _avatars.length,
                    itemBuilder: (context, index) {
                      final avatar = _avatars[index];
                      final isSelected = _selectedAvatarIndex == index;
                      final colorVal = int.parse(avatar['color']!);

                      return GestureDetector(
                        onTap: () => setState(() => _selectedAvatarIndex = index),
                        child: Padding(
                          padding: const EdgeInsets.only(right: 14),
                          child: Column(
                            children: [
                              AnimatedContainer(
                                duration: const Duration(milliseconds: 200),
                                width: 56,
                                height: 56,
                                decoration: BoxDecoration(
                                  color: Color(colorVal).withValues(alpha: isSelected ? 1.0 : 0.15),
                                  shape: BoxShape.circle,
                                  border: Border.all(
                                    color: isSelected
                                        ? const Color(0xFFE8734A)
                                        : Colors.transparent,
                                    width: 2.5,
                                  ),
                                  boxShadow: isSelected
                                      ? [
                                          BoxShadow(
                                            color: const Color(0xFFE8734A).withValues(alpha: 0.3),
                                            blurRadius: 8,
                                            offset: const Offset(0, 3),
                                          )
                                        ]
                                      : [],
                                ),
                                child: Center(
                                  child: Text(
                                    avatar['initials']!,
                                    style: TextStyle(
                                      fontFamily: 'Georgia',
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                      color: isSelected ? Colors.white : Color(colorVal),
                                    ),
                                  ),
                                ),
                              ),
                              const SizedBox(height: 6),
                              Text(
                                avatar['name']!,
                                style: TextStyle(
                                  fontSize: 12,
                                  fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
                                  color: isSelected
                                      ? const Color(0xFF2D1810)
                                      : const Color(0xFF8C7B6B),
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),
                const SizedBox(height: 16),

                // INPUT NAMA LENGKAP
                _buildTextFieldLabel('NAMA LENGKAP'),
                TextFormField(
                  controller: _nameController,
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'Nama lengkap tidak boleh kosong';
                    }
                    return null;
                  },
                  decoration: _buildInputDecoration(
                    hint: 'Masukkan nama lengkap Anda',
                    icon: Icons.person_outline_rounded,
                  ),
                  style: const TextStyle(color: Color(0xFF2D1810)),
                ),
                const SizedBox(height: 18),

                // INPUT EMAIL
                _buildTextFieldLabel('ALAMAT EMAIL'),
                TextFormField(
                  controller: _emailController,
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'Email tidak boleh kosong';
                    }
                    if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(value.trim())) {
                      return 'Masukkan alamat email yang valid';
                    }
                    return null;
                  },
                  keyboardType: TextInputType.emailAddress,
                  decoration: _buildInputDecoration(
                    hint: 'contoh@email.com',
                    icon: Icons.mail_outline_rounded,
                  ),
                  style: const TextStyle(color: Color(0xFF2D1810)),
                ),
                const SizedBox(height: 18),

                // INPUT KATA SANDI
                _buildTextFieldLabel('KATA SANDI'),
                TextFormField(
                  controller: _passwordController,
                  obscureText: _obscurePassword,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Kata sandi tidak boleh kosong';
                    }
                    if (value.length < 6) {
                      return 'Kata sandi minimal 6 karakter';
                    }
                    return null;
                  },
                  decoration: _buildInputDecoration(
                    hint: 'Minimal 6 karakter',
                    icon: Icons.lock_outline_rounded,
                    suffix: IconButton(
                      icon: Icon(
                        _obscurePassword
                            ? Icons.visibility_off_outlined
                            : Icons.visibility_outlined,
                        color: const Color(0xFF9C8474),
                        size: 20,
                      ),
                      onPressed: () {
                        setState(() {
                          _obscurePassword = !_obscurePassword;
                        });
                      },
                    ),
                  ),
                  style: const TextStyle(color: Color(0xFF2D1810)),
                ),
                const SizedBox(height: 36),

                // TOMBOL DAFTAR
                SizedBox(
                  width: double.infinity,
                  height: 52,
                  child: ElevatedButton(
                    onPressed: _isLoading ? null : _handleRegister,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF2D1810),
                      foregroundColor: Colors.white,
                      disabledBackgroundColor: const Color(0xFF2D1810).withValues(alpha: 0.4),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14),
                      ),
                      elevation: 0,
                    ),
                    child: _isLoading
                        ? const SizedBox(
                            width: 24,
                            height: 24,
                            child: CircularProgressIndicator(
                              strokeWidth: 2.5,
                              valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                            ),
                          )
                        : const Text(
                            'DAFTAR SEKARANG',
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                              letterSpacing: 1.0,
                            ),
                          ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTextFieldLabel(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0, left: 4.0),
      child: Text(
        text,
        style: const TextStyle(
          fontSize: 11,
          fontWeight: FontWeight.bold,
          letterSpacing: 1.0,
          color: Color(0xFF9C8474),
        ),
      ),
    );
  }

  InputDecoration _buildInputDecoration({
    required String hint,
    required IconData icon,
    Widget? suffix,
  }) {
    return InputDecoration(
      hintText: hint,
      hintStyle: TextStyle(
        color: Colors.grey.shade400,
        fontSize: 14,
      ),
      prefixIcon: Icon(
        icon,
        color: const Color(0xFF9C8474),
        size: 20,
      ),
      suffixIcon: suffix,
      filled: true,
      fillColor: Colors.white,
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: const BorderSide(color: Color(0xFFD4C5B5), width: 0.8),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: const BorderSide(color: Color(0xFFD4C5B5), width: 0.8),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: const BorderSide(color: Color(0xFFE8734A), width: 1.5),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: const BorderSide(color: Color(0xFFEF5350), width: 1.0),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: const BorderSide(color: Color(0xFFEF5350), width: 1.5),
      ),
    );
  }
}
