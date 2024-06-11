import 'package:flutter/material.dart';
import 'telaLogin.dart';


void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Save My Cash',
      theme: ThemeData(
        primarySwatch: Colors.green,
      ),
      home: TelaLogin(), // Defina TelaLogin como a tela inicial
    );
  }
}

