import 'dart:convert';
import 'dart:io';

import 'package:flutter_application_assignment/core/error/exception.dart';
import 'package:flutter_application_assignment/features/news_latest/data/models/news_model.dart';
import 'package:http/http.dart' as http;
import 'package:meta/meta.dart';

abstract class NewsRemoteDataSource {
  Future<NewsModel> getNewsSpecific(String path);

  Future<NewsModel> getRandomNews();
}

class NewsRemoteDataSourceImpl implements NewsRemoteDataSource {
  final http.Client client;


  NewsRemoteDataSourceImpl(@required this.client);

  @override
  Future<NewsModel> getNewsSpecific(String path) async{
    final response= await client.get('https://newsapi.org/v2/top-headlines?category=$path&apiKey=b3fcd8293b6c4021a3e93485339d24c9',headers: {HttpHeaders.contentTypeHeader:'application/json'});
    if(response.statusCode==200){
      return NewsModel.fromJson(jsonDecode(response.body));
    }  else{
      throw ServerException();
    }
  }

  @override
  Future<NewsModel> getRandomNews() async{
    final response= await client.get('https://newsapi.org/v2/top-headlines?category=business&apiKey=b3fcd8293b6c4021a3e93485339d24c9',headers: {HttpHeaders.contentTypeHeader:'application/json'});
    if(response.statusCode==200){
      return NewsModel.fromJson(jsonDecode(response.body));
    }  else{
      throw ServerException();
    }
  }
}
