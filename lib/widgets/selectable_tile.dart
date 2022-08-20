import 'package:bytre/styles.dart';
import 'package:flutter/material.dart';

class SelectableTile extends StatelessWidget {
  const SelectableTile({
    required this.title,
    this.selected = false,
    this.subtitle,
    this.leading,
    this.horizontalTitleGap,
    this.trailing,
    this.background,
    this.onTap,
    Key? key}) : super(key: key);

  final bool selected;
  final Function()? onTap;
  final Widget title;
  final Widget? subtitle;
  final Widget? leading;
  final double? horizontalTitleGap;
  final Color? background;
  final Widget? trailing;

  @override
  Widget build(BuildContext context) {
    final theme = context.appTheme;
    final cardBg = CardTheme.of(context).color ?? theme.elevatedBackground;
    final selectedBg = Color.alphaBlend(theme.accent.withOpacity(0.1), cardBg);
    return Card(
      color: selected ? selectedBg : background,
        shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.all(theme.borderRadius),
        side: selected ? BorderSide(
          color: theme.accent,
          width: 2
        ) : BorderSide.none
      ),
      child: InkWell(
        borderRadius: BorderRadius.all(theme.borderRadius),
        onTap: onTap,
        child: ListTile(
          leading: leading,
          horizontalTitleGap: horizontalTitleGap,
          title: title,
          subtitle: subtitle,
          trailing: trailing,
        )
      )
    );
  }

}