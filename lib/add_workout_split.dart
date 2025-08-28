import 'package:flutter/material.dart';

class AddWorkoutSplit extends StatelessWidget {
  AddWorkoutSplit({super.key});

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
    return Scaffold(
      appBar: AppBar(title: const Text("Add Workout Split")),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextField(
              controller: _controller,
              decoration: const InputDecoration(
                labelText: "Workout Name",
                border: OutlineInputBorder(),
              ),
              onSubmitted: (_) => _submit(context),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () => _submit(context),
              child: const Text("Add Split"),
            ),
          ],
        ),
      ),
    );
  }
}
