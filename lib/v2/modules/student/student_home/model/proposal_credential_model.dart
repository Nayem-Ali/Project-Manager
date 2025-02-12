import 'package:cloud_firestore/cloud_firestore.dart';

class ProposalCredentialModel {
  final bool allowEvaluation;
  final DateTime deadline;
  final bool isPreference;

  ProposalCredentialModel({
    required this.allowEvaluation,
    required this.deadline,
    required this.isPreference,
  });

  factory ProposalCredentialModel.fromJson(Map<String, dynamic> json) {
    return ProposalCredentialModel(
      allowEvaluation: json['allowEvaluation'] as bool,
      deadline: (json['deadline'] as Timestamp).toDate(),
      isPreference: json['isPreference'] as bool,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'allowEvaluation': allowEvaluation,
      'deadline': deadline.toIso8601String(),
      'isPreference': isPreference,
    };
  }
}
