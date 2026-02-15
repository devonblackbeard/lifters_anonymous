import 'package:flutter/material.dart';

class RenameRoutineDialog extends StatelessWidget {
  final String initialName;
  final String elementToRename;
  final Color primaryColor;
  final void Function(String) onSave;

  const RenameRoutineDialog({
    super.key,
    required this.initialName,
    required this.primaryColor,
    required this.onSave,
    required this.elementToRename
  });

  @override
  Widget build(BuildContext context) {
    final TextEditingController controller = TextEditingController(text: initialName);

    return AlertDialog(
      title: Text('Rename $elementToRename'),
      content: TextField(
        controller: controller,
        autofocus: true,
        decoration: InputDecoration(
          //labelText: 'New $elementToRename Name',
          border: OutlineInputBorder(),
        ),
      ),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Cancel'),
        ),
        ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: primaryColor,
            foregroundColor: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
          ),
          onPressed: () {
            String newName = controller.text.trim();
            if (newName.isNotEmpty && newName != initialName) {
              onSave(newName);
              Navigator.pop(context);
            } else {
              Navigator.pop(context);
            }
          },
          child: const Text('Save'),
        ),
      ],
    );
  }
}
