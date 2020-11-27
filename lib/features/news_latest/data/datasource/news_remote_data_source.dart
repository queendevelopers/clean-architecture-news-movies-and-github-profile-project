import 'package:flutter_application_assignment/features/news_latest/data/models/news_model.dart';

abstract class NewsRemoteDataSource{
  Future<NewsModel> getNewsSpecific(String path);
  Future<NewsModel> getRandomNews();


}