// ignore_for_file: deprecated_member_use

import 'package:dio/dio.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:news_app/models/article.dart';
import 'package:news_app/services/api_service.dart';
import 'package:news_app/util/errors.dart';

class NewsApiService implements ApiService {
  final Dio dio;
  final String _baseUrl = "https://newsapi.org/v2";

  NewsApiService({required this.dio});

  @override
  Future<List<Article>> fetchNews({String country = 'us'}) async {
    final apiKey = dotenv.env['NEWS_API_KEY'];
    
    try {
     final response = await dio.get(
        '$_baseUrl/top-headlines',
        queryParameters: {
          'country': country,
          'apiKey': apiKey,
        },
      );
      if (response.statusCode == 200) {
        final List<dynamic> articlesJson = response.data['articles'];
        return articlesJson.map((json) => Article.fromJson(json)).toList();
      } else {
        throw NewsApiError.serverError;
      }
    } on DioError catch (e) {
      if (e.type == DioErrorType.connectionTimeout ||
          e.type == DioErrorType.receiveTimeout) {
        throw NewsApiError.networkError;
      } else if (e.response?.statusCode == 401 ||
          e.response?.statusCode == 403) {
        throw NewsApiError.authorizationError;
      } else if (e.response != null) {
        throw NewsApiError.serverError;
      } else {
        throw NewsApiError.unknownError;
      }
    } catch (_) {
      throw NewsApiError.unknownError;
    }
  }
}
