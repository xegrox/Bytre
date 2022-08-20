import 'package:flutter/material.dart';

enum SlideDirection {
  rightIn,
  leftOut
}

class SlideFadeTransition extends StatelessWidget {
  const SlideFadeTransition({
    required this.slideDirection,
    required this.animation,
    required this.child,
    Key? key}) : super(key: key);

  final SlideDirection slideDirection;
  final Animation<double> animation;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    final fadeInTween = Tween<double>(begin: 0, end: 1);
    final fadeOutTween = Tween<double>(begin: 1, end: 0);
    late final Tween<double> fadeTween;
    late final Tween<Offset> slideTween;
    switch (slideDirection) {
      case SlideDirection.rightIn:
        fadeTween = fadeInTween;
        slideTween = Tween<Offset>(begin: const Offset(1, 0), end: Offset.zero);
        break;
      case SlideDirection.leftOut:
        fadeTween = fadeOutTween;
        slideTween = Tween<Offset>(begin: Offset.zero, end: const Offset(-1, 0));
        break;
    }
    return FadeTransition(
      opacity: fadeTween.animate(animation),
      child: SlideTransition(
        position: slideTween.animate(animation),
        child: child
      )
    );
  }
}