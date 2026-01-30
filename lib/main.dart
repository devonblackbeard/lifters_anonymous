import 'package:flutter/material.dart';
import 'package:lifters_anonymous/add_workout_item.dart';
import 'package:lifters_anonymous/home_page.dart';
import 'package:lifters_anonymous/view_move_history.dart';
import 'package:lifters_anonymous/view_workout_split.dart';
import 'package:lifters_anonymous/view_workout_split_details.dart';

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
      routes: {
        '/view_workout_split': (context) => ViewWorkoutSplit(),
        '/add_workout_split': (context) => AddWorkoutItem(type: ''),
        '/workout_split_details': (context) => ViewWorkoutSplitDetails(),
        // '/view_move_history':
        //     (context) => ViewMoveHistory(
        //       moveName: '',
        //     ), // option to add new log and can view history
      },
      debugShowCheckedModeBanner: false,
    );
  }
}
