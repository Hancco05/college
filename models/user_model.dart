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