import 'package:flutter/material.dart';
import 'package:lifters_anonymous/models/workout.dart';
import 'package:lifters_anonymous/models/workout_dtos.dart';
import 'package:lifters_anonymous/utils/database.dart';
import 'package:lifters_anonymous/utils/styles.dart';

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
    // final workout = Database.workoutBox.get(session.workoutId);

    final workout = Database.workoutBox.get(session.workoutId);
    // print(
    //   'ActiveSession: Loaded workout with id ${session.workoutId} - ${workout?.name}',
    // );

    if (workout == null) {
      return const Scaffold(body: Center(child: Text('Workout not found')));
    }

    return Scaffold(
      appBar: AppBar(title: Text(workout.name)),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: workout.moves.length,
              itemBuilder: (context, index) {
                final move = workout.moves[index];

                return ListTile(
                  leading: CircleAvatar(child: Text('${index + 1}')),
                  title: Text(move.name),
                  //subtitle: Text('${move.} sets × ${move.reps} reps'),
                  trailing: const Icon(Icons.chevron_right),
                  onTap: () {
                    var moveRecord = MoveRecordDTO(
                      moveId: move.id,
                      moveName: move.name,
                      sets: [],
                      sessionId: session.id,
                    );
                    // Handle move tap
                    print('Tapped on ${move.name}');
                    // You could navigate to a detail screen or show a dialog
                    // Navigator.pushNamed(context, '/move_details', arguments: {
                    //   'move': move,
                    //   'sessionId': session.id,
                    // });
                    Navigator.pushNamed(
                      context,
                      '/move_details',
                      arguments: moveRecord,
                    );
                  },
                );
              },
            ),
          ),

          Container(
            padding: const EdgeInsets.fromLTRB(20, 12, 20, 20),
            decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.06),
                  blurRadius: 12,
                  offset: const Offset(0, -2),
                ),
              ],
            ),
            child:
                session.isActive
                    ? SafeArea(
                      top: false,
                      child: SizedBox(
                        width: double.infinity,
                        height: 54,
                        child: ElevatedButton(
                          onPressed: () {
                            // DTODO: Implement end session logic here
                            session.isActive = false;
                            setState(() {});

                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: const Text('Nice work!'),
                                backgroundColor: primaryColor,
                                behavior: SnackBarBehavior.floating,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                duration: const Duration(seconds: 2),
                              ),
                            );
                            Navigator.pop(context);
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: primaryColor,
                            foregroundColor: Colors.white,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(14),
                            ),
                            elevation: 0,
                          ),
                          child: const Text(
                            'End Workout',
                            style: TextStyle(
                              fontSize: 17,
                              fontWeight: FontWeight.w600,
                              letterSpacing: 0.3,
                            ),
                          ),
                        ),
                      ),
                    )
                    : null,
          ),
        ],
      ),
    );
  }
}
