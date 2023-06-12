```dart
abstract class AppSettings {
  Future<void> clear();
}

class AppSettingsImpl implements AppSettings, ThemeModeSetting {
  final SharedPreferences _pref;

  AppSettingsImpl(SharedPreferences preferences) : _pref = preferences;

  @override
  ThemeMode? get themeMode {
    final index = _pref.getInt(ThemeModeSetting.key);
    return index != null ? ThemeMode.values[index] : null;
  }

  @override
  Future<void> setThemeMode(ThemeMode themeMode) async {
    await _pref.setInt(ThemeModeSetting.key, themeMode.index);
  }

  @override
  Future<void> clear() async {
    await _pref.clear();
  }
}

abstract class ThemeModeSetting {
  static const String key = 'themeMode';
  ThemeMode? get themeMode;
  Future<void> setThemeMode(ThemeMode themeMode);
}
```