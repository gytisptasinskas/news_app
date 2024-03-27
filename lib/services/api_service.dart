import 'package:news_app/models/article.dart';

abstract class ApiService {
  Future<List<Article>> fetchNews({String country});
}
