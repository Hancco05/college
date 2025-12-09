// models/teacher_model.dart
class TeacherModel extends UserModel {
  final String teacherId;
  final List<String> subjects;
  final List<String> assignedGrades;
  final List<String> assignedSections;
  final Map<String, String> schedule;

  TeacherModel({
    required super.id,
    required super.email,
    required super.name,
    required this.teacherId,
    this.subjects = const [],
    this.assignedGrades = const [],
    this.assignedSections = const [],
    this.schedule = const {},
    super.profileImage,
    super.createdAt,
  }) : super(
          role: 'teacher',
          additionalInfo: {
            'teacherId': teacherId,
            'subjects': subjects,
            'assignedGrades': assignedGrades,
            'assignedSections': assignedSections,
            'schedule': schedule,
          },
        );

  factory TeacherModel.fromUser(UserModel user) {
    return TeacherModel(
      id: user.id,
      email: user.email,
      name: user.name,
      teacherId: user.additionalInfo?['teacherId'] ?? '',
      subjects: List<String>.from(user.additionalInfo?['subjects'] ?? []),
      assignedGrades: List<String>.from(user.additionalInfo?['assignedGrades'] ?? []),
      assignedSections: List<String>.from(user.additionalInfo?['assignedSections'] ?? []),
      schedule: Map<String, String>.from(user.additionalInfo?['schedule'] ?? {}),
      profileImage: user.profileImage,
      createdAt: user.createdAt,
    );
  }
}