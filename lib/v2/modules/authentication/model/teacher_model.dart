import 'enums.dart';

class TeacherModel {
  String? name;
  String? initial;
  String? designation;
  String? email;
  Roles? role;
  RequestStatus? status;

  TeacherModel({
    this.name,
    this.initial,
    this.designation,
    this.email,
    this.role,
    this.status,
  });

  factory TeacherModel.fromJson(Map<String, dynamic> json) {
    return TeacherModel(
      name: json['name'] ?? '',
      initial: json['initial'] ?? '',
      designation: json['designation'] ?? '',
      email: json['email'] ?? '',
      role: _roleFromString(json['role']),
      status: _statusFromString(json['status']),
    );
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

  static RequestStatus? _statusFromString(String? status) {
    if (status == null) return null;
    switch (status.toLowerCase()) {
      case 'pending':
        return RequestStatus.pending;
      case 'approved':
        return RequestStatus.approved;
      case 'rejected':
        return RequestStatus.rejected;
      default:
        return null;
    }
  }

  // To JSON from TeacherModel
  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'initial': initial,
      'designation': designation,
      'email': email,
      'role': role?.toString().split('.').last,
      'status': status?.toString().split('.').last,
    };
  }
}
