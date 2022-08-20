part of 'storage_cubit.dart';

enum StorageOperationType {
  create,
  read,
  write,
  delete
}

@immutable
abstract class StorageState {}

class StorageInitial extends StorageUnavailable {}

class StorageAvailable extends StorageState {}

class StorageUnavailable extends StorageState {}

class StorageOperationInProgress extends StorageAvailable {
  StorageOperationInProgress(this.type);

  final StorageOperationType type;
}

class StorageOperationSuccess extends StorageAvailable {
  StorageOperationSuccess(this.type);

  final StorageOperationType type;
}

class StorageOperationFailure extends StorageAvailable {
  StorageOperationFailure(this.type);

  final StorageOperationType type;
}