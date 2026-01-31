import 'package:flutter/material.dart';
import 'add_workout_item.dart';

class ViewWorkoutSplit extends StatefulWidget {
  const ViewWorkoutSplit({super.key});

  @override
  State<ViewWorkoutSplit> createState() => _ViewWorkoutSplitState();
}

class _ViewWorkoutSplitState extends State<ViewWorkoutSplit> {
  // Start with initial items
  List<String> splitTypes = ["Push", "Pull", "Legs"];

  void _navigateToAddSplit() async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => AddWorkoutItem(type:'split')),
    );

    if (result != null && result is String && result.trim().isNotEmpty) {
      setState(() {
        splitTypes.add(result.trim());
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Select Routine",
          style: TextStyle(color: Colors.black),
        ),
        //iconTheme: const IconThemeData(color: Colors.white),
        centerTitle: true,
        backgroundColor: Colors.white,
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endTop,
      floatingActionButton: FloatingActionButton(
        onPressed: _navigateToAddSplit,
        backgroundColor: const Color.fromARGB(255, 146, 46, 141),
        child: const Icon(Icons.add, color: Colors.white),
      ),
      backgroundColor: Colors.white,
      body: Padding(
        padding: const EdgeInsets.only(top: 40.0),
        child: ListView.builder(
          padding: const EdgeInsets.all(12),
          itemCount: splitTypes.length,
          itemBuilder: (context, idx) {
            final split = splitTypes[idx];
            return Dismissible(
              key: ValueKey(split),
              direction: DismissDirection.endToStart,
              onDismissed: (direction) {
                setState(() {
                  splitTypes.removeAt(idx);
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
                    print('Tapped on $split');
                    Navigator.pushNamed(
                      context,
                      '/workout_split_details',
                      arguments: split,
                    );
                  },
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
