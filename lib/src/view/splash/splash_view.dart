import 'package:flutter/material.dart';
import 'package:intagrations_apis_and_graphql/src/data/datasource/check_network.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
class SplashView extends StatefulWidget {
  const SplashView({super.key});

  @override
  State<SplashView> createState() => _SplashViewState();
}
class _SplashViewState extends State<SplashView> {
    
  final CheckNetwork _checkNetwork = CheckNetwork(Connectivity());
  @override
  initState() {
    super.initState();
    _checkConnectivity();
  }
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _checkConnectivity();
  }
  Future<void> _checkConnectivity() async {
    bool isConnected = await _checkNetwork.isConnected();
    if (!isConnected) {
      _showRetryDialog();
    } else {
      _navigateToHome();
    }
  }

  void _showRetryDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        title: Text('No Internet Connection'),
        content: Text('Please check your connection and try again.'),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              _checkConnectivity();
            },
            child: Text('Retry'),
          ),
        ],
      ),
    );
  }
  void _navigateToHome() async {
    await Future.delayed(const Duration(seconds: 9), () {});
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