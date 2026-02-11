import 'package:flutter/material.dart';
import 'features/auth/presentation/pages/login_page.dart';
import 'features/home/presentation/pages/home_page.dart';
import 'features/about/presentation/pages/about_page.dart';

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: LoginPage(),
      routes: {
        '/home': (context) => const HomePage(),
        '/about': (context) => const AboutPage(),
      },
    );
  }
}
