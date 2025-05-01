import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:iconsax/iconsax.dart';
import 'dart:convert';

import 'package:news_app/api/endpoints.dart';
import 'package:news_app/models/articles.dart';
import 'package:news_app/news/widgets/article_container.dart';
import '../helpers/helper_function.dart';
import 'save_screen.dart';

class NewsHome extends StatefulWidget {
  const NewsHome({super.key});

  @override
  State<NewsHome> createState() => _NewsHomeState();
}

class _NewsHomeState extends State<NewsHome> {
  int _selectedIndex = 0;
  bool _isLoadingCategory = false;
  final ScrollController _scrollController = ScrollController();
  int _page = 1;
  bool _isLoadingMore = false;
  List<Article> _allArticles = [];
  bool _hasMore = true;
  late String selectedEndpoint;

  @override
  void initState() {
    super.initState();
    selectedEndpoint = ApiEndPoints.streetJornal;
    getPostById(selectedEndpoint, page: _page);

    _scrollController.addListener(() {
      if (_scrollController.position.pixels >=
              _scrollController.position.maxScrollExtent - 200 &&
          !_isLoadingMore &&
          _hasMore) {
        _isLoadingMore = true;
        _page++;
        getPostById(selectedEndpoint, page: _page);
      }
    });
  }

  Future<void> getPostById(String endpoint, {int page = 1}) async {
    final pagedUrl = "$endpoint&page=$page";
    final response = await http.get(Uri.parse(pagedUrl));

    if (response.statusCode == 200) {
      final List<dynamic> jsonData = json.decode(response.body)['articles'];
      final newArticles =
          jsonData.map((json) => Article.fromJson(json)).toList();

      setState(() {
        if (page == 1) {
          _allArticles = newArticles;
          _isLoadingCategory = false;
        } else {
          _allArticles.addAll(newArticles);
        }

        _hasMore = newArticles.isNotEmpty;
        _isLoadingMore = false;
      });
    } else {
      throw Exception('Failed to load data! Code: ${response.statusCode}');
    }
  }

  void changeCategory(String endpoint) {
    setState(() {
      selectedEndpoint = endpoint;
      _page = 1;
      _hasMore = true;
      _isLoadingMore = false;
      _isLoadingCategory = true;
      _allArticles.clear();
    });
    getPostById(endpoint, page: _page);
  }

  Widget buildFilterButton(String label, String endpoint) {
    return Padding(
      padding: const EdgeInsets.only(right: 8),
      child: ElevatedButton(
        onPressed: () => changeCategory(endpoint),
        style: ElevatedButton.styleFrom(
          shadowColor: Colors.transparent,
          backgroundColor: selectedEndpoint == endpoint
              ? Colors.blue.shade300
              : Colors.grey.shade300,
        ),
        child: Text(label, style: const TextStyle(color: Colors.black)),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final double screenHeight = KHelperFunction.screenHeight(context);

    // Screens
    final List<Widget> screens = [
      _buildHomeScreen(screenHeight),
      const SaveScreen(),
    ];

    return Scaffold(
      body: screens[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: (int index) => setState(() => _selectedIndex = index),
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Iconsax.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Iconsax.save_2),
            label: 'Saved',
          ),
        ],
      ),
    );
  }

  Widget _buildHomeScreen(double screenHeight) {
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: screenHeight * 0.1,
        centerTitle: true,
        backgroundColor: Colors.white,
        title: Image.asset(
          'assets/images/newspaper.png',
          height: screenHeight * 0.1,
        ),
        elevation: 0,
      ),
      body: Column(
        children: [
          SizedBox(height: screenHeight * 0.02),
          const Text(
            'Latest News',
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
          ),
          SizedBox(height: screenHeight * 0.03),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            padding: EdgeInsets.symmetric(horizontal: screenHeight * 0.02),
            child: Row(
              children: [
                buildFilterButton("Latest", ApiEndPoints.streetJornal),
                buildFilterButton("Apple", ApiEndPoints.appleArticle),
                buildFilterButton("Business", ApiEndPoints.businessHeadlines),
                buildFilterButton("Tesla", ApiEndPoints.teslaNews),
                buildFilterButton("TechCrunch", ApiEndPoints.techCrunch),
              ],
            ),
          ),
          SizedBox(height: screenHeight * 0.02),
          Expanded(
            child: _isLoadingCategory
                ? const Center(child: CircularProgressIndicator())
                : ListView.separated(
                    controller: _scrollController,
                    itemCount: _allArticles.length + (_hasMore ? 1 : 0),
                    separatorBuilder: (context, index) =>
                        const SizedBox(height: 16),
                    itemBuilder: (context, index) {
                      if (index < _allArticles.length) {
                        final article = _allArticles[index];
                        final isValid = article.title.isNotEmpty &&
                            (article.urlToImage?.isNotEmpty ?? false);

                        if (isValid) {
                          return KArticleContainer(
                            article: article,
                            title: article.title,
                            author: article.author ?? 'unknown',
                            imageUrl: article.urlToImage!,
                          );
                        } else {
                          return Padding(
                            padding: EdgeInsets.symmetric(
                              horizontal: screenHeight * 0.02,
                            ),
                            child: Container(
                              padding: const EdgeInsets.all(16),
                              decoration: BoxDecoration(
                                color: Colors.grey.shade300,
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: const Text(
                                'This article is unavailable or contains incomplete data.',
                                style: TextStyle(color: Colors.red),
                              ),
                            ),
                          );
                        }
                      } else {
                        return const Center(
                          child: Padding(
                            padding: EdgeInsets.all(16),
                            child: CircularProgressIndicator(),
                          ),
                        );
                      }
                    },
                  ),
          ),
        ],
      ),
    );
  }
}
