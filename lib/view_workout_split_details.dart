import 'package:flutter/material.dart';
import 'package:lifters_anonymous/add_workout_item.dart';
import 'package:lifters_anonymous/view_move_history.dart';

class ViewWorkoutSplitDetails extends StatefulWidget {
  const ViewWorkoutSplitDetails({super.key});

  @override
  State<ViewWorkoutSplitDetails> createState() =>
      _ViewWorkoutSplitDetailsState();
}

class _ViewWorkoutSplitDetailsState extends State<ViewWorkoutSplitDetails> {
  void _navigateToAddMove() async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => AddWorkoutItem(type: 'move')),
    );

    if (result != null && result is String && result.trim().isNotEmpty) {
      setState(() {
        moves.add(result.trim());
      });
    }
  }

  List<String> moves = ['A', 'B', 'C'];
  @override
  Widget build(BuildContext context) {
    final split = ModalRoute.of(context)?.settings.arguments as String?;
    return Scaffold(
      appBar: AppBar(title: Text(split ?? 'unknown')),
      floatingActionButtonLocation: FloatingActionButtonLocation.endTop,
      floatingActionButton: FloatingActionButton(
        onPressed: _navigateToAddMove,
        backgroundColor: const Color.fromARGB(255, 146, 46, 141),
        child: const Icon(Icons.add, color: Colors.white),
      ),
      body: Padding(
        padding: const EdgeInsets.only(top: 40.0),
        child: ListView.builder(
          padding: const EdgeInsets.all(12),
          itemCount: moves.length,
          itemBuilder: (context, idx) {
            final split = moves[idx];
            return Dismissible(
              key: ValueKey(split),
              direction: DismissDirection.endToStart, // swipe left to right
              onDismissed: (direction) {
                setState(() {
                  moves.removeAt(idx);
                });
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text("Removed $split"),
                    duration: const Duration(seconds: 1),
                  ),
                );
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
                  title: Text(split),
                  trailing: Icon(Icons.chevron_right_sharp),
                  onTap: () {
                    // TODO: Handle item tap
                    print('Tapped onf $split');
                    // Navigator.pushNamed(
                    //   context,
                    //   '/view_move_history',
                    //   arguments: split,
                    // );
                    callViewMove(split);
                  },
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  void callViewMove(String split) async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => ViewMoveHistory(moveName: split)),
    );
  }
}
