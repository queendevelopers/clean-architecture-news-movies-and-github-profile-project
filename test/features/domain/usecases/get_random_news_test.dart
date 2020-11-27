import 'package:dartz/dartz.dart';
import 'package:flutter_application_assignment/core/usecases/UseCase.dart';
import 'package:flutter_application_assignment/features/news_latest/data/models/news_model.dart';
import 'package:flutter_application_assignment/features/news_latest/domain/entities/news_entity.dart';
import 'package:flutter_application_assignment/features/news_latest/domain/repositories/news_repository.dart';
import 'package:flutter_application_assignment/features/news_latest/domain/usecases/get_random_news.dart';
import 'package:flutter_application_assignment/features/news_latest/domain/usecases/get_specific_news.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

class MockNewsRepository extends Mock implements NewsRepository {}

void main() {
  GetRandomNews getRandomNews;
  MockNewsRepository mockNewsRepository;

  setUp(() {
    mockNewsRepository = MockNewsRepository();
    getRandomNews = GetRandomNews(mockNewsRepository);
  });

  final tNewsEntity = NewsModel(
      title: 'news title',
      description: 'news descritpion',
      urlToImage: 'url_to_image');

  test('should get random news from the repository', () async {
    when(mockNewsRepository.getRandomNews()).thenAnswer((realInvocation) async => Right(tNewsEntity));
    final result=await getRandomNews(NoParams());
    expect(result,Right(tNewsEntity));
    verify(mockNewsRepository.getRandomNews());
    verifyNoMoreInteractions(mockNewsRepository);
  });
}
