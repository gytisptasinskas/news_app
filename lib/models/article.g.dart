// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'article.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Article _$ArticleFromJson(Map<String, dynamic> json) => Article(
      title: json['title'] as String,
      publishedAt: json['publishedAt'] as String,
      urlToImage: json['urlToImage'] as String?,
      author: json['author'] as String?,
      content: json['content'] as String?,
      url: json['url'] as String,
      description: json['description'] as String?,
    );

Map<String, dynamic> _$ArticleToJson(Article instance) => <String, dynamic>{
      'title': instance.title,
      'publishedAt': instance.publishedAt,
      'urlToImage': instance.urlToImage,
      'author': instance.author,
      'url': instance.url,
      'content': instance.content,
      'description': instance.description,
    };
