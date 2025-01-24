import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:gsheets/gsheets.dart';
import 'package:teamlead/constants/proposal_credentials.dart';

import '../model/proposal_model.dart';

class ProjectSheetApi {


  static final sheets = GSheets(ProposalCredentials.credentials);
  static Worksheet? cse3300;
  static Worksheet? cse4800;
  static Worksheet? cse4801;

  static Worksheet? teamRequest3300;
  static Worksheet? teamRequest4800;

  static Worksheet? teamDistribution;

  static Future initialize() async {
    try {
      final spreadSheet = await sheets.spreadsheet(ProposalCredentials.spreadsheetId);

      cse3300 = await getWorkSheet(spreadSheet, title: "CSE-3300");
      cse4800 = await getWorkSheet(spreadSheet, title: "CSE-4800");
      cse4801 = await getWorkSheet(spreadSheet, title: "CSE-4801");
      teamRequest3300 = await getWorkSheet(spreadSheet, title: "CSE-3300-team-request");
      teamRequest4800 = await getWorkSheet(spreadSheet, title: "CSE-4800-team-request");
      teamDistribution = await getWorkSheet(spreadSheet, title: "Team-Distribution");

      final firstRow = ProposalFields.getFields();

      cse3300!.values.insertRow(1, firstRow);
      cse4800!.values.insertRow(1, firstRow);
      cse4801!.values.insertRow(1, firstRow);
      teamRequest3300!.values.insertRow(1, firstRow);
      teamRequest4800!.values.insertRow(1, firstRow);
      teamDistribution!.values.insertRow(1, [
        'INITIAL',
        "CSE-3300",
        "CSE-4800",
        "CSE-4801",
        "Total",
      ]);
    } catch (e) {
      Get.showSnackbar(GetSnackBar(
        title: "Something Went Wrong",
        messageText: Text(e.toString()),
      ));
    }
  }

  static Future<Worksheet> getWorkSheet(Spreadsheet spreadsheet, {required String title}) async {
    try {
      return await spreadsheet.addWorksheet(title);
    } catch (e) {
      return spreadsheet.worksheetByTitle(title)!;
    }
  }

  static addProposal(Map<String, dynamic> proposalData, String type) async {
    // DataBaseMethods dataBaseMethods = DataBaseMethods();
    int proposalID = 0;
    if (cse3300 == null || cse4800 == null) return null;
    if (type == 'CSE-3300') {
      final lastRow = await cse3300!.values.lastRow();
      proposalID = (int.tryParse(lastRow!.first) ?? 0) + 1;
      proposalData['ID'] = proposalID.toString();
      cse3300!.values.map.appendRow(proposalData);
    } else {
      final lastRow = await cse4800!.values.lastRow();
      proposalID = (int.tryParse(lastRow!.first) ?? 0) + 1;
      proposalData['ID'] = proposalID.toString();
      cse4800!.values.map.appendRow(proposalData);
    }
    return proposalID;
    // dataBaseMethods.updateDataAfterProposalSubmission(proposalData['ID'], type);
  }

  static addTeamRequest(Map<String, dynamic> proposalData, String type) async {
    int proposalID = 0;
    if (teamRequest3300 == null || teamRequest4800 == null) return null;
    if (type == 'CSE-3300-team-request') {
      final lastRow = await teamRequest3300!.values.lastRow();
      proposalID = (int.tryParse(lastRow!.first) ?? 0) + 1;
      proposalData['ID'] = proposalID.toString();
      teamRequest3300!.values.map.appendRow(proposalData);
    } else {
      final lastRow = await teamRequest4800!.values.lastRow();
      proposalID = (int.tryParse(lastRow!.first) ?? 0) + 1;
      proposalData['ID'] = proposalID.toString();
      teamRequest4800!.values.map.appendRow(proposalData);
    }
    return proposalID;
  }

  static getAllRows(String type) async {
    List<Map<String, String>>? allData = [];
    if (type == 'CSE-3300') {
      allData = await cse3300!.values.map.allRows();
    } else if (type == 'CSE-4800') {
      allData = await cse4800!.values.map.allRows();
    } else {
      allData = await cse4801!.values.map.allRows();
    }
    return allData;
  }

  static getMyTeams(String initial, String type) async {
    dynamic allData = [];
    dynamic myTeams = [];
    if (type == 'CSE-3300') {
      allData = await cse3300!.values.map.allRows();
    } else if (type == 'CSE-4800') {
      allData = await cse4800!.values.map.allRows();
    } else {
      allData = await cse4801!.values.map.allRows();
    }
    // print(allData);
    if (allData != null) {
      for (var data in allData) {
        if (data['Supervisor'] == initial) {
          myTeams.add(data);
        }
      }
    }
    // print(myTeams);
    return myTeams;
  }

  static giveAccess() async {
    FirebaseAuth auth = FirebaseAuth.instance;
    final spreadSheet = await sheets.spreadsheet(ProposalCredentials.spreadsheetId);
    await spreadSheet.share(
      "${auth.currentUser!.email}",
      role: PermRole.writer,
      type: PermType.user,
      // withLink: true
    );
    final url = spreadSheet.url;
    return url;
  }

  static shift4800() async {
    dynamic allData = [];
    allData = await cse4800!.values.map.allRows();
    await cse4801!.deleteRow(2, count: cse4801!.rowCount);

    // print(allData);
    await cse4801!.values.map.appendRows(allData);
  }

  static clearProposalData(String type) async {
    if (type == 'CSE-4800') {
      if(cse4800!.rowCount > 1) {
        await cse4800!.deleteRow(2, count: cse4800!.rowCount);
      }
    } else if (type == 'CSE-3300') {
      if(cse3300!.rowCount > 1) {
        await cse3300!.deleteRow(2, count: cse3300!.rowCount);
      }
    } else if (type == 'CSE-3300-team-request') {
      if(teamRequest3300!.rowCount > 1) {
        await teamRequest3300!.deleteRow(2, count: teamRequest3300!.rowCount);
      }
    } else {
      if(teamRequest4800!.rowCount > 1) {
        await teamRequest4800!.deleteRow(2, count: teamRequest4800!.rowCount);
      }
    }
  }

  static addStatistics(Map<String, dynamic> data) async {
    await teamDistribution!.values.map.appendRow(data);
  }

  static clearStatistics() async {
    await teamDistribution!.deleteRow(2, count: teamDistribution!.rowCount);
  }

  static getColumn(String type, String columnName) async {
    List<String>? column = [];
    if (type == 'CSE-3300') {
      column = await cse3300!.values.columnByKey(columnName);
    } else if (type == 'CSE-4800') {
      column = await cse4800!.values.columnByKey(columnName);
    } else if (type == 'CSE-3300-team-request') {
      column = await teamRequest3300!.values.columnByKey(columnName);
    }else if (type == 'CSE-4800-team-request') {
      column = await teamRequest4800!.values.columnByKey(columnName);
    }else {
      column = await cse4801!.values.columnByKey(columnName);
    }
    return column;
  }

  static getRow(String type, int index)async{
    List<String>? row = [];
    if (type == 'CSE-3300') {
      row = await cse3300!.values.row(index);
    } else if (type == 'CSE-4800') {
      row = await cse4800!.values.row(index);
    } else if (type == 'CSE-3300-team-request') {
      row = await teamRequest3300!.values.row(index);
    }else if (type == 'CSE-4800-team-request') {
      row = await teamRequest4800!.values.row(index);
    }else {
      row = await cse4801!.values.row(index);
    }
    return row;
  }
}
