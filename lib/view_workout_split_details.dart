import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:lifters_anonymous/add_workout_item.dart';
import 'package:lifters_anonymous/shared/rename_routine_dialog.dart';
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
  bool _isInitialized = false;

  // Define consistent brand colors
  static const Color primaryColor = Color(0xFF922E8D);
  static const Color primaryLight = Color(0xFFB85FB3);
  static const Color surfaceColor = Color(0xFFF5F5F5);

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
      MaterialPageRoute(
        builder: (context) => const AddWorkoutItem(type: 'Move'),
      ),
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

  void renameMove(int idx) {
    print('Renaming move at index $idx');
    final myBox = Database.workoutBox;
    //final workouts = myBox.values.toList();
    final moves = currentWorkout.moves;
    // final split = workouts[idx];
    // final key = myBox.keys.elementAt(idx);

    showDialog(
      context: context,
      builder: (context) {
        return RenameRoutineDialog(
          initialName: moves[idx].name,
          elementToRename: 'Move',
          primaryColor: primaryColor,
          onSave: (newName) {
            final updatedMove = Move(id: moves[idx].id, name: newName);
            final updatedMoves = List<Move>.from(moves)..[idx] = updatedMove;
            final updatedWorkout = Workout(
              id: currentWorkout.id,
              name: currentWorkout.name,
              moves: updatedMoves,
            );
            final workoutKey = myBox.keys.firstWhere(
              (key) => (myBox.get(key) as Workout).id == currentWorkout.id,
            );
            myBox.put(workoutKey, updatedWorkout);
            setState(() {});
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('Renamed to $newName'),
                backgroundColor: primaryColor,
                behavior: SnackBarBehavior.floating,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                duration: const Duration(seconds: 2),
              ),
            );
          },
        );
      },
    );
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
        backgroundColor: Colors.red.shade400,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        duration: const Duration(seconds: 2),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        foregroundColor: Colors.black87,
        title: Text(
          currentWorkout.name,
          style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 20),
        ),
        centerTitle: true,
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 12.0),
            child: IconButton(
              onPressed: navigateToAddMove,
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
          // Stats header
          Container(
            margin: const EdgeInsets.all(20),
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [primaryColor, primaryLight],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Row(
              children: [
                Expanded(
                  child: _buildStatItem(
                    icon: Icons.fitness_center,
                    label: 'Exercises',
                    value: currentWorkout.moves.length.toString(),
                  ),
                ),
                Container(
                  width: 1,
                  height: 40,
                  color: Colors.white.withOpacity(0.3),
                ),
                Expanded(
                  child: _buildStatItem(
                    icon: Icons.history,
                    label: 'Sessions',
                    value: '0', // Mock data
                  ),
                ),
                Container(
                  width: 1,
                  height: 40,
                  color: Colors.white.withOpacity(0.3),
                ),
                Expanded(
                  child: _buildStatItem(
                    icon: Icons.calendar_today,
                    label: 'Last',
                    value: 'Never', // Mock data
                  ),
                ),
              ],
            ),
          ),

          // Exercises section header
          if (currentWorkout.moves.isNotEmpty)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
              child: Row(
                children: [
                  Text(
                    'Exercises',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: Colors.grey.shade700,
                      letterSpacing: 0.5,
                    ),
                  ),
                ],
              ),
            ),

          // Exercises list
          Expanded(
            child:
                currentWorkout.moves.isEmpty
                    ? _buildEmptyState()
                    : ListView.builder(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      itemCount: currentWorkout.moves.length,
                      itemBuilder: (context, idx) {
                        print(
                          'Here: ${currentWorkout.moves.map((e) => e.name).join(', ')}',
                        );
                        final move = currentWorkout.moves[idx];
                        return _buildMoveCard(move, idx);
                      },
                    ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatItem({
    required IconData icon,
    required String label,
    required String value,
  }) {
    return Column(
      children: [
        Icon(icon, color: Colors.white, size: 24),
        const SizedBox(height: 8),
        Text(
          value,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 2),
        Text(
          label,
          style: TextStyle(
            color: Colors.white.withOpacity(0.9),
            fontSize: 12,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
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
              'No Exercises Yet',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
            const SizedBox(height: 12),
            Text(
              'Add exercises to build your ${currentWorkout.name} routine',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 16, color: Colors.grey.shade600),
            ),
            const SizedBox(height: 32),
            ElevatedButton.icon(
              onPressed: navigateToAddMove,
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
                'Add Exercise',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMoveCard(Move move, int idx) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16),
        child: Slidable(
          key: ValueKey(move.id),
          endActionPane: ActionPane(
            motion: const DrawerMotion(),
            extentRatio: 0.4,
            children: [
              SlidableAction(
                onPressed: (context) {
                  renameMove(idx);
                },
                backgroundColor: const Color.fromARGB(255, 53, 157, 242),
                foregroundColor: Colors.white,
                icon: Icons.edit_rounded,
                spacing: 4,
              ),
              // Delete action
              SlidableAction(
                onPressed: (context) {
                  deleteMove(idx);
                },
                backgroundColor: const Color.fromARGB(255, 208, 51, 48),
                foregroundColor: Colors.white,
                icon: Icons.delete_rounded,
                spacing: 4,
              ),
            ],
          ),
          child: Container(
            decoration: BoxDecoration(
              color: surfaceColor,
              border: Border.all(color: Colors.grey.shade200, width: 1),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.04),
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Material(
              color: Colors.transparent,
              child: InkWell(
                borderRadius: BorderRadius.circular(16),
                onTap: () {
                  print('Tapped on ${move.name} with ID: ${move.id}');
                  //navigateToMoveDetails(move);
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
                          boxShadow: [
                            BoxShadow(
                              color: primaryColor.withOpacity(0.3),
                              blurRadius: 8,
                              offset: const Offset(0, 2),
                            ),
                          ],
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
                              move.name,
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
                                  'View history',
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
        ),
      ),
    );
  }
}

  





    // return Dismissible(
    //   key: ValueKey(move.id),
    //   direction: DismissDirection.endToStart,
    //   onDismissed: (direction) {
    //     deleteMove(idx);
    //   },
    //   background: Container(
    //     margin: const EdgeInsets.only(bottom: 12),
    //     alignment: Alignment.centerRight,
    //     padding: const EdgeInsets.only(right: 24),
    //     decoration: BoxDecoration(
    //       color: Colors.red.shade400,
    //       borderRadius: BorderRadius.circular(16),
    //     ),
    //     child: const Column(
    //       mainAxisAlignment: MainAxisAlignment.center,
    //       children: [
    //         Icon(Icons.delete_outline, color: Colors.white, size: 28),
    //         SizedBox(height: 4),
    //         Text(
    //           "Delete",
    //           style: TextStyle(
    //             color: Colors.white,
    //             fontWeight: FontWeight.w600,
    //             fontSize: 12,
    //           ),
    //         ),
    //       ],
    //     ),
    //   ),
    //   child: Container(
    //     margin: const EdgeInsets.only(bottom: 12),
    //     decoration: BoxDecoration(
    //       color: surfaceColor,
    //       borderRadius: BorderRadius.circular(16),
    //       border: Border.all(color: Colors.grey.shade200, width: 1),
    //     ),
    //     child: Material(
    //       color: Colors.transparent,
    //       child: InkWell(
    //         borderRadius: BorderRadius.circular(16),
    //         onTap: () {
    //           print('Tapped on ${move.name}');
    //           handleViewMove(move.name);
    //         },
    //         child: Padding(
    //           padding: const EdgeInsets.all(16),
    //           child: Row(
    //             children: [
    //               // Number badge
    //               Container(
    //                 width: 40,
    //                 height: 40,
    //                 decoration: BoxDecoration(
    //                   gradient: LinearGradient(
    //                     colors: [primaryColor, primaryLight],
    //                     begin: Alignment.topLeft,
    //                     end: Alignment.bottomRight,
    //                   ),
    //                   borderRadius: BorderRadius.circular(10),
    //                 ),
    //                 child: Center(
    //                   child: Text(
    //                     '${idx + 1}',
    //                     style: const TextStyle(
    //                       color: Colors.white,
    //                       fontSize: 18,
    //                       fontWeight: FontWeight.bold,
    //                     ),
    //                   ),
    //                 ),
    //               ),
    //               const SizedBox(width: 16),
    //               // Content
    //               Expanded(
    //                 child: Column(
    //                   crossAxisAlignment: CrossAxisAlignment.start,
    //                   children: [
    //                     Text(
    //                       move.name,
    //                       style: const TextStyle(
    //                         fontSize: 17,
    //                         fontWeight: FontWeight.w600,
    //                         color: Colors.black87,
    //                       ),
    //                     ),
    //                     const SizedBox(height: 6),
    //                     Row(
    //                       children: [
    //                         Icon(
    //                           Icons.history,
    //                           size: 16,
    //                           color: Colors.grey.shade600,
    //                         ),
    //                         const SizedBox(width: 6),
    //                         Text(
    //                           'View history',
    //                           style: TextStyle(
    //                             fontSize: 14,
    //                             color: Colors.grey.shade600,
    //                             fontWeight: FontWeight.w500,
    //                           ),
    //                         ),
    //                       ],
    //                     ),
    //                   ],
    //                 ),
    //               ),
    //               // Chevron
    //               Icon(
    //                 Icons.chevron_right,
    //                 size: 28,
    //                 color: Colors.grey.shade400,
    //               ),
    //             ],
    //           ),
    //         ),
    //       ),
    //     ),
    //   ),
    // );


  

