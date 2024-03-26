import 'package:flutter/material.dart';

// ignore: non_constant_identifier_names
Route SlideAnimationRoute({required Widget screen}) {
  return PageRouteBuilder(
    transitionDuration: const Duration(seconds: 1),
    pageBuilder: (context, animation, secondaryAnimation) => screen,
    transitionsBuilder: (context, animation, secondaryAnimation, child) {
      const begin = Offset(8.0, 0.0);
      const end = Offset(0.0, 0.0);
      const curve = Curves.ease;

      final tween = Tween(begin: begin, end: end);
      final curvedAnimation = CurvedAnimation(
        parent: animation,
        curve: curve,
      );

      return SlideTransition(
        position: tween.animate(curvedAnimation),
        child: child,
      );
    },
  );
}
