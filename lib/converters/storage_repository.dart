import 'dart:convert';
import 'package:bytre/repositories/storage/storage_interface.dart';
import 'package:bytre/repositories/storage/storage_native.dart';
import 'package:isar/isar.dart';

enum RepositoryType {
  native('native');

  const RepositoryType(this.name);
  factory RepositoryType.fromName(String name) => RepositoryType.values.firstWhere((e) => e.name == name);
  factory RepositoryType.fromRepo(IStorageRepository repo) {
    if (repo is StorageRepositoryNative) {
      return RepositoryType.native;
    } else {
      // TODO: implement unknown type
      throw UnimplementedError();
    }
  }
  final String name;

}

class StorageRepositoryConverter extends TypeConverter<IStorageRepository, String> {
  const StorageRepositoryConverter();

  @override
  IStorageRepository fromIsar(String object) {
    final parsed = jsonDecode(object) as Map<String, dynamic>;
    final type = RepositoryType.fromName(parsed['type'] as String);
    final data = parsed['data'] as Map<String, dynamic>;
    switch (type) {
      case RepositoryType.native:
        return StorageRepositoryNative.fromJson(data);
    }
  }

  @override
  String toIsar(IStorageRepository object) => jsonEncode({
    'type': RepositoryType.fromRepo(object).name,
    'data': object.toJson()
  });
}