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
    if (widget.type == 'workoutEvent') {
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
      case 'split':
      case 'move':
        return _buildSplitForm(context);
      case 'workoutEvent':
        return _buildWorkoutEventForm(context);
      default:
        return Center(child: Text('Unknown type: ${widget.type}'));
    }
  }

  Widget _buildWorkoutEventForm(BuildContext context) {
    final workouts = Database.workoutBox.values.toList();

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        DropdownButtonFormField<String>(
          value: selectedWorkoutId,
          decoration: const InputDecoration(
            labelText: 'Select Workout',
            border: OutlineInputBorder(),
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
          onPressed: () async {
            final date = await showDatePicker(
              context: context,
              initialDate: DateTime.now(),
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
          label: Text(
            selectedDate == null
                ? 'Select Date'
                : '${selectedDate!.month}/${selectedDate!.day}/${selectedDate!.year}',
          ),
        ),
        const SizedBox(height: 16),
        ElevatedButton(
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
                widget.type == 'split'
                    ? "e.g., Push, Pull, Legs"
                    : "e.g., Bench Press, Squats",
            border: const OutlineInputBorder(),
          ),
          onSubmitted: (_) => submit(context),
        ),
        const SizedBox(height: 16),
        ElevatedButton(
          onPressed: () => submit(context),
          child: Text("Add ${widget.type}"),
        ),
      ],
    );
  }
}
