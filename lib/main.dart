import 'package:flutter/material.dart';
import 'screens/home_screen.dart';
import 'theme/app_theme.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MetaFinApp());
}

class MetaFinApp extends StatelessWidget {
  const MetaFinApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'MetaFin - Jardín Botánico Financiero',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.gardenTheme,
      home: const HomeScreen(),
    );
  }
}
