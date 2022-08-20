import 'package:bytre/blocs/database/database_cubit.dart';
import 'package:bytre/models/storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:implicitly_animated_list/implicitly_animated_list.dart';
import 'package:isar/isar.dart';

class SortedStoragesAnimatedList extends StatelessWidget {
  const SortedStoragesAnimatedList({
    required this.groupBuilder,
    required this.storageBuilder,
    Key? key
  }) : super(key: key);

  final Widget Function(BuildContext context, Widget child, String group) groupBuilder;
  final Widget Function(BuildContext context, Storage storage) storageBuilder;

  @override
  Widget build(BuildContext context) {
    final storages = context.read<DatabaseCubit>().storages;
    return StreamBuilder<List<String>>(
      stream: storages.where().anyGroup().groupProperty().watch(initialReturn: true),
      builder: (_, snapshot) {
        if (!snapshot.hasData) return Container();
        final groups = snapshot.requireData;
        return ImplicitlyAnimatedList<String>(
          physics: const BouncingScrollPhysics(),
          itemData: groups,
          itemBuilder: (context, group) {
            final child = StreamBuilder<List<Storage>>(
              stream: storages.filter().groupEqualTo(group).build().watch(initialReturn: true),
              builder: (_, snapshot) {
                if (!snapshot.hasData) return Container();
                return ImplicitlyAnimatedList(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemData: snapshot.requireData,
                  itemBuilder: storageBuilder
                );
              }
            );
            return groupBuilder(context, child, group);
          }
        );
      }
    );
  }
}
