import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:syncfusion_flutter_xlsio/xlsio.dart';
import 'package:teamlead/v2/core/api/model/schedule_sheet_columns.dart';
import 'package:teamlead/v2/core/utils/logger/logger.dart';
import 'package:teamlead/v2/modules/admin/generate_schedule/controller/generate_schedule_controller.dart';
import 'package:teamlead/v2/modules/admin/generate_schedule/model/scheule_model.dart';
import 'package:teamlead/v2/modules/student/proposal/model/proposal_model.dart';

class ScheduleFormatting {
  static final _scheduleController = Get.find<GenerateScheduleController>();

  static void setWidth(Worksheet sheet, int pl) {
    sheet.getRangeByName('A1:A$pl').columnWidth = 5;
    sheet.getRangeByName('B1:B$pl').columnWidth = 25;
    sheet.getRangeByName('C1:C$pl').columnWidth = 30;
    sheet.getRangeByName('D1:D$pl').columnWidth = 30;
    sheet.getRangeByName('E1:E$pl').columnWidth = 40;
    sheet.getRangeByName('F1:F$pl').columnWidth = 30;
    sheet.getRangeByName('G1:G$pl').columnWidth = 40;
  }

  static void setHeading(Worksheet sheet) {
    sheet.getRangeByName('A1').setText(ScheduleSheetColumns.sl);
    sheet.getRangeByName('B1').setText(ScheduleSheetColumns.schedule);
    sheet.getRangeByName('C1').setText(ScheduleSheetColumns.studentID);
    sheet.getRangeByName('D1').setText(ScheduleSheetColumns.name);
    sheet.getRangeByName('E1').setText(ScheduleSheetColumns.title);
    sheet.getRangeByName('F1').setText(ScheduleSheetColumns.supervisor);
    sheet.getRangeByName('G1').setText(ScheduleSheetColumns.signature);
  }

  static void addEachDay(Worksheet sheet, String date) {
    // decorationRows.add(sheet.getLastRow() + 1);
    sheet.getRangeByName("A${sheet.getLastRow() + 1}").setText(date);
    try {
      sheet.getRangeByName('A${sheet.getLastRow()}:G${sheet.getLastRow()}').cellStyle
        ..hAlign = HAlignType.center
        ..vAlign = VAlignType.center
        ..fontSize = 14
        ..borders.all
        ..backColor = '#d7e477';
    } catch (e) {
      debug("Heading Style Error: $e");
    }
    sheet.getRangeByIndex(sheet.getLastRow(), 1, sheet.getLastRow(), 7).merge();
  }


