import 'package:bytre/blocs/database/database_cubit.dart';
import 'package:bytre/models/project.dart';
import 'package:bytre/widgets/bottom_sheet.dart';
import 'package:bytre/widgets/tabler_icon.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ProjectInfoBottomSheet extends StatelessWidget {
  const ProjectInfoBottomSheet({
    required this.project,
    Key? key
  }) : super(key: key);

  final Project project;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final titleTextTheme = textTheme.bodyText1!.copyWith(color: textTheme.caption!.color);
    final projects = context.read<DatabaseCubit>().projects;
    final storage = project.storage.get()!;
    return AppBottomSheet(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Padding(
            padding: const EdgeInsets.all(20),
            child: Container(
              clipBehavior: Clip.antiAlias,
              foregroundDecoration: BoxDecoration(
                borderRadius: const BorderRadius.all(
                  Radius.circular(10)),
                gradient: LinearGradient(
                  colors: [
                    Colors.transparent,
                    Colors.black.withOpacity(0.1)
                  ],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  stops: const [0.8, 1]
                )
              ),
              decoration: const BoxDecoration(
                borderRadius: BorderRadius.all(Radius.circular(10)),
              ),
              child: AspectRatio(
                aspectRatio: 3 / 2,
                child: Stack(
                  children: [
                    if (project.image == null) Container(color: Colors.grey)
                    else Image.memory(project.image!),
                    Align(
                      alignment: Alignment.bottomLeft,
                      child: Padding(
                        padding: const EdgeInsets.all(10),
                        child: Text(project.name, style: textTheme.headline5)
                      )
                    )
                  ]
                )
              )
            )
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 30),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Description', style: titleTextTheme),
                const SizedBox(height: 10),
                Text(project.description, style: textTheme.bodyText1),
                const SizedBox(height: 25),
                Text('Properties', style: titleTextTheme),
                const SizedBox(height: 10),
                Table(
                  children: {
                    'Storage': '[${storage.group}] ${storage.name}',
                    'Path': storage.repository.getDisplayPath(project.path),
                    'Last opened': '1 December 2020',
                  }.entries.map((e) => TableRow(
                    children: [
                      Text(e.key),
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 3),
                        child: Text(e.value, style: titleTextTheme)
                      )
                    ]
                  )).toList()
                ),
                const SizedBox(height: 20)
              ]
            )
          ),
          const Divider(),
          ListTile(
            leading: TablerIcon(TablerIcons.pencil),
            title: const Text('Edit'),
            onTap: () {},
          ),
          ListTile(
            leading: TablerIcon(TablerIcons.trash),
            title: const Text('Remove'),
            onTap: () async {
              final shouldRemove = await showDialog<bool>(
                  context: context,
                  builder: (_) => const _ConfirmRemoveDialog()
              ) ?? false;
              if (shouldRemove) {
                Navigator.of(context).pop();
                projects.delete(project.id);
              }
            },
          )
        ]
      )
    );
  }
}

class _ConfirmRemoveDialog extends StatelessWidget {
  const _ConfirmRemoveDialog({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) => AlertDialog(
    title: const Text('Remove project?'),
    content: const Text('Your files will not be deleted.'),
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