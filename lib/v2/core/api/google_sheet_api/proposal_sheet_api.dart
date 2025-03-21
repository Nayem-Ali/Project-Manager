import 'package:gsheets/gsheets.dart';
import 'package:teamlead/constants/proposal_credentials.dart';
import 'package:teamlead/v2/core/api/model/proposal_sheet_columns.dart';
import 'package:teamlead/v2/core/api/model/team_distribution_columns.dart';
import 'package:teamlead/v2/core/utils/constant/google_worksheet_titles.dart';
import 'package:teamlead/v2/core/utils/logger/logger.dart';

class ProposalSheetAPI {
  final GSheets proposalSheets = GSheets(ProposalCredentials.credentials);
  Worksheet? cse3300;
  Worksheet? cse4800;
  Worksheet? cse4801;

  Worksheet? teamRequest3300;
  Worksheet? teamRequest4800;

  Worksheet? teamDistribution;

  Future initialize() async {
    try {
      final Spreadsheet spreadSheet =
          await proposalSheets.spreadsheet(ProposalCredentials.spreadsheetId);
      cse3300 = await getWorkSheet(spreadSheet, title: WorksheetTitles.cse3300);
      cse4800 = await getWorkSheet(spreadSheet, title: WorksheetTitles.cse4800);
      cse4801 = await getWorkSheet(spreadSheet, title: WorksheetTitles.cse4801);
      teamRequest3300 = await getWorkSheet(spreadSheet, title: WorksheetTitles.cse3300TeamRequest);
      teamRequest4800 = await getWorkSheet(spreadSheet, title: WorksheetTitles.cse4800TeamRequest);
      teamDistribution = await getWorkSheet(spreadSheet, title: WorksheetTitles.teamDistribution);
      final List<String> columnsTitle = ProposalSheetColumns.getColumnsTitle();
      cse3300!.values.insertRow(1, columnsTitle);
      cse4800!.values.insertRow(1, columnsTitle);
      cse4801!.values.insertRow(1, columnsTitle);
      teamRequest3300!.values.insertRow(1, columnsTitle);
      teamRequest4800!.values.insertRow(1, columnsTitle);
      teamDistribution!.values.insertRow(1, TeamDistributionColumns.getColumns());
      debug("Proposal Sheet Initialization Success");
    } catch (e) {
      debug("Error Initializing Proposal Sheet: e");
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
