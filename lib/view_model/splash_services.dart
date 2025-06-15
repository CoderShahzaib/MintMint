import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mindmint/utils/routes/routes_name.dart';

class SplashServices {
  late final AnimationController _animationController;
  late final Animation<double> fadeAnimation;
  final Ref ref;

  SplashServices(this.ref);

  void initializeAnimation(TickerProvider vsync) {
    _animationController = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: vsync,
    );

    fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeIn),
    );

    _animationController.forward();
  }

  void moveToHome(BuildContext context) {
    Future.delayed(const Duration(seconds: 3), () {
      if (context.mounted) {
        Navigator.pushReplacementNamed(context, RoutesName.home);
      }
    });
  }

  void dispose() {
    _animationController.dispose();
  }
}

final splashServicesProvider = Provider((ref) => SplashServices(ref));
