import 'dart:collection';
import 'dart:math';
import 'dart:typed_data';

import 'package:bloc/bloc.dart';
import 'package:bytre/blocs/storage/storage_cubit.dart';
import 'package:bytre/utils/iterable_extension.dart';
import 'package:flutter/foundation.dart';
import 'package:mime/mime.dart';
import 'package:path/path.dart' as p;

part 'editor_state.dart';

class EditorTabInfo {
  EditorTabInfo._({
    required this.path,
    required this.name,
    required this.mimeType,
  });

  Uint8List? _savedContent;
  Uint8List? _editedContent;

  Uint8List? get savedContent => _savedContent;
  Uint8List? get editedContent => _editedContent;

  final String path;
  final String name;
  final String mimeType;

  bool get isModified => savedContent != null && !listEquals(savedContent, editedContent);
}

class EditorCubit extends Cubit<EditorState> {
  EditorCubit(this.storage, [List<String> initialTabs = const []]) : super(EditorInitial()) {
    initialTabs.forEach(openTab);
  }

  final StorageCubit storage;

  final Map<String, EditorTabInfo> _tabs = {};
  Map<String, EditorTabInfo> get tabs => UnmodifiableMapView(_tabs);

  String? _focusedPath;
  String? get focusedPath => _focusedPath;

  void focusTab(String? path) {
    if (_focusedPath == path) return;
    if (path == null) {
      _focusedPath = null;
      emit(EditorFocusTab(null));
    } else {
      final tab = _tabs[path];
      if (tab == null) return;
      _focusedPath = path;
      emit(EditorFocusTab(tab));
    }
  }

  void openTab(String path) {
    if (_tabs.containsKey(path)) return;
    final name = p.basename(storage.getDisplayPath(path));
    final mimeType = lookupMimeType(path) ?? 'text/plain';
    final tab = EditorTabInfo._(
      path: path,
      name: name,
      mimeType: mimeType
    );
    _tabs[path] = tab;
    emit(EditorOpenTabOngoing(tab));
    focusTab(path);
    storage.readFile(path).then((content) {
      tab._savedContent = content;
      tab._editedContent = content;
      emit(EditorOpenTabSuccess(tab));
    });
  }

  void closeTab(String path) {
    final tab = _tabs[path];
    if (tab == null) return;
    final index = _tabs.keys.indexOf(path);
    _tabs.remove(path);
    emit(EditorCloseTab(tab, index));
    if (_tabs.isEmpty) focusTab(null);
    else focusTab(_tabs.keys.elementAt(max(0, index-1)));
  }

  void saveTabContent(String path) {
    final tab = _tabs[path];
    if (tab == null || tab.editedContent == null) return;
    storage.writeFile(path, tab.editedContent!);
    tab._savedContent = tab.editedContent;
    emit(EditorUpdateTab(tab));
  }

  void editTabContent(String path, Uint8List content) {
    informTabContent(path, content);
    final tab = _tabs[path]!;
    emit(EditorUpdateTabContent(tab));
  }

  void informTabContent(String path, Uint8List content) {
    final tab = _tabs[path];
    if (tab == null || listEquals(tab.editedContent, content)) return;
    tab._editedContent = content;
    emit(EditorUpdateTab(tab));
  }

}
