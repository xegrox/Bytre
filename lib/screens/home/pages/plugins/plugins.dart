import 'package:flutter/material.dart';
import '../page_info_mixin.dart';

class PluginsPage extends StatelessWidget with PageInfoMixin{
  const PluginsPage({Key? key}) : super(key: key);

  @override
  String get title => 'Plugins';

  @override
  String get fabLabel => 'Search';

  @override
  void fabAction(BuildContext context, TabController controller) {}

  @override
  Widget build(BuildContext context) {
    return Container();
  }
}
