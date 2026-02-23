import 'package:flutter/material.dart';

class ModuleDetailScreen extends StatelessWidget {
  final String moduleId;
  const ModuleDetailScreen({super.key, required this.moduleId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(body: Center(child: Text('Module: $moduleId')));
  }
}
