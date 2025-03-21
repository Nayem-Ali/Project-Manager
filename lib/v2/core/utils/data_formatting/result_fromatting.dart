import 'package:syncfusion_flutter_xlsio/xlsio.dart';
import 'package:teamlead/v2/core/api/model/resutl_sheet_columns.dart';
import 'package:teamlead/v2/core/utils/logger/logger.dart';
import 'package:teamlead/v2/modules/admin/generate_result/model/overall_marking_model.dart';

class ResultFormatting {
  static void setWidth(Worksheet sheet, int pl) {
    sheet.getRangeByName('A1:A$pl').columnWidth = 5; // ID
    sheet.getRangeByName('B1:B$pl').columnWidth = 35; // Title
    sheet.getRangeByName('C1:C$pl').columnWidth = 20; // Link
    sheet.getRangeByName('D1:D$pl').columnWidth = 25; // Members
    sheet.getRangeByName('E1:E$pl').columnWidth = 40; // Name
    sheet.getRangeByName('F1:F$pl').columnWidth = 25; // Student ID
    sheet.getRangeByName('G1:G$pl').columnWidth = 35; // Email
    sheet.getRangeByName('H1:H$pl').columnWidth = 30; // CGPA
    sheet.getRangeByName('I1:I$pl').columnWidth = 15; // Phone
    sheet.getRangeByName('J1:J$pl').columnWidth = 15; // Supervisor
    sheet.getRangeByName('K1:K$pl').columnWidth = 15; // Preference
  }

  static void setHeading(Worksheet sheet) {
    sheet.getRangeByName('A1').setText(ResultSheetColumns.id);
    sheet.getRangeByName('B1').setText(ResultSheetColumns.title);
    sheet.getRangeByName('C1').setText(ResultSheetColumns.members);
    sheet.getRangeByName('D1').setText(ResultSheetColumns.evaluatedBy);
    sheet.getRangeByName('E1').setText(ResultSheetColumns.board);
    sheet.getRangeByName('F1').setText(ResultSheetColumns.supervisor);
    sheet.getRangeByName('G1').setText(ResultSheetColumns.name);
    sheet.getRangeByName('H1').setText(ResultSheetColumns.studentID);
    sheet.getRangeByName('I1').setText(ResultSheetColumns.total);
    sheet.getRangeByName('J1').setText(ResultSheetColumns.grade);
    sheet.getRangeByName('K1').setText(ResultSheetColumns.point);
  }

  static void addAllData({
    required List<OverAllMarkingModel> marks,
    required Worksheet sheet,
  }) async {
    setWidth(sheet, marks.length + 1);
    setHeading(sheet);
    debug("MArks Length in add data ${marks.length}");

    sheet.getRangeByName('A1:K${sheet.getLastRow()}').cellStyle
      ..hAlign = HAlignType.center
      ..vAlign = VAlignType.center
      ..fontSize = 14
      ..bold
      ..borders
      ..backColor = '#77E4C8';

    // Iterate through proposals and add data
    for (OverAllMarkingModel mark in marks) {
      for (IndividualGrade grade in mark.grades) {
        int lastRow = sheet.getLastRow() + 1;
        sheet.getRangeByName('A$lastRow').setText("${mark.id ?? 0}");
        sheet.getRangeByName('B$lastRow').setText(mark.title ?? "");
        sheet.getRangeByName('C$lastRow').setText("${mark.totalMembers ?? 0}");
        sheet.getRangeByName('D$lastRow').setText("${mark.evaluatedBy ?? 0}"); // Eval Vy
        sheet.getRangeByName('E$lastRow').setText(grade.boardMark ?? ""); // Board Average
        sheet.getRangeByName('F$lastRow').setText(grade.supervisorMark ?? ""); // Supervisor Mark
        sheet.getRangeByName('G$lastRow').setText(grade.name ?? ""); // name
        sheet.getRangeByName('H$lastRow').setText("${grade.studentId ?? 0.0}"); // student id
        sheet.getRangeByName('I$lastRow').setText(grade.total ?? ""); // total
        sheet.getRangeByName('J$lastRow').setText(grade.grade ?? ""); // grade
        sheet.getRangeByName('K$lastRow').setText(grade.point); // point

      }

      int lastRow = sheet.getLastRow();
      int firstRow = lastRow - (mark.totalMembers - 1);

      if (mark.totalMembers > 1) {
        sheet.getRangeByIndex(firstRow, 1, lastRow, 1).merge(); // Column A
        sheet.getRangeByIndex(firstRow, 2, lastRow, 2).merge(); // Column B
        sheet.getRangeByIndex(firstRow, 3, lastRow, 3).merge(); // Column C
        sheet.getRangeByIndex(firstRow, 4, lastRow, 4).merge(); // Column D
        // sheet.getRangeByIndex(firstRow, 10, lastRow, 10).merge(); // Column J
        // sheet.getRangeByIndex(firstRow, 11, lastRow, 11).merge(); // Column K
      }

      /// TODO: Uncomment Later
      int blankRow = sheet.getLastRow() + 1;
      debug("Blank Row ${blankRow}");
      sheet.getRangeByIndex(blankRow, 1, blankRow, 11).cellStyle
        ..hAlign = HAlignType.center
        ..vAlign = VAlignType.center;
    }
    // debug("KLR ${sheet.getLastRow()} ${sheet.name}");
    sheet.getRangeByName('A1:K${sheet.getLastRow()}').cellStyle
      ..fontName = "Cambria"
      ..hAlign = HAlignType.center
      ..vAlign = VAlignType.center;

    // Save the Excel file

    // File('${appDocumentsDir.path}/CreateExcel.xlsx').writeAsBytesSync(bytes);
    debug("DONE");
  }
}
