import 'dart:typed_data';

import 'package:bytre/blocs/database/database_cubit.dart';
import 'package:bytre/blocs/theme/theme_cubit.dart';
import 'package:bytre/screens/home/home.dart';
import 'package:bytre/screens/image_cropper/image_cropper.dart';
import 'package:bytre/styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      systemNavigationBarColor: Colors.transparent,
      systemNavigationBarDividerColor: Colors.transparent
  ));
  SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
  final database = DatabaseCubit();
  await database.open();
  runApp(
    MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => ThemeCubit(AppThemeDark())),
        BlocProvider(create: (_) => database)
      ],
      child: Builder(
        builder: (context) => MaterialApp(
          title: 'Bytre',
          theme: context.appTheme.materialTheme,
          initialRoute: '/',
          routes: {
            '/': (context) => const HomeScreen()
          },
          onGenerateRoute: (settings) {
            final args = settings.arguments;
            switch(settings.name) {
              case '/image_cropper': {
                if (args is Uint8List) {
                  return MaterialPageRoute<Uint8List>(
                    builder: (context) => ImageCropperScreen(args),
                    fullscreenDialog: true
                  );
                }
              }
            }
            return null;
          },
        )
      )
    )
  );
}