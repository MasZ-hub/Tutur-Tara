import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'screens/home_screen.dart';
import 'screens/login_screen.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.dark,
    ),
  );
  runApp(const TuturTaraApp());
}

class TuturTaraApp extends StatelessWidget {
  const TuturTaraApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Tutur-Tara',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        fontFamily: 'Roboto',
        scaffoldBackgroundColor: const Color(0xFFF5F0EB),
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF8B4513),
          surface: const Color(0xFFF5F0EB),
        ),
        appBarTheme: const AppBarTheme(
          backgroundColor: Color(0xFFF5F0EB),
          elevation: 0,
          centerTitle: true,
          titleTextStyle: TextStyle(
            fontFamily: 'Serif',
            fontSize: 22,
            fontWeight: FontWeight.bold,
            color: Color(0xFF2D1810),
          ),
          iconTheme: IconThemeData(color: Color(0xFF2D1810)),
        ),
      ),
      home: const _AuthGate(),
    );
  }
}

class _AuthGate extends StatefulWidget {
  const _AuthGate();

  @override
  State<_AuthGate> createState() => _AuthGateState();
}

class _AuthGateState extends State<_AuthGate> {
  bool? _isLoggedIn;

  @override
  void initState() {
    super.initState();
    _checkLoginStatus();
  }

  Future<void> _checkLoginStatus() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      setState(() {
        _isLoggedIn = prefs.getBool('is_logged_in') ?? false;
      });
    } catch (e) {
      setState(() {
        _isLoggedIn = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoggedIn == null) {
      return const Scaffold(
        body: Center(
          child: CircularProgressIndicator(
            valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF2D1810)),
          ),
        ),
      );
    }
    return _isLoggedIn! ? const HomeScreen() : const LoginScreen();
  }
}
