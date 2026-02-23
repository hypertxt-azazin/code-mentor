import 'package:flutter/material.dart';

class QuizScreen extends StatelessWidget {
  final String moduleId;
  const QuizScreen({super.key, required this.moduleId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(body: Center(child: Text('Quiz: $moduleId')));
  }
}
