import 'package:shared_preferences/shared_preferences.dart';

class LocalStorage {
  SharedPreferences? prefs;

  LocalStorage._() {
    init();
  }

  static LocalStorage? _instance;

  LocalStorage._pre(SharedPreferences this.prefs);

  static Future<LocalStorage> preInit() async {
    if (_instance == null) {
      var prefs = await SharedPreferences.getInstance();
      _instance = LocalStorage._pre(prefs);
    }

    return _instance!;
  }

  static LocalStorage getInstance() {
    _instance ??= LocalStorage._();
    return _instance!;
  }

  void init() async {
    prefs ??= await SharedPreferences.getInstance();
  }

  setString(String key, String value) {
    prefs?.setString(key, value);
  }

  setDouble(String key, double value) {
    prefs?.setDouble(key, value);
  }

  setInt(String key, int value) {
    prefs?.setInt(key, value);
  }

  setBool(String key, bool value) {
    prefs?.setBool(key, value);
  }

  setStringList(String key, List<String> value) {
    prefs?.setStringList(key, value);
  }

  remove(String key) {
    prefs?.remove(key);
  }

  Object? get<T>(String key) {
    return prefs?.get(key);
  }
}
