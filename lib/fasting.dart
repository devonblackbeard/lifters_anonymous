import 'package:flutter/material.dart';
import 'dart:async';

class Fasting extends StatefulWidget {
  const Fasting({super.key});

  @override
  State<Fasting> createState() => _FastingState();
}

class _FastingState extends State<Fasting> {
  bool isFasting = false;
  Duration fastingDuration = Duration();
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    // Do not start timer initially; only start when fasting starts
  }

  void _startTimer() {
    _timer?.cancel();
    _timer = Timer.periodic(Duration(seconds: 1), (timer) {
      setState(() {
        fastingDuration += Duration(seconds: 1);
      });
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  String get timerString {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    final hours = twoDigits(fastingDuration.inHours);
    final minutes = twoDigits(fastingDuration.inMinutes.remainder(60));
    final seconds = twoDigits(fastingDuration.inSeconds.remainder(60));
    return "$hours:$minutes:$seconds";
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text('Fasting For:', style: TextStyle(fontSize: 24)),
                SizedBox(height: 12),
                Text(
                  timerString,
                  style: TextStyle(fontSize: 48, fontWeight: FontWeight.bold),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: SizedBox(
              width: double.infinity,
              height: 56,
              child: ElevatedButton(
                onPressed: () {
                  setState(() {
                    if (isFasting) {
                      // End fast: stop timer and reset, and keep timer at zero
                      _timer?.cancel();
                      fastingDuration = Duration();
                    } else {
                      // Start fast: start timer
                      _startTimer();
                    }
                    isFasting = !isFasting;
                  });
                  print('Fast button pressed $isFasting');
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color.fromARGB(255, 146, 46, 141),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: Text(
                  '${isFasting ? "End" : "Start"} Fast',
                  style: TextStyle(fontSize: 24, color: Colors.white),
                ),
              ),
            ),
          ),
          const SizedBox(height: 80), // Add space below the button
        ],
      ),
    );
  }
}
