import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:telegram_app/providers/shared_preferences_provider.dart';

class DarkModeCubit extends Cubit<bool> {
  final SharedPreferencesProvider preferencesProvider;

  DarkModeCubit({required this.preferencesProvider}) : super(false);

  void init() async {
    emit(await preferencesProvider.darkModeEnabled);
  }

  void setDarkModeEnabled(bool mode) async {
    await preferencesProvider.setDarkMode(mode);
    emit(mode);
  }

  void toggleDarkMode() => setDarkModeEnabled(!state);

}