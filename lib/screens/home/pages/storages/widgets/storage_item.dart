import 'package:bytre/styles.dart';
import 'package:bytre/widgets/expansion_tile.dart';
import 'package:bytre/widgets/tabler_icon.dart';
import 'package:flutter/material.dart';

class StorageItem extends StatelessWidget {
  const StorageItem({required this.name, required this.onRemove, Key? key}) : super(key: key);
  final String name;
  final void Function() onRemove;

  @override
  Widget build(BuildContext context) {
    final theme = context.appTheme;
    return Card(
      clipBehavior: Clip.antiAlias,
      child: AppExpansionTile(
        title: Text(name),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            OutlinedButton.icon(
              onPressed: onRemove,
              style: OutlinedButton.styleFrom(primary: theme.red),
              icon: TablerIcon(TablerIcons.trash, size: 18),
              label: const Text('Remove'),
              clipBehavior: Clip.antiAlias
            )
          ]
        )
      )
    );
  }
}