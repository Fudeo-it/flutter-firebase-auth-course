import 'package:shared_preferences/shared_preferences.dart';

const String _SHARED_PREFERENCES_DARK_MODE_ENABLED = 'DARK_MODE_ENABLED';

class SharedPreferencesProvider {
  final Future<SharedPreferences> sharedPreferences;

  SharedPreferencesProvider({required this.sharedPreferences});

  Future<bool> get darkModeEnabled async =>
      (await sharedPreferences)
          .getBool(_SHARED_PREFERENCES_DARK_MODE_ENABLED) ??
      false;

  Future<void> setDarkMode(bool value) async => (await sharedPreferences)
      .setBool(_SHARED_PREFERENCES_DARK_MODE_ENABLED, value);
}
