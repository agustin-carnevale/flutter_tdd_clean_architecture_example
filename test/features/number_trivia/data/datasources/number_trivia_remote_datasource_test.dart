import 'dart:convert';
import 'package:mockito/mockito.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:number_trivia/core/errors/exceptions.dart';
import 'package:number_trivia/features/number_trivia/data/datasources/number_trivia_remote_datasource.dart';
import 'package:number_trivia/features/number_trivia/data/models/number_trivia_model.dart';
import '../../../../fixtures/fixture_reader.dart';
import 'package:matcher/matcher.dart';
import 'package:http/http.dart' as http;

class MockHttpClient extends Mock implements http.Client {}

void main() {
  NumberTriviaRemoteDataSourceImpl numberTriviaRemoteDataSource;
  MockHttpClient httpClient;

  setUp(() {
    httpClient = MockHttpClient();
    numberTriviaRemoteDataSource =
        NumberTriviaRemoteDataSourceImpl(httpClient: httpClient);
  });

  void setUpMockHttpClientSuccess200() {
    when(httpClient.get(any, headers: anyNamed('headers')))
        .thenAnswer((_) async => http.Response(fixture('trivia.json'), 200));
  }

  void setUpMockHttpClientFailure404() {
    when(httpClient.get(any, headers: anyNamed('headers')))
        .thenAnswer((_) async => http.Response('Something went wrong', 404));
  }

  group('getConcreteNumberTrivia', () {
    final tNumber = 12;
    final tNumberTriviaModel =
        NumberTriviaModel.fromJson(json.decode(fixture('trivia.json')));

    test(
      ''' should perform a GET on a url with number being on
       the endpoint with application/json header ''',
      () async {
        // arrange
        setUpMockHttpClientSuccess200();
        // act
        numberTriviaRemoteDataSource.getConcreteNumberTrivia(tNumber);
        // assert
        verify(httpClient.get('http://numbersapi.com/$tNumber',
            headers: {'Content-Type': 'application/json'}));
      },
    );

    test(
      'should return NumberTrivia when response code is 200',
      () async {
        // arrange
        setUpMockHttpClientSuccess200();
        // act
        final result =
            await numberTriviaRemoteDataSource.getConcreteNumberTrivia(tNumber);
        // assert
        expect(result, equals(tNumberTriviaModel));
      },
    );

    test(
      'should throw a ServerException when response code is 404 or other',
      () async {
        // arrange
        setUpMockHttpClientFailure404();
        // act
        final call = numberTriviaRemoteDataSource.getConcreteNumberTrivia;
        // assert
        expect(() => call(tNumber), throwsA(TypeMatcher<ServerException>()));
      },
    );
  });

  group('getRandomNumberTrivia', () {
    final tNumberTriviaModel =
        NumberTriviaModel.fromJson(json.decode(fixture('trivia.json')));

    test(
      ''' should perform a GET on a url with random being on
       the endpoint with application/json header ''',
      () async {
        // arrange
        setUpMockHttpClientSuccess200();
        // act
        numberTriviaRemoteDataSource.getRandomNumberTrivia();
        // assert
        verify(httpClient.get('http://numbersapi.com/random',
            headers: {'Content-Type': 'application/json'}));
      },
    );

    test(
      'should return NumberTrivia when response code is 200',
      () async {
        // arrange
        setUpMockHttpClientSuccess200();
        // act
        final result =
            await numberTriviaRemoteDataSource.getRandomNumberTrivia();
        // assert
        expect(result, equals(tNumberTriviaModel));
      },
    );

    test(
      'should throw a ServerException when response code is 404 or other',
      () async {
        // arrange
        setUpMockHttpClientFailure404();
        // act
        final call = numberTriviaRemoteDataSource.getRandomNumberTrivia;
        // assert
        expect(call, throwsA(TypeMatcher<ServerException>()));
      },
    );
  });
}
