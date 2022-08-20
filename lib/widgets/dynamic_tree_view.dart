import 'package:bytre/blocs/dynamic_tree/dynamic_tree_cubit.dart';
import 'package:bytre/models/tree_node.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class DynamicTreeView<T> extends StatelessWidget {
  const DynamicTreeView({
    required this.cubit,
    required this.buildLeaf,
    required this.buildBranch,
    Key? key
  }) : super(key: key);

  final DynamicTreeCubit<T> cubit;
  final Widget Function(BuildContext context, TreeLeaf<T> leaf) buildLeaf;
  final Widget Function(BuildContext context, TreeBranch<T> branch, Widget child, bool loading) buildBranch;
  
  Widget _buildRecursively(BuildContext context, TreeBranch<T> root) {
    final child = BlocBuilder(
      bloc: cubit,
      buildWhen: (_, current) => current is DynamicTreeBranchExpanded
        && identical(root, current.branch),
      builder: (context, state) => Column(
        children: root.children.expand<Widget>((node) {
          if (node is TreeLeaf<T>) return [buildLeaf(context, node)];
          else if (node is TreeBranch<T>) return [_buildRecursively(context, node)];
          else return [];
        }).toList()
      )
    );
    return BlocBuilder(
      bloc: cubit,
      builder: (context, state) {
        final loading = state is DynamicTreeBranchLoading && identical(root, state.branch);
        return buildBranch(context, root, child, loading);
      }
    );
  }
  
  @override
  Widget build(BuildContext context) => _buildRecursively(context, cubit.root);

}


// import 'package:bytre/blocs/dynamic_tree/dynamic_tree_cubit.dart';
// import 'package:bytre/models/tree_node.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';

// class DynamicTreeView<T> extends StatelessWidget {
//   const DynamicTreeView({
//     required this.cubit,
//     required this.buildLeaf,
//     required this.buildBranch,
//     this.displayRoot = true,
//     Key? key
//   }) : super(key: key);

//   final DynamicTreeCubit<T> cubit;
//   final Widget Function(BuildContext context, TreeLeaf<T> leaf) buildLeaf;
//   final Widget Function(BuildContext context, TreeBranch<T> branch, Widget child, bool loading) buildBranch;
//   final bool displayRoot;
  
//   Widget _buildRecursively(BuildContext context, TreeBranch<T> root, [bool displayRoot = false]) {
//     final child = BlocBuilder(
//       bloc: cubit,
//       buildWhen: (_, current) => current is DynamicTreeBranchExpanded
//         && identical(root, current.branch),
//       builder: (context, state) => Column(
//         children: root.children.expand<Widget>((node) {
//           if (node is TreeLeaf<T>) return [buildLeaf(context, node)];
//           else if (node is TreeBranch<T>) return [_buildRecursively(context, node)];
//           else return [];
//         }).toList()
//       )
//     );
//     return displayRoot ? BlocBuilder(
//       bloc: cubit,
//       builder: (context, state) {
//         final loading = state is DynamicTreeBranchLoading && identical(root, state.branch);
//         return buildBranch(context, root, child, loading);
//       }
//     ) : child;
//   }
  
//   @override
//   Widget build(BuildContext context) => _buildRecursively(context, cubit.root, displayRoot);

// }