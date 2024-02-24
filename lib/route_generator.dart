import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:quraan/screens/correct_mistakes_page.dart';
import 'package:quraan/screens/home_page.dart';
import 'package:quraan/screens/quiz_screen.dart';
import 'package:quraan/screens/score_page.dart';

class RouteGenerator {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    // final args = settings.arguments;

    switch (settings.name) {
      case '/':
        return MaterialPageRoute(
          builder: (_) => const HomePage(),
        );
      case '/home':
        return MaterialPageRoute(
          builder: (_) => const HomePage(),
        );

      case '/quiz':
        String args = settings.arguments.toString();
        return MaterialPageRoute(
          builder: (_) => QuizPage(
            level: int.parse(args),
          ),
        );

      case '/correctMistakes':
        var args = settings.arguments as Map<String, Object>;

        return MaterialPageRoute(
          builder: (_) => CorrectMistakes(
            questions: args['wrongAnswers'] as List<dynamic>,
            quizLength: args['quizLength'] as int,
          ),
        );

      case '/score':
        var args = settings.arguments as Map<String, Object>;

        return MaterialPageRoute(
          builder: (_) => ScorePage(
            wrongLength: args['wrongLength'] as int,
            quizLength: args['quizLength'] as int,
          ),
        );

      default:
        print(settings.name);
        return _errorRoute();
    }
  }

  static Route<dynamic> _errorRoute() {
    return MaterialPageRoute(builder: (_) {
      return Scaffold(
        appBar: AppBar(
          backgroundColor: const Color(0xff1a52f3),
          title: const Text('Error'),
        ),
        body: const Center(
          child: Text('Router Error'),
        ),
      );
    });
  }
}
