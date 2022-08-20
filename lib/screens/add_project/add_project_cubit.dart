import 'dart:typed_data';

import 'package:bloc/bloc.dart';
import 'package:bytre/blocs/database/database_cubit.dart';
import 'package:bytre/models/project.dart';
import 'package:bytre/models/storage.dart';
import 'package:isar/isar.dart';
import 'package:meta/meta.dart';

part 'add_project_state.dart';

enum AddProjectMethod {
  folder,
  git
}

class AddProjectCubit extends Cubit<AddProjectCubitState> {
  AddProjectCubit(this.database)
    : _selectedStorage = database.storages.where().anyGroup().findFirstSync()!,
    super(AddProjectInitial());

  final DatabaseCubit database;

  Storage _selectedStorage;
  String name = '';
  String description = '';
  Uint8List? _image;
  AddProjectMethod _method = AddProjectMethod.folder;
  String _path = '';

  Uint8List? get imageData => _image;
  Storage get selectedStorage => _selectedStorage;
  AddProjectMethod get method => _method;
  String get path => _path;


  set imageData(Uint8List? data) {
    _image = data;
    emit(AddProjectImageSelected(data));
  }

  set selectedStorage(Storage storage) {
    _selectedStorage = storage;
    emit(AddProjectStorageSelected(storage));
  }

  set method(AddProjectMethod method) {
    _method = method;
    emit(AddProjectMethodSelected(method));
  }

  set path(String path) {
    _path = path;
    emit(AddProjectPathSelected(_path));
  }

  Future<void> createProject() => database.projects.putTxn(Project()
    ..storage.value = _selectedStorage
    ..path = _path
    ..name = name
    ..description = description
    ..image = _image
  );
}
