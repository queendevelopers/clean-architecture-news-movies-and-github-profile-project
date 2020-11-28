import 'dart:convert';

import 'package:flutter_application_assignment/core/error/exception.dart';
import 'package:flutter_application_assignment/features/news_latest/data/datasource/news_local_data_source.dart';
import 'package:flutter_application_assignment/features/news_latest/data/models/news_model.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:meta/meta.dart';

const CACHED_NEWS = 'CACHED_NEWS';

class NewsLocalDataSourceImpl implements NewsLocalDataSource{
  final SharedPreferences sharedPreferences;

  NewsLocalDataSourceImpl(@required this.sharedPreferences);

  @override
  Future<void> cacheNews(NewsModel newsModel) {
    return sharedPreferences.setString(CACHED_NEWS, json.encode(newsModel.toJson()));
  }

  @override
  Future<NewsModel> getLastNews() {
    final jsonString=sharedPreferences.getString(CACHED_NEWS);
    if(jsonString!=null){
      return Future.value(NewsModel.fromJson(jsonDecode(jsonString)));
    }else{
      throw CacheExecption();
    }
  }


}