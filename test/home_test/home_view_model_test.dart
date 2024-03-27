import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:news_app/core/home/viewModel/home_view_model.dart';
import 'package:news_app/models/article.dart';
import 'package:news_app/services/news_api_service.dart';
import 'package:news_app/util/errors.dart';
import 'package:mockito/annotations.dart';

// Generate mocks
@GenerateMocks([NewsApiService])
import 'home_view_model_test.mocks.dart';

void main() {
  group('HomeViewModel', () {
    late MockNewsApiService mockNewsApiService;
    late HomeViewModel viewModel;

    setUp(() {
       mockNewsApiService = MockNewsApiService();
       viewModel = HomeViewModel(newsApiService: mockNewsApiService);
    });

    test('fetchArticles successfully updates articles and loading state',
        () async {
      final articles = [Article(title: 'Dummy Artical', publishedAt: '2024-01', url: 'https://google.com')];
      when(mockNewsApiService.fetchNews(country: anyNamed('country')))
          .thenAnswer((_) async => articles);

      expect(viewModel.isLoading, isFalse);
      viewModel.fetchArticles('us');

      expect(viewModel.isLoading, isTrue);

      await untilCalled(
          mockNewsApiService.fetchNews(country: anyNamed('country')));

      expect(viewModel.isLoading, isFalse);
      expect(viewModel.articles, equals(articles));
    });

    test('fetchArticles updates errorMessage on failure', () async {
      when(mockNewsApiService.fetchNews(country: anyNamed('country')))
          .thenThrow(NewsApiError.networkError);

      viewModel.fetchArticles('us');

      await untilCalled(
          mockNewsApiService.fetchNews(country: anyNamed('country')));

      expect(viewModel.errorMessage, isNotNull);
      expect(viewModel.errorMessage,
          "Network error. Please check your internet connection.");
    });
  });
}
