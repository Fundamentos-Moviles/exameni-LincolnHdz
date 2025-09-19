import 'package:examen1/memorama.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}
//Clase sin estado
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'Flutter Demo',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        ),
        home: Memorama()
    );
  }
}