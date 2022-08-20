import 'package:flutter/material.dart';
import '../page_info_mixin.dart';

class SDKManagerPage extends StatelessWidget with PageInfoMixin {

  const SDKManagerPage({Key? key}) : super(key: key);

  @override
  String get title => 'SDK Manager';

  @override
  void fabAction(BuildContext context, TabController controller) {}

  @override
  String get fabLabel => 'Add SDK';

  @override
  Widget build(BuildContext context) {
    return Container();
  }
}
