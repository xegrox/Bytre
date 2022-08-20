import 'dart:typed_data';

import 'package:bytre/models/storage.dart';
import 'package:equatable/equatable.dart';
import 'package:isar/isar.dart';
part 'project.g.dart';

@Collection(inheritance: false)
class Project with EquatableMixin {
  int id = isarAutoIncrementId;
  late String path;
  late String name;
  late String description;
  late Uint8List? image;
  final storage = IsarLink<Storage>();
  
  @override
  List<Object?> get props => [id, path, name, description, image, storage];
}