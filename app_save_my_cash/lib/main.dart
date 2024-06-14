import 'package:flutter/material.dart';
import 'telaLogin.dart';
import 'telaConfiguracoes.dart';


void main() {
  runApp(MyApp());
}


class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Save My Cash',
      theme: ThemeData(primarySwatch: Colors.green),
      home: TelaLogin(),
    );
  }
}

/*class MyApp extends StatelessWidget {
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
} */

