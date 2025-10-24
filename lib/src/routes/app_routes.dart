import 'package:flutter/material.dart';
import 'package:persona_app/core/models/user.dart';
import 'package:persona_app/src/details/details.dart';
import 'package:persona_app/src/home/home.dart';
import 'package:persona_app/src/spash/splash.dart';

class AppRoutes {
  // Nomes das Rotas
  static const String splash = '/';
  static const String home = '/home';
  static const String details = "/details";
  static Map<String, WidgetBuilder> get routes {
    return {
      splash: (context) => const Splash(),
      home: (context) => const Home(),
      details: (context) {
        final currentUser = ModalRoute.of(context)!.settings.arguments as User;
        return Details(currentUser: currentUser);
      },
    };
  }
}
