import 'package:bytre/blocs/database/database_cubit.dart';
import 'package:bytre/models/storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../page_info_mixin.dart';
import 'widgets/add_storage_bottom_sheet.dart';
import 'widgets/manage_storages_list.dart';

class StoragesPage extends StatefulWidget with PageInfoMixin {

  const StoragesPage({Key? key}) : super(key: key);

  @override
  String get title => 'Storages';

  @override
  String get fabLabel => 'Add storage';

  @override
  Future<void> fabAction(BuildContext context, TabController controller) async {
    final storages = context.read<DatabaseCubit>().storages;
    final storage = await showModalBottomSheet<Storage>(
      context: context,
      builder: (_) => const AddStorageBottomSheet()
    );
    if (storage != null) {
      storages.putTxn(storage);
    }
  }

  @override
  State<StatefulWidget> createState() => _StoragesPageState();
}

class _StoragesPageState extends State<StoragesPage> with AutomaticKeepAliveClientMixin {

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return const ManageStoragesList();
  }

  @override
  bool get wantKeepAlive => true;
}