  static Future<DateTime> addSchedule({
    required List<ProposalModel> proposals,
    required DateTime startDate,
    required TimeOfDay startTime,
    required TimeOfDay endTime,
    required TimeOfDay breakTime,
    required int slotDuration,
    required int breakDuration,
    required Worksheet sheet,
    required DateTime continuedTime,
  }) async {
    DateTime startLimit = continuedTime;
    TimeOfDay tempStartTime = startTime;
    TimeOfDay tempEndTime = endTime;


    DateTime endLimit = DateTime(
      continuedTime.year,
      continuedTime.month,
      continuedTime.day,
      endTime.hour,
      endTime.minute,
    );
    setWidth(sheet, proposals.length + 1);
    setHeading(sheet);
    if (sheet.getLastRow() > 0) {
      // debug("header formatting ${sheet.getLastRow()}");
      try {
        sheet.getRangeByName('A1:G${sheet.getLastRow()}').cellStyle
          ..hAlign = HAlignType.center
          ..vAlign = VAlignType.center
          ..fontSize = 14
          ..borders.all
          ..backColor = '#77E4C8';
      } catch (e) {
        debug("Heading Style Error: $e");
      }
    }
    if(startLimit.weekday == 5){
      startLimit = DateTime(
        startLimit.year,
        startLimit.month,
        startLimit.day + 2,
        startTime.hour,
        startTime.minute,
      );
      endLimit = DateTime(
        startLimit.year,
        startLimit.month,
        startLimit.day + 2,
        endTime.hour,
        endTime.minute,
      );
    } else if(startLimit.weekday == 6){
      startLimit = DateTime(
        startLimit.year,
        startLimit.month,
        startLimit.day + 1,
        startTime.hour,
        startTime.minute,
      );
      endLimit = DateTime(
        startLimit.year,
        startLimit.month,
        startLimit.day + 1,
        endTime.hour,
        endTime.minute,
      );
    }
    addEachDay(sheet, DateFormat.yMMMMEEEEd().format(startLimit));
    for (ProposalModel proposal in proposals) {
      // DateFormat.jm().format(startLimit) == DateFormat.jm().format(endLimit)
      if (startLimit.hour >= endLimit.hour && startLimit.minute >= endLimit.minute) {
        debug("startLimit: $startLimit endLimit: $endLimit");
        startLimit = DateTime(
          startLimit.year,
          startLimit.month,
          startLimit.day + 1,
          startTime.hour,
          startTime.minute,
        );
        endLimit = DateTime(
          startLimit.year,
          startLimit.month,
          startLimit.day + 1,
          endTime.hour,
          endTime.minute,
        );
        debug("Day Over Start ${DateFormat.yMMMMEEEEd().format(startLimit)} "
            "${DateFormat.jm().format(startLimit)}");
        debug("Day Over End ${DateFormat.yMMMMEEEEd().format(endLimit)} "
            "${DateFormat.jm().format(endLimit)}");
        /// Skipping Friday and Saturday
        if(startLimit.weekday == 5){
          startLimit = DateTime(
            startLimit.year,
            startLimit.month,
            startLimit.day + 2,
            startTime.hour,
            startTime.minute,
          );
          endLimit = DateTime(
            startLimit.year,
            startLimit.month,
            startLimit.day + 2,
            endTime.hour,
            endTime.minute,
          );
        } else if(startLimit.weekday == 6){
          startLimit = DateTime(
            startLimit.year,
            startLimit.month,
            startLimit.day + 1,
            startTime.hour,
            startTime.minute,
          );
          endLimit = DateTime(
            startLimit.year,
            startLimit.month,
            startLimit.day + 1,
            endTime.hour,
            endTime.minute,
          );
        }
        addEachDay(sheet, DateFormat.yMMMMEEEEd().format(startLimit));
      }


      String start = DateFormat.jm().format(startLimit);
      startLimit = startLimit.add(Duration(minutes: slotDuration));
      String end = DateFormat.jm().format(startLimit);
      // debug("${proposal.id} $start - $end");
      if (startLimit.hour == breakTime.hour) {
        startLimit = startLimit.add(Duration(minutes: breakDuration));
      }

      List<StudentList> students = [];

      for (Member member in proposal.members!) {
        int lastRow = sheet.getLastRow() + 1;
        sheet.getRangeByName('A$lastRow').setText("${proposal.id ?? 0}");
        sheet.getRangeByName('B$lastRow').setText("$start - $end");
        sheet.getRangeByName('C$lastRow').setText(member.studentId ?? "");
        sheet.getRangeByName('D$lastRow').setText("${member.name ?? 0}");
        sheet.getRangeByName('E$lastRow').setText(proposal.title ?? "");
        sheet.getRangeByName('F$lastRow').setText(proposal.supervisor ?? "");
        sheet.getRangeByName('G$lastRow').setText("");
        students.add(StudentList(name: member.name!, studentId: member.studentId!));
      }

      _scheduleController.schedules.add(ScheduleModel(
        sl: proposal.id!,
        date: DateFormat.yMMMd().format(startLimit),
        timeSlot: "$start - $end",
        supervisor: proposal.supervisor!,
        title: proposal.title!,
        students: students,
      ));

      int lastRow = sheet.getLastRow();
      int firstRow = lastRow - (proposal.totalMembers! - 1);

      if (proposal.totalMembers! > 1) {
        sheet.getRangeByIndex(firstRow, 1, lastRow, 1).merge(); // Column A
        sheet.getRangeByIndex(firstRow, 2, lastRow, 2).merge(); // Column B
        sheet.getRangeByIndex(firstRow, 5, lastRow, 5).merge(); // Column C
        sheet.getRangeByIndex(firstRow, 6, lastRow, 6).merge(); // Column D
      }
      int blankRow = sheet.getLastRow() + 1;
      sheet.getRangeByName("A$blankRow:G$blankRow").setText("");
    }
    if (sheet.getFirstRow() < sheet.getLastRow()) {
      // debug("First ${sheet.getFirstRow()} - Last ${sheet.getLastRow()}");
      try {
        sheet.getRangeByName('A1:G${sheet.getLastRow()}').cellStyle
          ..fontName = "Cambria"
          ..hAlign = HAlignType.center
          ..vAlign = VAlignType.center;
      } catch (e) {
        debug("All Text Formatting Error: $e");
      }
    }
    // formatWholeSheet(sheet);
    // sheet.getRangeByName('A${sheet.getFirstRow()}:G${sheet.getLastRow()}').cellStyle;
    // TimeOfDay kContinue = TimeOfDay(hour: startLimit.hour, minute: startLimit.minute);
    // decorateSheet(sheet);
    return startLimit;
  }
}

