import 'package:flutter/material.dart';
import 'package:lifters_anonymous/utils/database.dart';
import 'package:lifters_anonymous/models/workout.dart';
import 'add_workout_item.dart';

class ViewWorkoutSplit extends StatefulWidget {
  const ViewWorkoutSplit({super.key});

  @override
  State<ViewWorkoutSplit> createState() => _ViewWorkoutSplitState();
}

class _ViewWorkoutSplitState extends State<ViewWorkoutSplit> {
  void navigateToAddSplit() async {
    final myBox = Database.workoutBox;

    final result = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => AddWorkoutItem(type: 'Split')),
    );

    if (result != null && result is String && result.trim().isNotEmpty) {
      final newWorkout = Workout(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        name: result.trim(),
        moves: [],
      );

      myBox.add(newWorkout);
      setState(() {}); // Just trigger rebuild
      print('myBox contents: ${myBox.values.toList()}');
    }
  }

  void navigateToWorkoutDetails(Workout split) async {
    // Navigate and await the return
    await Navigator.pushNamed(
      context,
      '/workout_split_details',
      arguments: split,
    );

    print('RETURNED FROM WORKOUT DETAILS');
    // When we return, trigger rebuild to refresh data from Hive
    setState(() {});
  }

  void deleteSplitType(int idx) {
    final myBox = Database.workoutBox;
    final workouts = myBox.values.toList();
    final split = workouts[idx];
    final key = myBox.keys.elementAt(idx);

    myBox.delete(key);
    setState(() {}); // Trigger rebuild

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text("Removed ${split.name}"),
        duration: const Duration(seconds: 1),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final myBox = Database.workoutBox;
    final splitTypes = myBox.values.toList(); // Read directly in build

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Select Routine",
          style: TextStyle(color: Colors.black),
        ),
        centerTitle: true,
        backgroundColor: Colors.white,
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endTop,
      floatingActionButton: FloatingActionButton(
        onPressed: navigateToAddSplit,
        backgroundColor: const Color.fromARGB(255, 146, 46, 141),
        child: const Icon(Icons.add, color: Colors.white),
      ),
      backgroundColor: Colors.white,
      body: Column(
        children: [
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(top: 40.0),
              child: ListView.builder(
                padding: const EdgeInsets.all(12),
                itemCount: splitTypes.length,
                itemBuilder: (context, idx) {
                  final split = splitTypes[idx];
                  return Dismissible(
                    key: ValueKey(split.id),
                    direction: DismissDirection.endToStart,
                    onDismissed: (direction) {
                      deleteSplitType(idx);
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
                        title: Text(split.name),
                        trailing: const Icon(Icons.chevron_right_sharp),
                        onTap: () {
                          print('Tapped on ${split.name} with ID: ${split.id}');
                          navigateToWorkoutDetails(split); // Changed this line
                        },
                      ),
                    ),
                  );
                },
              ),
            ),
          ),
          Container(
            padding: const EdgeInsets.all(16),
            color: Colors.grey[200],
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Box length: ${myBox.length}'),
                Text('Keys: ${myBox.keys.toList()}'),
                Text(
                  'Values: ${splitTypes.map((w) => '${w.id}: ${w.name} (${w.moves.length} moves)').toList()}',
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
