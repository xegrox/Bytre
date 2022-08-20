import 'package:bytre/blocs/database/database_cubit.dart';
import 'package:bytre/blocs/project/project_cubit.dart';
import 'package:bytre/models/project.dart';
import 'package:bytre/screens/workbench/workbench.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:implicitly_animated_list/implicitly_animated_list.dart';
import 'package:isar/isar.dart';

import 'project_card.dart';
import 'project_info_bottom_sheet.dart';
class ProjectsAnimatedList extends StatelessWidget {
  const ProjectsAnimatedList({
    Key? key
  }) : super(key: key);


  @override
  Widget build(BuildContext context) {
    final projects = context.read<DatabaseCubit>().projects;
    return StreamBuilder<List<Project>>(
      stream: projects.where().watch(initialReturn: true),
      builder: (_, snapshot) {
        if (!snapshot.hasData) {
          return Container();
        }
        return ImplicitlyAnimatedList<Project>(
          itemData: snapshot.requireData,
          physics: const BouncingScrollPhysics(),
          scrollDirection: Axis.horizontal,
          padding: const EdgeInsets.all(10),
          itemBuilder: (context, project) {
            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: ProjectCard(
                project,
                onTap: () async {
                  final cubit = ProjectCubit(project);
                  await cubit.openProject();
                  Navigator.push(context, MaterialPageRoute(
                    builder: (context) => WorkbenchScreen(project: cubit)
                  ));
                },
                onLongPress: () => showModalBottomSheet(
                  context: context,
                  isScrollControlled: true,
                  builder: (context) => ProjectInfoBottomSheet(
                    project: project
                  ),
                )
              )
            );
          }
        );
      }
    );
  }
  
}