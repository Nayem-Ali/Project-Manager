class Student {
  String name;
  String studentId;
  String section;
  String batch;
  String role;

  Student({
    required this.name,
    required this.studentId,
    required this.section,
    required this.batch,
    required this.role,
  });

  factory Student.fromJson(Map<String, dynamic> json) {
    return Student(
      name: json['name'] ?? '',
      studentId: json['studentId'] ?? '',
      section: json['section'] ?? '',
      batch: json['batch'] ?? '',
      role: json['role'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'studentId': studentId,
      'section': section,
      'batch': batch,
      'role': role,
    };
  }
}
