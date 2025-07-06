import 'package:shared_preferences/shared_preferences.dart';

class SearchHistoryService {
  static const String key = 'search_history';

  Future<void> save(String keyword) async {
    final prefs = await SharedPreferences.getInstance();
    List<String> history = prefs.getStringList(key) ?? [];
    history.remove(keyword);
    history.insert(0, keyword);
    if (history.length > 5) history = history.sublist(0, 5);
    await prefs.setStringList(key, history);
  }

  Future<List<String>> get() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getStringList(key) ?? [];
  }

  Future<void> remove(String keyword) async {
    final prefs = await SharedPreferences.getInstance();
    List<String> history = prefs.getStringList(key) ?? [];
    history.remove(keyword);
    await prefs.setStringList(key, history);
  }

  Future<void> clear() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(key);
  }
}
