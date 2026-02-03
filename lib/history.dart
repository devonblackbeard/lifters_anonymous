import 'package:flutter/material.dart';
import 'package:lifters_anonymous/add_workout_item.dart';

class History extends StatefulWidget {
  const History({super.key});

  @override
  State<History> createState() => _HistoryState();
}

class _HistoryState extends State<History> {
  void navigateToAddCalendarEntry() async {
    print('Add calendar entry');
    final newWorkout = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => AddWorkoutItem(type: 'workoutEvent'),
      ),
    );
    print('Returned from adding calendar entry$newWorkout');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('History')),
      floatingActionButtonLocation: FloatingActionButtonLocation.endTop,
      floatingActionButton: FloatingActionButton(
        onPressed: navigateToAddCalendarEntry,
        backgroundColor: const Color.fromARGB(255, 146, 46, 141),
        child: const Icon(Icons.add, color: Colors.white),
      ),
      body: Padding(
        padding: const EdgeInsets.only(top: 40.0),
        child: Center(
          child: ListView.builder(
            itemBuilder: (context, index) => historicalItemCard(index + 1),
            itemCount: 35,
          ),
        ),
      ),
    );
  }

  Widget historicalItemCard(int dateVariable) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      margin: const EdgeInsets.fromLTRB(20, 12, 20, 12),
      child: Padding(
        padding: const EdgeInsets.all(10),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    'Mon, January $dateVariable',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 8),
                  Text('Push workout', style: TextStyle(fontSize: 16)),
                  SizedBox(height: 4),
                  Text(
                    '14 hour fast',
                    style: TextStyle(fontSize: 16, color: Colors.grey[700]),
                  ),
                ],
              ),
            ),
            Icon(Icons.chevron_right, size: 32, color: Colors.grey[600]),
          ],
        ),
      ),
    );
  }
}
