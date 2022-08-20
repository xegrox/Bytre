import 'package:bytre/styles.dart';
import 'package:flutter/material.dart';

class UnderlinedTitle extends StatelessWidget {
  const UnderlinedTitle({required this.title, Key? key}) : super(key: key);

  final Widget title;

  @override
  Widget build(BuildContext context) {
    final theme = context.appTheme;
    return Stack(
      children: [
        Positioned(
          height: 4,
          bottom: 0,
          right: 0,
          left: 0,
          child: CustomPaint(
            painter: _UnderlinePainter(theme.primary, theme.accent)
          )
        ),
        Padding(
          padding: const EdgeInsets.only(bottom: 5),
          child: title
        ),
      ]
    );
  }

}

class _UnderlinePainter extends CustomPainter {

  _UnderlinePainter(this.start, this.stop);

  final Color start;
  final Color stop;

  @override
  void paint(Canvas canvas, Size size) {
    final path = Path();
    path.moveTo(0, 0);
    path.lineTo(size.width, 0);
    path.lineTo(size.width, size.height);
    path.lineTo(0, size.height);
    path.close();

    final rect = Offset.zero & size;
    final gradient = LinearGradient(
      begin: Alignment.centerLeft,
      end: Alignment.centerRight,
      colors: [start, stop]
    );

    canvas.drawPath(
      path,
      Paint()..shader = gradient.createShader(rect),
    );

  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}