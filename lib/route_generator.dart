import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:quraan/screens/home_page.dart';
import 'package:quraan/screens/quiz_screen.dart';
import 'package:quraan/views/multi_q_view.dart';

class RouteGenerator {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    final args = settings.arguments;

    switch (settings.name) {
      case '/':
        return MaterialPageRoute(
          builder: (_) => HomePage(),
        );
      case '/home':
        return MaterialPageRoute(
          builder: (_) => HomePage(),
        );
      case '/quiz':
        String args = settings.arguments.toString();
        return MaterialPageRoute(
          builder: (_) => QuizPage(
            level: int.parse(args),
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
