class TreeNode<T> {
  TreeNode(this.name, this.data, [this.parent]);

  final String name;
  final T data;
  TreeBranch? parent;
  int get depth => (parent?.depth ?? -1) + 1;
}

class TreeLeaf<T> extends TreeNode<T> {
  TreeLeaf(String name, T data, [TreeBranch? parent]) : super(name, data, parent);
}

class TreeBranch<T> extends TreeNode<T> {
  TreeBranch(String name, T data, [TreeBranch? parent]) : super(name, data, parent);

  final List<TreeNode<T>> _children = [];

  bool expanded = false;

  List<TreeNode<T>> get children => [..._children];

  void addChild(TreeNode<T> node) {
    node.parent = this;
    _children.add(node);
  }

  void clearChildren() => _children.clear();
}
