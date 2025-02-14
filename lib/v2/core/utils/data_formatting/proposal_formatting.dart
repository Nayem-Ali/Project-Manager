import 'package:syncfusion_flutter_xlsio/xlsio.dart';
import 'package:teamlead/v2/core/api/model/proposal_sheet_columns.dart';
import 'package:teamlead/v2/core/utils/logger/logger.dart';
import 'package:teamlead/v2/modules/student/proposal/model/proposal_model.dart';

class ProposalFormatting {
  void setWidth(Worksheet sheet, int pl) {
    sheet.getRangeByName('A1:A$pl').columnWidth = 5; // ID
    sheet.getRangeByName('B1:B$pl').columnWidth = 30; // Title
    sheet.getRangeByName('C1:C$pl').columnWidth = 40; // Link
    sheet.getRangeByName('D1:D$pl').columnWidth = 20; // Members
    sheet.getRangeByName('E1:E$pl').columnWidth = 20; // Name
    sheet.getRangeByName('F1:F$pl').columnWidth = 15; // Student ID
    sheet.getRangeByName('G1:G$pl').columnWidth = 35; // Email
    sheet.getRangeByName('H1:H$pl').columnWidth = 10; // CGPA
    sheet.getRangeByName('I1:I$pl').columnWidth = 15; // Phone
    sheet.getRangeByName('J1:J$pl').columnWidth = 20; // Supervisor
    sheet.getRangeByName('K1:K$pl').columnWidth = 20; // Preference
  }

  void setHeading(Worksheet sheet) {
    sheet.getRangeByName('A1').setText(ProposalSheetColumns.id);
    sheet.getRangeByName('B1').setText(ProposalSheetColumns.title);
    sheet.getRangeByName('C1').setText(ProposalSheetColumns.link);
    sheet.getRangeByName('D1').setText(ProposalSheetColumns.members);
    sheet.getRangeByName('E1').setText(ProposalSheetColumns.name);
    sheet.getRangeByName('F1').setText(ProposalSheetColumns.studentID);
    sheet.getRangeByName('G1').setText(ProposalSheetColumns.email);
    sheet.getRangeByName('H1').setText(ProposalSheetColumns.cgpa);
    sheet.getRangeByName('I1').setText(ProposalSheetColumns.phone);
    sheet.getRangeByName('J1').setText(ProposalSheetColumns.supervisor);
    sheet.getRangeByName('K1').setText(ProposalSheetColumns.preference);
  }

  void addAllData({
    required List<ProposalModel> proposals,
    required Workbook workbook,
    required Worksheet sheet,
  }) async {
    setWidth(sheet, proposals.length + 1);
    setHeading(sheet);


    sheet.getRangeByName('A1:K${sheet.getLastRow()}').cellStyle
      ..hAlign = HAlignType.center
      ..vAlign = VAlignType.center
      ..fontSize = 14
      ..bold
      ..borders
      ..backColor = '#00FFCC';

    // Iterate through proposals and add data
    for (ProposalModel proposal in proposals) {
      for (Member member in proposal.members!) {
        int lastRow = sheet.getLastRow() + 1;
        sheet.getRangeByName('A$lastRow').setText("${proposal.id ?? 0}");
        sheet.getRangeByName('B$lastRow').setText(proposal.title ?? "");
        sheet.getRangeByName('C$lastRow').setText(proposal.proposal ?? "");
        sheet.getRangeByName('D$lastRow').setText("${proposal.totalMembers ?? 0}");
        sheet.getRangeByName('E$lastRow').setText(member.name ?? "");
        sheet.getRangeByName('F$lastRow').setText(member.studentId ?? "");
        sheet.getRangeByName('G$lastRow').setText(member.email ?? "");
        sheet.getRangeByName('H$lastRow').setText("${member.cgpa ?? 0.0}");
        sheet.getRangeByName('I$lastRow').setText(member.mobile ?? "");
        sheet.getRangeByName('J$lastRow').setText(proposal.supervisor ?? "");
        sheet.getRangeByName('K$lastRow').setText(proposal.preference.toString());
      }

      int lastRow = sheet.getLastRow();
      int firstRow = lastRow - (proposal.totalMembers! - 1);

      if (proposal.totalMembers! > 1) {
        sheet.getRangeByIndex(firstRow, 1, lastRow, 1).merge(); // Column A
        sheet.getRangeByIndex(firstRow, 2, lastRow, 2).merge(); // Column B
        sheet.getRangeByIndex(firstRow, 3, lastRow, 3).merge(); // Column C
        sheet.getRangeByIndex(firstRow, 4, lastRow, 4).merge(); // Column D
        sheet.getRangeByIndex(firstRow, 10, lastRow, 10).merge(); // Column J
        sheet.getRangeByIndex(firstRow, 11, lastRow, 11).merge(); // Column K
      }
      int blankRow = sheet.getLastRow() + 1;
      sheet.getRangeByIndex(blankRow, 1, blankRow, 11).cellStyle
        ..hAlign = HAlignType.center
        ..vAlign = VAlignType.center;
    }
    sheet.getRangeByName('A1:K${sheet.getLastRow()}').cellStyle
      ..fontName = "Cambria"
      ..hAlign = HAlignType.center
      ..vAlign = VAlignType.center;

    // Save the Excel file


    // File('${appDocumentsDir.path}/CreateExcel.xlsx').writeAsBytesSync(bytes);
    debug("DONE");
  }
}
