import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/articles.dart';

class SaveManager {
  static const String key = 'saved_articles';

  static Future<void> saveArticle(Article article) async {
    final prefs = await SharedPreferences.getInstance();
    final saved = prefs.getStringList(key) ?? [];

    // prevent duplicate saves
    if (saved.any((item) => jsonDecode(item)['url'] == article.url)) return;

    saved.add(jsonEncode(article.toJson()));
    await prefs.setStringList(key, saved);
  }

  static Future<List<Article>> getSavedArticles() async {
    final prefs = await SharedPreferences.getInstance();
    final saved = prefs.getStringList(key) ?? [];
    return saved.map((item) => Article.fromJson(jsonDecode(item))).toList();
  }

  static Future<void> removeArticle(String url) async {
    final prefs = await SharedPreferences.getInstance();
    final saved = prefs.getStringList(key) ?? [];
    saved.removeWhere((item) => jsonDecode(item)['url'] == url);
    await prefs.setStringList(key, saved);
  }
}
