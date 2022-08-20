import 'package:flutter/material.dart';
import 'package:rive/rive.dart';

class SetupScreen extends StatelessWidget {

  const SetupScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    const anim = RiveAnimation.asset('assets/rive/bytre.riv');
    return Container(
      color: Theme.of(context).backgroundColor,
        alignment: Alignment.center,
        padding: const EdgeInsets.all(50),
        child: const SizedBox(
          width: 400,
          child: anim
        )
    );
  }
}