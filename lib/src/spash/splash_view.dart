import 'package:face_app/core/utils/const.dart';
import 'package:face_app/src/spash/splash_view_model.dart';
import 'package:flutter/material.dart';

class SplashView extends SplashViewModel {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: primaryColor,
      body: Center(
        child: ScaleTransition(
          scale: scaleAnimation,
          child: FadeTransition(
            opacity: fadeAnimation,
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
      ),
    );
  }
}
