import 'package:bytre/styles.dart';
import 'package:flutter/material.dart';

class AppBottomSheet extends StatelessWidget {
  const AppBottomSheet({required this.child, Key? key}) : super(key: key);

  final Widget child;

  @override
  Widget build(BuildContext context) {
    final theme = context.appTheme;
    return Material(
      type: MaterialType.card,
      borderRadius: BorderRadius.vertical(top: theme.borderRadius),
      child: SafeArea(child: child)
    );
  }
}