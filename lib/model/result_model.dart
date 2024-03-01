class ResultFields {
  static const String id = 'ID';
  static const String title = 'Title';
  static const String members = 'Team Members';
  static const String studentID = 'Student ID';
  static const String name = 'Name';
  static const String board = 'Defense Board Mark Average';
  static const String supervisor = 'Supervisor Mark';
  static const String total = 'Total';


  static List<String> getFields() => [
    id,
    title,
    members,
    name,
    studentID,
    board,
    supervisor,
    total
  ];
}
