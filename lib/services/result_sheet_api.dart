import 'package:firebase_auth/firebase_auth.dart';
import 'package:gsheets/gsheets.dart';
import 'package:teamlead/constants/result_credentials.dart';

import '../model/result_model.dart';

class ResultSheetApi {


  static final gsheets = GSheets(ResultCredentials.credentials);
  static Worksheet? result3300;
  static Worksheet? result4800;
  static Worksheet? result4801;

  static Future initialize() async {
    try {
      final spreadSheet = await gsheets.spreadsheet(ResultCredentials.spreadsheetId);
      result3300 = await getWorkSheet(spreadSheet, title: "CSE-3300");
      result4800 = await getWorkSheet(spreadSheet, title: "CSE-4800");
      result4801 = await getWorkSheet(spreadSheet, title: "CSE-4801");

      final firstRow = ResultFields.getFields();

      result3300!.values.insertRow(1, firstRow);
      result4800!.values.insertRow(1, firstRow);
      result4801!.values.insertRow(1, firstRow);
    } catch (e) {
      print("$e");
      // Get.snackbar(
      //   "Oops",
      //   "Something went wrong",
      // );
    }
  }

  static Future<Worksheet> getWorkSheet(Spreadsheet spreadsheet, {required String title}) async {
    try {
      return await spreadsheet.addWorksheet(title);
    } catch (e) {
      return spreadsheet.worksheetByTitle(title)!;
    }
  }

  static addResult(Map<String, dynamic> resultData, String type) async {
    // DataBaseMethods dataBaseMethods = DataBaseMethods();
    if (result3300 == null || result4800 == null || result4801 == null) return null;
    if (type == 'CSE-3300') {
      // await result3300!.deleteRow(2,count: result3300!.rowCount);
      final lastRow = await result3300!.values.lastRow();
      resultData['ID'] = ((int.tryParse(lastRow!.first) ?? 0) + 1).toString();
      await result3300!.values.map.appendRow(resultData);
    } else if (type == 'CSE-4800') {
      // await result3300!.deleteRow(2,count: result3300!.rowCount);
      final lastRow = await result4800!.values.lastRow();
      resultData['ID'] = ((int.tryParse(lastRow!.first) ?? 0) + 1).toString();
      await result4800!.values.map.appendRow(resultData);
    } else {
      // await result3300!.deleteRow(2,count: result3300!.rowCount);
      final lastRow = await result4801!.values.lastRow();
      resultData['ID'] = ((int.tryParse(lastRow!.first) ?? 0) + 1).toString();
      await result4801!.values.map.appendRow(resultData);
    }
    // dataBaseMethods.updateDataAfterProposalSubmission(proposalData['ID'], type);
  }

  static deleteResult(String type) async {
    // DataBaseMethods dataBaseMethods = DataBaseMethods();
    if (result3300 == null || result4800 == null || result4801 == null) return null;
    if (type == 'CSE-3300') {
      if (result3300!.rowCount > 1) {
        await result3300!.deleteRow(2, count: result3300!.rowCount);
      }
    } else if (type == 'CSE-4800') {
      if (result4800!.rowCount > 1) {
        await result4800!.deleteRow(2, count: result4800!.rowCount);
      }
    } else {
      if (result4801!.rowCount > 1) {
        await result4801!.deleteRow(2, count: result4801!.rowCount);
      }
    }
    // dataBaseMethods.updateDataAfterProposalSubmission(proposalData['ID'], type);
  }

  static getResult(String type) async {
    dynamic allData = [];
    if (type == 'CSE-3300') {
      allData = await result3300!.values.map.allRows();
    } else if (type == 'CSE-4800') {
      allData = await result4800!.values.map.allRows();
    } else {
      allData = await result4801!.values.map.allRows();
    }
    return allData;
  }

  static giveAccess() async {
    FirebaseAuth auth = FirebaseAuth.instance;
    final spreadSheet = await gsheets.spreadsheet(ResultCredentials.spreadsheetId);
    await spreadSheet.share(
      "${auth.currentUser!.email}",
      role: PermRole.writer,
      type: PermType.user,
      // withLink: true
    );
    final url = spreadSheet.url;
    return url;
  }
}
