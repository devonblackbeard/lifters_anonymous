import 'package:flutter/material.dart';
import 'package:lifters_anonymous/models/workout.dart';
import 'package:lifters_anonymous/utils/database.dart';

class ActiveSession extends StatefulWidget {
  const ActiveSession({super.key});

  @override
  State<ActiveSession> createState() => _ActiveSessionState();
}

class _ActiveSessionState extends State<ActiveSession> {
  @override
  Widget build(BuildContext context) {
    final session = ModalRoute.of(context)!.settings.arguments as Session;

    // Get the workout from the session's workoutId
    //final workout = Database.workoutBox.get(session.workoutId);

    final workout = Database.workoutBox.get(session.workoutId);
    // print(
    //   'ActiveSession: Loaded workout with id ${session.workoutId} - ${workout?.name}',
    // );
    if (workout == null) {
      return const Scaffold(body: Center(child: Text('Workout not found')));
    }

    return Scaffold(
      appBar: AppBar(title: Text(workout.name)),
      body: ListView.builder(
        itemCount: workout.moves.length,
        itemBuilder: (context, index) {
          final move = workout.moves[index];

          return ListTile(
            leading: CircleAvatar(child: Text('${index + 1}')),
            title: Text(move.name),
            //subtitle: Text('${move.} sets × ${move.reps} reps'),
            trailing: const Icon(Icons.chevron_right),
            onTap: () {
              // Handle move tap
              print('Tapped on ${move.name}');
              // You could navigate to a detail screen or show a dialog
            },
          );
        },
      ),
    );
  }
}
