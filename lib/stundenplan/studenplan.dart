import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../components/drawer.dart';

class Stundenplan extends StatelessWidget {
  const Stundenplan({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Stundenplan'),
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