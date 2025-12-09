// models/user_model.dart
class UserModel {
  final String id;
  final String email;
  final String name;
  final String role; // 'student', 'teacher', 'admin'
  final String? profileImage;
  final DateTime? createdAt;
  final Map<String, dynamic>? additionalInfo;

  UserModel({
    required this.id,
    required this.email,
    required this.name,
    required this.role,
    this.profileImage,
    this.createdAt,
    this.additionalInfo,
  });

  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
      id: map['id'] ?? '',
      email: map['email'] ?? '',
      name: map['name'] ?? '',
      role: map['role'] ?? 'student',
      profileImage: map['profileImage'],
      createdAt: map['createdAt'] != null 
          ? DateTime.parse(map['createdAt'])
          : DateTime.now(),
      additionalInfo: map['additionalInfo'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'email': email,
      'name': name,
      'role': role,
      'profileImage': profileImage,
      'createdAt': createdAt?.toIso8601String(),
      'additionalInfo': additionalInfo,
    };
  }
}

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

class Assignment {
  final String id;
  final String title;
  final String description;
  final DateTime dueDate;
  final double maxScore;
  final Map<String, double> studentScores;

  Assignment({
    required this.id,
    required this.title,
    required this.description,
    required this.dueDate,
    required this.maxScore,
    this.studentScores = const {},
  });

  factory Assignment.fromMap(Map<String, dynamic> map) {
    return Assignment(
      id: map['id'] ?? '',
      title: map['title'] ?? '',
      description: map['description'] ?? '',
      dueDate: DateTime.parse(map['dueDate']),
      maxScore: (map['maxScore'] ?? 0).toDouble(),
      studentScores: Map<String, double>.from(map['studentScores'] ?? {}),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'dueDate': dueDate.toIso8601String(),
      'maxScore': maxScore,
      'studentScores': studentScores,
    };
  }
}