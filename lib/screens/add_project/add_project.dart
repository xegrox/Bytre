import 'package:bytre/blocs/database/database_cubit.dart';
import 'package:bytre/screens/add_project/add_project_cubit.dart';
import 'package:bytre/screens/add_project/pages/page_one/page_one.dart';
import 'package:bytre/utils/next_page_mixin.dart';
import 'package:bytre/widgets/slide_transition_page.dart';
import 'package:bytre/widgets/tabler_icon.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AddProjectScreen extends StatefulWidget {
  const AddProjectScreen({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _AddProjectScreenState();
}

class _AddProjectScreenState extends State<AddProjectScreen> {

  final pages = <NextPage>[];
  final navigatorKey = GlobalKey<NavigatorState>();
  late final AddProjectCubit cubit;

  @override
  void initState() {
    super.initState();
    cubit = AddProjectCubit(context.read<DatabaseCubit>());
    pages.add(AddProjectPageOne(cubit));
  }

  @override
  void dispose() {
    super.dispose();
    cubit.close();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        if (navigatorKey.currentState?.canPop() == true) {
          navigatorKey.currentState?.pop();
          return false;
        } else {
          return true;
        }
      },
      child: Scaffold(
        appBar: AppBar(
          leading: IconButton(
            icon: TablerIcon(TablerIcons.x),
            onPressed: () {
              Navigator.of(context).pop();
            }
          ),
          title: const Text('Add Project')
        ),
        body: Padding(
          padding: const EdgeInsets.all(16),
          child: Navigator(
            key: navigatorKey,
            pages: pages.map((e) => SlideTransitionPage(child: e)).toList(),
            onPopPage: (route, result) {
              if (route.didPop(result)) {
                pages.removeLast();
                setState(() {});
                return true;
              }
              return false;
            }
          )
        ),
        floatingActionButton: FloatingActionButton.extended(
          onPressed: () async {
            if (pages.last is FinalPage) {
              await cubit.createProject();
              Navigator.pop(context, true);
            } else {
              final nextPage = await pages.last.nextPage();
              if (nextPage != null) {
                pages.add(nextPage);
                setState(() {});
              }
            }
          },
          label: Text(pages.last is FinalPage ? 'Finish' : 'Next'),
          icon: TablerIcon(pages.last is FinalPage ? TablerIcons.check : TablerIcons.arrow_right),
        )
      )
    );
  }
}