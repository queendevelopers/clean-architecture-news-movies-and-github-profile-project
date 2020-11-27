import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_application_assignment/core/error/failure.dart';
import 'package:flutter_application_assignment/core/usecases/UseCase.dart';
import 'package:flutter_application_assignment/features/news_latest/domain/entities/news_entity.dart';
import 'package:flutter_application_assignment/features/news_latest/domain/repositories/news_repository.dart';

class GetSpecificNews extends UseCase<NewsEntity, Params> {
  final NewsRepository newsRepository;

  GetSpecificNews(this.newsRepository);

  @override
  Future<Either<Failure, NewsEntity>> call(params) async {
    return await newsRepository.getSpecificNews(params.path);
  }
}

class Params extends Equatable {
  final String path;

  Params({@required this.path});

  @override
  List<Object> get props => [path];
}
