import 'package:flutter/material.dart';

class AddWorkoutItem extends StatelessWidget {
  final String type;
  AddWorkoutItem({super.key, required this.type});

  final TextEditingController _controller = TextEditingController();

  void _submit(BuildContext context) {
    final text = _controller.text.trim();
    if (text.isNotEmpty) {
      Navigator.pop(context, text); // Return the text to the previous screen
    } else {
      // Optionally show a SnackBar if empty
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please enter a workout name")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    print('Type value: $type');

    return Scaffold(
      appBar: AppBar(title: Text("Add Workout $type")),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextField(
              controller: _controller,
              decoration: InputDecoration(
                labelText: "Workout $type name",
                border: OutlineInputBorder(),
              ),
              onSubmitted: (_) => _submit(context),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () => _submit(context),
              child: Text("Add $type"),
            ),
          ],
        ),
      ),
    );
  }
}
