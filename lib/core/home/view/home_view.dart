import 'package:flutter/material.dart';
import 'package:news_app/core/home/viewModel/home_view_model.dart';
import 'package:news_app/widgets/article_tile.dart';
import 'package:provider/provider.dart';

class HomeView extends StatelessWidget {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<HomeViewModel>(
      create: (_) => HomeViewModel()..fetchArticles('us'),
      child: Scaffold(
        appBar: AppBar(
          title: const Text('News Articles'),
        ),
        body: Consumer<HomeViewModel>(
          builder: (context, viewModel, _) {
            if (viewModel.isLoading) {
              return const Center(child: CircularProgressIndicator.adaptive());
            } else if (viewModel.errorMessage != null) {
              return Center(
                  child: Text(viewModel.errorMessage!));
            }
            return ListView.builder(
              itemCount: viewModel.articles.length,
              itemBuilder: (context, index) =>
                  ArticleTile(article: viewModel.articles[index]),
            );
          },
        ),
      ),
    );
  }
}
