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

  // Define consistent brand colors
  static const Color primaryColor = Color(0xFF922E8D);
  static const Color primaryLight = Color(0xFFB85FB3);
  static const Color surfaceColor = Color(0xFFF5F5F5);

  @override
  void initState() {
    super.initState();
    // Do not start timer initially; only start when fasting starts
  }

  void _startTimer() {
    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        fastingDuration += const Duration(seconds: 1);
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

  // Calculate progress based on common fasting goals
  double get fastingProgress {
    final hours = fastingDuration.inHours;
    if (hours >= 16) return 1.0;
    return hours / 16.0;
  }

  String get fastingGoalText {
    final hours = fastingDuration.inHours;
    if (hours < 12) return '12 hour goal';
    if (hours < 16) return '16 hour goal';
    if (hours < 24) return '24 hour goal';
    return 'Extended fast';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(24.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // Status indicator
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 20,
                        vertical: 10,
                      ),
                      decoration: BoxDecoration(
                        color:
                            isFasting
                                ? primaryColor.withOpacity(0.1)
                                : surfaceColor,
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(
                          color:
                              isFasting
                                  ? primaryColor.withOpacity(0.3)
                                  : Colors.grey.shade300,
                          width: 1.5,
                        ),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Container(
                            width: 8,
                            height: 8,
                            decoration: BoxDecoration(
                              color: isFasting ? primaryColor : Colors.grey,
                              shape: BoxShape.circle,
                            ),
                          ),
                          const SizedBox(width: 8),
                          Text(
                            isFasting ? 'Fasting Active' : 'Not Fasting',
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                              color:
                                  isFasting
                                      ? primaryColor
                                      : Colors.grey.shade700,
                              letterSpacing: 0.5,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 48),

                    // Timer display with gradient circle
                    Stack(
                      alignment: Alignment.center,
                      children: [
                        // Gradient background circle
                        Container(
                          width: 280,
                          height: 280,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            gradient:
                                isFasting
                                    ? LinearGradient(
                                      colors: [
                                        primaryColor.withOpacity(0.1),
                                        primaryLight.withOpacity(0.05),
                                      ],
                                      begin: Alignment.topLeft,
                                      end: Alignment.bottomRight,
                                    )
                                    : null,
                            color: isFasting ? null : surfaceColor,
                          ),
                        ),
                        // Progress ring
                        if (isFasting)
                          SizedBox(
                            width: 280,
                            height: 280,
                            child: CircularProgressIndicator(
                              value: fastingProgress,
                              strokeWidth: 8,
                              backgroundColor: Colors.transparent,
                              valueColor: AlwaysStoppedAnimation<Color>(
                                primaryColor.withOpacity(0.3),
                              ),
                            ),
                          ),
                        // Timer content
                        Column(
                          children: [
                            Text(
                              'Fasting For',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w500,
                                color: Colors.grey.shade600,
                                letterSpacing: 0.5,
                              ),
                            ),
                            const SizedBox(height: 16),
                            Text(
                              timerString,
                              style: TextStyle(
                                fontSize: 56,
                                fontWeight: FontWeight.bold,
                                color:
                                    isFasting
                                        ? primaryColor
                                        : Colors.grey.shade800,
                                height: 1.0,
                                letterSpacing: -1,
                              ),
                            ),
                            if (isFasting) ...[
                              const SizedBox(height: 16),
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 16,
                                  vertical: 8,
                                ),
                                decoration: BoxDecoration(
                                  color: primaryColor.withOpacity(0.1),
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: Text(
                                  fastingGoalText,
                                  style: TextStyle(
                                    fontSize: 13,
                                    fontWeight: FontWeight.w600,
                                    color: primaryColor,
                                    letterSpacing: 0.3,
                                  ),
                                ),
                              ),
                            ],
                          ],
                        ),
                      ],
                    ),

                    const SizedBox(height: 48),

                    // Info cards
                    if (isFasting)
                      Row(
                        children: [
                          Expanded(
                            child: _buildInfoCard(
                              icon: Icons.local_fire_department,
                              label: 'Calories',
                              value:
                                  '~${(fastingDuration.inHours * 70).toString()}',
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: _buildInfoCard(
                              icon: Icons.auto_awesome,
                              label: 'State',
                              value:
                                  fastingDuration.inHours < 12
                                      ? 'Early'
                                      : fastingDuration.inHours < 16
                                      ? 'Ketosis'
                                      : 'Peak',
                            ),
                          ),
                        ],
                      ),
                  ],
                ),
              ),
            ),

            // Bottom button
            Padding(
              padding: const EdgeInsets.all(24.0),
              child: SizedBox(
                width: double.infinity,
                height: 56,
                child: ElevatedButton(
                  onPressed: () {
                    setState(() {
                      if (isFasting) {
                        // End fast: stop timer and reset
                        _timer?.cancel();
                        fastingDuration = const Duration();
                      } else {
                        // Start fast: start timer
                        _startTimer();
                      }
                      isFasting = !isFasting;
                    });
                    print('Fast button pressed $isFasting');
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor:
                        isFasting ? Colors.red.shade400 : primaryColor,
                    foregroundColor: Colors.white,
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        isFasting
                            ? Icons.stop_circle_outlined
                            : Icons.play_circle_outlined,
                        size: 24,
                      ),
                      const SizedBox(width: 12),
                      Text(
                        '${isFasting ? "End" : "Start"} Fast',
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                          letterSpacing: 0.5,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoCard({
    required IconData icon,
    required String label,
    required String value,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: surfaceColor,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey.shade200, width: 1),
      ),
      child: Column(
        children: [
          Icon(icon, size: 24, color: primaryColor),
          const SizedBox(height: 8),
          Text(
            value,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w500,
              color: Colors.grey.shade600,
            ),
          ),
        ],
      ),
    );
  }
}
