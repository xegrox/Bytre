import 'package:bytre/widgets/transitions/slide_fade_transition.dart';
import 'package:flutter/material.dart';

class SlideTransitionPage<T> extends Page<T> {
  const SlideTransitionPage({required this.child});

  final Widget child;

  @override
  Route<T> createRoute(BuildContext context) => PageRouteBuilder(
    settings: this,
    pageBuilder: (context, animation, secondaryAnimation) => child,
    transitionsBuilder: (context, animation, secondaryAnimation, child) {
      final anim = CurvedAnimation(parent: animation, curve: Curves.easeOutCubic);
      final secAnim = CurvedAnimation(parent: secondaryAnimation, curve: Curves.easeOutCubic);
      return SlideFadeTransition(
        slideDirection: SlideDirection.rightIn,
        animation: anim,
        child: SlideFadeTransition(
          slideDirection: SlideDirection.leftOut,
          animation: secAnim,
          child: child
        )
      );
    }
  );

}