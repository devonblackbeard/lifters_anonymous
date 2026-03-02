import 'package:flutter/material.dart';
//import 'package:lifters_anonymous/models/workout.dart';
import 'package:lifters_anonymous/models/workout_dtos.dart';

class MoveDetails extends StatefulWidget {
  const MoveDetails({super.key});

  @override
  State<MoveDetails> createState() => _MoveDetailsState();
}

class _MoveDetailsState extends State<MoveDetails> {
  @override
  Widget build(BuildContext context) {
    final moveDetails = ModalRoute.of(context)!.settings.arguments as MoveRecordDTO;

    return Text('Move ID: ${moveDetails.moveId}, Session ID: ${moveDetails.sessionId}');
  }
}