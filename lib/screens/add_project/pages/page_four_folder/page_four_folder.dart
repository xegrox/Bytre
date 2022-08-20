import 'package:bytre/blocs/storage/storage_cubit.dart';
import 'package:bytre/screens/add_project/add_project_cubit.dart';
import 'package:bytre/utils/next_page_mixin.dart';
import 'package:bytre/widgets/filesystem_tree_picker.dart';
import 'package:bytre/widgets/underlined_title.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AddProjectPageFourFolder extends StatefulWidget with FinalPage {
  const AddProjectPageFourFolder(this.cubit, this.storageCubit, {Key? key}) : super(key: key);

  final AddProjectCubit cubit;
  final StorageCubit storageCubit;

  @override
  State<StatefulWidget> createState() => AddProjectPageFourFolderState();
}

class AddProjectPageFourFolderState extends State<AddProjectPageFourFolder> {

  @override
  void dispose() {
    super.dispose();
    widget.storageCubit.close();
  }

  @override
  Widget build(BuildContext context) {
    return Flex(
      crossAxisAlignment: CrossAxisAlignment.start,
      direction: Axis.vertical,
      children: [
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 12),
          child: UnderlinedTitle(
            title: Text(
              'Select project folder',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)
            )
          )
        ),
        const SizedBox(height: 30),
        Expanded(
          child: SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            child: BlocProvider(
              create: (_) => StorageCubit(widget.cubit.selectedStorage),
              child: Builder(
                builder: (context) => FilesystemTreePicker(
                  storage: widget.storageCubit,
                  onSelect: (path) => widget.cubit.path = path,
                )
              )
            )
          )
        )
      ]
    );
  }
}