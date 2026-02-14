import 'package:hive/hive.dart';

part 'workout.g.dart';

@HiveType(typeId: 0)
class Workout {
  // Workout aka split
  @HiveField(0)
  final String id;

  @HiveField(1)
  final String name;

  @HiveField(2)
  final List<Move> moves;

  Workout({required this.id, required this.name, this.moves = const []});
}

@HiveType(typeId: 1)
class Move {
  @HiveField(0)
  final String id;

  @HiveField(1)
  final String name;

  Move({required this.id, required this.name});
}

@HiveType(typeId: 2)
class Session {
  @HiveField(0)
  final String id;

  @HiveField(1)
  final DateTime date;

  @HiveField(2)
  final String workoutId;

  @HiveField(3)
  final List<MoveRecord> moveRecords;

  @HiveField(4)
  final int duration; // in minutes

  Session({
    required this.id,
    required this.workoutId,
    required this.date,
    required this.moveRecords,
    required this.duration,
  });
}

class MoveRecord {
  final String moveId;
  final int setsCompleted;
  final int repsCompleted;

  MoveRecord({
    required this.moveId,
    required this.setsCompleted,
    required this.repsCompleted,
  });
}