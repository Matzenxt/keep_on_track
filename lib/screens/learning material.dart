import 'package:flutter/material.dart';
import 'package:keep_on_track/components/drawer.dart';

class LearningMaterial extends StatelessWidget {
  const LearningMaterial({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Lernstoff'),
      ),
      drawer: const CustomDrawer(),
      body: Center(
        child: ElevatedButton(
          onPressed: () {
            Navigator.pop(context);
          },
          child: const Text('Go back!'),
        ),
      ),
    );
  }
}
