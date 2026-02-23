import 'package:flutter/material.dart';

class PracticeScreen extends StatelessWidget {
  final String lessonId;
  const PracticeScreen({super.key, required this.lessonId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(body: Center(child: Text('Practice: $lessonId')));
  }
}
