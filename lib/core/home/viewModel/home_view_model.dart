import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:news_app/models/article.dart';
import 'package:news_app/services/news_api_service.dart';
import 'package:news_app/util/errors.dart';

class HomeViewModel extends ChangeNotifier {
  final NewsApiService _newsApiService;

  List<Article> _articles = [];
  List<Article> get articles => _articles;

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  String? _errorMessage;
  String? get errorMessage => _errorMessage;

  HomeViewModel({NewsApiService? newsApiService})
      : _newsApiService = newsApiService ?? NewsApiService(dio: Dio());

  void fetchArticles(String country) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      _articles = await _newsApiService.fetchNews(country: country);
    } on NewsApiError catch (error) {
      _errorMessage = _mapErrorToMessage(error);
    } catch (_) {
      _errorMessage = "An unexpected error occurred. Please try again.";
    }

    _isLoading = false;
    notifyListeners();
  }

  String _mapErrorToMessage(NewsApiError error) {
    switch (error) {
      case NewsApiError.networkError:
        return "Network error. Please check your internet connection.";
      case NewsApiError.authorizationError:
        return "Authorization error. Please check your API key.";
      case NewsApiError.serverError:
        return "Server error. Please try again later.";
      default:
        return "An unknown error occurred. Please try again.";
    }
  }
}
