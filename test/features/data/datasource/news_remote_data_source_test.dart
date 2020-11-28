import 'dart:convert';
import 'dart:io';

import 'package:flutter_application_assignment/core/error/exception.dart';
import 'package:flutter_application_assignment/features/news_latest/data/datasource/news_remote_data_source.dart';
import 'package:flutter_application_assignment/features/news_latest/data/models/news_model.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:mockito/mockito.dart';

import '../../../fixtures/fixture_reader.dart';

class MockHttpClient extends Mock implements http.Client {}

void main() {
  NewsRemoteDataSource newsRemoteDataSourceImpl;
  MockHttpClient mockHttpClient;

  setUp(() {
    mockHttpClient = MockHttpClient();
    newsRemoteDataSourceImpl = NewsRemoteDataSourceImpl(mockHttpClient);
  });

  void setUpMockHttpClientSuccess200() {
    when(mockHttpClient.get(any, headers: anyNamed('headers'))).thenAnswer(
        (realInvocation) async => http.Response(fixture('news.json'), 200));
  }

  void setUpMockHttpClientFailure404() {
    when(mockHttpClient.get(any, headers: anyNamed('headers'))).thenAnswer(
        (realInvocation) async => http.Response('Something went wrong', 404));
  }

  group('getSpecificNews', () {
    final tNewsModel = NewsModel.fromJson(jsonDecode(fixture('news.json')));
    final tPath = 'technology';

    test(
        'should perform a GET request on a URL with path being the endpoint and with application/json header',
        () {
      when(mockHttpClient.get(any, headers: anyNamed('headers'))).thenAnswer(
          (realInvocation) async => http.Response(fixture('news.json'), 200));
      newsRemoteDataSourceImpl.getNewsSpecific(tPath);
      verify(mockHttpClient.get(
          'https://newsapi.org/v2/top-headlines?category=$tPath&apiKey=b3fcd8293b6c4021a3e93485339d24c9',
          headers: {HttpHeaders.contentTypeHeader: 'application/json'}));
    });

    test('should return NewsEntity when the response is 200 (success)',
        () async {
      setUpMockHttpClientSuccess200();
      final result = await newsRemoteDataSourceImpl.getNewsSpecific(tPath);
      expect(result, equals(tNewsModel));
    });

    test(
        'should throw a ServerException when the response code is 404 or other',
        () async {
      setUpMockHttpClientFailure404();
      final call = newsRemoteDataSourceImpl.getNewsSpecific;
      expect(() => call(tPath), throwsA(isA<ServerException>()));
    });
  });

  group('getRandomeNews', () {
    final tNewsModel = NewsModel.fromJson(jsonDecode(fixture('news.json')));

    test(
        'should perform a GET request on a URL with path being the endpoint and with application/json header',
            () {
          when(mockHttpClient.get(any, headers: anyNamed('headers'))).thenAnswer(
                  (realInvocation) async => http.Response(fixture('news.json'), 200));
          newsRemoteDataSourceImpl.getRandomNews();
          verify(mockHttpClient.get(
              'https://newsapi.org/v2/top-headlines?category=business&apiKey=b3fcd8293b6c4021a3e93485339d24c9',
              headers: {HttpHeaders.contentTypeHeader: 'application/json'}));
        });

    test('should return NewsEntity when the response is 200 (success)',
            () async {
          setUpMockHttpClientSuccess200();
          final result = await newsRemoteDataSourceImpl.getRandomNews();
          expect(result, equals(tNewsModel));
        });

    test(
        'should throw a ServerException when the response code is 404 or other',
            () async {
          setUpMockHttpClientFailure404();
          final call = newsRemoteDataSourceImpl.getRandomNews;
          expect(() => call(), throwsA(isA<ServerException>()));
        });
  });
}
