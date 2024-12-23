class Course {
  final String id;
  final String studentNum;
  final Map<String, CourseDetail>
      courseDetails; // Maps gX (course code) to its details

  Course({
    required this.id,
    required this.studentNum,
    required this.courseDetails,
  });

  factory Course.fromJson(Map<String, dynamic> json) {
    final courseDetails = <String, CourseDetail>{};

    // Dynamically parse all course details
    for (int i = 1; i <= 12; i++) {
      final courseCode = json['g$i'] ?? ''; // Extract gX course code
      if (courseCode.isNotEmpty) {
        courseDetails[courseCode] = CourseDetail(
          code: courseCode,
          rawName: json['g${i}_name'] ?? '',
          grade: json['g${i}_grade'] ?? '',
          attendance: json['g${i}_att'] ?? '',
          totalLectures: json['g${i}_total_lec'] ?? '',
          date: json['g${i}_date'] ?? '',
        );
      }
    }

    return Course(
      id: json['id'].toString(),
      studentNum: json['student_num'] ?? '',
      courseDetails: courseDetails,
    );
  }
}

class CourseDetail {
  final String code; // Course code (e.g., g1, g2)
  final String rawName; // Original course name with potential prefix
  final String name; // Cleaned course name
  final String grade; // Course grade
  final String attendance; // Attendance count
  final String totalLectures; // Total number of lectures
  final String date; // Course date

  CourseDetail({
    required this.code,
    required this.rawName,
    required this.grade,
    required this.attendance,
    required this.totalLectures,
    required this.date,
  }) : name = rawName.contains('_')
            ? rawName.split('_').last
            : rawName; // Cleaned name
}
