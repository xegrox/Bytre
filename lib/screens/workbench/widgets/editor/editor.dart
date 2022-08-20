import 'package:bytre/screens/workbench/widgets/editor/widgets/editor_tabs.dart';
import 'package:bytre/screens/workbench/widgets/editor/widgets/editor_view.dart';
import 'package:flutter/material.dart';


class Editor extends StatelessWidget {
  const Editor({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: const [
        EditorTabs(),
        Expanded(
          child: EditorView()
        )
      ]
    );
  }

}