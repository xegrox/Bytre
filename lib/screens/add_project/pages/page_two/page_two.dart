import 'package:bytre/screens/add_project/add_project_cubit.dart';
import 'package:bytre/utils/next_page_mixin.dart';
import 'package:bytre/widgets/expansion_tile.dart';
import 'package:bytre/widgets/selectable_tile.dart';
import 'package:bytre/widgets/sorted_storages_animated_list.dart';
import 'package:bytre/widgets/underlined_title.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../page_three/page_three.dart';

class AddProjectPageTwo extends StatelessWidget with NextPage {
  const AddProjectPageTwo(this.cubit, {Key? key}) : super(key: key);

  final AddProjectCubit cubit;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 12),
          child: UnderlinedTitle(
            title: Text(
              'Select a storage',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)
            )
          )
        ),
        const SizedBox(height: 20),
        Expanded(
          child: SortedStoragesAnimatedList(
            groupBuilder: (context, child, group) => AppExpansionTile(
              initiallyExpanded: true,
              title: Text(group, style: TextStyle(color: Theme.of(context).textTheme.caption!.color)),
              child: child,
            ),
            storageBuilder: (context, storage) => BlocBuilder(
              bloc: cubit,
              buildWhen: (_, state) => state is AddProjectStorageSelected,
              builder: (context, state) => SelectableTile(
                selected: cubit.selectedStorage == storage,
                title: Text(storage.name),
                onTap: () => cubit.selectedStorage = storage,
              )
            )
          )
        )
      ]
    );
  }

  @override
  Future<NextPage?> nextPage() async => AddProjectPageThree(cubit);
}