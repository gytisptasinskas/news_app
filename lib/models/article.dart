import 'package:json_annotation/json_annotation.dart';

part 'article.g.dart';

@JsonSerializable()
class Article {
  final String title;
  final String publishedAt;
  final String? urlToImage;
  final String? author;
  final String url;
  final String? content;
  final String? description;

  Article({
    required this.title,
    required this.publishedAt,
    this.urlToImage,
    this.author,
    this.content,
    required this.url,
    this.description,
  });

  factory Article.fromJson(Map<String, dynamic> json) =>
      _$ArticleFromJson(json);
  Map<String, dynamic> toJson() => _$ArticleToJson(this);
}
