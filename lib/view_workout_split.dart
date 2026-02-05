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
  // Define consistent brand colors
  static const Color primaryColor = Color(0xFF922E8D);
  static const Color primaryLight = Color(0xFFB85FB3);
  static const Color surfaceColor = Color(0xFFF5F5F5);

  void navigateToAddSplit() async {
    final myBox = Database.workoutBox;

    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const AddWorkoutItem(type: 'Split'),
      ),
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

      // Show success feedback
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Added ${result.trim()}"),
          backgroundColor: primaryColor,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          duration: const Duration(seconds: 2),
        ),
      );
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
    setState(() {});

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text("Removed ${split.name}"),
        backgroundColor: Colors.red.shade400,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        duration: const Duration(seconds: 2),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final myBox = Database.workoutBox;
    final splitTypes = myBox.values.toList(); // Read directly in build

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        foregroundColor: Colors.black87,
        title: const Text(
          "Select Routine",
          style: TextStyle(fontWeight: FontWeight.w600, fontSize: 20),
        ),
        centerTitle: true,
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 12.0),
            child: IconButton(
              onPressed: navigateToAddSplit,
              icon: Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [primaryColor, primaryLight],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Icon(Icons.add, color: Colors.white, size: 24),
              ),
            ),
          ),
        ],
      ),
      body:
          splitTypes.isEmpty
              ? _buildEmptyState()
              : ListView.builder(
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 16,
                ),
                itemCount: splitTypes.length,
                itemBuilder: (context, idx) {
                  final split = splitTypes[idx];
                  return _buildSplitCard(split, idx);
                },
              ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    primaryColor.withOpacity(0.1),
                    primaryLight.withOpacity(0.05),
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                shape: BoxShape.circle,
              ),
              child: Icon(Icons.fitness_center, size: 64, color: primaryColor),
            ),
            const SizedBox(height: 24),
            const Text(
              'No Routines Yet',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
            const SizedBox(height: 12),
            Text(
              'Create your first workout routine to get started',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 16, color: Colors.grey.shade600),
            ),
            const SizedBox(height: 32),
            ElevatedButton.icon(
              onPressed: navigateToAddSplit,
              style: ElevatedButton.styleFrom(
                backgroundColor: primaryColor,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(
                  horizontal: 32,
                  vertical: 16,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
              ),
              icon: const Icon(Icons.add),
              label: const Text(
                'Create Routine',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSplitCard(Workout split, int idx) {
    return Dismissible(
      key: ValueKey(split.id),
      direction: DismissDirection.endToStart,
      onDismissed: (direction) {
        deleteSplitType(idx);
      },
      background: Container(
        margin: const EdgeInsets.only(bottom: 12),
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.only(right: 24),
        decoration: BoxDecoration(
          color: Colors.red.shade400,
          borderRadius: BorderRadius.circular(16),
        ),
        child: const Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.delete_outline, color: Colors.white, size: 28),
            SizedBox(height: 4),
            Text(
              "Delete",
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w600,
                fontSize: 12,
              ),
            ),
          ],
        ),
      ),
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        decoration: BoxDecoration(
          color: surfaceColor,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: Colors.grey.shade200, width: 1),
        ),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            borderRadius: BorderRadius.circular(16),
            onTap: () {
              print('Tapped on ${split.name} with ID: ${split.id}');
              navigateToWorkoutDetails(split);
            },
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  // Icon container
                  Container(
                    width: 56,
                    height: 56,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [primaryColor, primaryLight],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Icon(
                      Icons.fitness_center,
                      color: Colors.white,
                      size: 28,
                    ),
                  ),
                  const SizedBox(width: 16),
                  // Content
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          split.name,
                          style: const TextStyle(
                            fontSize: 17,
                            fontWeight: FontWeight.w600,
                            color: Colors.black87,
                          ),
                        ),
                        const SizedBox(height: 6),
                        Row(
                          children: [
                            Icon(
                              Icons.list_alt,
                              size: 16,
                              color: Colors.grey.shade600,
                            ),
                            const SizedBox(width: 6),
                            Text(
                              '${split.moves.length} ${split.moves.length == 1 ? 'exercise' : 'exercises'}',
                              style: TextStyle(
                                fontSize: 14,
                                color: Colors.grey.shade600,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  // Chevron
                  Icon(
                    Icons.chevron_right,
                    size: 28,
                    color: Colors.grey.shade400,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
