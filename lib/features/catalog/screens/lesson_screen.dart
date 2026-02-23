import 'package:flutter/material.dart';

class LessonScreen extends StatelessWidget {
  final String lessonId;
  const LessonScreen({super.key, required this.lessonId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(body: Center(child: Text('Lesson: $lessonId')));
  }
}
