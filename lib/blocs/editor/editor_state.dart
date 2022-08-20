part of 'editor_cubit.dart';

@immutable
abstract class EditorState {}

class EditorInitial extends EditorState {}

class EditorOpenTabOngoing extends EditorState {
  EditorOpenTabOngoing(this.tab);

  final EditorTabInfo tab;
}

class EditorOpenTabSuccess extends EditorUpdateTabContent {
  EditorOpenTabSuccess(EditorTabInfo tab) : super(tab);
}

class EditorCloseTab extends EditorState {
  EditorCloseTab(this.tab, this.index);

  final EditorTabInfo tab;
  final int index;
}

class EditorFocusTab extends EditorState {
  EditorFocusTab(this.tab);

  final EditorTabInfo? tab;
}

class EditorUpdateTab extends EditorState {
  EditorUpdateTab(this.tab);

  final EditorTabInfo tab;
}

class EditorUpdateTabContent extends EditorState {
  EditorUpdateTabContent(this.tab);

  final EditorTabInfo tab;
}