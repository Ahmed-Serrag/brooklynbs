import 'package:brooklynbs/src/provider/user_provider.dart';
import 'package:brooklynbs/src/widgets/Course_Card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class CoursePage extends ConsumerStatefulWidget {
  const CoursePage({super.key});

  @override
  ConsumerState<CoursePage> createState() => _CoursePageState();
}

class _CoursePageState extends ConsumerState<CoursePage> {
  @override
  void initState() {
    super.initState();

    // Trigger data fetching when the page is loaded
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(courseProvider2.notifier).fetchCourses(context);
    });
  }

  @override
  Widget build(BuildContext context) {
    // Watch the course provider for changes
    final coursesAsync = ref.watch(courseProvider2);

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
        child: coursesAsync.when(
          loading: () => const Center(child:Text('')),
          error: (error, stackTrace) => Center(child: Text('Error: $error')),
          data: (courses) {
            if (courses.isEmpty) {
              return const Center(child: Text("No courses available"));
            }

            return ListView.builder(
              itemCount: courses.length,
              itemBuilder: (context, courseIndex) {
                final course = courses[courseIndex];

                return CourseCard(
                  title: course.name, // Course name
                  courseCode: course.code, // Course code
                  startDate: '12/5/222', // Start date (if available)
                  grade: 'grade', // Grade (if available)
                  attendance: 7, // Attendance (if available)
                  totalLectures: 12, // Total lectures (if available)
                  isProject: false, // Determine if it's a project
                  isType2: false, // Determine layout type
                );
              },
            );
          },
        ),
      ),
    );
  }
}
