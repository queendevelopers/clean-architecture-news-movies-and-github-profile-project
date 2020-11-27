import 'package:equatable/equatable.dart';
import 'package:flutter_application_assignment/features/news_latest/domain/entities/news_entity.dart';
import 'package:meta/meta.dart';

class NewsModel extends Equatable with NewsEntity {
  NewsModel({@required this.title, @required this.description, @required this.urlToImage});

  factory NewsModel.fromJson(Map<String, dynamic> json) => NewsModel(
      title: json['title'],
      description: json['description'],
      urlToImage: json['urlToImage']);

    Map<String,dynamic> toJson()=>  {'title':title,'description':description,'urlToImage': urlToImage};

  @override
  String description;

  @override
  String title;

  @override
  String urlToImage;

  @override
  List<Object> get props => [title, description, urlToImage];

}
