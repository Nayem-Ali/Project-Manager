class Teacher {
  String name;
  String initial;
  String designation;
  String email;
  String role;
  String status;
  List<String>? cse3300;
  List<String>? cse4800;
  List<String>? cse4801;

  Teacher({
    required this.name,
    required this.initial,
    required this.designation,
    required this.email,
    required this.role,
    required this.status,
    this.cse3300,
    this.cse4800,
    this.cse4801,
  });

  factory Teacher.fromJson(Map<String, dynamic> json) {
    return Teacher(
      name: json['name'] ?? '',
      initial: json['initial'] ?? '',
      designation: json['designation'] ?? '',
      email: json['email'] ?? '',
      role: json['role'] ?? '',
      status: json['status'] ?? '',
      cse3300: json['cse3300'] != null ? List<String>.from(json['cse3300']) : null,
      cse4800: json['cse4800'] != null ? List<String>.from(json['cse4800']) : null,
      cse4801: json['cse4801'] != null ? List<String>.from(json['cse4801']) : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'initial': initial,
      'designation': designation,
      'email': email,
      'role': role,
      'status': status,
      'cse3300': cse3300,
      'cse4800': cse4800,
      'cse4801': cse4801,
    };
  }
}
