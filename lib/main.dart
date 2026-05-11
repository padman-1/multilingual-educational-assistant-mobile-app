import 'package:flutter/material.dart';
import 'package:multilingual_educational_assitant_mobile_app/features/home/presentation/home_screen.dart';
import 'package:multilingual_educational_assitant_mobile_app/shared/utils/theme.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: appTheme,
      home: HomeScreen(),
    );
  }
}
