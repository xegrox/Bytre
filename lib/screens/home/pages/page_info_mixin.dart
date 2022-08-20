import 'package:flutter/material.dart';

mixin PageInfoMixin on Widget {
  String get title;
  String get fabLabel;
  void fabAction(BuildContext context, TabController controller);
}