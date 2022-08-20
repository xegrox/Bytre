import 'package:bytre/blocs/editor/editor_cubit.dart';
import 'package:bytre/blocs/project/project_cubit.dart';
import 'package:bytre/widgets/tabler_icon.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'widgets/editor/editor.dart';
import 'widgets/side_panel.dart';

class WorkbenchScreen extends StatefulWidget {
  const WorkbenchScreen({
    required this.project,
    Key? key
  }) : super(key: key);

  final ProjectCubit project;

  @override
  State<StatefulWidget> createState() => WorkbenchScreenState();
}

class WorkbenchScreenState extends State<WorkbenchScreen> {

  @override
  Widget build(BuildContext context) {
    final editor = widget.project.editor;
    return MultiBlocProvider(
      providers: [
        BlocProvider.value(value: widget.project),
      ],
      child: Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          title: BlocBuilder(
            bloc: editor,
            buildWhen: (_, state) => state is EditorFocusTab,
            builder: (_, state) {
              final path = editor.focusedPath;
              final name = editor.tabs[path]?.name ?? '';
              return Text(name);
            }
          )
        ),
        body: const SafeArea(
          child: Editor()
        ),
        drawer: const SidePanel(),
        bottomNavigationBar: BottomAppBar(
          child: IntrinsicHeight(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Builder(
                  builder: (context) => IconButton(
                    icon: TablerIcon(TablerIcons.menu),
                    onPressed: () => Scaffold.of(context).openDrawer()
                  )
                ),
                Expanded(
                  child: GestureDetector(
                    onDoubleTap: () {
                      final focusedPath = editor.focusedPath;
                      if (focusedPath != null) editor.saveTabContent(focusedPath);
                    },
                  )
                )
              ]
            )
          )
        )
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();
    widget.project.close();
  }

}