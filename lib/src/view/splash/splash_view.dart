import 'package:flutter/material.dart';

class SplashView extends StatefulWidget {
  const SplashView({super.key});

  @override
  State<SplashView> createState() => _SplashViewState();
}
class _SplashViewState extends State<SplashView> {
  initState() {
    super.initState();
    _navigateToHome();
  }
  void _navigateToHome() async {
    await Future.delayed(const Duration(seconds: 2), () {});
    Navigator.pushReplacementNamed(context, '/home');
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              'Welcome to the Database Integrations App',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            const CircularProgressIndicator(),
          ],
        ),
      ),
    );
  }
}