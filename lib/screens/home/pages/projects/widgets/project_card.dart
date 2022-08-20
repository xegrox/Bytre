import 'package:bytre/models/project.dart';
import 'package:flutter/material.dart';

class ProjectCard extends StatelessWidget {
  const ProjectCard(this.project, {
    this.onTap,
    this.onLongPress,
    Key? key}) : super(key: key);

  final Project project;
  final void Function()? onLongPress;
  final void Function()? onTap;

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: 2/3,
      child: Card(
        clipBehavior: Clip.antiAlias,
        child: InkWell(
          onTap: onTap,
          onLongPress: onLongPress,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              AspectRatio(
                aspectRatio: 4/3,
                child: project.image == null
                  ? Container()
                  : Image.memory(project.image!, fit: BoxFit.cover),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ListTile(
                      title: Text(project.name),
                      subtitle: Text(project.description),
                      isThreeLine: true,
                      contentPadding: EdgeInsets.zero,
                    )
                  ],
                )
              )
            ]
          ),
        )
      )
    );
  }

}