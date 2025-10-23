import 'dart:async';

import 'package:flutter/material.dart';
import 'package:persona_app/src/spash/splash.dart';

abstract class SplashViewModel extends State<Splash> {
  double opacityLevel = 0.0;
  final animationDuration = Duration(milliseconds: 1500);

  @override
  void initState() {
    super.initState();
    _startAnimationAndNavigation();
  }

  void _startAnimationAndNavigation() {
    const splashDuration = Duration(seconds: 3);

    Timer(const Duration(milliseconds: 100), () {
      if (mounted) {
        setState(() {
          opacityLevel = 1.0;
        });
      }
    });

    Timer(splashDuration, () {
      if (mounted) {
        Navigator.of(context).pushReplacementNamed('/home');
      }
    });
  }
}
