import 'package:bytre/blocs/database/database_cubit.dart';
import 'package:bytre/screens/add_project/add_project.dart';
import 'package:bytre/screens/home/pages/projects/widgets/projects_animated_list.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../page_info_mixin.dart';

class ProjectsPage extends StatefulWidget with PageInfoMixin {
  const ProjectsPage({Key? key}) : super(key: key);

  @override
  String get title => 'Projects';

  @override
  String get fabLabel => 'Add project';

  @override
  Future<void> fabAction(BuildContext context, TabController controller) async {
    final database = context.read<DatabaseCubit>();
    final storagesIsEmpty = await database.storages.count() == 0;
    if (!storagesIsEmpty) {
      final success = await Navigator.push<bool>(
        context,
        MaterialPageRoute(
          builder: (_) => const AddProjectScreen(),
          fullscreenDialog: true
        )
      );
      if (success == true) {
        const snackBar = SnackBar(content: Text('New project added'));
        ScaffoldMessenger.of(context).showSnackBar(snackBar);
      }
    } else {
      controller.animateTo(0);
      const snackBar = SnackBar(content: Text('Please add a storage location'));
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
    }
  }

  @override
  State<StatefulWidget> createState() => ProjectsPageState();
}
class ProjectsPageState extends State<ProjectsPage> with AutomaticKeepAliveClientMixin {

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Expanded(
          flex: 4,
          child: ProjectsAnimatedList()
        ),
        Expanded(
          flex: 5,
          child: Column(
            children: const [
              SizedBox(height: 20),
              ListTile(
                contentPadding: EdgeInsets.symmetric(horizontal: 25),
                title: Text('Recently opened')
              )
            ],
          ),
        )
      ]
    );
  }

  @override
  bool get wantKeepAlive => true;
}
