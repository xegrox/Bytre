part of 'dynamic_tree_cubit.dart';

@immutable
abstract class DynamicTreeState {}

class DynamicTreeInitial extends DynamicTreeState {}

class DynamicTreeBranchLoading<T> extends DynamicTreeState {
  DynamicTreeBranchLoading(this.branch);

  final TreeBranch<T> branch;
}

class DynamicTreeBranchExpanded<T> extends DynamicTreeState {
  DynamicTreeBranchExpanded(this.branch);

  final TreeBranch<T> branch;
}

class DynamicTreeBranchCollapsed<T> extends DynamicTreeState {
  DynamicTreeBranchCollapsed(this.branch);

  final TreeBranch<T> branch;
}