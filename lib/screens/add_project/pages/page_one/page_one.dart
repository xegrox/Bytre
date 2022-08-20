import 'dart:io';
import 'dart:typed_data';

import 'package:bytre/screens/add_project/add_project_cubit.dart';
import 'package:bytre/screens/add_project/pages/page_two/page_two.dart';
import 'package:bytre/styles.dart';
import 'package:bytre/utils/next_page_mixin.dart';
import 'package:bytre/widgets/tabler_icon.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';

class AddProjectPageOne extends StatelessWidget with NextPage {
  AddProjectPageOne(this.cubit, {Key? key}) : super(key: key);

  final AddProjectCubit cubit;
  final formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    final theme = context.appTheme;
    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      child: Form(
        key: formKey,
        child: Column(
          children: [
            Container(
              clipBehavior: Clip.antiAlias,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.all(theme.borderRadius)
              ),
              child: Stack(
                children: [
                  AspectRatio(
                    aspectRatio: 3/2,
                    child: AnimatedSwitcher(
                      duration: const Duration(milliseconds: 200),
                      child: BlocBuilder(
                        bloc: cubit,
                        buildWhen: (_, current) => current is AddProjectImageSelected,
                        builder: (_, __) {
                          if (cubit.imageData != null) {
                            return Image(
                              width: double.infinity,
                              key: UniqueKey(),
                              image: Image.memory(cubit.imageData!).image,
                              fit: BoxFit.contain,
                            );
                          } else {
                            return Container(color: Colors.blue);
                          }
                        }
                      )
                    )
                  ),
                  Positioned(
                    bottom: 0,
                    right: 0,
                    child: Padding(
                    padding: const EdgeInsets.all(10),
                      child: TextButton.icon(
                        onPressed: () async {
                          final picker = ImagePicker();
                          final xfile = await picker.pickImage(source: ImageSource.gallery);
                          if (xfile == null) return;
                          final file = File(xfile.path);
                          file.readAsBytes().then((bytes) async {
                            final navigator = Navigator.of(context, rootNavigator: true);
                            final croppedBytes = await navigator.pushNamed<Uint8List>('/image_cropper', arguments: bytes);
                            if (croppedBytes != null) cubit.imageData = croppedBytes;
                          });
                        },
                        icon: TablerIcon(TablerIcons.photo, color: Colors.white, size: 16),
                        label: const Text('Select Image', style: TextStyle(color: Colors.white, fontSize: 12)),
                        style: ButtonStyle(
                          tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                          elevation: MaterialStateProperty.all(0),
                          backgroundColor: MaterialStateProperty.all(Colors.black.withOpacity(0.3)),
                          shape: MaterialStateProperty.all(RoundedRectangleBorder(borderRadius: BorderRadius.all(theme.borderRadius)))
                        )
                      )
                    )
                  )
                ],
              )
            ),
            const SizedBox(height: 20),
            TextFormField(
              validator: (str) => ((str ?? '').isEmpty) ? 'Cannot be empty' : null,
              onSaved: (name) => cubit.name = name ?? '',
              autovalidateMode: AutovalidateMode.onUserInteraction,
              decoration: const InputDecoration(
                labelText: 'Name'
              )
            ),
            const SizedBox(height: 15),
            TextFormField(
              maxLines: null,
              onSaved: (desc) => cubit.description = desc ?? '',
              decoration: const InputDecoration(
                label: Text.rich(TextSpan(
                  children: [
                    TextSpan(text: 'Description '),
                    TextSpan(
                      text: '(optional)',
                      style: TextStyle(fontStyle: FontStyle.italic)
                    )
                  ])
                )
              )
            )
          ]
        )
      )
    );
  }

  @override
  Future<NextPage?> nextPage() async {
    if (formKey.currentState?.validate() == true) {
      formKey.currentState?.save();
      return AddProjectPageTwo(cubit);
    } else {
      return null;
    }
  }
}