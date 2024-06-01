import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:gsheets/gsheets.dart';

import '../model/proposal_model.dart';

class ProjectSheetApi {
  static const spreadsheetId = '1DHJxCxB4AGp6OgQ-NwtPQczXM8Xp93B3zDGocQWq19o';
  static const credentials = r'''
  {
  "type": "service_account",
  "project_id": "project-409112",
  "private_key_id": "a30f745ea44ccd7242e576b145183aa4450ebfad",
  "private_key": "-----BEGIN PRIVATE KEY-----\nMIIEvgIBADANBgkqhkiG9w0BAQEFAASCBKgwggSkAgEAAoIBAQCXeMNa91EpVgdE\nsbbQcp/X+GzCLC177Px6DobmLmh6p9PPdxv+jhsEvfrf+IP6NrBVL5Bi7NziI4LB\n8KJsr9XrIjhkbVwqLCtSKruCsCNumIMjGJakohh0dvkaKKcfUg1LUwoIwBEKgvw8\n3cVqNvOebG+7yLVcTgDRUIaXOIJk64Ue3aCn3rSjr2GOLyfAgASJswGEejG7qP5i\n0hc0OEKSfsFD+kSGNyjpa0s51UHJNyIWt1bdlookCsswjewmz5ZCihQtSIlBX7JL\ne1iozz5iQyALtbul4DP8ZcCdNpJQbi78u/3Z69Z9PtQj1cbatfhpGTU7NXR9b++/\nXSZ1hf57AgMBAAECggEAKnq8Msk0Ukbln+7FCd1zlYJ+oc/4643RWruzOl+efnON\ns9vAFpos2p4a+u/7t1LaDfHaaNvrsGHsHE7LhnajpB9DOGrxE4Sym4cPcj3Kmgwc\njt2o9b/d4t+wyZTIFcERqGO/5ydSQCPu8HTzle+WUAIyLbRCpIHdudX/AO7gpsN1\n3EX/ojBY4T01gKwfftmOOXG2vmDqQKhCM8nFTQm9z6l440ILE6C+T3ZFss6j6OqX\nwRXqu80/MQ8/bBnJ5FQWSKij0asZfCQm+jcOVZjfoZi4q56gW3NT2T5nsZ4yE7mw\nEsqfMIskUKjOAsngBkLytZmV8S01YIopM39zpUNaqQKBgQDLzZgrM6mwFqZHfuBR\n0hzmuhcydGzFJ8un1JHxuupJrgFM+xYI5rI8CEwVGcZ3KsuhtO9DIxc6AF5mJxCO\nrqt982zmbCycvC46A9UWlAw/gqui91JT+K9Tf7U9PgzqNTA133zenOxr5NkGZZym\nhmPVbDUIwWd1sXoHVtBQfA12WQKBgQC+RAxRc/TnVaW7aO++N9wQZ5ykVebnIk4M\ny9tizAhdyRFXDWysJIL7rr28s66QIALf7e2oqd+0q+N9Rl5W31vglZuEn1q2M9dw\n4PJc9EGqbMmieRvKpt1ii0TosBF85q+ZIDe0kGd/4YOUoLBw4iC/E96Lx0CZSCsB\n02huea7o8wKBgAUfKpbTWo1ZVF5xmtOTkzRdMt4KvP0LbfvOxMgtaVvmqpOzr68T\nlSEbGEZjenBeO/XZZTXruNa1UaoBi1H6o8arim4UA98Af6znkcBagiBKeWPEEWaY\n1lcj23sphwuPwKFp92pkyTBA9Q9LGG+66uFfMcoBikcT6bwre1q6c2ApAoGBAJNu\nqVjokIo9jLnm+3cbU9QGZZPV2KGbrH0v7iTlU0pRBrW8+kt9011xLycs2IRnubKJ\nbJI4Z9dZJmMphuqsE0a4xxSCYsky7KtUM5mhz8xelfPnAokKuhulLVVdMX/mRYVT\nOLca+ohWWB5wUah3IMbPf7AySrU7/c9hYNfSRJ3PAoGBAMZz1lnVyMVfHQhQ27oK\nkAP2C4/9p6Bowb59TdHoBtv1QLT+R1alnrp0p2IXDt4MyJeMTBhmXT4I+gOG7jxS\niSUvCbUOD7oR+HbUgh97ordqFRq4c6AoKoSzJ2Dpq/UDm+pMSOMl4vZOs0qm2x4f\nhRZP10GLvhOrkfLx0KuOAik0\n-----END PRIVATE KEY-----\n",
  "client_email": "cse-department@project-409112.iam.gserviceaccount.com",
  "client_id": "101330273595080556978",
  "auth_uri": "https://accounts.google.com/o/oauth2/auth",
  "token_uri": "https://oauth2.googleapis.com/token",
  "auth_provider_x509_cert_url": "https://www.googleapis.com/oauth2/v1/certs",
  "client_x509_cert_url": "https://www.googleapis.com/robot/v1/metadata/x509/cse-department%40project-409112.iam.gserviceaccount.com",
  "universe_domain": "googleapis.com"
}
  ''';

  static final sheets = GSheets(credentials);
  static Worksheet? cse3300;
  static Worksheet? cse4800;
  static Worksheet? cse4801;

  static Worksheet? teamRequest3300;
  static Worksheet? teamRequest4800;

  static Worksheet? teamDistribution;

  static Future initialize() async {
    try {
      final spreadSheet = await sheets.spreadsheet(spreadsheetId);

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
    if (cse3300 == null || cse4800 == null) return null;
    if (type == 'CSE-3300') {
      final lastRow = await cse3300!.values.lastRow();
      proposalData['ID'] = ((int.tryParse(lastRow!.first) ?? 0) + 1).toString();
      cse3300!.values.map.appendRow(proposalData);
    } else {
      final lastRow = await cse4800!.values.lastRow();
      proposalData['ID'] = ((int.tryParse(lastRow!.first) ?? 0) + 1).toString();
      cse4800!.values.map.appendRow(proposalData);
    }
    // dataBaseMethods.updateDataAfterProposalSubmission(proposalData['ID'], type);
  }

  static addTeamRequest(Map<String, dynamic> proposalData, String type) async {
    if (teamRequest3300 == null || teamRequest4800 == null) return null;
    if (type == 'CSE-3300-request') {
      final lastRow = await teamRequest3300!.values.lastRow();
      proposalData['ID'] = ((int.tryParse(lastRow!.first) ?? 0) + 1).toString();
      teamRequest3300!.values.map.appendRow(proposalData);
    } else {
      final lastRow = await teamRequest4800!.values.lastRow();
      proposalData['ID'] = ((int.tryParse(lastRow!.first) ?? 0) + 1).toString();
      teamRequest4800!.values.map.appendRow(proposalData);
    }
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
    final spreadSheet = await sheets.spreadsheet(spreadsheetId);
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

  static getAllTitles(String type) async {
    List<String>? titles = [];
    if (type == 'CSE-3300') {
      titles = await cse3300!.values.columnByKey("Title");
    } else if (type == 'CSE-4800') {
      titles = await cse4800!.values.columnByKey("Title");
    } else {
      titles = await cse4801!.values.columnByKey("Title");
    }
    return titles;
  }
}
