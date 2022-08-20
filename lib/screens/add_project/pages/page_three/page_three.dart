import 'package:bytre/blocs/storage/storage_cubit.dart';
import 'package:bytre/screens/add_project/add_project_cubit.dart';
import 'package:bytre/screens/add_project/pages/page_four_folder/page_four_folder.dart';
import 'package:bytre/utils/next_page_mixin.dart';
import 'package:bytre/widgets/selectable_tile.dart';
import 'package:bytre/widgets/tabler_icon.dart';
import 'package:bytre/widgets/underlined_title.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../page_four_git/page_four_git.dart';

class AddProjectPageThree extends StatelessWidget with NextPage {
  AddProjectPageThree(this.cubit, {Key? key}) : super(key: key);

  final AddProjectCubit cubit;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder(
      bloc: cubit,
      buildWhen: (_, current) => current is AddProjectMethodSelected,
      builder: (_, __) => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 12),
            child: UnderlinedTitle(
              title: Text(
                'Select method',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)
              )
            )
          ),
          const SizedBox(height: 30),
          SelectableTile(
            selected: cubit.method == AddProjectMethod.folder,
            horizontalTitleGap: 5,
            leading: SizedBox(
              height: double.infinity,
              child: TablerIcon(TablerIcons.folder)
            ),
            title: const Text('Open folder'),
            subtitle: const Text('Open project from existing folder'),
            onTap: () => cubit.method = AddProjectMethod.folder,
          ),
          const SizedBox(height: 10),
          SelectableTile(
            selected: cubit.method == AddProjectMethod.git,
            horizontalTitleGap: 5,
            leading: SizedBox(
                height: double.infinity,
                child: TablerIcon(TablerIcons.git_fork)
            ),
            title: const Text('Git clone'),
            subtitle: const Text('Clone project from git repository'),
            onTap: () => cubit.method = AddProjectMethod.git,
          )
        ],
      )
    );
  }

  @override
  Future<NextPage?> nextPage() async {
    switch (cubit.method) {
      case AddProjectMethod.folder:
        final storageCubit = StorageCubit(cubit.selectedStorage);
        // TODO: display loading in fab
        await storageCubit.open();
        return AddProjectPageFourFolder(cubit, storageCubit);
      case AddProjectMethod.git:
        return AddProjectPageFourGit(cubit);
    }
  }

}