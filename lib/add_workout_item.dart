import 'package:flutter/material.dart';
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
  DateTime? selectedDate;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void submit(BuildContext context) {
    if (widget.type == 'Session') {
      // For workout events, return the selected workout ID and date
      if (selectedWorkoutId != null && selectedDate != null) {
        Navigator.pop(context, {
          'workoutId': selectedWorkoutId,
          'date': selectedDate,
        });
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Please select a workout and date")),
        );
      }
    } else {
      // For split/move, return the text
      final text = _controller.text.trim();
      if (text.isNotEmpty) {
        Navigator.pop(context, text);
      } else {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(const SnackBar(content: Text("Please enter a name")));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Add ${widget.type}")),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: buildForm(context),
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
    var selectedDate = DateTime.now();

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

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        DropdownButtonFormField<String>(
          initialValue: selectedWorkoutId,
          decoration: const InputDecoration(
            labelText: 'Select Workout',
            border: OutlineInputBorder(
              borderRadius: BorderRadius.all(Radius.circular(18)),
            ),
          ),
          items:
              workouts.map((workout) {
                return DropdownMenuItem(
                  value: workout.id,
                  child: Text(workout.name),
                );
              }).toList(),
          onChanged: (String? newValue) {
            setState(() {
              selectedWorkoutId = newValue;
            });
          },
        ),
        const SizedBox(height: 16),
        OutlinedButton.icon(
          style: OutlinedButton.styleFrom(
            foregroundColor: Colors.black,
            side: const BorderSide(
              color: Color.fromARGB(255, 146, 46, 141),
            ),
          ),
          onPressed: () async {
            final date = await showDatePicker(
              context: context,
              initialDate: selectedDate,
              firstDate: DateTime(2020),
              lastDate: DateTime(2030),
            );
            if (date != null) {
              setState(() {
                selectedDate = date;
              });
            }
          },
          icon: const Icon(Icons.calendar_today),
          label: Text(formatDate(selectedDate)),
        ),
        const SizedBox(height: 76),
        ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color.fromARGB(255, 146, 46, 141),
            foregroundColor: Colors.white,
          ),
          onPressed: () => submit(context),
          child: const Text("Start Workout!"),
        ),
      ],
    );
  }

  Widget _buildSplitForm(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        TextField(
          controller: _controller,
          decoration: InputDecoration(
            labelText: "${widget.type} name",
            hintText:
                widget.type == 'Split'
                    ? "e.g., Push, Pull, Legs"
                    : "e.g., Bench Press, Squats",
            border: const OutlineInputBorder(
              borderRadius: BorderRadius.all(Radius.circular(18)),
            ),
          ),
          onSubmitted: (_) => submit(context),
        ),
        const SizedBox(height: 16),
        ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color.fromARGB(255, 146, 46, 141),
          ),
          onPressed: () => submit(context),
          child: Text("Add ${widget.type}"),
        ),
      ],
    );
  }
}
