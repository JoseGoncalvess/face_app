import 'package:flutter/material.dart';
import 'package:face_app/src/details/details.dart';
import 'package:face_app/src/home/home.dart';
import 'package:face_app/src/spash/splash.dart';

class AppRoutes {
  static const String splash = '/';
  static const String home = '/home';
  static const String details = "/details";
  static Map<String, WidgetBuilder> get routes {
    return {
      splash: (context) => const Splash(),
      home: (context) => const Home(),
      details: (context) {
        return Details();
      },
    };
  }
}
