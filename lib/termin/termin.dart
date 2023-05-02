import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../components/drawer.dart';

class Termin extends StatelessWidget {
  const Termin({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Terminübersicht'),
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