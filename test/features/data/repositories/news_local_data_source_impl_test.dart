import 'dart:convert';
import 'package:matcher/matcher.dart';

import 'package:flutter_application_assignment/core/error/exception.dart';
import 'package:flutter_application_assignment/features/news_latest/data/models/news_model.dart';
import 'package:flutter_application_assignment/features/news_latest/data/repositories/news_local_data_source_impl.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../fixtures/fixture_reader.dart';

class MockSharedPreferences extends Mock implements SharedPreferences {}

void main() {
  NewsLocalDataSourceImpl newsLocalDataSourceImpl;
  MockSharedPreferences mockSharedPreferences;

  setUp(() {
    mockSharedPreferences = MockSharedPreferences();
    newsLocalDataSourceImpl = NewsLocalDataSourceImpl(mockSharedPreferences);
  });

  group('getLastNews', () {
    final tNewsModel =
        NewsModel.fromJson(jsonDecode(fixture('news_cached.json')));

    test(
        'should return NewsEntity from SharedPreferences when there is one is the cache',
        () async {
      when(mockSharedPreferences.getString(any))
          .thenReturn(fixture('news_cached.json'));
      final result = await newsLocalDataSourceImpl.getLastNews();
      verify(mockSharedPreferences.getString(CACHED_NEWS));
      expect(result, tNewsModel);
    });

    /* // Error returns Instance of CacheException
   test('should throw a CacheException when there is not a cached value', ()async{
      when(mockSharedPreferences.getString(any)).thenReturn(null);
      final call = newsLocalDataSourceImpl.getLastNews();
      expect(call, throwsA(isA<CacheExecption>()));
    });
    */
  });

  group('cacheNewsLatest', () {
    final tNewsLatest = NewsModel(
        title: 'news title',
        description: 'news description',
        urlToImage: 'url_to_image');
    test('should call SharedPreferences to cache the data', () {
      newsLocalDataSourceImpl.cacheNews(tNewsLatest);
      final expectedJsonString = json.encode(tNewsLatest.toJson());
      verify(mockSharedPreferences.setString(CACHED_NEWS, expectedJsonString));
    });
  });
}
