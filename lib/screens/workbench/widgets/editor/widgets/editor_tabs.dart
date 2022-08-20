import 'package:bytre/blocs/editor/editor_cubit.dart';
import 'package:bytre/blocs/project/project_cubit.dart';
import 'package:bytre/styles.dart';
import 'package:bytre/widgets/filesystem_icon_theme.dart';
import 'package:bytre/widgets/tabler_icon.dart';
import 'package:bytre/widgets/transitions/size_fade_transition.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class EditorTabItem extends StatelessWidget {

  const EditorTabItem({
    required this.name,
    required this.path,
    required this.selected,
    required this.modified,
    required this.onTap,
    required this.onClose,
    Key? key
  }) : super(key: key);

  final String name;
  final String path;
  final bool selected;
  final bool modified;
  final Function() onTap;
  final Function() onClose;

  @override
  Widget build(BuildContext context) {
    final theme = context.appTheme;
    return AnimatedOpacity(
      duration: theme.animDuration,
      opacity: selected ? 1 : 0.7,
      child: InkWell(
        onTap: onTap,
        child: AnimatedContainer(
          height: 40,
          duration: theme.animDuration,
          decoration: BoxDecoration(
            color: selected ? theme.elevatedBackground : Colors.transparent,
            border: Border.all(color: Theme.of(context).dividerColor)
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                FilesystemIconTheme.file(name),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 5),
                  child: Text(name),
                ),
                if (modified) Container(
                  width: 8,
                  margin: const EdgeInsets.symmetric(horizontal: 5),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: theme.textUnfocusedColor,
                  ),
                ),
                GestureDetector(
                  onTap: onClose,
                  child: TablerIcon(
                    TablerIcons.x,
                    size: 16,
                    color: Theme.of(context).textTheme.caption!.color!.withOpacity(0.5)
                  )
                )
              ],
            ),
          )
        )
      )
    );
  }
}

class EditorTabs extends StatelessWidget {
  const EditorTabs({Key? key}) : super(key: key);

  Widget _buildItem(BuildContext context, Animation<double> anim, EditorTabInfo tab) {
    final editor = context.read<ProjectCubit>().editor;
    return SizeFadeTransition(
      axis: Axis.horizontal,
      animation: anim,
      child: BlocSelector(
        bloc: editor,
        selector: (_) => ((editor.focusedPath == tab.path ? 1 : 0) << 1) | (tab.isModified ? 1 : 0),
        builder: (context, _) => EditorTabItem(
          name: tab.name,
          path: tab.path,
          selected: editor.focusedPath == tab.path,
          modified: tab.isModified,
          onTap: () => editor.focusTab(tab.path),
          onClose: () => editor.closeTab(tab.path)
        )
      ),
    );
  }
  
  @override
  Widget build(BuildContext context) {
    final listKey = GlobalKey<AnimatedListState>();
    final cubit = context.read<ProjectCubit>().editor;
    return SizedBox(
      height: 40,
      child: BlocListener(
        bloc: cubit,
        listener: (context, state) {
          const duration = Duration(milliseconds: 200);
          if (state is EditorOpenTabSuccess) {
            listKey.currentState?.insertItem(cubit.tabs.length-1, duration: duration);
          } else if (state is EditorCloseTab) {
            final tab = state.tab;
            listKey.currentState?.removeItem(
              state.index,
              (context, anim) => _buildItem(context, anim, tab),
              duration: duration
            );
          }
        },
        child: AnimatedList(
          key: listKey,
          physics: const BouncingScrollPhysics(),
          scrollDirection: Axis.horizontal,
          initialItemCount: cubit.tabs.length,
          itemBuilder: (context, index, anim) {
            final tab = cubit.tabs.values.elementAt(index);
            return _buildItem(context, anim, tab);
          }
        )
      )
    );
  }

}