part of 'number_trivia_bloc.dart';

abstract class NumberTriviaState extends Equatable {
  NumberTriviaState([List props = const <dynamic>[]]): super(props);
  
  @override
  List<Object> get props => [];
}

class NumberTriviaInitial extends NumberTriviaState {}

class Loading extends NumberTriviaState {}

class Loaded extends NumberTriviaState {
  final NumberTrivia trivia;
  Loaded({this.trivia}): super([trivia]);
}

class Error extends NumberTriviaState {
  final String errorMessage;
  Error({this.errorMessage}): super([errorMessage]);
}