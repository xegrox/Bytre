import 'package:bytre/models/project.dart';
import 'package:bytre/models/storage.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:isar/isar.dart';
import 'package:path_provider/path_provider.dart';

import 'database_state.dart';

extension IsarCollectionUtils<T> on IsarCollection<T> {
  Future<void> putTxn(T object) => isar.writeTxn((isar) => put(object, saveLinks: true));
}

extension IsarLinkUtils<T> on IsarLink<T> {
  T? get() {
    if (!isLoaded) loadSync();
    return value;
  }
}

class DatabaseCubit extends Cubit<DatabaseState> {
  DatabaseCubit() : super(DatabaseInitial());

  late Isar _database;
  
  IsarCollection<Storage> get storages => _database.storages;
  IsarCollection<Project> get projects => _database.projects;
  Future<void> writeTxn(Future<void> Function() callback) => _database.writeTxn((isar) => callback());

  Future<void> open() async {
    final dir = await getApplicationSupportDirectory();
    _database = await Isar.open(
      schemas: [StorageSchema, ProjectSchema],
      directory: dir.path
    );
    emit(DatabaseOpened());
  }

  @override
  Future<void> close() {
    _database.close();
    emit(DatabaseClosed());
    return super.close();
  }
}