import 'package:bloc/bloc.dart';
import 'package:bytre/blocs/database/database_cubit.dart';
import 'package:bytre/blocs/dynamic_tree/filesystem_tree_cubit.dart';
import 'package:bytre/blocs/editor/editor_cubit.dart';
import 'package:bytre/blocs/storage/storage_cubit.dart';
import 'package:bytre/models/project.dart';
import 'package:meta/meta.dart';

part 'project_state.dart';

class ProjectCubit extends Cubit<ProjectState> {
  ProjectCubit(this._project) : super(ProjectInitial());

  final Project _project;

  StorageCubit get storage => state is ProjectAvailable
      ? (state as ProjectAvailable).storage
      : throw StateError('Project "${_project.name}" not opened');

  EditorCubit get editor => state is ProjectAvailable
      ? (state as ProjectAvailable).editor
      : throw StateError('Project "${_project.name}" not opened');

  FilesystemTreeCubit get explorer => state is ProjectAvailable
      ? (state as ProjectAvailable).explorer
      : throw StateError('Project "${_project.name}" not opened');

  Future<void> openProject() async {
    if (state is ProjectUnavailable) {
      final cubit = StorageCubit(_project.storage.get()!);
      await cubit.open();
      emit(ProjectAvailable(
        storage: cubit,
        path: _project.path,
        initialTabs: const []
      ));
    }
  }

  Future<void> closeProject() async {
    if (state is ProjectAvailable) {
      (state as ProjectAvailable)
        ..explorer.close()
        ..editor.close()
        ..storage.close();
    }
  }

  @override
  Future<void> close() async {
    await closeProject();
    return super.close();
  }
  

}
