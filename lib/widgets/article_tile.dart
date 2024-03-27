import 'package:flutter/material.dart';
import 'package:news_app/core/detail/view/article_detail_view.dart';
import 'package:news_app/models/article.dart';
import 'package:news_app/util/date.dart';

class ArticleTile extends StatelessWidget {
  final Article article;
  const ArticleTile({super.key, required this.article});

  @override
  Widget build(BuildContext context) {
    final String formattedDate = DateFormatter.formatDate(article.publishedAt);

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 5),
      child: Card(
        elevation: 2.0,
        child: ListTile(
          title: Text(
            article.title,
            style: Theme.of(context).textTheme.titleSmall,
            maxLines: 3,
            overflow: TextOverflow.ellipsis,
          ),
          subtitle: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(article.description ?? "No description", maxLines: 2,),
              Text("Date: $formattedDate")
            ],
          ),
          leading: article.urlToImage != null && article.urlToImage!.isNotEmpty
              ? Image.network(
                  article.urlToImage!,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) =>
                      const Icon(Icons.image_not_supported),
                )
              : const SizedBox(
                  width: 100,
                  child: Center(
                    child: Icon(Icons.image_not_supported),
                  ),
                ),
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => ArticleDetailView(article: article),
              ),
            );
          },
        ),
      ),
    );
  }
}
