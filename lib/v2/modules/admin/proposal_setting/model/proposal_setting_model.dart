import 'package:cloud_firestore/cloud_firestore.dart';

class ProposalSettingModel {
  bool? allowEvaluation;
  DateTime? deadline;
  bool? allowPreference;

  ProposalSettingModel({
    this.allowEvaluation,
    this.deadline,
    this.allowPreference,
  });

  factory ProposalSettingModel.fromJson(Map<String, dynamic> json) {
    return ProposalSettingModel(
      allowEvaluation: json['allowEvaluation'] ?? false,
      deadline: (json['deadline'] as Timestamp).toDate(),
      allowPreference: json['isPreference'] ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'allowEvaluation': allowEvaluation,
      'deadline': deadline,
      'isPreference': allowPreference,
    };
  }
}