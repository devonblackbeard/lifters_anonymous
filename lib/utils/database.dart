import 'package:hive_flutter/hive_flutter.dart';
import 'package:lifters_anonymous/models/workout.dart';

class Database {
  //static Box get workoutBox => Hive.box('workoutDataBox');

  static Box<Workout> get workoutBox => Hive.box<Workout>('workoutDataBox');

  // static Box get fastingBox => Hive.box('fastingDataBox');
  static Box<Session> get sessionBox => Hive.box<Session>('sessionDataBox');
}
