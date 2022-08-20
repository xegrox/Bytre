import 'dart:typed_data';

import 'package:bytre/blocs/project/project_cubit.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nanoid/non_secure.dart';

abstract class EditorViewer extends StatefulWidget {
  EditorViewer({Key? key}) : super(key: key);

  final id = nanoid();
  bool acceptMimeType(String mimeType);

  @override
  EditorViewerState createState();
}

abstract class EditorViewerState<T extends EditorViewer> extends State<T> {
  void create(String path, String extension);
  void update(String path, Uint8List content);
  void focus(String path);
  void remove(String path);
  
  @protected
  void setContent(String path, Uint8List content) {
    final cubit = context.read<ProjectCubit>().editor;
    cubit.informTabContent(path, content);
  }
}