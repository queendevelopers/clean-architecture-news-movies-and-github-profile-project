import 'dart:convert';

import 'package:flutter_application_assignment/features/news_latest/data/models/news_model.dart';
import 'package:flutter_application_assignment/features/news_latest/domain/entities/news_entity.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../../fixtures/fixture_reader.dart';

void main() {
  final tNewsModel = NewsModel(
      title: "news title",
      description: "news description",
      urlToImage: "url_to_image");

  test('should be a subclass of NewsEntity entity', () async{
    expect(tNewsModel, isA<NewsModel>());
  });

  group('fromJson()', () {
    test('should be a subclass of NewsEntity entity', () async{
      final Map<String, dynamic> jsonMap = json.decode(fixture('news.json'));
      final result = NewsModel.fromJson(jsonMap);
      expect(result, tNewsModel);
    });
  });

  group('toJson()', () {
    test('should return a JSON map containg the proper data', () {
      final result = tNewsModel.toJson();
      final expectedJsonMap = {
        'title': 'news title',
        'description': 'news description',
        'urlToImage': 'url_to_image'
      };

      expect(result, expectedJsonMap);
    });
  });
}
