import 'package:bytre/blocs/storage/storage_cubit.dart';
import 'package:bytre/models/tree_node.dart';
import 'package:bytre/repositories/storage/storage_interface.dart';
import 'package:path/path.dart' as p;

import 'dynamic_tree_cubit.dart';

class FilesystemTreeCubit extends DynamicTreeCubit<String> {
  FilesystemTreeCubit(this.storage, [String path = '']) :
    super(TreeBranch(p.basename(storage.getDisplayPath(path)), path));

  final StorageCubit storage;

  @override
  Future<Iterable<TreeNode<String>>> fetchChildren(String data) async {
    final children = await storage.listDirectory(data);
    return children.map((file) {
      switch (file.type) {
        case FileInfoType.file:
          return TreeLeaf(file.name, file.path);
        case FileInfoType.dir:
          return TreeBranch(file.name, file.path);
      }
    });
  }
}