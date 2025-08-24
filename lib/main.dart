import 'package:flutter/material.dart';
import 'package:lifters_anonymous/home_page.dart';
import 'package:lifters_anonymous/view_workout_split.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(primarySwatch: Colors.lightBlue),
      home: const HomePage(),
      routes: {'/view_workout_split': (context) => ViewWorkoutSplit()},
      debugShowCheckedModeBanner: false,
    );
  }
}
