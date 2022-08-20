import 'package:bytre/models/storage.dart';
import 'package:bytre/repositories/storage/storage_native.dart';
import 'package:bytre/widgets/bottom_sheet.dart';
import 'package:bytre/widgets/tabler_icon.dart';
import 'package:flutter/material.dart';

class AddStorageBottomSheet extends StatelessWidget {

  const AddStorageBottomSheet({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AppBottomSheet(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          ListTile(
            leading: TablerIcon(TablerIcons.folder),
            title: const Text('Local'),
            onTap: () async {
              final result = await StorageRepositoryNative.init();
              final repository = result.item1;
              final name = result.item2;
              final storage = Storage()
                ..group = repository.defaultGroupName
                ..name = name
                ..repository = repository;
              Navigator.pop(context, storage);
            },
          ),
          ListTile(
            leading: TablerIcon(TablerIcons.cloud),
            title: const Text('SFTP'),
            onTap: () {},
          )
        ],
      )
    );
  }
}