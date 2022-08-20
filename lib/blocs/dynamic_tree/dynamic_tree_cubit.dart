import 'package:bloc/bloc.dart';
import 'package:bytre/models/tree_node.dart';
import 'package:meta/meta.dart';

part 'dynamic_tree_state.dart';

abstract class DynamicTreeCubit<T> extends Cubit<DynamicTreeState> {
  DynamicTreeCubit(this.root) : super(DynamicTreeInitial());

  final TreeBranch<T> root;

  Future<void> expandBranch(TreeBranch<T> branch) async {
    emit(DynamicTreeBranchLoading(branch));
    branch.clearChildren();
    (await fetchChildren(branch.data)).forEach(branch.addChild);
    branch.expanded = true;
    emit(DynamicTreeBranchExpanded(branch));
  }

  void collapseBranch(TreeBranch<T> branch) {
    branch.expanded = false;
    emit(DynamicTreeBranchCollapsed(branch));
  }

  void toggleBranch(TreeBranch<T> branch) {
    if (branch.expanded) collapseBranch(branch);
    else expandBranch(branch);
  }

  @protected
  Future<Iterable<TreeNode<T>>> fetchChildren(T data);
}
