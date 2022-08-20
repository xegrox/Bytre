import 'package:bytre/blocs/project/project_cubit.dart';
import 'package:bytre/widgets/filesystem_tree_explorer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SidePanel extends StatelessWidget {
  const SidePanel({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final project = context.read<ProjectCubit>();
    return Drawer(
      child: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 10),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
              child: Text(
                'File explorer',
                style: Theme.of(context).textTheme.headline6
              )
            ),
            Expanded(
              child: FilesystemTreeExplorer(
                cubit: project.explorer,
                onTapFile: (path) {
                  project.editor.openTab(path);
                  Navigator.of(context).pop();
                },
              )
            )
          ]
        )
      )
    );
  }

}