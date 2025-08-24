import 'package:flutter/material.dart';

class ViewWorkoutSplit extends StatelessWidget {
  ViewWorkoutSplit({super.key});

  List<String> splitTypes = ["Push", "Pull", "Legs"];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Select Routine", style: TextStyle(color: Colors.white)),
        iconTheme: IconThemeData(
          color: Colors.white, // back button color
        ),
        centerTitle: true,
        backgroundColor: Colors.indigo,
      ),
      backgroundColor: Colors.indigo,
      body: Center(
        child: Column(
          children: [
            SizedBox(height: 50),
            SizedBox(height: 80),
            ...List.generate(3, (idx) {
              return Stack(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: SizedBox(
                      width: 190,
                      height: 60,
                      child: ElevatedButton(
                        onPressed: () {},
                        style: ElevatedButton.styleFrom(
                          foregroundColor: Colors.white,
                          backgroundColor: const Color.fromARGB(
                            255,
                            146,
                            46,
                            141,
                          ),
                        ),
                        child: Text(splitTypes[idx]),
                      ),
                    ),
                  ),
                ],
              );
            }),
          ],
        ),
      ),
    );
  }
}
