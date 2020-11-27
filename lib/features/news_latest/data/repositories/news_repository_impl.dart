import 'package:dartz/dartz.dart';
import 'package:flutter_application_assignment/core/error/exception.dart';
import 'package:flutter_application_assignment/core/error/failure.dart';
import 'package:flutter_application_assignment/core/network/network_info.dart';
import 'package:flutter_application_assignment/features/news_latest/data/datasource/news_local_data_source.dart';
import 'package:flutter_application_assignment/features/news_latest/data/datasource/news_remote_data_source.dart';
import 'package:flutter_application_assignment/features/news_latest/domain/entities/news_entity.dart';
import 'package:flutter_application_assignment/features/news_latest/domain/repositories/news_repository.dart';

typedef Future<NewsEntity> _SpecificOrRandomChooser();

class NewsRepositoryImpl implements NewsRepository {
  final NewsRemoteDataSource newsRemoteDataSource;
  final NewsLocalDataSource newsLocalDataSource;
  final NetworkInfo networkInfo;


  NewsRepositoryImpl(
      {this.newsRemoteDataSource, this.newsLocalDataSource, this.networkInfo});

  @override
  Future<Either<Failure, NewsEntity>> getRandomNews() async {
    return await _getNews((){
      return newsRemoteDataSource.getRandomNews();
    });
  }

  @override
  Future<Either<Failure, NewsEntity>> getSpecificNews(String path) async{
      return await _getNews(() {
        return newsRemoteDataSource.getNewsSpecific(path);
      });
    }


    Future<Either<Failure, NewsEntity>> _getNews(
        _SpecificOrRandomChooser getSpecificOrRandom) async {
      if (await networkInfo.isConnected) {
        try {
          final remoteNews = await getSpecificOrRandom();
          newsLocalDataSource.cacheNews(remoteNews);
          return Right(remoteNews);
        } on ServerException {
          return Left(ServerFailure());
        }
      } else {
        try {
          final localNews = await newsLocalDataSource.getLastNews();
          return Right(localNews);
        } on CacheExecption {
          return Left(CacheFailure());
        }
      }
    }
  }