import 'package:flutter/material.dart';
import 'package:repify/add_workout_item.dart';
import 'package:repify/models/workout.dart';
import 'package:repify/models/workout_dtos.dart';
import 'package:repify/utils/database.dart';
import 'package:repify/utils/styles.dart';

class History extends StatefulWidget {
  const History({super.key});

  @override
  State<History> createState() => _HistoryState();
}

class _HistoryState extends State<History> {
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

  void navigateToActiveWorkout(Session session) async {
    // Navigate and await the return
    print('workout ID: ${session.workoutId}');
    await Navigator.pushNamed(context, '/active_session', arguments: session);

    print('RETURNED FROM ACTIVE WORKOUT');
    // When we return, trigger rebuild to refresh data from Hive
    setState(() {});
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
    print('Returned from adding calendar entry $result');

    //save session to db
    if (result != null && result is SessionDTO) {
      print('Saving active session!');
      var newSessionObj = Session(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        workoutId: result.workoutId,
        date: result.date,
        duration:
            null, // Placeholder, replace with actual duration if available
        moveRecords: [],
      );
      mySessionBox.put(
        newSessionObj.id,
        newSessionObj,
      ); // DTODO: dont use add, use Put to set the ID explicitly
      setState(() {});
      navigateToActiveWorkout(newSessionObj);
    }
  }

  // DTODO: Move to util
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
    var hasActiveSession = Database.sessionBox.values.any(
      (session) => session.isActive,
    );

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
                  hasActiveSession
                      ? () => showDialog(
                        context: context,
                        builder:
                            (_) => AlertDialog(
                              title: const Text('Active Session In Progress'),
                              content: const Text(
                                'End your current session before starting a new one.',
                              ),
                              actions: [
                                TextButton(
                                  onPressed: () => Navigator.of(context).pop(),
                                  child: const Text('OK'),
                                ),
                              ],
                            ),
                      )
                      : navigateToAddCalendarEntry,
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

  // void _showActiveSessionDialog(BuildContext context) {
  //   showModalBottomSheet(
  //     context: context,
  //     builder:
  //         (context) => Padding(
  //           padding: const EdgeInsets.all(24.0),
  //           child: Column(
  //             mainAxisSize: MainAxisSize.min,
  //             children: [
  //               const Icon(
  //                 Icons.warning_amber_rounded,
  //                 size: 48,
  //                 color: Colors.orange,
  //               ),
  //               const SizedBox(height: 12),
  //               const Text(
  //                 'Active Session In Progress',
  //                 style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
  //               ),
  //               const SizedBox(height: 8),
  //               const Text(
  //                 'Please end your current session before starting a new one.',
  //               ),
  //               const SizedBox(height: 24),
  //               SizedBox(
  //                 width: double.infinity,
  //                 child: ElevatedButton(
  //                   onPressed: () => Navigator.of(context).pop(),
  //                   child: const Text('Got it'),
  //                 ),
  //               ),
  //             ],
  //           ),
  //         ),
  //   );
  // }

  _buildSessionCard(Session session, int idx) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: () {
          navigateToActiveWorkout(session);
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
              session.isActive
                  ? Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: Color.fromARGB(255, 199, 248, 3),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      'Active',
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  )
                  : const SizedBox.shrink(),
              // Chevron
              Padding(
                padding: const EdgeInsets.only(left: 5.0),
                child: Icon(
                  Icons.chevron_right,
                  size: 28,
                  color: Colors.grey.shade400,
                ),
              ),
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
