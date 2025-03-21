import 'package:teamlead/v2/core/api/model/proposal_sheet_columns.dart';
import 'package:teamlead/v2/core/utils/logger/logger.dart';

class ProposalModel {
  int? id;
  String? title;
  String? proposal;
  String? preference;
  List<Member>? members;
  int? totalMembers;
  String? supervisor;

  ProposalModel({
    this.id,
    this.title,
    this.proposal,
    this.preference,
    this.members,
    this.totalMembers,
    this.supervisor,
  });

  factory ProposalModel.fromJson(Map<String, dynamic> json) {
    return ProposalModel(
      id: json['id'] ?? '',
      title: json['title'] ?? '',
      proposal: json['proposal'] ?? '',
      preference:
          json['preference'] ?? '',
      members: json['members'] != null
          ? (json['members'] as List<dynamic>)
              .map((member) => Member.fromJson(member as Map<String, dynamic>))
              .toList()
          : [],
      totalMembers: json['totalMembers'] ?? 0,
      supervisor: json['supervisor'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id ?? 0,
      'title': title ?? '',
      'proposal': proposal ?? '',
      'preference': preference ?? [],
      'members': members?.map((member) => member.toJson()).toList() ?? [],
      'totalMembers': totalMembers ?? 0,
      'supervisor': supervisor ?? "",
    };
  }

  Map<String, dynamic> toColumnData() {
    return {
      ProposalSheetColumns.id: id.toString(),
      ProposalSheetColumns.title: title ?? '',
      ProposalSheetColumns.members: totalMembers.toString(),
      ProposalSheetColumns.name:
          members?.map((member) => "${member.name}\n").toList().join() ?? '',
      ProposalSheetColumns.studentID:
          members?.map((member) => "${member.studentId}\n").toList().join() ?? '',
      ProposalSheetColumns.email:
          members?.map((member) => "${member.email}\n").toList().join() ?? '',
      ProposalSheetColumns.phone:
          members?.map((member) => "${member.mobile}\n").toList().join() ?? '',
      ProposalSheetColumns.cgpa:
          members?.map((member) => "${member.cgpa}\n").toList().join() ?? '',
      ProposalSheetColumns.link: proposal ?? '',
      ProposalSheetColumns.supervisor: supervisor ?? '',
      ProposalSheetColumns.preference: preference ?? "",
    };
  }

  factory ProposalModel.fromColumn(Map<String, String> rowData) {
    return ProposalModel(
        id: int.tryParse(rowData[ProposalSheetColumns.id] ?? "0") ?? 0,
        title: rowData[ProposalSheetColumns.title] ?? "No title found",
        supervisor: rowData[ProposalSheetColumns.supervisor] ?? "Not Assigned",
        proposal: rowData[ProposalSheetColumns.link] ?? "No Document Link Found",
        preference: rowData[ProposalSheetColumns.preference] ?? "No Preference",
        totalMembers: int.tryParse(rowData[ProposalSheetColumns.members] ?? "0") ?? 0,
        members: memberExtractionLogic(
          name: rowData[ProposalSheetColumns.name] ?? '',
          studentId: rowData[ProposalSheetColumns.studentID] ?? '',
          cgpa: rowData[ProposalSheetColumns.cgpa] ?? '',
          email: rowData[ProposalSheetColumns.email] ?? '',
          phone: rowData[ProposalSheetColumns.phone] ?? '',
        ));
  }

  static List<Member> memberExtractionLogic({
    required String name,
    required String studentId,
    required String cgpa,
    required String email,
    required String phone,
  }) {
    List<String> names = name.split('\n');
    List<String> ids = studentId.split('\n');
    List<String> cg = cgpa.split('\n');
    List<String> emails = email.split('\n');
    List<String> numbers = phone.split('\n');
    List<Member> members = [];

    for (int i = 0; i < names.length; i++) {
      Member member = Member(
        name: names[i],
        studentId: ids[i],
        cgpa: cg.length == names.length ? double.tryParse(cg[i].trim()) : 0.0,
        email: emails.length == names.length ? emails[i] : "",
        mobile: numbers.length == names.length ? numbers[i] : "",
      );
      members.add(member);
    }
    return members;
  }
}

class Member {
  String? name;
  String? studentId;
  double? cgpa;
  String? email;
  String? mobile;

  Member({
    this.name,
    this.studentId,
    this.cgpa,
    this.email,
    this.mobile,
  });

  factory Member.fromJson(Map<String, dynamic> json) {
    return Member(
      name: json['name'] ?? '',
      studentId: json['studentId'] ?? '',
      cgpa: json['cgpa'] != null ? (json['cgpa'] as num).toDouble() : 0.0,
      email: json['email'] ?? '',
      mobile: json['mobile'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name ?? '',
      'studentId': studentId ?? '',
      'cgpa': cgpa ?? 0.0,
      'email': email ?? '',
      'mobile': mobile ?? '',
    };
  }
}
