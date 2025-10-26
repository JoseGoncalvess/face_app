import 'dart:async';
import 'package:flutter/material.dart';
import 'package:persona_app/src/routes/app_routes.dart';
import 'package:persona_app/src/spash/splash.dart';

abstract class SplashViewModel extends State<Splash>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  late Animation<double> _scaleAnimation;

  Animation<double> get fadeAnimation => _fadeAnimation;
  Animation<double> get scaleAnimation => _scaleAnimation;
  @override
  void initState() {
    super.initState();

    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );

    _fadeAnimation = CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeIn,
    );

    _scaleAnimation = CurvedAnimation(
      parent: _animationController,
      reverseCurve: Curves.bounceIn,
      curve: Curves.easeOutBack,
    );

    _animationController.forward();

    _startNavigationTimer();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void _startNavigationTimer() {
    const splashDuration = Duration(seconds: 3);

    Timer(splashDuration, () {
      if (mounted && _animationController.status.isCompleted) {
        Navigator.of(context).pushReplacementNamed(AppRoutes.home);
      }
    });
  }
}
