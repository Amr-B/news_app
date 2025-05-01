// ignore_for_file: deprecated_member_use, use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import '../helpers/helper_function.dart';
import '../helpers/save_manager.dart';
import '../models/articles.dart';

class DetailsScreen extends StatefulWidget {
  final Article article;
  const DetailsScreen({super.key, required this.article});

  @override
  State<DetailsScreen> createState() => _DetailsScreenState();
}

class _DetailsScreenState extends State<DetailsScreen> {
  //  BUILD UI
  @override
  Widget build(BuildContext context) {
    // > responsive
    final double screenHeight = KHelperFunction.screenHeight(context);
    final double screenWidth = KHelperFunction.screenWidth(context);

    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: screenHeight * 0.3,
            pinned: true,
            flexibleSpace: FlexibleSpaceBar(
              background: Stack(
                fit: StackFit.expand,
                children: [
                  widget.article.urlToImage != null
                      ? Image.network(
                          widget.article.urlToImage!,
                          fit: BoxFit.cover,
                          errorBuilder: (_, __, ___) => const Center(
                            child: Icon(
                              Icons.broken_image,
                              size: 60,
                            ),
                          ),
                          loadingBuilder: (context, child, loadingProgress) {
                            if (loadingProgress == null) return child;
                            return Center(
                              child: CircularProgressIndicator(
                                color: Colors.black,
                              ),
                            );
                          },
                        )
                      : Center(
                          child: Icon(
                            Icons.image,
                            size: 60,
                          ),
                        ),
                ],
              ),
            ),
            leading: IconButton(
              onPressed: () => Navigator.pop(context),
              icon: Container(
                padding: EdgeInsets.all(6),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.6),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.chevron_left,
                  size: 24,
                  color: Colors.black,
                ),
              ),
            ),
            actions: [
              IconButton(
                onPressed: () async {
                  await SaveManager.saveArticle(widget.article);
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Article saved')),
                  );
                },
                icon: Container(
                  padding: EdgeInsets.all(6),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.6),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    Iconsax.save_2,
                    size: 20,
                    color: Colors.black,
                  ),
                ),
              ),
            ],
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  // > article title
                  Text(
                    widget.article.title,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: screenHeight * 0.02),

                  // > author and date
                  Padding(
                    padding:
                        EdgeInsets.symmetric(horizontal: screenWidth * 0.03),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Text(
                            'By ${widget.article.author ?? "Unknown"}',
                            style: TextStyle(
                              color: Colors.grey.shade500,
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                            softWrap: true,
                          ),
                        ),
                        Text(
                          widget.article.publishedAt.split('T').first,
                          style: TextStyle(color: Colors.blue),
                        ),
                      ],
                    ),
                  ),

                  SizedBox(height: 30),

                  // > discription of news
                  Padding(
                    padding:
                        EdgeInsets.symmetric(horizontal: screenWidth * 0.03),
                    child: Text(
                      widget.article.content ?? 'error loading content',
                      style: TextStyle(
                        fontSize: 20,
                      ),
                      textAlign: TextAlign.start,
                    ),
                  )
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
