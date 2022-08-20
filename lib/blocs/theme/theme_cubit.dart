import 'package:bloc/bloc.dart';
import 'package:bytre/styles.dart';
import 'package:meta/meta.dart';

part 'theme_state.dart';

class ThemeCubit extends Cubit<ThemeState> {
  ThemeCubit(this._theme) : super(ThemeInitial());

  AppTheme _theme;

  AppTheme get theme => _theme;

  set theme(AppTheme theme) {
    _theme = theme;
    emit(ThemeChanged());
  }
}
