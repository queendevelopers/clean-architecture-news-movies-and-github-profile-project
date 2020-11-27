import 'package:dartz/dartz.dart';
import 'package:flutter_application_assignment/features/news_latest/data/models/news_model.dart';
import 'package:flutter_application_assignment/features/news_latest/domain/entities/news_entity.dart';
import 'package:flutter_application_assignment/features/news_latest/domain/repositories/news_repository.dart';
import 'package:flutter_application_assignment/features/news_latest/domain/usecases/get_specific_news.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

class MockNewsRepository extends Mock implements NewsRepository {}

void main() {
  GetSpecificNews getSpecificNews;
  MockNewsRepository mockNewsRepository;

  setUp(() {
    mockNewsRepository = MockNewsRepository();
    getSpecificNews = GetSpecificNews(mockNewsRepository);
  });

  final tpath = 'technology';
  final tNewsEntity = NewsModel(
      title: 'news title',
      description: 'news descritpion',
      urlToImage: 'url_to_image');

  test('should get technology news from the repository', () async {
    when(mockNewsRepository.getSpecificNews(any)).thenAnswer((realInvocation) async => Right(tNewsEntity));
    final result=await getSpecificNews(Params(path: 'technology'));
    expect(result,Right(tNewsEntity));
    verify(mockNewsRepository.getSpecificNews(tpath));
    verifyNoMoreInteractions(mockNewsRepository);
  });
}
