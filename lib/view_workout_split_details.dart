import 'package:flutter/material.dart';
import 'package:lifters_anonymous/add_workout_item.dart';
import 'package:lifters_anonymous/models/workout.dart';
import 'package:lifters_anonymous/utils/database.dart';
import 'package:lifters_anonymous/view_move_history.dart';

class ViewWorkoutSplitDetails extends StatefulWidget {
  const ViewWorkoutSplitDetails({super.key});

  @override
  State<ViewWorkoutSplitDetails> createState() =>
      _ViewWorkoutSplitDetailsState();
}

class _ViewWorkoutSplitDetailsState extends State<ViewWorkoutSplitDetails> {
  late Workout currentWorkout;
  bool _isInitialized = false; // Add this flag

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // Only initialize once
    if (!_isInitialized) {
      print("in DID CHANGE DEP - initializing");
      currentWorkout = ModalRoute.of(context)?.settings.arguments as Workout;
      _isInitialized = true;
    } else {
      print("in DID CHANGE DEP - skipping (already initialized)");
    }
  }

  void _reloadWorkout() {
    final box = Database.workoutBox;
    final updatedWorkout = box.values.firstWhere(
      (workout) => workout.id == currentWorkout.id,
    );
    setState(() {
      currentWorkout = updatedWorkout;
    });
  }

  void handleViewMove(String moveName) async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ViewMoveHistory(moveName: moveName),
      ),
    );
  }

  void navigateToAddMove() async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => AddWorkoutItem(type: 'move')),
    );

    if (result != null && result is String && result.trim().isNotEmpty) {
      // Create a new move
      final newMove = Move(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        name: result.trim(),
      );

      // Create updated workout with the new move
      final updatedMoves = [...currentWorkout.moves, newMove];
      final updatedWorkout = Workout(
        id: currentWorkout.id,
        name: currentWorkout.name,
        moves: updatedMoves,
      );

      // Update in Hive
      final box = Database.workoutBox;
      final workoutKey = box.keys.firstWhere(
        (key) => (box.get(key) as Workout).id == currentWorkout.id,
      );
      box.put(workoutKey, updatedWorkout);

      setState(() {
        currentWorkout = updatedWorkout;
        print('updated: ${currentWorkout.moves.length} moves');
      });
    }
  }

  void deleteMove(int idx) {
    final move = currentWorkout.moves[idx];

    // Create updated workout without the deleted move
    final updatedMoves = List<Move>.from(currentWorkout.moves)..removeAt(idx);
    final updatedWorkout = Workout(
      id: currentWorkout.id,
      name: currentWorkout.name,
      moves: updatedMoves,
    );

    // Update in Hive
    final box = Database.workoutBox;
    final workoutKey = box.keys.firstWhere(
      (key) => (box.get(key) as Workout).id == currentWorkout.id,
    );
    box.put(workoutKey, updatedWorkout);

    setState(() {
      currentWorkout = updatedWorkout;
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text("Removed ${move.name}"),
        duration: const Duration(seconds: 1),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(currentWorkout.name)),
      floatingActionButtonLocation: FloatingActionButtonLocation.endTop,
      floatingActionButton: FloatingActionButton(
        onPressed: navigateToAddMove,
        backgroundColor: const Color.fromARGB(255, 146, 46, 141),
        child: const Icon(Icons.add, color: Colors.white),
      ),
      body: Column(
        children: [
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(top: 40.0),
              child: ListView.builder(
                padding: const EdgeInsets.all(12),
                itemCount: currentWorkout.moves.length,
                itemBuilder: (context, idx) {
                  final move = currentWorkout.moves[idx];
                  return Dismissible(
                    key: ValueKey(move.id),
                    direction: DismissDirection.endToStart,
                    onDismissed: (direction) {
                      deleteMove(idx);
                    },
                    background: Container(
                      alignment: Alignment.centerRight,
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      color: Colors.red,
                      child: const Text(
                        "Delete",
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    child: Card(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: ListTile(
                        title: Text(move.name),
                        trailing: const Icon(Icons.chevron_right_sharp),
                        onTap: () {
                          print('Tapped on ${move.name}');
                          handleViewMove(move.name);
                        },
                      ),
                    ),
                  );
                },
              ),
            ),
          ),
          Text("${currentWorkout.moves.length} moves in this workout"),
        ],
      ),
    );
  }
}
