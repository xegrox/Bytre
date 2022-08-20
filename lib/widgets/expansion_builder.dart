import 'package:bytre/widgets/tabler_icon.dart';
import 'package:flutter/material.dart';

const _duration = Duration(milliseconds: 200);

class ExpansionBuilder extends StatelessWidget {
  const ExpansionBuilder({
    required this.expanded,
    required this.builder,
    required this.child,
    this.loading = false,
    this.iconTurns,
    this.iconSize = 20,
    Key? key
  }) : super(key: key);


  final bool expanded;
  final Widget Function(BuildContext context, Widget icon) builder;
  final Widget child;
  final bool loading;
  final Tween<double>? iconTurns;
  final double iconSize;

  Widget _buildIcon(Color color) => AnimatedSwitcher(
      duration: const Duration(milliseconds: 200),
      child: loading ? SizedBox(
        width: iconSize,
        height: iconSize,
        child: CircularProgressIndicator(
          color: color,
          strokeWidth: 2,
        )
      ): AnimatedRotation(
        duration: _duration,
        turns: expanded ? (iconTurns?.end ?? -0.5) : (iconTurns?.begin ?? 0),
        child: TablerIcon(
          TablerIcons.chevron_down,
          color: color.withOpacity(0.5),
          size: iconSize
        )
      )
  );

  @override
  Widget build(BuildContext context) {
    final color = Theme.of(context).textTheme.caption!.color!;
    return Column(
      children: [
        builder(context, _buildIcon(color)),
        ClipRect(
          child: AnimatedAlign(
            alignment: Alignment.center,
            curve: Curves.easeIn,
            duration: _duration,
            heightFactor: expanded ? 1 : 0,
            child: child,
          )
        )
      ]
    );
  }
}