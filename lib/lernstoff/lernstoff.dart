import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class Lernstoff extends StatelessWidget {
  const Lernstoff({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Lernstoff'),
      ),
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