import 'package:flutter/material.dart';
import 'package:news_app/models/articles.dart';
import 'package:news_app/news/widgets/article_container.dart';
import '../helpers/save_manager.dart';

class SaveScreen extends StatefulWidget {
  const SaveScreen({super.key});

  @override
  State<SaveScreen> createState() => _SaveScreenState();
}

class _SaveScreenState extends State<SaveScreen> {
  List<Article> _saved = [];

  @override
  void initState() {
    super.initState();
    loadSavedArticles();
  }

  Future<void> loadSavedArticles() async {
    final data = await SaveManager.getSavedArticles();
    setState(() => _saved = data);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Saved Articles'),
        centerTitle: true,
        backgroundColor: Colors.white,
      ),
      body: _saved.isEmpty
          ? const Center(child: Text('No saved articles'))
          : ListView.separated(
              separatorBuilder: (context, index) => const SizedBox(height: 16),
              itemCount: _saved.length,
              itemBuilder: (context, index) {
                final article = _saved[index];
                return KArticleContainer(
                  article: article,
                  title: article.title,
                  author: article.author ?? 'unknown',
                  imageUrl: article.urlToImage ?? '',
                );
              },
            ),
    );
  }
}
