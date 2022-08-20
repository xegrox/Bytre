import 'package:bytre/widgets/expansion_builder.dart';
import 'package:flutter/material.dart';

class AppExpansionTile extends StatefulWidget {
  const AppExpansionTile({
    required this.child,
    required this.title,
    this.subtitle,
    this.childrenPadding = const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
    this.initiallyExpanded = false,
    Key? key
  }) : super(key: key);

  final Widget child;
  final Widget title;
  final Widget? subtitle;
  final EdgeInsets childrenPadding;
  final bool initiallyExpanded;

  @override
  State<StatefulWidget> createState() => _AppExpansionTileState();
}

class _AppExpansionTileState extends State<AppExpansionTile> {
  
  late bool isExpanded = widget.initiallyExpanded;
  
  @override
  Widget build(BuildContext context) {
    return ExpansionBuilder(
      expanded: isExpanded,
      child: Padding(
        padding: widget.childrenPadding,
        child: widget.child
      ),
      builder: (context, icon) => ListTile(
        title: widget.title,
        subtitle: widget.subtitle,
        trailing: icon,
        onTap: () => setState(() => isExpanded = !isExpanded),
      )
    );
  }
}