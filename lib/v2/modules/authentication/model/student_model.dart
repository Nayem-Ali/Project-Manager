import 'enums.dart';

class StudentModel {
  String? name;
  String? id;
  String? email;
  String? section;
  String? batch;
  Roles? role;

  StudentModel({
    this.name,
    this.id,
    this.email,
    this.section,
    this.batch,
    this.role,
  });

  factory StudentModel.fromJson(Map<String, dynamic> json) {
    return StudentModel(
      name: json['name'] ?? '',
      id: json['id'] ?? '',
      email: json['email'] ?? '',
      section: json['section'] ?? '',
      batch: json['batch'] ?? '',
      role: _roleFromString(json['role']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'id': id,
      'email': email,
      'section': section,
      'batch': batch,
      'role': role?.toString().split('.').last,
    };
  }

  static Roles? _roleFromString(String? role) {
    if (role == null) return null;
    switch (role.toLowerCase()) {
      case 'student':
        return Roles.student;
      case 'teacher':
        return Roles.teacher;
      case 'admin':
        return Roles.admin;
      default:
        return null;
    }
  }
}
