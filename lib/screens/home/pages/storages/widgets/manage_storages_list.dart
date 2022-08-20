import 'package:bytre/blocs/database/database_cubit.dart';
import 'package:bytre/widgets/expansion_tile.dart';
import 'package:bytre/widgets/sorted_storages_animated_list.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'storage_item.dart';

class ManageStoragesList extends StatelessWidget {
  const ManageStoragesList({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final database = context.read<DatabaseCubit>();
    return SortedStoragesAnimatedList(
      groupBuilder: (context, child, name) => AppExpansionTile(
        initiallyExpanded: true,
        title: Text(name, style: TextStyle(color: Theme.of(context).textTheme.caption!.color)),
        child: child
      ),
      storageBuilder: (context, storage) => StorageItem(
        key: UniqueKey(),
        name: storage.name,
        onRemove: () async {
          final projectCount = await storage.projects.count();
          final shouldRemove = await showDialog<bool>(
            context: context,
            builder: (_) => _ConfirmRemoveDialog(projectCount: projectCount)
          ) ?? false;
          if (shouldRemove == true) {
            await database.writeTxn(() async {
              await storage.projects.load();
              await database.projects.deleteAll(storage.projects.map((p) => p.id).toList());
              await database.storages.delete(storage.id);
            });
          }
        }
      )
    );
  }

}

class _ConfirmRemoveDialog extends StatelessWidget {
  const _ConfirmRemoveDialog({
    required this.projectCount,
    Key? key
  }) : super(key: key);

  final int projectCount;

  @override
  Widget build(BuildContext context) => AlertDialog(
    title: const Text('Remove storage?'),
    content: Text.rich(
      TextSpan(
        children: [
          if (projectCount > 0) TextSpan(children: [
            TextSpan(text: '$projectCount', style: const TextStyle(fontWeight: FontWeight.bold)),
            const TextSpan(text: ' associated project(s) will be removed.\n')
          ]),
          const TextSpan(text: 'Your files will not be deleted.')
        ]
      )
    ),
    actions: [
      TextButton(
          child: const Text('No'),
          onPressed: () => Navigator.of(context).pop(false)
      ),
      TextButton(
          child: const Text('Yes'),
          onPressed: () => Navigator.of(context).pop(true)
      )
    ],
  );
}