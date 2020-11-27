import 'package:dartz/dartz.dart';
import 'package:flutter_application_assignment/core/error/failure.dart';
import 'package:flutter_application_assignment/features/news_latest/domain/entities/news_entity.dart';

abstract class NewsRepository {
  Future<Either<Failure, NewsEntity>> getSpecificNews(String path);
  Future<Either<Failure, NewsEntity>> getRandomNews();
}