import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: SplashScreen(),
    );
  }
}

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  Future<void> _initializeApp() async {
    // Simulate initialization tasks (e.g., fetching data, setting up services)
    await Future.delayed(Duration(seconds: 3));
  }

  @override
  void initState() {
    super.initState();
    _initializeApp().then((_) {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (context) => MyAppContent()),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      backgroundColor: Color(0xFF1E1E1E),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircularProgressIndicator(),
            SizedBox(height: 10),
            Text('Loading...', style: TextStyle(color: Colors.white)),
          ],
        ),
      ),
    );
  }
}

class MyAppContent extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF1E1E1E),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        title: const Text('My App', style: TextStyle(color: Colors.white)),
      ),
      body: const Center(
        child:
            Text('Welcome to My App!', style: TextStyle(color: Colors.white)),
      ),
    );
  }
}
