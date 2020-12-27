import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:number_trivia/core/utils/input_converter.dart';
import 'package:number_trivia/features/number_trivia/presentation/bloc/number_trivia_bloc.dart';
import 'package:number_trivia/injection_container.dart';
import '../widgets/widgets.dart';

class NumberTriviaPage extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Number Trivia"),
      ),
      body: _buildBody(context)
   );
  }

  BlocProvider<NumberTriviaBloc> _buildBody(BuildContext context) {
    return BlocProvider(
      builder: (_) => sl<NumberTriviaBloc>() ,
      child: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Column(
          children: [
            SizedBox(height: 10.0),
            BlocBuilder<NumberTriviaBloc, NumberTriviaState>(
              builder: (BuildContext context, state) { 
                if (state is NumberTriviaInitial){
                  return  MessageDisplay(message: 'Start Searching');
                }else if (state is Loading){
                  return LoadingDisplay();
                }else if (state is Loaded){
                  return TriviaDisplay(numberTrivia: state.trivia);
                }else if (state is Error){
                   return  MessageDisplay(message: state.errorMessage);
                }
               },
            ),
            SizedBox(height: 20.0),
            TriviaControls(),
          ],
        ),
      ),
    );
  }
}

