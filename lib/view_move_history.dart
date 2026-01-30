import 'package:flutter/material.dart';

class ViewMoveHistory extends StatelessWidget {
  final String moveName;
  const ViewMoveHistory({super.key, required this.moveName});


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(moveName)),
      body: Center(child: Text('Move History for $moveName')),
    );
  }
}
