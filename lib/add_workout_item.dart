import 'package:flutter/material.dart';
import 'package:lifters_anonymous/models/workout.dart';
import 'package:lifters_anonymous/utils/database.dart';

class AddWorkoutItem extends StatefulWidget {
  final String type;

  const AddWorkoutItem({super.key, required this.type});

  @override
  State<AddWorkoutItem> createState() => _AddWorkoutItemState();
}

class _AddWorkoutItemState extends State<AddWorkoutItem> {
  final TextEditingController _controller = TextEditingController();
  String? selectedWorkoutId;
  DateTime selectedDate = DateTime.now();

  // Define your brand color
  static const Color primaryColor = Color(0xFF922E8D); // Your purple color
  static const Color primaryLight = Color(0xFFB85FB3);
  static const Color surfaceColor = Color(0xFFF5F5F5);

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void submit(BuildContext context) {
    if (widget.type == 'Rename') {
      final text = _controller.text.trim();
      if (text.isNotEmpty) {
        Navigator.pop(context, text);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Text("Please enter a name"),
            backgroundColor: Colors.red.shade400,
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
          ),
        );
      }
      return;
    }
    if (widget.type == 'Session') {
      // For workout events, return the selected workout ID and date
      if (selectedWorkoutId != null) {
        // Navigator.pop(context, {
        //   'workoutId': selectedWorkoutId,
        //   'date': selectedDate,
        // });
        Navigator.pop(
          context,
          SessionDTO(workoutId: selectedWorkoutId!, date: selectedDate),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Text("Please select a workout"),
            backgroundColor: Colors.red.shade400,
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
          ),
        );
      }
    } else {
      // For split/move, return the text
      final text = _controller.text.trim();
      if (text.isNotEmpty) {
        Navigator.pop(context, text);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Text("Please enter a name"),
            backgroundColor: Colors.red.shade400,
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
          ),
        );
      }
    }
  }

  String formatDate(DateTime date) {
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
    String day = date.day.toString().padLeft(2, '0');
    return '${months[date.month - 1]} $day ${date.year}';
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
          "Add ${widget.type}",
          style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 20),
        ),
        centerTitle: true,
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: buildForm(context),
        ),
      ),
    );
  }

  Widget buildForm(BuildContext context) {
    switch (widget.type) {
      case 'Split':
      case 'Move':
        return _buildSplitForm(context);
      case 'Session':
        return _buildWorkoutEventForm(context);
      default:
        return Center(child: Text('Unknown type: ${widget.type}'));
    }
  }

  Widget _buildWorkoutEventForm(BuildContext context) {
    final workouts = Database.workoutBox.values.toList();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const SizedBox(height: 8),
        // Header section with icon
        Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [primaryColor, primaryLight],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(20),
          ),
          child: Column(
            children: [
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.2),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.fitness_center,
                  size: 40,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 12),
              const Text(
                'Start Your Session',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                'Select a workout and date to begin',
                style: TextStyle(
                  color: Colors.white.withOpacity(0.9),
                  fontSize: 14,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 32),

        // Workout Selection
        Text(
          'Workout',
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: Colors.grey.shade700,
            letterSpacing: 0.5,
          ),
        ),
        const SizedBox(height: 8),
        Container(
          decoration: BoxDecoration(
            color: surfaceColor,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color:
                  selectedWorkoutId != null
                      ? primaryColor.withOpacity(0.3)
                      : Colors.grey.shade300,
              width: 1.5,
            ),
          ),
          child: DropdownButtonFormField<String>(
            initialValue: selectedWorkoutId,
            decoration: const InputDecoration(
              contentPadding: EdgeInsets.symmetric(
                horizontal: 20,
                vertical: 16,
              ),
              border: InputBorder.none,
              hintText: 'Choose your workout',
            ),
            dropdownColor: Colors.white,
            icon: Icon(Icons.keyboard_arrow_down, color: primaryColor),
            items:
                workouts.map((workout) {
                  return DropdownMenuItem(
                    value: workout.id,
                    child: Text(
                      workout.name,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  );
                }).toList(),
            onChanged: (String? newValue) {
              setState(() {
                selectedWorkoutId = newValue;
              });
            },
          ),
        ),

        const SizedBox(height: 24),

        // Date Selection
        Text(
          'Date',
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: Colors.grey.shade700,
            letterSpacing: 0.5,
          ),
        ),
        const SizedBox(height: 8),
        InkWell(
          onTap: () async {
            final date = await showDatePicker(
              context: context,
              initialDate: selectedDate,
              firstDate: DateTime(2020),
              lastDate: DateTime(2030),
              builder: (context, child) {
                return Theme(
                  data: Theme.of(context).copyWith(
                    colorScheme: ColorScheme.light(
                      primary: primaryColor,
                      onPrimary: Colors.white,
                      surface: Colors.white,
                      onSurface: Colors.black87,
                    ),
                  ),
                  child: child!,
                );
              },
            );
            if (date != null) {
              setState(() {
                selectedDate = date;
              });
            }
          },
          borderRadius: BorderRadius.circular(16),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
            decoration: BoxDecoration(
              color: surfaceColor,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: Colors.grey.shade300, width: 1.5),
            ),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: primaryColor.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Icon(
                    Icons.calendar_today,
                    size: 20,
                    color: primaryColor,
                  ),
                ),
                const SizedBox(width: 16),
                Text(
                  formatDate(selectedDate),
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
        ),

        const Spacer(),

        // Submit Button
        SizedBox(
          height: 56,
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: primaryColor,
              foregroundColor: Colors.white,
              elevation: 0,
              shadowColor: primaryColor.withOpacity(0.3),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
            ),
            onPressed: () => submit(context),
            child: const Text(
              "Start Workout",
              style: TextStyle(
                fontSize: 17,
                fontWeight: FontWeight.w600,
                letterSpacing: 0.5,
              ),
            ),
          ),
        ),
        const SizedBox(height: 16),
      ],
    );
  }

  Widget _buildSplitForm(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const SizedBox(height: 8),
        // Header section
        Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [primaryColor, primaryLight],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(20),
          ),
          child: Column(
            children: [
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.2),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  widget.type == 'Split'
                      ? Icons.view_module
                      : Icons.fitness_center,
                  size: 40,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 12),
              Text(
                'New ${widget.type}',
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                widget.type == 'Split'
                    ? 'Create a new workout split'
                    : 'Add a new exercise',
                style: TextStyle(
                  color: Colors.white.withOpacity(0.9),
                  fontSize: 14,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 32),

        // Input field
        Text(
          '${widget.type} Name',
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: Colors.grey.shade700,
            letterSpacing: 0.5,
          ),
        ),
        const SizedBox(height: 8),
        TextField(
          controller: _controller,
          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
          decoration: InputDecoration(
            hintText:
                widget.type == 'Split'
                    ? "e.g., Push, Pull, Legs"
                    : "e.g., Bench Press, Squats",
            hintStyle: TextStyle(
              color: Colors.grey.shade400,
              fontWeight: FontWeight.normal,
            ),
            filled: true,
            fillColor: surfaceColor,
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 20,
              vertical: 18,
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16),
              borderSide: BorderSide(color: Colors.grey.shade300, width: 1.5),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16),
              borderSide: BorderSide(color: Colors.grey.shade300, width: 1.5),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16),
              borderSide: BorderSide(color: primaryColor, width: 2),
            ),
          ),
          onSubmitted: (_) => submit(context),
        ),

        const Spacer(),

        // Submit Button
        SizedBox(
          height: 56,
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: primaryColor,
              foregroundColor: Colors.white,
              elevation: 0,
              shadowColor: primaryColor.withOpacity(0.3),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
            ),
            onPressed: () => submit(context),
            child: Text(
              "Add ${widget.type}",
              style: const TextStyle(
                fontSize: 17,
                fontWeight: FontWeight.w600,
                letterSpacing: 0.5,
              ),
            ),
          ),
        ),
        const SizedBox(height: 16),
      ],
    );
  }
}
