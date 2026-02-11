import 'package:flutter/material.dart';
import 'package:auth_app/src/core/config/app_env.dart';
import 'package:auth_app/src/core/services/auth_service.dart';
import 'package:auth_app/src/features/auth/presentation/pages/login_page.dart';
import 'package:auth_app/src/core/widgets/app_button.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    Future<void> handleLogout() async {
      await AppEnv.init();
      final authService = AuthService(baseUrl: AppEnv.baseUrl);
      await authService.logout();
      if (!context.mounted) return;
      Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(builder: (_) => const LoginPage()),
        (route) => false,
      );
    }

    return Scaffold(
      appBar: AppBar(title: const Text('Home')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                'Welcome to the Home Page!',
                style: TextStyle(fontSize: 24),
              ),
              const SizedBox(height: 16),
              const Text(
                'You have successfully logged in.',
                style: TextStyle(fontSize: 16),
              ),
              const SizedBox(height: 32),
              AppButton(
                label: 'About',
                onPressed: () {
                  Navigator.of(context).pushNamed('/about');
                },
              ),
              const SizedBox(height: 32),
              Align(
                alignment: Alignment.center,
                child: AppButton(
                  label: 'Logout',
                  onPressed: handleLogout,
                  backgroundColor: const Color(0xFFDC2626),
                  disabledColor: const Color(0xFFFCA5A5),
                ),
              ),
              const SizedBox(height: 16),
            ],
          ),
        ),
      ),
    );
  }
}
