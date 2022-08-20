import 'package:bytre/blocs/editor/editor_cubit.dart';
import 'package:bytre/blocs/project/project_cubit.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:path/path.dart' as p;

import 'editor_viewers/editor_viewer_code.dart';
import 'editor_viewers/editor_viewer_impl.dart';

class EditorView extends StatelessWidget {
  const EditorView({Key? key}) : super(key: key);

  EditorViewerState _getViewerState(EditorViewer viewer) {
    return (viewer.key! as GlobalKey<EditorViewerState>).currentState!;
  }

  @override
  Widget build(BuildContext context) {
    final tabViewers = <EditorTabInfo, EditorViewer>{};
    final viewers = <EditorViewer>[
      EditorViewerCode(key: GlobalKey<EditorViewerState>())
    ];

    void addTabView(EditorTabInfo tab) {
      final viewer = viewers.firstWhere((v) => v.acceptMimeType(tab.mimeType));
      tabViewers[tab] = viewer;
      _getViewerState(viewer).create(tab.path, p.extension(tab.name));
    }
    
    void removeTabView(EditorTabInfo tab) {
      final viewer = tabViewers[tab]!;
      _getViewerState(viewer).remove(tab.path);
      tabViewers.remove(tab);
    }

    void updateTabView(EditorTabInfo tab) {
      final viewer = tabViewers[tab]!;
      _getViewerState(viewer).update(tab.path, tab.editedContent!);
    }

    void focusTabView(EditorTabInfo tab) {
      final viewer = tabViewers[tab]!;
      _getViewerState(viewer).focus(tab.path);
    }

    int? index;
    final cubit = context.read<ProjectCubit>().editor;
    return BlocConsumer(
      bloc: cubit,
      listener: (_, state) {
        if (state is EditorOpenTabOngoing) addTabView(state.tab);
        else if (state is EditorUpdateTabContent) updateTabView(state.tab);
        else if (state is EditorCloseTab) removeTabView(state.tab);
        else if (state is EditorFocusTab && state.tab != null) focusTabView(state.tab!); 
      },
      buildWhen: (_, state) {
        if (state is EditorFocusTab) {
          final viewer = tabViewers[state.tab];
          final newIndex = viewer != null ? viewers.indexOf(viewer) : null;
          if (newIndex != index) {
            index = newIndex;
            return true;
          }
        }
        return false;
      },
      builder: (context, state) => IndexedStack(
        index: index,
        children: viewers
      )
    );
  }
}