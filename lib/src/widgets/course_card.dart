import 'package:clean_one/src/widgets/exam_form.dart';
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
      padding: const EdgeInsets.all(10),
      margin: const EdgeInsets.symmetric(vertical: 3),
      decoration: BoxDecoration(
        color: currentTheme.secondaryHeaderColor,
        borderRadius: BorderRadius.circular(15),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
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
                const SizedBox(height: 6),

                // Course code
                Text(
                  'Course Code: $courseCode',
                  style: GoogleFonts.poppins(
                    fontSize: 15,
                    color: currentTheme.primaryColor,
                  ),
                ),
                const SizedBox(height: 16),

                // Start date and grade
                Row(
                  children: [
                    if (startDate.trim().isNotEmpty)
                      Text(
                        'start Date\n$startDate',
                        style: GoogleFonts.poppins(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: currentTheme.primaryColor,
                        ),
                      ),
                    const SizedBox(width: 30),
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
                          grade,
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

          // Conditional Content: Attendance or Online Course with Button
          isProject
              ? SizedBox.shrink() // Render nothing for projects
              : isType2
                  // For courses with Attendance
                  ? Column(
                      children: [
                        CircularPercentIndicator(
                          animation: true,
                          animationDuration: 3000,
                          radius: 30.0,
                          lineWidth: 5.0,
                          percent: (attendance ?? 0) / (totalLectures ?? 1),
                          header: const Text(
                            "Attendance",
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                              color: Colors.black,
                            ),
                          ),
                          center: Text(
                            '${attendance ?? 0}/${totalLectures ?? 0}',
                            style: GoogleFonts.poppins(
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                              color: currentTheme.primaryColor,
                            ),
                          ),
                          progressColor:
                              currentTheme.appBarTheme.backgroundColor,
                          backgroundColor: Colors.grey[300]!,
                        ),
                        const SizedBox(height: 8),
                        ElevatedButton(
                          onPressed: () {
                            // Navigate to BookingExamForm
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => BookingExamForm(
                                  courseTitle: title, // Pass course title
                                  courseCode: courseCode, // Pass course code
                                ),
                              ),
                            );
                          },
                          style: ElevatedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(horizontal: 20),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                            backgroundColor: currentTheme.primaryColor,
                          ),
                          child: const Text(
                            'Book Exam',
                            style: TextStyle(fontSize: 12, color: Colors.white),
                          ),
                        ),
                      ],
                    )
                  :
                  // For Online Courses
                  Column(
                      children: [
                        SizedBox(
                          height: 10,
                        ),
                        const Text(
                          ' Online\nCourse',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Colors.green,
                          ),
                        ),
                        const SizedBox(height: 20),
                        ElevatedButton(
                          onPressed: () {
                            // Navigate to BookingExamForm
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => BookingExamForm(
                                  courseTitle: title, // Pass course title
                                  courseCode: courseCode, // Pass course code
                                ),
                              ),
                            );
                          },
                          style: ElevatedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(horizontal: 20),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                            backgroundColor: currentTheme.primaryColor,
                          ),
                          child: const Text(
                            'Book Exam',
                            style: TextStyle(fontSize: 12, color: Colors.white),
                          ),
                        ),
                      ],
                    ),
        ],
      ),
    );
  }
}
