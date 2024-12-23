import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:percent_indicator/percent_indicator.dart';

class CourseCard extends StatelessWidget {
  final String title; // Course name
  final String courseCode; // Course code
  final String startDate; // Course start date
  final String grade; // Course grade
  final int?
      attendance; // gX_att (attendance count, only for courses starting with 2)
  final int?
      totalLectures; // gX_total_lec (total lectures, only for courses starting with 2)
  final bool isType2; // Determines the type of course (2 or 5)
  final bool isProject; // Determines if it's a project (starts with 202)

  CourseCard({
    super.key,
    required this.title,
    required this.courseCode,
    required this.startDate,
    required this.grade,
    this.attendance,
    this.totalLectures,
    required this.isType2, // Determines layout type
    required this.isProject, // Determines layout type
  });

  @override
  Widget build(BuildContext context) {
    final currentTheme = Theme.of(context);

    return Container(
      padding: const EdgeInsets.all(16),
      margin: const EdgeInsets.symmetric(vertical: 8),
      decoration: BoxDecoration(
        color:
            currentTheme.secondaryHeaderColor, // Original card background color
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: [
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Course title
                Text(
                  title,
                  style: GoogleFonts.poppins(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: currentTheme.primaryColor,
                  ),
                ),
                const SizedBox(height: 4),

                // Course code
                Text(
                  'Course Code: $courseCode',
                  style: GoogleFonts.poppins(
                    fontSize: 15,
                    color: currentTheme.primaryColor,
                  ),
                ),
                const SizedBox(height: 23),

                // Start date and grade
                Row(
                  children: [
                    if (startDate.trim().isNotEmpty)
                      Text(
                        'start Date\n$startDate', // Start date
                        style: GoogleFonts.poppins(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: currentTheme.primaryColor,
                        ),
                      ),
                    const SizedBox(width: 36),
                    if (grade.trim().isNotEmpty)
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.grey[300],
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          grade, // Grade
                          style: GoogleFonts.poppins(
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                          ),
                        ),
                      ),
                  ],
                ),
              ],
            ),
          ),

          // Conditional Content
          isProject
              ? SizedBox.shrink() // Render nothing for projects
              : isType2
                  // For courses starting with 2: Attendance and progress circle
                  ? CircularPercentIndicator(
                      radius: 30.0,
                      lineWidth: 4.0,
                      percent: (attendance ?? 0) / (totalLectures ?? 1),
                      center: Text(
                        '${attendance ?? 0}/${totalLectures ?? 0}',
                        style: GoogleFonts.poppins(
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                          color: currentTheme.primaryColor,
                        ),
                      ),
                      progressColor: currentTheme.appBarTheme.backgroundColor,
                      backgroundColor: Colors.grey[300]!,
                      footer: const Text('Attendance'),
                    )
                  :
                  // For courses starting with 5: Online icon
                  const Text(
                      ' Online\nCourse',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.green,
                      ),
                    ),
        ],
      ),
    );
  }
}
