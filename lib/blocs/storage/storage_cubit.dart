import 'dart:async';
import 'dart:typed_data';

import 'package:bytre/models/storage.dart';
import 'package:bytre/repositories/storage/storage_interface.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meta/meta.dart';

part 'storage_state.dart';

class StorageCubit extends Cubit<StorageState> {
  StorageCubit(this._storage) : super(StorageInitial());

  final Storage _storage;

  String get name => _storage.name;

  void _ensureStateAvailable() {
    if (state is! StorageAvailable) {
      throw StateError('Storage "${_storage.name}" not opened');
    }
  }

  String getDisplayPath(String path) => _storage.repository.getDisplayPath(path);

  Future<Uint8List> readFile(String path) {
    _ensureStateAvailable();
    return _storage.repository.readFile(path);
  }

  Future<void> writeFile(String path, Uint8List data) {
    _ensureStateAvailable();
    return _storage.repository.writeFile(path, data);
  }

  Future<FileInfo> createFile(String path, String name) async {
    _ensureStateAvailable();
    const type = StorageOperationType.create;
    emit(StorageOperationInProgress(type));
    final fileInfo = await _storage.repository.createFile(path, name);
    emit(StorageOperationSuccess(type));
    return fileInfo;
  }
  
  Future<bool> deleteRecursively(String path) async {
    _ensureStateAvailable();
    const type = StorageOperationType.delete;
    emit(StorageOperationInProgress(type));
    final success = await _storage.repository.deleteRecursively(path);
    emit(StorageOperationSuccess(type));
    return success;
  }

  Future<Iterable<FileInfo>> listDirectory(String path) async {
    _ensureStateAvailable();
    const type = StorageOperationType.read;
    emit(StorageOperationInProgress(type));
    final list = await _storage.repository.listDirectory(path);
    emit(StorageOperationSuccess(type));
    return list;
  }

  Future<void> open() async {
    if (state is! StorageUnavailable) return;
    await _storage.repository.open();
    emit(StorageAvailable());
  }

  @override
  Future<void> close() async {
    if (state is! StorageAvailable) return;
    await _storage.repository.close();
    emit(StorageUnavailable());
    return super.close();
  }

}
