import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'telaLogin.dart';


Future<void> main() async {
  await Supabase.initialize(
    url: 'https://vuetcneobhpjzvtngoxc.supabase.co',
    anonKey: 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6InZ1ZXRjbmVvYmhwanp2dG5nb3hjIiwicm9sZSI6ImFub24iLCJpYXQiOjE3MTk0NDYyMDAsImV4cCI6MjAzNTAyMjIwMH0.8sbnHMBEMeEXjaBsAc_NJ9kOjAp5TY3Q3eXkjCAfcHY',
  );

  runApp(MyApp());
}

// Get a reference your Supabase client
final supabase = Supabase.instance.client;




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

