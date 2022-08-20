import 'package:flutter/material.dart';

mixin NextPage on Widget {
  Future<NextPage?> nextPage();
}

mixin FinalPage on Widget implements NextPage {
  @override
  Future<NextPage?> nextPage() async => null;
}