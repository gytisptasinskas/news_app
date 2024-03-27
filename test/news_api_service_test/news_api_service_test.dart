import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:mockito/annotations.dart';
import 'package:dio/dio.dart';
import 'package:mockito/mockito.dart';
import 'package:news_app/models/article.dart';
import 'package:news_app/services/news_api_service.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:news_app/util/errors.dart';

import 'news_api_service_test.mocks.dart';

// Generate the MockDio class
@GenerateMocks([Dio])
void main() {
  group('fetchNews', () {
    final mockDio = MockDio();
    final service = NewsApiService(dio: mockDio);

    setUp(() {
      dotenv.testLoad();
    });

    test('returns a list of Article on a successful call', () async {
      when(mockDio.get(any, queryParameters: anyNamed('queryParameters')))
          .thenAnswer((_) async => Response(
                  data: {
                    'articles': [
                      {
                        "source": {"id": "test-id", "name": "Test Name"},
                        "author": "Test Author",
                        "title": "Test Title",
                        "description": "Test Description",
                        "url": "https://example.com",
                        "urlToImage": "https://example.com/image.jpg",
                        "publishedAt": "2022-04-23T19:04:05Z",
                        "content": "Test Content",
                      }
                    ]
                  },
                  statusCode: 200,
                  requestOptions: RequestOptions(path: '', queryParameters: {
                    'country': 'us',
                    'apiKey': dotenv.env['NEWS_API_KEY']
                  })));

      final articles = await service.fetchNews();
      expect(articles, isA<List<Article>>());
      expect(articles.isNotEmpty, true);
      expect(articles.first.author, 'Test Author');
    });

    test('throws NewsApiError.networkError on DioErrorType.other', () async {
      when(mockDio.get(any, queryParameters: anyNamed('queryParameters')))
          .thenThrow(DioError(
              type: DioErrorType.unknown,
              error: 'No Internet Connection',
              requestOptions: RequestOptions(path: '')));

      expect(
          () async => await service.fetchNews(), throwsA(isA<NewsApiError>()));
    });

    test('throws NewsApiError.authorizationError on 401 status code', () async {
      when(mockDio.get(any, queryParameters: anyNamed('queryParameters')))
          .thenThrow(DioError(
              response: Response(
                  statusCode: 401, requestOptions: RequestOptions(path: '')),
              requestOptions: RequestOptions(path: '')));

      expect(
          () async => await service.fetchNews(), throwsA(isA<NewsApiError>()));
    });

    test('throws NewsApiError.notFoundError on 404 status code', () async {
      when(mockDio.get(any, queryParameters: anyNamed('queryParameters')))
          .thenThrow(DioError(
              response: Response(
                  statusCode: 404, requestOptions: RequestOptions(path: '')),
              requestOptions: RequestOptions(path: '')));

      expect(
          () async => await service.fetchNews(), throwsA(isA<NewsApiError>()));
    });

    test('successfully fetches news with a different country parameter',
        () async {
      final country = 'uk';
      when(mockDio.get(any, queryParameters: anyNamed('queryParameters')))
          .thenAnswer((_) async => Response(
                  data: {
                    'articles': [
                      {
                        "source": {"id": "uk-test-id", "name": "UK Test Name"},
                        "author": "UK Test Author",
                        "title": "UK Test Title",
                        "description": "UK Test Description",
                        "url": "https://example.uk",
                        "urlToImage": "https://example.uk/image.jpg",
                        "publishedAt": "2022-05-01T12:00:00Z",
                        "content": "UK Test Content",
                      }
                    ]
                  },
                  statusCode: 200,
                  requestOptions: RequestOptions(path: '', queryParameters: {
                    'country': country,
                    'apiKey': dotenv.env['NEWS_API_KEY']
                  })));

      final articles = await service.fetchNews(country: country);
      expect(articles, isA<List<Article>>());
      expect(articles.isNotEmpty, true);
      expect(articles.first.author, 'UK Test Author');
    });
  });
}
