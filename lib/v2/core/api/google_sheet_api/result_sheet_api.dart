import 'package:gsheets/gsheets.dart';
import 'package:teamlead/constants/result_credentials.dart';
import 'package:teamlead/v2/core/api/model/resutl_sheet_columns.dart';
import 'package:teamlead/v2/core/utils/constant/google_worksheet_titles.dart';
import 'package:teamlead/v2/core/utils/logger/logger.dart';

class ResultSheetAPI {
  final resultSheets = GSheets(ResultCredentials.credentials);
  Worksheet? result3300;
  Worksheet? result4800;
  Worksheet? result4801;

  Future initialize() async {
    try {
      final spreadSheet = await resultSheets.spreadsheet(ResultCredentials.spreadsheetId);
      result3300 = await getWorkSheet(spreadSheet, title: WorksheetTitles.cse3300);
      result4800 = await getWorkSheet(spreadSheet, title: WorksheetTitles.cse4800);
      result4801 = await getWorkSheet(spreadSheet, title: WorksheetTitles.cse4801);
      final List<String> columnsTitles = ResultSheetColumns.getColumnsTitle();
      result3300!.values.insertRow(1, columnsTitles);
      result4800!.values.insertRow(1, columnsTitles);
      result4801!.values.insertRow(1, columnsTitles);
    } catch (e) {
      debug("Error initializing result sheet: $e");
    }
  }

  Future<Worksheet> getWorkSheet(Spreadsheet spreadsheet, {required String title}) async {
    try {
      Worksheet? worksheet = spreadsheet.worksheetByTitle(title);
      if (worksheet != null) return worksheet;
    } catch (e) {
      debug("Error Getting WorkSheet: $e");
    }
    return await spreadsheet.addWorksheet(title);
  }
}
