class MarkingModel {
  String proposalTitle;
  int proposalId;
  String evaluatedBy;
  List<IndividualMark> marks;

  MarkingModel({
    required this.proposalTitle,
    required this.proposalId,
    required this.evaluatedBy,
    required this.marks,
  });

  // Factory method to create an instance from a JSON object
  factory MarkingModel.fromJson(Map<String, dynamic> json) {
    return MarkingModel(
      proposalTitle: json['proposalTitle'] as String,
      proposalId: json['proposalId'] as int,
      evaluatedBy: json['evaluatedBy'] as String,
      marks: (json['marks'] as List)
          .map((mark) => IndividualMark.fromJson(mark))
          .toList(),
    );
  }

  // Method to convert an instance to a JSON object
  Map<String, dynamic> toJson() {
    return {
      'proposalTitle': proposalTitle,
      'proposalId': proposalId,
      'evaluatedBy': evaluatedBy,
      'marks': marks.map((mark) => mark.toJson()).toList(),
    };
  }

}

class IndividualMark {
  String name;
  String studentID;
  double criteria1;
  double criteria2;
  double total;

  IndividualMark({
    required this.name,
    required this.studentID,
    required this.criteria1,
    required this.criteria2,
    required this.total,
  });

  // Factory method to create an instance from a JSON object
  factory IndividualMark.fromJson(Map<String, dynamic> json) {
    return IndividualMark(
      name: json['name'] as String,
      studentID: json['studentID'] as String,
      criteria1: (json['criteria1'] as num).toDouble(),
      criteria2: (json['criteria2'] as num).toDouble(),
      total: (json['total'] as num).toDouble(),
    );
  }

  // Method to convert an instance to a JSON object
  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'studentID': studentID,
      'criteria1': criteria1,
      'criteria2': criteria2,
      'total': total,
    };
  }

}
