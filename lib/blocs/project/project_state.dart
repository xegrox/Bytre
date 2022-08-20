part of 'project_cubit.dart';

@immutable
abstract class ProjectState {}

class ProjectInitial extends ProjectUnavailable {}

class ProjectAvailable extends ProjectState {
  ProjectAvailable({
    required this.storage, 
    required String path,
    required List<String> initialTabs
  }) : assert(storage.state is StorageAvailable), 
    editor = EditorCubit(storage, initialTabs),
    explorer = FilesystemTreeCubit(storage, path);

  final StorageCubit storage;
  final EditorCubit editor;
  final FilesystemTreeCubit explorer;
}

class ProjectUnavailable extends ProjectState {}
