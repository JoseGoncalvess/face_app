import 'package:flutter/material.dart';
import 'package:persona_app/src/home/home.dart';
import 'package:persona_app/src/spash/splash.dart';

class AppRoutes {
  // Nomes das Rotas
  static const String splash = '/';
  static const String home = '/home';

  static Map<String, WidgetBuilder> get routes {
    return {
      splash: (context) => const Splash(),
      home: (context) => const Home(),
    };
  }
}
