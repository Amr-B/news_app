class ApiEndPoints {
  static const String baseUrl = "https://newsapi.org/v2";
  static const String appleArticle =
      "$baseUrl/everything?q=apple&from=2025-04-29&to=2025-04-29&sortBy=popularity&apiKey=a14a4288d91c40db8d9c6b15a5be8826";

  // > latest news
  static const String streetJornal =
      "$baseUrl/everything?domains=wsj.com&apiKey=a14a4288d91c40db8d9c6b15a5be8826";

  // > top headlines from TechCrunch
  static const String techCrunch =
      "https://newsapi.org/v2/top-headlines?sources=techcrunch&apiKey=a14a4288d91c40db8d9c6b15a5be8826";

  static const String businessHeadlines =
      "$baseUrl/top-headlines?country=us&category=business&apiKey=a14a4288d91c40db8d9c6b15a5be8826";

  static const String teslaNews =
      "$baseUrl/everything?q=tesla&from=2025-03-30&sortBy=publishedAt&apiKey=a14a4288d91c40db8d9c6b15a5be8826";
}
