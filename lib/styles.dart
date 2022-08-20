import 'package:bytre/blocs/theme/theme_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';

extension BuildContextExtension on BuildContext {
  AppTheme get appTheme {
    return read<ThemeCubit>().theme;
  }
}

abstract class AppTheme {
  Color get primary;
  Color get accent;
  Color get background;
  Color get divider;
  Color get unselectedColor;
  Color get textUnfocusedColor;

  Color get textDisplayColor;
  Color get textBodyColor;

  Color get red;
  Color get orange;
  Color get yellow;
  Color get green;
  Color get blue;
  Color get purple;

  Radius get borderRadius;
  Color get splashColor;
  Color get highlightColor;

  Color get elevatedBackground;
  Color get snackBarBackground;
  Color get snackBarForeground;

  Color get bottomNavSelectedFS => purple;
  Color get bottomNavSelectedProj => accent;
  Color get bottomNavSelectedPlug => green;
  Color get bottomNavSelectedSDK => blue;

  Duration get animDuration;

  ThemeData get materialTheme {
    final theme = ThemeData(
      brightness: Brightness.dark,
      primaryColor: primary,
      backgroundColor: background,
      scaffoldBackgroundColor: background,
      dividerColor: divider,
      toggleableActiveColor: accent,
      unselectedWidgetColor: unselectedColor,
      appBarTheme: AppBarTheme(
        elevation: 0,
        backgroundColor: background,
        centerTitle: true,
        toolbarHeight: 60,
        titleTextStyle: GoogleFonts.workSans(
          fontSize: 20,
          fontWeight: FontWeight.w500
        )
      ),
      textTheme: GoogleFonts.workSansTextTheme().apply(
        displayColor: textDisplayColor,
        bodyColor: textBodyColor
      ),
      dialogTheme: DialogTheme(
        backgroundColor: elevatedBackground,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(borderRadius)
        )
      ),
      cardColor: elevatedBackground,
      cardTheme: CardTheme(
        color: elevatedBackground,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(borderRadius)
        ),
      ),
      bottomNavigationBarTheme: BottomNavigationBarThemeData(
        selectedItemColor: primary,
        unselectedItemColor: textUnfocusedColor,
        backgroundColor: background
      ),
      bottomSheetTheme: const BottomSheetThemeData(
        backgroundColor: Colors.transparent
      ),
      snackBarTheme: SnackBarThemeData(
        backgroundColor: snackBarBackground,
        contentTextStyle: TextStyle(color: snackBarForeground)
      ),
      splashColor: splashColor,
      highlightColor: highlightColor,
      inputDecorationTheme: InputDecorationTheme(
        border: OutlineInputBorder(
          borderRadius: BorderRadius.all(borderRadius)
        )
      ),
      floatingActionButtonTheme: FloatingActionButtonThemeData(
        extendedTextStyle: GoogleFonts.workSans(
          fontWeight: FontWeight.w500
        )
      ),
      bottomAppBarTheme: BottomAppBarTheme(
        color: elevatedBackground
      ),
      drawerTheme: DrawerThemeData(
        backgroundColor: elevatedBackground
      )
    );
    return theme.copyWith(
      colorScheme: theme.colorScheme.copyWith(
        primary: primary,
        secondary: accent
      )
    );
  }
}

class AppThemeDark extends AppTheme {
  @override
  Color get primary => const Color(0xFF0090FF);

  @override
  Color get accent => const Color(0xFF00D6FC);

  @override
  Color get background => const Color(0xFF000015);

  @override
  Color get divider => Colors.white.withOpacity(0.2);
  
  @override
  Color get unselectedColor => Colors.white.withOpacity(0.3);

  @override
  Color get textUnfocusedColor => const Color(0xFFAAAAAA);

  @override
  Color get textDisplayColor => const Color(0xFFCACACA);

  @override
  Color get textBodyColor => const Color(0xFFEAEAEA);

  @override
  Color get red => const Color(0xFFE38B8B);

  @override
  Color get orange => const Color(0xFFF3AD8E);

  @override
  Color get yellow => const Color(0xFFECC237);

  @override
  Color get green => const Color(0xFF7EB16B);

  @override
  Color get blue => const Color(0xFF3299E7);

  @override
  Color get purple => const Color(0xFFA077C9);

  @override
  Radius get borderRadius => const Radius.circular(10);

  @override
  Color get splashColor => Colors.white30.withOpacity(0.06);

  @override
  Color get highlightColor => Colors.white30.withOpacity(0.01);

  @override
  Color get elevatedBackground => const Color(0xFF191925);

  @override
  Color get snackBarBackground => const Color(0xFF4698D7);

  @override
  Color get snackBarForeground => Colors.black;

  @override
  Duration get animDuration => const Duration(milliseconds: 200);
}