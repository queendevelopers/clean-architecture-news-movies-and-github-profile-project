import 'package:dartz/dartz.dart';
import 'package:flutter_application_assignment/core/error/exception.dart';
import 'package:flutter_application_assignment/core/error/failure.dart';
import 'package:flutter_application_assignment/core/network/network_info.dart';
import 'package:flutter_application_assignment/features/news_latest/data/datasource/news_local_data_source.dart';
import 'package:flutter_application_assignment/features/news_latest/data/datasource/news_remote_data_source.dart';
import 'package:flutter_application_assignment/features/news_latest/data/models/news_model.dart';
import 'package:flutter_application_assignment/features/news_latest/data/repositories/news_repository_impl.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:meta/meta.dart';

class MockRemoteDataSource extends Mock implements NewsRemoteDataSource {}

class MockLocalDataSource extends Mock implements NewsLocalDataSource {}

class MockNetworkInfo extends Mock implements NetworkInfo {}

void main() {
  NewsRepositoryImpl newsRepositoryImpl;
  MockRemoteDataSource mockRemoteDataSource;
  MockLocalDataSource mockLocalDataSource;
  MockNetworkInfo mockNetworkInfo;

  setUp(() {
    mockRemoteDataSource = MockRemoteDataSource();
    mockLocalDataSource = MockLocalDataSource();
    mockNetworkInfo = MockNetworkInfo();
    newsRepositoryImpl = NewsRepositoryImpl(
        newsRemoteDataSource: mockRemoteDataSource,
        newsLocalDataSource: mockLocalDataSource,
        networkInfo: mockNetworkInfo);
  });

  group('getSpecificNews', () {
    final tPath = 'technology';
    final tNewsModel = NewsModel(
        title: 'news title',
        description: 'news description',
        urlToImage: 'url_to_image');
    final NewsModel newsModel = tNewsModel;

    test('should check if the device is online', () {
      when(mockNetworkInfo.isConnected)
          .thenAnswer((realInvocation) async => true);
      newsRepositoryImpl.getSpecificNews(tPath);
      verify(mockNetworkInfo.isConnected);
    });

    group('device is online', () {
      setUp(() {
        when(mockNetworkInfo.isConnected)
            .thenAnswer((realInvocation) async => true);
      });

      test(
          'should return remote data when the call to remote data source is successful',
          () async {
        when(mockRemoteDataSource.getNewsSpecific(tPath))
            .thenAnswer((realInvocation) async => tNewsModel);

        final result = await newsRepositoryImpl.getSpecificNews(tPath);
        verify(mockRemoteDataSource.getNewsSpecific(tPath));
        expect(result, equals(Right(tNewsModel)));
      });

      test(
          'should cache the data locally when the call to remote data source is successful',
          () async {
        when(mockRemoteDataSource.getNewsSpecific(tPath))
            .thenAnswer((realInvocation) async => tNewsModel);

        await newsRepositoryImpl.getSpecificNews(tPath);
        verify(mockRemoteDataSource.getNewsSpecific(tPath));
        verify(mockLocalDataSource.cacheNews(newsModel));
      });

      test(
          'should return server failure when the call to remote data source is unsuccessful',
          () async {
        when(mockRemoteDataSource.getNewsSpecific(tPath))
            .thenThrow(ServerException());

        final result = await newsRepositoryImpl.getSpecificNews(tPath);
        verify(mockRemoteDataSource.getNewsSpecific(tPath));
        verifyZeroInteractions(mockLocalDataSource);
        expect(result, equals(Left(ServerFailure())));
      });
    });

    group('device is offline', () {
      setUp(() {
        when(mockNetworkInfo.isConnected)
            .thenAnswer((realInvocation) async => false);
      });

      test('should return last locally cached data when cache data is present',
          () async {
        when(mockLocalDataSource.getLastNews())
            .thenAnswer((realInvocation) async => tNewsModel);

        final result = await newsRepositoryImpl.getSpecificNews(tPath);
        verifyZeroInteractions(mockRemoteDataSource);
        verify(mockLocalDataSource.getLastNews());
        expect(result, equals(Right(tNewsModel)));
      });

      test('should return CacheFailure when there is no cached data present',
          () async {
        when(mockLocalDataSource.getLastNews()).thenThrow(CacheExecption());

        final result = await newsRepositoryImpl.getSpecificNews(tPath);

        verifyZeroInteractions(mockRemoteDataSource);
        verify(mockLocalDataSource.getLastNews());
        expect(result, equals(Left(CacheFailure())));
      });
    });

    void runTestsOnline(Function body) {
      group('device is online', () {
        setUp() {
          when(mockNetworkInfo.isConnected)
              .thenAnswer((realInvocation) async => true);
          body();
        }
      });
    }

    void runTestsOffline(Function body) {
      group('device is offline', () {
        setUp() {
          when(mockNetworkInfo.isConnected)
              .thenAnswer((realInvocation) async => false);
        }
      });
    }

    group('getRandomNews', () {
      final tNewsModel = NewsModel(
          title: 'news title',
          description: 'news description',
          urlToImage: 'url_to_image');
      final NewsModel newsModel = tNewsModel;

      test('should check if the device is online', () {
        when(mockNetworkInfo.isConnected)
            .thenAnswer((realInvocation) async => true);
        newsRepositoryImpl.getRandomNews();
        verify(mockNetworkInfo.isConnected);
      });

      runTestsOnline(() {
        test(
            'should return remote data when the call to remote data source is successful',
            () async {
          when(mockRemoteDataSource.getRandomNews())
              .thenAnswer((realInvocation) async => tNewsModel);

          final result = await newsRepositoryImpl.getRandomNews();
          verify(mockRemoteDataSource.getRandomNews());
          expect(result, equals(Right(tNewsModel)));
        });

        test(
            'should cache the data locally when the call to remote data source is successful',
            () async {
          when(mockRemoteDataSource.getRandomNews())
              .thenAnswer((realInvocation) async => tNewsModel);

          await newsRepositoryImpl.getRandomNews();
          verify(mockRemoteDataSource.getRandomNews());
          verify(mockLocalDataSource.cacheNews(newsModel));
        });

        test(
            'should return server failure when the call to remote data source is unsuccessful',
            () async {
          when(mockRemoteDataSource.getRandomNews())
              .thenThrow(ServerException());

          final result = await newsRepositoryImpl.getRandomNews();
          verify(mockRemoteDataSource.getRandomNews());
          verifyZeroInteractions(mockLocalDataSource);
          expect(result, equals(Left(ServerFailure())));
        });
      });

      runTestsOffline(() {
        test(
            'should return last locally cached data when cache data is present',
            () async {
          when(mockLocalDataSource.getLastNews())
              .thenAnswer((realInvocation) async => tNewsModel);

          final result = await newsRepositoryImpl.getRandomNews();
          verifyZeroInteractions(mockRemoteDataSource);
          verify(mockLocalDataSource.getLastNews());
          expect(result, equals(Right(tNewsModel)));
        });

        test('should return CacheFailure when there is no cached data present',
            () async {
          when(mockLocalDataSource.getLastNews()).thenThrow(CacheExecption());

          final result = await newsRepositoryImpl.getRandomNews();

          verifyZeroInteractions(mockRemoteDataSource);
          verify(mockLocalDataSource.getLastNews());
          expect(result, equals(Left(CacheFailure())));
        });
      });
    });
  });
}
