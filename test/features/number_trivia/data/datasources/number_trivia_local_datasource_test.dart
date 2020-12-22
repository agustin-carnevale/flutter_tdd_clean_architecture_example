import 'dart:convert';
import 'package:mockito/mockito.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:number_trivia/core/errors/exceptions.dart';
import 'package:number_trivia/features/number_trivia/data/datasources/number_trivia_local_datasource.dart';
import 'package:number_trivia/features/number_trivia/data/models/number_trivia_model.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:matcher/matcher.dart';
import '../../../../fixtures/fixture_reader.dart';

class MockSharedPreferences extends Mock implements SharedPreferences {}

void main(){
  NumberTriviaLocalDataSourceImpl numberTriviaLocalDataSource;
  MockSharedPreferences sharedPreferences;

  setUp((){
    sharedPreferences = MockSharedPreferences();
    numberTriviaLocalDataSource = NumberTriviaLocalDataSourceImpl(sharedPreferences: sharedPreferences);
  });

  group('getLastNumberTrivia', (){
    final tNumberTriviaModel = NumberTriviaModel.fromJson(json.decode(fixture('trivia_cached.json')));
    test(
      'should return NumberTrivia from shared preferences when there is one in the cache',
      () async { 
        // arrange
        when(sharedPreferences.getString(any))
        .thenReturn(fixture('trivia_cached.json'));

        // act
        final result = await numberTriviaLocalDataSource.getLastNumberTrivia();

        // assert
        verify(sharedPreferences.getString('CACHED_NUMBER_TRIVIA'));
        expect(result, equals(tNumberTriviaModel));
      },
    );

     test(
      'should throw CacheException when there is NO value in the cache',
      () async { 
        // arrange
        when(sharedPreferences.getString(any))
        .thenReturn(null);

        // act
        final call = numberTriviaLocalDataSource.getLastNumberTrivia;

        // assert
        expect(call, throwsA(TypeMatcher<CacheException>()));
      },
    );
  });

  group('cacheNumberTrivia', (){
      final tNumberTriviaModel = NumberTriviaModel(number: 123, text: "test text");
    test(
      'should call shared preferences to cache the data',
      () async { 
        // act
        numberTriviaLocalDataSource.cacheNumberTrivia(tNumberTriviaModel);
        // assert
        final expectedJsonString = json.encode(tNumberTriviaModel.toJson());
        verify(sharedPreferences.setString('CACHED_NUMBER_TRIVIA', expectedJsonString));
      },
    );
  });
}
