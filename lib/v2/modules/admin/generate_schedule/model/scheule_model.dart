class ScheduleModel {
  final int sl;
  final String date;
  final String timeSlot;
  final String supervisor;
  final String title;
  final List<StudentList> students;

  ScheduleModel({
    required this.sl,
    required this.date,
    required this.timeSlot,
    required this.supervisor,
    required this.title,
    required this.students,
  });

  factory ScheduleModel.fromJson(Map<String, dynamic> json) {
    return ScheduleModel(
      sl: json['sl'],
      date: json['date'],
      timeSlot: json['timeSlot'],
      supervisor: json['supervisor'],
      title: json['title'],
      students: (json['students'] as List)
          .map((student) => StudentList.fromJson(student))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'sl': sl,
      'date': date,
      'timeSlot': timeSlot,
      'supervisor': supervisor,
      'title': title,
      'students': students.map((student) => student.toJson()).toList(),
    };
  }
}

class StudentList {
  final String name;
  final String studentId;

  StudentList({
    required this.name,
    required this.studentId,
  });

  factory StudentList.fromJson(Map<String, dynamic> json) {
    return StudentList(
      name: json['name'],
      studentId: json['studentId'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'studentId': studentId,
    };
  }
}
