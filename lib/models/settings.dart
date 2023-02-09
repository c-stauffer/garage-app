import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:garage_app/global_config.dart';

class GarageAppSettings {
  final _storage = const FlutterSecureStorage();

  String? _username;
  String? _password;
  String? _tempUnits;
  int? _doorInactiveRefreshSeconds;
  int? _doorActiveRefreshSeconds;
  bool? _showDebug;
  ThemeMode _themeMode = ThemeMode.system;

  String? get username => _username;
  String? get password => _password;
  String? get tempUnits => _tempUnits;
  int? get doorInactiveRefreshSeconds => _doorInactiveRefreshSeconds;
  int? get doorActiveRefreshSeconds => _doorActiveRefreshSeconds;
  bool? get showDebug => _showDebug;
  ThemeMode get themeMode => _themeMode;

  set username(String? value) {
    _username = value;
    _storage.write(key: 'username', value: value);
  }

  set password(String? value) {
    _password = value;
    _storage.write(key: 'password', value: value);
  }

  set tempUnits(String? value) {
    _tempUnits = value;
    _storage.write(key: 'tempUnits', value: value);
  }

  set doorInactiveRefreshSeconds(int? value) {
    _doorInactiveRefreshSeconds = value;
    _storage.write(key: 'doorInactiveRefreshSeconds', value: value?.toString());
  }

  set doorActiveRefreshSeconds(int? value) {
    _doorActiveRefreshSeconds = value;
    _storage.write(key: 'doorActiveRefreshSeconds', value: value?.toString());
  }

  set showDebug(bool? value) {
    _showDebug = value;
    _storage.write(
        key: 'showDebug', value: (value ?? false) ? 'true' : 'false');
  }

  set themeMode(ThemeMode value) {
    _themeMode = value;
    _storage.write(key: 'themeMode', value: _themeMode.name);
    currentTheme.switchTheme(value);
  }

  GarageAppSettings() {
    init();
  }

  Future<void> init() async {
    _username = await _storage.read(key: 'username');
    _password = await _storage.read(key: 'password');
    _tempUnits = await _storage.read(key: 'tempUnits') ?? 'F';
    _doorInactiveRefreshSeconds = int.tryParse(
        await _storage.read(key: 'doorInactiveRefreshSeconds') ?? '5');
    _doorActiveRefreshSeconds = int.tryParse(
        await _storage.read(key: 'doorActiveRefreshSeconds') ?? '1');
    _showDebug =
        (await _storage.read(key: 'showDebug'))?.toLowerCase() == 'true';
    var settingTheme = await _storage.read(key: 'themeMode') ?? 'system';
    _themeMode = ThemeMode.values.firstWhere((tm) => tm.name == settingTheme);
    currentTheme.switchTheme(_themeMode);
  }
}
