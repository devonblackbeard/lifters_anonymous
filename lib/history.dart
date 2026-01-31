import 'package:flutter/material.dart';

class History extends StatelessWidget {
  const History({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('History')),
      body: Center(
        child: ListView.builder(
          itemBuilder: (context, index) => historicalItemCard(index + 1),
          itemCount: 35,
        ),
      ),
    );
  }

  Widget historicalItemCard(int dateVariable) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      margin: const EdgeInsets.fromLTRB(20, 12, 20, 12),
      child: Padding(
        padding: const EdgeInsets.all(10),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    'Mon, January $dateVariable',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 8),
                  Text('Push workout', style: TextStyle(fontSize: 16)),
                  SizedBox(height: 4),
                  Text(
                    '14 hour fast',
                    style: TextStyle(fontSize: 16, color: Colors.grey[700]),
                  ),
                ],
              ),
            ),
            Icon(Icons.chevron_right, size: 32, color: Colors.grey[600]),
          ],
        ),
      ),
    );
  }
}
