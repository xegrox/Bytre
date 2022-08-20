import 'package:bytre/blocs/dynamic_tree/filesystem_tree_cubit.dart';
import 'package:bytre/models/tree_node.dart';
import 'package:bytre/styles.dart';
import 'package:bytre/widgets/dynamic_tree_view.dart';
import 'package:bytre/widgets/expansion_builder.dart';
import 'package:bytre/widgets/filesystem_icon_theme.dart';
import 'package:bytre/widgets/tabler_icon.dart';
import 'package:flutter/material.dart';

class _TreeTile extends StatelessWidget {
  const _TreeTile({
    required this.depth,
    required this.name,
    required this.leading,
    required this.onTap,
    required this.onLongPress,
    this.arrow = const SizedBox(width: 16),
    Key? key
  }) : super(key: key);

  final int depth;
  final String name;
  final Widget leading;
  final Function() onTap;
  final Function() onLongPress;
  final Widget arrow;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      onLongPress: onLongPress,
      child: Padding(
        padding: EdgeInsets.only(left: 15 + depth * 10, top: 15, bottom: 15, right: 10),
        child: Row(
          children: [
            arrow,
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8),
              child: leading
            ),
            Expanded(
              child: Text(
                name,
                style: Theme.of(context).textTheme.subtitle2,
                overflow: TextOverflow.fade,
                softWrap: false
              )
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8),
              child: TablerIcon(
                TablerIcons.dots_vertical,
                size: 16,
                color: Theme.of(context).textTheme.caption!.color!.withOpacity(0.7)
              )
            )
          ],
        )
      )
    );
  }
}

class FilesystemTreeExplorer extends StatelessWidget {
  FilesystemTreeExplorer({
    required this.cubit,
    required this.onTapFile,
    this.displayRoot = false,
    Key? key
  }) : super(key: key);

  final FilesystemTreeCubit cubit;
  final void Function(String path) onTapFile;
  final bool displayRoot;

  final _selectedNodes = ValueNotifier<Set<TreeNode<String>>>({});

  Color _selectedColor(BuildContext context) => context.appTheme.primary.withOpacity(0.1);

  Widget _buildLeaf(BuildContext context, TreeLeaf<String> leaf) => ValueListenableBuilder<Set<TreeNode<String>>>(
    valueListenable: _selectedNodes,
    child: _TreeTile(
      depth: leaf.depth,
      name: leaf.name,
      leading: FilesystemIconTheme.file(leaf.name, size: 20),
      onLongPress: () => _toggleSelection(leaf),
      onTap: () {
        if (_selectedNodes.value.isEmpty) {
          onTapFile(leaf.data);
        } else {
          _toggleSelection(leaf);
        }
      }
    ),
    builder: (context, selectedNodes, child) => AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      color: selectedNodes.contains(leaf) ? _selectedColor(context) : Colors.transparent,
      child: child
    )
  );

  void _toggleSelection(TreeNode<String> node) {
    if (_selectedNodes.value.contains(node)) {
      _selectedNodes.value = _selectedNodes.value.toSet()..remove(node);
    } else {
      _selectedNodes.value = _selectedNodes.value.toSet()..add(node);
    }
  }

  Widget _buildBranch(BuildContext context, TreeBranch<String> branch, Widget child, bool loading) {
    return ExpansionBuilder(
      child: child,
      expanded: branch.expanded,
      loading: loading,
      iconSize: 16,
      iconTurns: Tween(begin: -0.25, end: 0),
      builder: (context, icon) => ValueListenableBuilder<Set<TreeNode<String>>>(
        valueListenable: _selectedNodes,
        child: _TreeTile(
          depth: branch.depth,
          name: branch.name,
          leading: FilesystemIconTheme.folder(branch.name, size: 20),
          arrow: icon,
          onLongPress: () => _toggleSelection(branch),
          onTap: () {
            if (_selectedNodes.value.isEmpty) {
              cubit.toggleBranch(branch);
            } else {
              _toggleSelection(branch);
            }
          }
        ),
        builder: (context, selectedNodes, child) => AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          color: selectedNodes.contains(branch) ? _selectedColor(context) : Colors.transparent,
          child: child
        )
      )
    );
  }

  Widget _buildSelectionCounter() {
    var selectedCount = 0;
    return ClipRect(
      child: ValueListenableBuilder<Set<TreeNode<String>>>(
        valueListenable: _selectedNodes,
        builder: (context, selectedNodes, _) {
          if (selectedNodes.isNotEmpty) selectedCount = selectedNodes.length;
          return AnimatedAlign(
            alignment: Alignment.center,
            duration: const Duration(milliseconds: 200),
            heightFactor: selectedNodes.isEmpty ? 0 : 1,
            child: AnimatedOpacity(
              opacity: selectedNodes.isEmpty ? 0 : 1,
              duration: const Duration(milliseconds: 200),
              child: Container(
                color: context.appTheme.primary.withOpacity(0.2),
                child: ListTile(
                  title: Text('$selectedCount Selected'),
                  trailing: GestureDetector(
                    child: TablerIcon(TablerIcons.x, size: 18),
                    onTap: () => _selectedNodes.value = {}
                  ),
                )
              )
            )
          );
        }
      )
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            scrollDirection: Axis.vertical,
            child: DynamicTreeView<String>(
              cubit: cubit,
              buildLeaf: _buildLeaf,
              buildBranch: _buildBranch,
              // displayRoot: displayRoot,
            )
          )
        ),
        _buildSelectionCounter()
      ]
    );
  }

}