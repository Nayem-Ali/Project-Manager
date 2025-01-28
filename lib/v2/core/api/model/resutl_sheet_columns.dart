class ResultSheetColumns {
  static const String id = 'ID';
  static const String title = 'Title';
  static const String members = 'Team Members';
  static const String studentID = 'Student ID';
  static const String name = 'Name';
  static const String evaluatedBy = 'Evaluated By';
  static const String board = 'Defense Board Mark Average';
  static const String supervisor = 'Supervisor Mark';
  static const String total = 'Total';
  static const String grade = 'Grade';
  static const String point = 'Point';


  static List<String> getColumnsTitle() => [
    id,
    title,
    members,
    name,
    studentID,
    evaluatedBy,
    board,
    supervisor,
    total,
    grade,
    point,
  ];
}
