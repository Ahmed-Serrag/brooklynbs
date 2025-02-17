class Course {
  final String id; // Course ID
  final String code; // Course code
  final String name; // Course name

  Course({
    required this.id,
    required this.code,
    required this.name,
  });

  factory Course.fromJson(Map<String, dynamic> json) {
    return Course(
      id: json['id'].toString(),
      code: json['code'].toString(),
      name: json['name'],
    );
  }
}

class Scholarship {
  final String id; // Scholarship ID
  final String name; // Scholarship name
  final List<Course> courses; // List of courses

  Scholarship({
    required this.id,
    required this.name,
    required this.courses,
  });

  factory Scholarship.fromJson(Map<String, dynamic> json) {
    final courses = (json['courses'] as List)
        .map((course) => Course.fromJson(course))
        .toList();

    return Scholarship(
      id: json['id'].toString(),
      name: json['name'],
      courses: courses,
    );
  }
}