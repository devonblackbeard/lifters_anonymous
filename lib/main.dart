import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:lifters_anonymous/add_workout_item.dart';
import 'package:lifters_anonymous/history.dart';
import 'package:lifters_anonymous/fasting.dart';
import 'package:lifters_anonymous/models/workout.dart';
import 'package:lifters_anonymous/view_workout_split.dart';
import 'package:lifters_anonymous/view_workout_split_details.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Hive.initFlutter();
  Hive.registerAdapter(WorkoutAdapter());
  Hive.registerAdapter(MoveAdapter());
  Hive.registerAdapter(SessionAdapter());

  var workoutBox = await Hive.openBox<Workout>('workoutDataBox');
  var sessionBox = await Hive.openBox<Session>('sessionDataBox');

  // keep these as a manual string

  await workoutBox.clear();
  await sessionBox.clear();

  // Remove this line after first run if you want to keep data
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(primarySwatch: Colors.lightBlue),
      home: const MainScreen(),
      routes: {
        '/view_workout_split': (context) => ViewWorkoutSplit(),
        '/add_workout_split': (context) => AddWorkoutItem(type: ''),
        '/workout_split_details': (context) => ViewWorkoutSplitDetails(),
      },
      debugShowCheckedModeBanner: false,
    );
  }
}

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _currentIndex = 0;

  final List<Widget> _screens = [History(), ViewWorkoutSplit(), Fasting() ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _screens[_currentIndex],
      bottomNavigationBar: NavigationBar(
        selectedIndex: _currentIndex,
        onDestinationSelected: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        labelBehavior: NavigationDestinationLabelBehavior.alwaysHide,
        destinations: const [
            NavigationDestination(
            icon: Icon(Icons.calendar_month_sharp),
            label: 'History',
          ),
          NavigationDestination(
            icon: Icon(Icons.fitness_center),
            label: 'Workout',
          ),
          NavigationDestination(
            icon: Icon(Icons.food_bank_sharp),
            label: 'Fasting',
          )
        ],
      ),
    );
  }
}
