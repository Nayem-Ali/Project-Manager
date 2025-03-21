import 'dart:io';

import 'package:bot_toast/bot_toast.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';
import 'package:syncfusion_flutter_xlsio/xlsio.dart';
import 'package:teamlead/v2/core/utils/data_formatting/schedule_formating.dart';
import 'package:teamlead/v2/core/utils/logger/logger.dart';
import 'package:teamlead/v2/modules/admin/generate_schedule/model/scheule_model.dart';
import 'package:teamlead/v2/modules/student/proposal/controller/proposal_controller.dart';

class GenerateScheduleController extends GetxController {
  final _proposalController = Get.find<ProposalController>();

  RxList<ScheduleModel> schedules = RxList<ScheduleModel>([]);

  Future<void> testSlotTimeAllocation({
    required DateTime startDate,
    required TimeOfDay startTime,
    required TimeOfDay endTime,
    required TimeOfDay breakTime,
    required List<int> slotsDuration,
    required int breakDuration,
    required List<String> courses,
  }) async {
    Workbook scheduleBook = Workbook();
    DateTime continuedTime = DateTime(
      startDate.year,
      startDate.month,
      startDate.day,
      startTime.hour,
      startTime.minute,
    );
    debug("Continue Time: ${continuedTime}");
    BotToast.showLoading();
    schedules.clear();
    for (int i = 0; i < courses.length; i++) {
      _proposalController.fetchAllProposals(
        cse3300: courses[i] == 'CSE-3300',
        cse4800: courses[i] == 'CSE-4800',
        cse4801: courses[i] == 'CSE-4801',
      );
      await Future.delayed(const Duration(seconds: 3));


      if (courses[i] == "CSE-3300") {
        Worksheet cse3300 = scheduleBook.worksheets.add();
        cse3300.name = courses[i];
        continuedTime = await ScheduleFormatting.addSchedule(
          proposals: _proposalController.allProposal,
          startDate: startDate,
          startTime: startTime,
          endTime: endTime,
          breakTime: breakTime,
          slotDuration: slotsDuration[i],
          breakDuration: breakDuration,
          continuedTime: continuedTime,
          sheet: cse3300,
        );
      } else if (courses[i] == "CSE-4800") {
        Worksheet cse4800 = scheduleBook.worksheets.add();
        cse4800.name = courses[i];
        continuedTime = await ScheduleFormatting.addSchedule(
          proposals: _proposalController.allProposal,
          startDate: startDate,
          startTime: startTime,
          endTime: endTime,
          breakTime: breakTime,
          slotDuration: slotsDuration[i],
          breakDuration: breakDuration,
          continuedTime: continuedTime,
          sheet: cse4800,
        );

        // cse4800.workbook.dispose();
      } else if (courses[i] == "CSE-4801") {
        Worksheet cse4801 = scheduleBook.worksheets.add();
        cse4801.name = courses[i];
        continuedTime = await ScheduleFormatting.addSchedule(
          proposals: _proposalController.allProposal,
          startDate: startDate,
          startTime: startTime,
          endTime: endTime,
          breakTime: breakTime,
          slotDuration: slotsDuration[i],
          breakDuration: breakDuration,
          continuedTime: continuedTime,
          sheet: cse4801,
        );
        // cse4801.workbook.dispose();
      }
    }
    BotToast.closeAllLoading();
    await getSheet(scheduleBook);
    // scheduleBook.worksheets.clear();
    scheduleBook.dispose();
  }

  Future<void> getSheet(Workbook scheduleBook) async {
    final List<int> bytes = scheduleBook.saveAsStream();
    final Directory directory = await getApplicationDocumentsDirectory();
    final filePath = "${directory.path}/Schedule.xlsx";
    final file = File(filePath);
    await file.writeAsBytes(bytes);


    final xFile = XFile(file.path);

    // Share the file
    await Share.shareXFiles([xFile], text: 'Here is your Excel file!');
  }
}



