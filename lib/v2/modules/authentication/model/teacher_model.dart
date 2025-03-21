import 'enums.dart';

class TeacherModel {
  String? name;
  String? initial;
  String? designation;
  String? email;
  Roles? role;
  RequestStatus? status;
  List<String>? cse3300;
  List<String>? cse4800;
  List<String>? cse4801;

  TeacherModel({
    this.name,
    this.initial,
    this.designation,
    this.email,
    this.role,
    this.status,
    this.cse3300,
    this.cse4800,
    this.cse4801,
  });

  factory TeacherModel.fromJson(Map<String, dynamic> json) {
    return TeacherModel(
      name: json['name'] ?? '',
      initial: json['initial'] ?? '',
      designation: json['designation'] ?? '',
      email: json['email'] ?? '',
      role: _roleFromString(json['role']),
      status: _statusFromString(json['status']),
      cse3300: json['cse3300'] != null ? List<String>.from(json['cse3300']) : null,
      cse4800: json['cse4800'] != null ? List<String>.from(json['cse4800']) : null,
      cse4801: json['cse4801'] != null ? List<String>.from(json['cse4801']) : null,
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
      case 'accepted':
        return RequestStatus.accepted;
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
      'cse3300': cse3300,
      'cse4800': cse4800,
      'cse4801': cse4801,
    };
  }
}
