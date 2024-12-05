import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:simple_circular_progress_bar/simple_circular_progress_bar.dart';

class LearningPlanCard extends StatefulWidget {
  final String title;
  final int initialProgress; // Initial progress value
  final int maxo;

  const LearningPlanCard({
    super.key,
    required this.title,
    required this.initialProgress,
    required this.maxo,
  });

  @override
  _LearningPlanCardState createState() => _LearningPlanCardState();
}

class _LearningPlanCardState extends State<LearningPlanCard> {
  late ValueNotifier<double> progressNotifier;

  @override
  void initState() {
    super.initState();
    progressNotifier = ValueNotifier(widget.initialProgress.toDouble());
  }

  @override
  void dispose() {
    progressNotifier
        .dispose(); // Dispose of the notifier when the widget is destroyed
    super.dispose();
  }

  void updateProgress(double value) {
    if (value <= widget.maxo) {
      progressNotifier.value = value; // Update the progress value
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.grey[300],
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                widget.title,
                style: GoogleFonts.poppins(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
              const SizedBox(height: 8),
              ValueListenableBuilder<double>(
                valueListenable: progressNotifier,
                builder: (context, progress, _) {
                  return Text(
                    '${progress.toInt()} / ${widget.maxo}',
                    style: GoogleFonts.poppins(
                      fontSize: 14,
                      color: Colors.grey[600],
                    ),
                  );
                },
              ),
            ],
          ),
          SimpleCircularProgressBar(
            progressColors: const [
              Colors.cyan,
              Colors.green,
              Colors.amberAccent,
              Colors.redAccent,
            ],
            size: 60,
            fullProgressColor: Colors.green,
            mergeMode: true,
            maxValue: widget.maxo.toDouble(),
            valueNotifier: progressNotifier,
          ),
        ],
      ),
    );
  }
}
