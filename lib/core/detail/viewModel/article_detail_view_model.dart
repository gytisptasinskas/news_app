import 'package:url_launcher/url_launcher.dart';

class ArticleDetailViewModel {
  Future launchURL(String url) async {
    Uri webView = Uri.parse(url);
    await launchUrl(webView);
  }
}


