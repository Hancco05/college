// models/student_model.dart
class StudentModel extends UserModel {
  final String studentId;
  final String grade;
  final String section;
  final List<String> enrolledCourses;
  final Map<String, double> grades;
  final List<String> parentContacts;

  StudentModel({
    required super.id,
    required super.email,
    required super.name,
    required this.studentId,
    required this.grade,
    required this.section,
    this.enrolledCourses = const [],
    this.grades = const {},
    this.parentContacts = const [],
    super.profileImage,
    super.createdAt,
  }) : super(
          role: 'student',
          additionalInfo: {
            'studentId': studentId,
            'grade': grade,
            'section': section,
            'enrolledCourses': enrolledCourses,
            'grades': grades,
            'parentContacts': parentContacts,
          },
        );

  factory StudentModel.fromUser(UserModel user) {
    return StudentModel(
      id: user.id,
      email: user.email,
      name: user.name,
      studentId: user.additionalInfo?['studentId'] ?? '',
      grade: user.additionalInfo?['grade'] ?? '',
      section: user.additionalInfo?['section'] ?? '',
      enrolledCourses: List<String>.from(user.additionalInfo?['enrolledCourses'] ?? []),
      grades: Map<String, double>.from(user.additionalInfo?['grades'] ?? {}),
      parentContacts: List<String>.from(user.additionalInfo?['parentContacts'] ?? []),
      profileImage: user.profileImage,
      createdAt: user.createdAt,
    );
  }
}