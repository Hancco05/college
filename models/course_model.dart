// models/course_model.dart
class CourseModel {
  final String id;
  final String name;
  final String description;
  final String teacherId;
  final String grade;
  final String section;
  final List<String> students;
  final Map<String, dynamic> schedule;
  final List<Assignment> assignments;

  CourseModel({
    required this.id,
    required this.name,
    required this.description,
    required this.teacherId,
    required this.grade,
    required this.section,
    this.students = const [],
    this.schedule = const {},
    this.assignments = const [],
  });

  factory CourseModel.fromMap(Map<String, dynamic> map) {
    return CourseModel(
      id: map['id'] ?? '',
      name: map['name'] ?? '',
      description: map['description'] ?? '',
      teacherId: map['teacherId'] ?? '',
      grade: map['grade'] ?? '',
      section: map['section'] ?? '',
      students: List<String>.from(map['students'] ?? []),
      schedule: Map<String, dynamic>.from(map['schedule'] ?? {}),
      assignments: List<Assignment>.from(
        (map['assignments'] ?? []).map((x) => Assignment.fromMap(x)),
      ),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'teacherId': teacherId,
      'grade': grade,
      'section': section,
      'students': students,
      'schedule': schedule,
      'assignments': assignments.map((x) => x.toMap()).toList(),
    };
  }
}