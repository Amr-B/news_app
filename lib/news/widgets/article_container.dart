import 'package:flutter/material.dart';
import 'package:news_app/news/details_screen.dart';

import '../../helpers/helper_function.dart';
import '../../models/articles.dart';

class KArticleContainer extends StatelessWidget {
  const KArticleContainer({
    super.key,
    required this.title,
    required this.author,
    required this.imageUrl,
    required this.article,
  });

  final String title;
  final String author;
  final String imageUrl;
  final Article article;

  @override
  Widget build(BuildContext context) {
    // > responsive

    final double screenHeight = KHelperFunction.screenHeight(context);
    final double screenWidth = KHelperFunction.screenWidth(context);

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.05),
      child: GestureDetector(
        onTap: () {
          Navigator.push(
            context,
            PageRouteBuilder(
              pageBuilder: (context, animation, secondaryAnimation) =>
                  DetailsScreen(article: article),
              transitionsBuilder:
                  (context, animation, secondaryAnimation, child) {
                const begin = Offset(1.0, 0.0);
                const end = Offset.zero;
                const curve = Curves.ease;

                var tween = Tween(begin: begin, end: end)
                    .chain(CurveTween(curve: curve));
                var offsetAnimation = animation.drive(tween);

                return FadeTransition(
                  opacity: animation,
                  child: SlideTransition(
                    position: offsetAnimation,
                    child: child,
                  ),
                );
              },
            ),
          );
        },
        child: Container(
          height: screenHeight * 0.15,
          decoration: BoxDecoration(
            color: Colors.grey.shade300,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Row(
            children: [
              // Image on the left with loading
              ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: SizedBox(
                  height: screenHeight * 0.2,
                  width: screenWidth * 0.4,
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      const Center(child: CircularProgressIndicator()),
                      Image.network(
                        imageUrl,
                        cacheWidth: 400,
                        height: screenHeight * 0.3,
                        width: screenWidth * 0.4,
                        fit: BoxFit.cover,
                        loadingBuilder: (context, child, loadingProgress) {
                          if (loadingProgress == null) return child;
                          return const SizedBox
                              .shrink(); // loader already shown
                        },
                        errorBuilder: (_, __, ___) => Container(
                          color: Colors.grey,
                          child: const Center(
                            child:
                                Icon(Icons.broken_image, color: Colors.white),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              // Texts on the right
              Expanded(
                child: Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: screenWidth * 0.03,
                    vertical: screenHeight * 0.02,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        title,
                        style: const TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 8),
                      Expanded(
                        child: Text(
                          "by: $author",
                          style: const TextStyle(
                            fontSize: 14,
                            color: Colors.grey,
                          ),
                          softWrap: true,
                        ),
                      ),
                      Expanded(
                        child: Text(
                          "Read more >",
                          style: const TextStyle(
                            fontSize: 14,
                            color: Colors.blue,
                          ),
                          softWrap: true,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
