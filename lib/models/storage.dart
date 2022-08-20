import 'package:bytre/converters/storage_repository.dart';
import 'package:bytre/models/project.dart';
import 'package:bytre/repositories/storage/storage_interface.dart';
import 'package:equatable/equatable.dart';
import 'package:isar/isar.dart';
part 'storage.g.dart';

@Collection(inheritance: false)
class Storage with EquatableMixin {
  int id = isarAutoIncrementId;
  @Index(type: IndexType.hash)
  late String group;
  late String name;
  @StorageRepositoryConverter()
  late IStorageRepository repository;
  @Backlink(to: 'storage')
  final projects = IsarLinks<Project>();

  @override
  List<Object?> get props => [id, group, name, repository.toJson()];
}