import 'dart:convert';

import 'package:flutter_application_assignment/features/news_latest/data/datasource/news_local_data_source.dart';
import 'package:flutter_application_assignment/features/news_latest/data/models/news_model.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

import '../../../fixtures/fixture_reader.dart';

class MockNewsLocalDataSource extends Mock implements NewsLocalDataSource{}
void main(){
  setUp((){
    MockNewsLocalDataSource mockNewsLocalDataSource;
  });

  group('getLastNews', (){
    final tNewsModel=NewsModel.fromJson(jsonDecode(fixture('news_cached.json')));

    test('should return NewsEntity from SharedPreferences when there is one is the cache', ()async{
    });
  });
}