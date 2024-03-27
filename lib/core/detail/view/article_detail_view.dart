import 'package:flutter/material.dart';
import 'package:news_app/core/detail/viewModel/article_detail_view_model.dart';
import 'package:news_app/models/article.dart';
import 'package:news_app/util/date.dart';

class ArticleDetailView extends StatelessWidget {
  final Article article;
  final ArticleDetailViewModel viewModel = ArticleDetailViewModel();
  ArticleDetailView({super.key, required this.article});

  @override
  Widget build(BuildContext context) {
    final String formattedDate = DateFormatter.formatDate(article.publishedAt);
    return Scaffold(
      body: CustomScrollView(
        slivers: <Widget>[
          SliverAppBar(
            iconTheme: const IconThemeData(color: Colors.white),
            expandedHeight: 150.0,
            floating: false,
            pinned: true,
            flexibleSpace: LayoutBuilder(
              builder: (BuildContext context, BoxConstraints constraints) {
                var top = constraints.biggest.height;
                bool isCollapsed = top <= 150;
                return FlexibleSpaceBar(
                  centerTitle:true,
                  title: AnimatedOpacity(
                    opacity: isCollapsed ? 1.0 : 0.0,
                    duration: const Duration(milliseconds: 250),
                    child: const Text(
                      'News App',
                      style: TextStyle(
                          color: Colors.black
                          ),
                    ),
                  ),
                  background: article.urlToImage != null &&
                          article.urlToImage!.isNotEmpty
                      ? Image.network(
                          article.urlToImage!,
                          fit: BoxFit.cover,
                        )
                      : const Icon(Icons.image_not_supported, size: 150),
                );
              },
            ),
          ),
          SliverFillRemaining(
            hasScrollBody: true,
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    article.title,
                    style: Theme.of(context).textTheme.headlineSmall,
                  ),
                  const SizedBox(height: 10),
                  Text(
                    formattedDate,
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                  const SizedBox(height: 20),
                  Text(
                    article.content ?? 'No content available',
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                  Container(
                    margin: const EdgeInsets.only(top: 20),
                    decoration: BoxDecoration(
                      color: Colors.blue,
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                    width: double.infinity,
                    child: TextButton(
                      onPressed: () => viewModel.launchURL(article.url),
                      child: Text(
                        "Read full Article",
                        style: Theme.of(context)
                            .textTheme
                            .bodyMedium!
                            .copyWith(color: Colors.white),
                      ),
                    ),
                  )
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
