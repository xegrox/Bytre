import 'package:flutter/material.dart';

class SizeFadeTransition extends StatelessWidget {
  const SizeFadeTransition({
    required this.child,
    required this.animation,
    this.axis = Axis.vertical,
    Key? key
  }) : super(key: key);

  final Axis axis;
  final Widget child;
  final Animation<double> animation;
  
  @override
  Widget build(BuildContext context) => SizeTransition(
    axis: axis,
    sizeFactor: animation,
    child: FadeTransition(
      opacity: animation,
      child: child
    )
  );
}