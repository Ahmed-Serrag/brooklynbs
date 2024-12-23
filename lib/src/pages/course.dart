import 'package:clean_one/src/provider/user_provider.dart';
import 'package:clean_one/src/widgets/Course_Card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class CoursePage extends ConsumerWidget {
  const CoursePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Read courses from the provider
    final courses = ref.watch(courseProvider);
    
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        title: const Text(
          'Courses',
          style: TextStyle(color: Colors.white),
        ),
        centerTitle: true,
      ),
      body: Container(
        decoration: BoxDecoration(
          color: Theme.of(context).cardColor,
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(30), // Rounded top-left corner
            topRight: Radius.circular(30), // Rounded top-right corner
          ),
        ),
        padding: const EdgeInsets.all(16.0),
        child: courses.isEmpty
            ? const Center(child: Text("No courses available"))
            : ListView.builder(
                itemCount: courses.length,
                itemBuilder: (context, courseIndex) {
                  final course = courses[courseIndex];

                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: course.courseDetails.values.map((detail) {
                      final isType2 = detail.code.startsWith('2');

                      return CourseCard(
                        title: detail.name, // Course name
                        courseCode: detail.code, // Course code
                        startDate: detail.date, // Start date
                        grade: detail.grade, // Grade
                        attendance: isType2
                            ? int.tryParse(detail.attendance) ?? 0
                            : null, // Attendance only for Type 2
                        totalLectures: isType2
                            ? int.tryParse(detail.totalLectures) ?? 1
                            : null, // Total lectures only for Type 2
                        isType2: isType2, // Determines layout type
                      );
                    }).toList(),
                  );
                },
              ),
      ),
    );
  }
}
