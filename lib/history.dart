import 'package:flutter/material.dart';
import 'package:lifters_anonymous/add_workout_item.dart';
import 'package:lifters_anonymous/models/workout.dart';
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
  static const Color surfaceColor = Color(0xFFF5F5F5);

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

    //save session to db
    if (result != null && result is SessionDTO) {
      print('YES!');
      var newSessionObj = Session(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        workoutId: result.workoutId,
        date: result.date,
        moveRecords: [],
      );
      mySessionBox.add(newSessionObj);
      setState(() {});
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
              onPressed: navigateToAddCalendarEntry,
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
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
              itemBuilder:
                  (context, index) => _buildSessionCard(
                    Database.sessionBox.values.toList()[index],
                    index,
                  ),
              itemCount: Database.sessionBox.length,
            ),
          ),
          Text(
            'Total Sessions: ${Database.sessionBox.length}',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w500,
              color: Colors.grey.shade700,
            ),
          ),
        ],
      ),
    );
  }

  // Widget historicalSessionCard(int dateVariable) {
  //   return Container(
  //     margin: const EdgeInsets.only(bottom: 12),
  //     decoration: BoxDecoration(
  //       color: surfaceColor,
  //       borderRadius: BorderRadius.circular(16),
  //       border: Border.all(color: Colors.grey.shade200, width: 1),
  //     ),
  //     child: ListView.builder(
  //       itemBuilder: (context, idx) {
  //         final session = Database.sessionBox.values.toList()[idx];
  //         return _buildSessionCard(session, idx);
  //       },
  //       itemCount: Database.sessionBox.length,
  //       shrinkWrap: true,
  //       physics: const NeverScrollableScrollPhysics(),
  //     ),
  //   );
  // }

  //   child: Material(
  //     color: Colors.transparent,
  //     child: InkWell(
  //       borderRadius: BorderRadius.circular(16),
  //       onTap: () {
  //         // Handle tap
  //         print('Tapped on entry $dateVariable');
  //       },
  //       child: Padding(
  //         padding: const EdgeInsets.all(16),
  //         child: Row(
  //           children: [
  //             // Date icon
  //             Container(
  //               width: 56,
  //               height: 56,
  //               decoration: BoxDecoration(
  //                 gradient: LinearGradient(
  //                   colors: [primaryColor, primaryLight],
  //                   begin: Alignment.topLeft,
  //                   end: Alignment.bottomRight,
  //                 ),
  //                 borderRadius: BorderRadius.circular(12),
  //               ),
  //               child: Column(
  //                 mainAxisAlignment: MainAxisAlignment.center,
  //                 children: [
  //                   Text(
  //                     'JAN',
  //                     style: TextStyle(
  //                       color: Colors.white.withOpacity(0.9),
  //                       fontSize: 11,
  //                       fontWeight: FontWeight.w600,
  //                       letterSpacing: 0.5,
  //                     ),
  //                   ),
  //                   const SizedBox(height: 2),
  //                   Text(
  //                     dateVariable.toString().padLeft(2, '0'),
  //                     style: const TextStyle(
  //                       color: Colors.white,
  //                       fontSize: 20,
  //                       fontWeight: FontWeight.bold,
  //                     ),
  //                   ),
  //                 ],
  //               ),
  //             ),
  //             const SizedBox(width: 16),
  //             // Content
  //             Expanded(
  //               child: Column(
  //                 crossAxisAlignment: CrossAxisAlignment.start,
  //                 children: [
  //                   Text(
  //                     'Push Workout',
  //                     style: TextStyle(
  //                       fontSize: 17,
  //                       fontWeight: FontWeight.w600,
  //                       color: Colors.black87,
  //                     ),
  //                   ),
  //                   const SizedBox(height: 6),
  //                   Row(
  //                     children: [
  //                       Icon(
  //                         Icons.timer_outlined,
  //                         size: 16,
  //                         color: Colors.grey.shade600,
  //                       ),
  //                       const SizedBox(width: 6),
  //                       Text(
  //                         '14 hour fast',
  //                         style: TextStyle(
  //                           fontSize: 14,
  //                           color: Colors.grey.shade600,
  //                           fontWeight: FontWeight.w500,
  //                         ),
  //                       ),
  //                     ],
  //                   ),
  //                   const SizedBox(height: 4),
  //                   Row(
  //                     children: [
  //                       Icon(
  //                         Icons.fitness_center,
  //                         size: 16,
  //                         color: Colors.grey.shade600,
  //                       ),
  //                       const SizedBox(width: 6),
  //                       Text(
  //                         '8 exercises',
  //                         style: TextStyle(
  //                           fontSize: 14,
  //                           color: Colors.grey.shade600,
  //                           fontWeight: FontWeight.w500,
  //                         ),
  //                       ),
  //                     ],
  //                   ),
  //                 ],
  //               ),
  //             ),
  //             // Chevron
  //             Icon(
  //               Icons.chevron_right,
  //               size: 28,
  //               color: Colors.grey.shade400,
  //             ),
  //           ],
  //         ),
  //       ),
  //     ),
  //   ),
  // );

  _buildSessionCard(session, int idx) {
    //return Text('YOOO!');
    print('CALLED');

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
                      session.date.month.toString().padLeft(2, '0'),
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
                      session.workoutId,
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
                          '8 exercises',
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
}
