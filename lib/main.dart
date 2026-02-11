import 'src/app.dart';
import 'package:flutter/material.dart';
import 'package:auth_app/src/core/config/app_env.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await AppEnv.init();
  runApp(const App());
}
