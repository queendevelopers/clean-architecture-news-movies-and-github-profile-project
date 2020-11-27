import 'package:dartz/dartz.dart';
import 'package:flutter_application_assignment/core/error/failure.dart';
import 'package:flutter_application_assignment/core/usecases/UseCase.dart';
import 'package:flutter_application_assignment/features/news_latest/domain/entities/news_entity.dart';
import 'package:flutter_application_assignment/features/news_latest/domain/repositories/news_repository.dart';

class GetRandomNews extends  UseCase<NewsEntity, NoParams> {
  final NewsRepository newsRepository;

  GetRandomNews(this.newsRepository);

  @override
  Future<Either<Failure, NewsEntity>> call(NoParams params) async {
    return await newsRepository.getRandomNews();
  }
}