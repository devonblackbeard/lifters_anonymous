import 'package:flutter/material.dart';
import 'package:lifters_anonymous/add_workout_item.dart';
import 'package:lifters_anonymous/models/workout.dart';
import 'package:lifters_anonymous/models/workoutDtos.dart';
import 'package:lifters_anonymous/utils/database.dart';

class History extends StatefulWidget {
  const History({super.key});

  @override
  State<History> createState() => _HistoryState();
}

class _HistoryState extends State<History> {
  // Define consistent brand colors
  static const Color primaryColor = Color(0xFF922E8D);
  static const Color primaryLight = Color(0xFFB85FB3);
  //static const Color surfaceColor = Color(0xFFF5F5F5);

  Widget _buildEmptyState() {
    final workoutBox = Database.workoutBox;
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
              child: Icon(
                Icons.sentiment_dissatisfied_outlined,
                size: 64,
                color: primaryColor,
              ),
            ),
            const SizedBox(height: 24),
            const Text(
              'No workouts logged',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
            const SizedBox(height: 12),
            workoutBox.isEmpty
                ? Text(
                  'Add routines before logging your workout sessions',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 16, color: Colors.grey.shade600),
                )
                : const SizedBox.shrink(),
            const SizedBox(height: 32),
            ElevatedButton.icon(
              onPressed:
                  workoutBox.isNotEmpty ? navigateToAddCalendarEntry : null,
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
                'Start session',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void navigateToAddCalendarEntry() async {
    final mySessionBox = Database.sessionBox;

    print('Add calendar entry');
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const AddWorkoutItem(type: 'Session'),
      ),
    );
    print('Returned from adding calendar entry$result');

    //save session to db [only after the workout is done]
    if (result != null && result is SessionDTO) {
      print('Saving completed workout!');
      // var newSessionObj = Session(
      //   id: DateTime.now().millisecondsSinceEpoch.toString(),
      //   workoutId: result.workoutId,
      //   date: result.date,
      //   duration: null, // Placeholder, replace with actual duration if available
      //   moveRecords: [],
      // );
      // mySessionBox.add(newSessionObj);
      // setState(() {});
    }
  }

  String formatDate(int day) {
    const months = [
      'Jan',
      'Feb',
      'Mar',
      'Apr',
      'May',
      'Jun',
      'Jul',
      'Aug',
      'Sep',
      'Oct',
      'Nov',
      'Dec',
    ];
    // Mock: using January for all entries
    String dayStr = day.toString().padLeft(2, '0');
    return '${months[0]} $dayStr 2026';
  }

  // DTODO should be able to edit these sessions
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        foregroundColor: Colors.black87,
        title: const Text(
          'History',
          style: TextStyle(fontWeight: FontWeight.w600, fontSize: 20),
        ),
        centerTitle: true,
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 12.0),
            child: IconButton(
              onPressed:
                  Database.workoutBox.isNotEmpty
                      ? navigateToAddCalendarEntry
                      : null,
              icon: Opacity(
                opacity:
                    Database.workoutBox.isNotEmpty
                        ? 1.0
                        : 0.5, // Dim when disabled
                child: Container(
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
              selectedIcon: const Icon(
                Icons.add,
                color: Colors.white,
                size: 24,
              ),
            ),
          ),
        ],
      ),
      body:
          Database.sessionBox.isEmpty
              ? _buildEmptyState()
              : ListView.builder(
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 16,
                ),
                itemBuilder:
                    (context, index) => _buildSessionCard(
                      Database.sessionBox.values.toList()[index],
                      index,
                    ),
                itemCount: Database.sessionBox.length,
              ),
    );
  }

  _buildSessionCard(Session session, int idx) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: () {
          // Handle tap
          // print('Tapped on entry $dateVariable');
        },
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              // Date icon
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
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      getMonthName(
                        session.date.month,
                      ), //.toString().padLeft(2, '0'),
                      style: TextStyle(
                        color: Colors.white.withOpacity(0.9),
                        fontSize: 11,
                        fontWeight: FontWeight.w600,
                        letterSpacing: 0.5,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      session.date.day.toString().padLeft(2, '0'),
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 16),
              // Content
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      getWorkout(session.workoutId).name,
                      style: TextStyle(
                        fontSize: 17,
                        fontWeight: FontWeight.w600,
                        color: Colors.black87,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Row(
                      children: [
                        Icon(
                          Icons.timer_outlined,
                          size: 16,
                          color: Colors.grey.shade600,
                        ),
                        const SizedBox(width: 6),
                        Text(
                          '14 hour fast',
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.grey.shade600,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        Icon(
                          Icons.fitness_center,
                          size: 16,
                          color: Colors.grey.shade600,
                        ),
                        const SizedBox(width: 6),
                        Text(
                          '${getWorkout(session.workoutId).moves.length} exercises',
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
              Icon(Icons.chevron_right, size: 28, color: Colors.grey.shade400),
            ],
          ),
        ),
      ),
    );
  }

  String getMonthName(int month) {
    const months = [
      'Jan',
      'Feb',
      'Mar',
      'Apr',
      'May',
      'Jun',
      'Jul',
      'Aug',
      'Sep',
      'Oct',
      'Nov',
      'Dec',
    ];
    return months[month - 1];
  }

  Workout getWorkout(workoutId) {
    final workoutBox = Database.workoutBox;
    final workout = workoutBox.values.firstWhere(
      (workout) => workout.id == workoutId,
      orElse: () => Workout(id: 'unknown', name: 'Unknown Workout'),
    );
    return workout;
  }
}
