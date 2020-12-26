import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:number_trivia/core/errors/failure.dart';
import 'package:number_trivia/core/usecases/usecase.dart';
import 'package:number_trivia/core/utils/input_converter.dart';
import 'package:number_trivia/features/number_trivia/domain/entities/number_trivia.dart';
import 'package:number_trivia/features/number_trivia/domain/usecases/get_concrete_number_trivia.dart';
import 'package:number_trivia/features/number_trivia/domain/usecases/get_random_number_trivia.dart';
import 'package:number_trivia/features/number_trivia/presentation/bloc/number_trivia_bloc.dart';

class MockGetConcreteNumberTrivia extends Mock
    implements GetConcreteNumberTrivia {}

class MockGetRandomNumberTrivia extends Mock implements GetRandomNumberTrivia {}

class MockInputConverter extends Mock implements InputConverter {}

void main() {
  NumberTriviaBloc bloc;
  MockGetConcreteNumberTrivia mockGetConcreteNumberTrivia;
  MockGetRandomNumberTrivia mockGetRandomNumberTrivia;
  MockInputConverter mockInputConverter;

  setUp(() {
    mockGetConcreteNumberTrivia = MockGetConcreteNumberTrivia();
    mockGetRandomNumberTrivia = MockGetRandomNumberTrivia();
    mockInputConverter = MockInputConverter();

    bloc = NumberTriviaBloc(
        getConcreteNumberTrivia: mockGetConcreteNumberTrivia,
        getRandomNumberTrivia: mockGetRandomNumberTrivia,
        inputConverter: mockInputConverter);
  });

  test(
    'initialState should be NumberTriviaInitial',
    () async {
      // assert
      expect(bloc.initialState, NumberTriviaInitial());
    },
  );

  group('getTriviaForConcreteNumber', () {
    final tNumberString = '1';
    final tNumberParsed = 1;
    final tNumberTrivia = NumberTrivia(number: 1, text: 'test trivia');

    void setUpMockInputConverterSuccess() =>
      when(mockInputConverter.stringToUnsignedInteger(any))
        .thenReturn(Right(tNumberParsed));
    
    void setUpMockInputConverterFailure() =>
      when(mockInputConverter.stringToUnsignedInteger(any))
        .thenReturn(Left(InvalidInputFailure()));

    test(
      'should call the InputConverter to validate and convert the numberString to unsigned integer ',
      () async {
        // arrange
        setUpMockInputConverterSuccess();

        // act
        bloc.dispatch(GetTriviaForConcreteNumber(tNumberString));
        await untilCalled(mockInputConverter.stringToUnsignedInteger(any));
        // assert
        verify(mockInputConverter.stringToUnsignedInteger(tNumberString));
      },
    );

    test(
       'should emit [Error] when the input is invalid',
       () async { 
        // arrange
        setUpMockInputConverterFailure();

        // assert Later
        expectLater(bloc.state, emitsInOrder([
          NumberTriviaInitial(),
          Error(errorMessage: INVALID_INPUT_FAILURE_MESSAGE)
        ]));

        // act
        bloc.dispatch(GetTriviaForConcreteNumber(tNumberString));
       },
    );

    test(
       'should get data from the concrete use-case',
       () async { 
        // arrange
        setUpMockInputConverterSuccess();
        when(mockGetConcreteNumberTrivia(any))
          .thenAnswer((_) async => Right(tNumberTrivia));

        // act
        bloc.dispatch(GetTriviaForConcreteNumber(tNumberString));
        await untilCalled(mockGetConcreteNumberTrivia(any));

        // assert
        verify(mockGetConcreteNumberTrivia(Params(number: tNumberParsed)));
       },
    );

    test(
       'should emit [Loading, Loaded] when data is gotten successfully',
       () async { 
        // arrange
        setUpMockInputConverterSuccess();
        when(mockGetConcreteNumberTrivia(any))
          .thenAnswer((_) async => Right(tNumberTrivia));

        // assert Later
        expectLater(bloc.state, emitsInOrder([
          NumberTriviaInitial(),
          Loading(),
          Loaded(trivia: tNumberTrivia)
        ]));

        // act
        bloc.dispatch(GetTriviaForConcreteNumber(tNumberString));
       },
    );

    test(
       'should emit [Loading, Error] when fetching data fails (server failure)',
       () async { 
        // arrange
        setUpMockInputConverterSuccess();
        when(mockGetConcreteNumberTrivia(any))
          .thenAnswer((_) async => Left(ServerFailure()));

        // assert Later
        expectLater(bloc.state, emitsInOrder([
          NumberTriviaInitial(),
          Loading(),
          Error(errorMessage: SERVER_FAILURE_MESSAGE)
        ]));

        // act
        bloc.dispatch(GetTriviaForConcreteNumber(tNumberString));
       },
    );

    test(
       'should emit [Loading, Error] when fetching data fails (cache failure)',
       () async { 
        // arrange
        setUpMockInputConverterSuccess();
        when(mockGetConcreteNumberTrivia(any))
          .thenAnswer((_) async => Left(CacheFailure()));

        // assert Later
        expectLater(bloc.state, emitsInOrder([
          NumberTriviaInitial(),
          Loading(),
          Error(errorMessage: CACHE_FAILURE_MESSAGE)
        ]));

        // act
        bloc.dispatch(GetTriviaForConcreteNumber(tNumberString));
       },
    );
  });

   group('getTriviaForRandomNumber', () {
    final tNumberTrivia = NumberTrivia(number: 1, text: 'test trivia');

    test(
       'should get data from the random use-case',
       () async { 
        // arrange
        when(mockGetRandomNumberTrivia(any))
          .thenAnswer((_) async => Right(tNumberTrivia));

        // act
        bloc.dispatch(GetTriviaForRandomNumber());
        await untilCalled(mockGetRandomNumberTrivia(any));

        // assert
        verify(mockGetRandomNumberTrivia(NoParams()));
       },
    );

    test(
       'should emit [Loading, Loaded] when data is gotten successfully',
       () async { 
        // arrange
        when(mockGetRandomNumberTrivia(any))
          .thenAnswer((_) async => Right(tNumberTrivia));

        // assert Later
        expectLater(bloc.state, emitsInOrder([
          NumberTriviaInitial(),
          Loading(),
          Loaded(trivia: tNumberTrivia)
        ]));

        // act
        bloc.dispatch(GetTriviaForRandomNumber());
       },
    );

    test(
       'should emit [Loading, Error] when fetching data fails (server failure)',
       () async { 
        // arrange
        when(mockGetRandomNumberTrivia(any))
          .thenAnswer((_) async => Left(ServerFailure()));

        // assert Later
        expectLater(bloc.state, emitsInOrder([
          NumberTriviaInitial(),
          Loading(),
          Error(errorMessage: SERVER_FAILURE_MESSAGE)
        ]));

        // act
        bloc.dispatch(GetTriviaForRandomNumber());
       },
    );

    test(
       'should emit [Loading, Error] when fetching data fails (cache failure)',
       () async { 
        // arrange
        when(mockGetRandomNumberTrivia(any))
          .thenAnswer((_) async => Left(CacheFailure()));

        // assert Later
        expectLater(bloc.state, emitsInOrder([
          NumberTriviaInitial(),
          Loading(),
          Error(errorMessage: CACHE_FAILURE_MESSAGE)
        ]));

        // act
        bloc.dispatch(GetTriviaForRandomNumber());
       },
    );
  });
}
