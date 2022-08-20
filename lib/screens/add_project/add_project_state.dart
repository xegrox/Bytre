part of 'add_project_cubit.dart';

@immutable
abstract class AddProjectCubitState {}

class AddProjectInitial extends AddProjectCubitState {}

class AddProjectStorageSelected extends AddProjectCubitState {
  AddProjectStorageSelected(this.storage);

  final Storage storage;
}

class AddProjectPathSelected extends AddProjectCubitState {
  AddProjectPathSelected(this.path);

  final String path;
}

class AddProjectImageSelected extends AddProjectCubitState {
  AddProjectImageSelected(this.imageData);

  final Uint8List? imageData;
}

class AddProjectMethodSelected extends AddProjectCubitState {
  AddProjectMethodSelected(this.method);

  final AddProjectMethod method;
}