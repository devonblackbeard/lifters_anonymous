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
      floatingActionButtonLocation: FloatingActionButtonLocation.endTop,
      floatingActionButton: Padding(
        padding: const EdgeInsets.only(top: 90.0),
        child: ElevatedButton.icon(
          icon: Icon(Icons.add),
          onPressed: () {
            Navigator.pushNamed(context, '/add_workout_split');
          },
          label: Text("Add"),
        ),
      ),
      backgroundColor: Colors.indigo,
      body: Center(
        child: Column(
          children: [
            SizedBox(height: 180),
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
            SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}
