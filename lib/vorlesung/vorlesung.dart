import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../components/drawer.dart';

class Vorlesung extends StatelessWidget {
  const Vorlesung({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Vorlesung'),
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