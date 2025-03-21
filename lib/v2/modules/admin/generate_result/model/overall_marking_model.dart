class OverAllMarkingModel {
  final int id;
  final int totalMembers;
  final String title;
  final String evaluatedBy;
  final List<IndividualGrade> grades;

  OverAllMarkingModel({
    required this.id,
    required this.title,
    required this.totalMembers,
    required this.evaluatedBy,
    required this.grades,
  });

  factory OverAllMarkingModel.fromJson(Map<String, dynamic> json) {
    return OverAllMarkingModel(
      id: json['id'] as int,
      title: json['title'] as String,
      totalMembers: json['totalMembers'] as int,
      evaluatedBy: json['evaluatedBy'] as String,
      grades: (json['grades'] as List<dynamic>)
          .map((grade) => IndividualGrade.fromJson(grade))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'totalMembers': totalMembers,
      'evaluatedBy': evaluatedBy,
      'grades': grades.map((grade) => grade.toJson()).toList(),
    };
  }
}

class IndividualGrade {
  final String name;
  final String studentId;
  final String boardMark;
  final String supervisorMark;
  final String total;
  final String grade;
  final String point;

  IndividualGrade({
    required this.name,
    required this.studentId,
    required this.boardMark,
    required this.supervisorMark,
    required this.total,
    required this.grade,
    required this.point,
  });

  factory IndividualGrade.fromJson(Map<String, dynamic> json) {
    return IndividualGrade(
      name: json['name'] as String,
      studentId: json['studentId'] as String,
      boardMark: json['boardMark'],
      supervisorMark: json['supervisorMark'],
      total: json['total'],
      grade: json['grade'] as String,
      point: json['point'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'studentId': studentId,
      'boardMark': boardMark,
      'supervisorMark': supervisorMark,
      'total': total,
      'grade': grade,
      'point': point,
    };
  }
}
