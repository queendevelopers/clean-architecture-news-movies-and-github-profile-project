import 'package:flutter_application_assignment/features/news_latest/data/models/news_model.dart';

abstract class NewsLocalDataSource{
  Future<NewsModel> getLastNews();
  Future<void> cacheNews(NewsModel newsModel);
}