import 'package:lifters_anonymous/models/workout.dart';

class SessionDTO {
  final String workoutId;
  final DateTime date;

  final bool isActive;

  SessionDTO({required this.workoutId, required this.date, required this.isActive});
}

class MoveRecordDTO {
  final String sessionId;
  final String moveId;
  final List<SetRecord> sets;

  MoveRecordDTO({required this.moveId, required this.sets, required this.sessionId});
}