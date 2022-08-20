import 'package:bytre/blocs/dynamic_tree/filesystem_tree_cubit.dart';
import 'package:bytre/blocs/storage/storage_cubit.dart';
import 'package:bytre/models/tree_node.dart';
import 'package:bytre/widgets/dynamic_tree_view.dart';
import 'package:bytre/widgets/expansion_builder.dart';
import 'package:bytre/widgets/filesystem_icon_theme.dart';
import 'package:bytre/widgets/selectable_tile.dart';
import 'package:flutter/material.dart';

class FilesystemTreePicker extends StatefulWidget {
  const FilesystemTreePicker({
    required this.storage,
    this.onSelect,
    Key? key
  }) : super(key: key);

  final StorageCubit storage;
  final Function(String path)? onSelect;

  @override
  State<StatefulWidget> createState() => FilesystemTreePickerState();
}

class FilesystemTreePickerState extends State<FilesystemTreePicker> {

  late final ValueNotifier<String> _selectedPath;
  late FilesystemTreeCubit _cubit;

  String get selectedPath => _selectedPath.value;

  @override
  void initState() {
    super.initState();
    _cubit = FilesystemTreeCubit(widget.storage);
    _selectedPath = ValueNotifier(_cubit.root.data);
    _selectedPath.addListener(() => widget.onSelect?.call(_selectedPath.value));
  }

  Widget _buildLeaf(BuildContext context, TreeLeaf<String> leaf) {
    return ValueListenableBuilder(
      valueListenable: _selectedPath,
      builder: (context, selectedPath, _) => SelectableTile(
        selected: selectedPath == leaf.data,
        leading: FilesystemIconTheme.file(leaf.name),
        horizontalTitleGap: 5,
        background: Colors.transparent,
        title: Text(leaf.name),
      )
    );
  }

  Widget _buildBranch(BuildContext context, TreeBranch<String> branch, Widget child, bool loading) {
    return ExpansionBuilder(
      expanded: branch.expanded,
      loading: loading,
      child: Padding(
        padding: const EdgeInsets.only(left: 15),
        child: child
      ),
      builder: (context, icon) => ValueListenableBuilder(
        valueListenable: _selectedPath,
        builder: (context, selectedPath, child) => SelectableTile(
          background: Colors.transparent,
          selected: selectedPath == branch.data,
          leading: FilesystemIconTheme.folder(branch.name),
          trailing: icon,
          title: Text(branch.name),
          horizontalTitleGap: 5,
          onTap: () {
            _selectedPath.value = branch.data;
            _cubit.toggleBranch(branch);
          },
        )
      )
    );
  }

  @override
  Widget build(BuildContext context) => DynamicTreeView(
    cubit: _cubit,
    buildLeaf: _buildLeaf,
    buildBranch: _buildBranch
  );

  @override
  void dispose() {
    super.dispose();
    _cubit.close();
    _selectedPath.dispose();
  }
}
