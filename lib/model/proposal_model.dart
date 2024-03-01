class ProposalFields {
  static const String id = 'ID';
  static const String title = 'Title';
  static const String members = 'Team Members';
  static const String studentID = 'Student ID';
  static const String name = 'Name';
  static const String email = 'Email';
  static const String phone = 'Phone';
  static const String cgpa = 'CGPA';
  static const String link = 'Proposal Drive Link';
  static const String supervisor = 'Supervisor';
  static const String preference = 'Preferred Supervisor';

  static List<String> getFields() => [
        id,
        title,
        members,
        name,
        studentID,
        email,
        phone,
        cgpa,
        link,
        supervisor,
        preference,
      ];
}
