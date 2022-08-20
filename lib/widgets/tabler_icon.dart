import 'package:flutter/material.dart';
export 'package:flutter_tabler_icons/flutter_tabler_icons.dart';

class TablerIcon extends Container {
  TablerIcon(IconData icon, {Key? key, double? size, Color? color}) : super(
    key: key,
    margin: const EdgeInsets.only(bottom: 4),
    child: Icon(icon, size: size, color: color)
  );
}