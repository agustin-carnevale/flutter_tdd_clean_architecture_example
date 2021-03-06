import 'package:flutter/material.dart';
import 'package:number_trivia/features/number_trivia/presentation/pages/number_trivia_page.dart';
import 'package:number_trivia/injection_container.dart' as di;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await di.init();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Number Trivia',
      theme: ThemeData(
        primarySwatch: Colors.green,
        accentColor: Colors.green.shade600,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: NumberTriviaPage(),
    );
  }
}
