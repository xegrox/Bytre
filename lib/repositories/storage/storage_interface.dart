import 'dart:typed_data';

enum FileInfoType {
  file,
  dir
}

class FileInfo {
  FileInfo({required this.name, required this.path, required this.type});
  final String name;
  final String path;
  final FileInfoType type;
}

abstract class IStorageRepository {
  IStorageRepository();

  String get defaultGroupName;
  Future<void> open();
  Future<void> close();
  Future<FileInfo> createFile(String path, String name);
  Future<FileInfo> createDirectory(String path, String name);
  Future<Uint8List> readFile(String path);
  Future<void> writeFile(String path, Uint8List data);
  Future<bool> deleteRecursively(String path);
  Future<Iterable<FileInfo>> listDirectory(String path);
  String getDisplayPath(String path) => path;

  Map<String, dynamic> toJson();
}
