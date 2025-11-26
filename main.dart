import 'package:flutter/material.dart';
import 'screens/login.dart';
import 'screens/dashboard.dart';
import 'screens/production_form.dart';
import 'screens/qc_form.dart';
import 'screens/ai_chat.dart';
import 'screens/ocr_review.dart';
import 'screens/settings.dart';

void main() {
  runApp(GraniteBotApp());
}

class GraniteBotApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'GraniteBot',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: LoginScreen(),
      routes: {
        '/dashboard': (context) => DashboardScreen(),
        '/production': (context) => ProductionFormScreen(),
        '/qc': (context) => QCFormScreen(),
        '/chat': (context) => AIChatScreen(),
        '/ocr': (context) => OCRReviewScreen(),
        '/settings': (context) => SettingsScreen(),
      },
    );
  }
}
