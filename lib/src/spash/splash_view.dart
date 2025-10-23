import 'package:flutter/material.dart';
import 'package:persona_app/core/utils/const.dart';
import 'package:persona_app/src/spash/splash_view_model.dart';

class SplashView extends SplashViewModel {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: primaryColor,
      body: Center(
        child: AnimatedOpacity(
          opacity: opacityLevel,
          duration: animationDuration,
          curve: Curves.easeIn,
          child: const Text(
            'face app',
            style: TextStyle(
              fontSize: 48,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
        ),
      ),
    );
  }
}
