import 'dart:io';

import 'package:bot_toast/bot_toast.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';
import 'package:syncfusion_flutter_xlsio/xlsio.dart';
import 'package:teamlead/v2/core/api/google_sheet_api/result_sheet_api.dart';
import 'package:teamlead/v2/core/database/firebase_db/collection_name.dart';
import 'package:teamlead/v2/core/database/firebase_db/firebase_handler.dart';
import 'package:teamlead/v2/core/utils/data_formatting/result_fromatting.dart';
import 'package:teamlead/v2/core/utils/logger/logger.dart';
import 'package:teamlead/v2/modules/admin/generate_result/model/overall_marking_model.dart';
import 'package:teamlead/v2/modules/shared/marking/model/marking_model.dart';
import 'package:teamlead/v2/modules/student/proposal/model/proposal_model.dart';

class GenerateResultController extends GetxController {
  final ResultSheetAPI _resultSheetAPI = Get.find<ResultSheetAPI>();
  final Workbook proposalBook = Workbook();
  RxList<OverAllMarkingModel> marks = RxList([]);

  Future<void> resultGeneration({required List<ProposalModel> proposals}) async {
    await _resultSheetAPI.result3300?.clearRow(2, count: _resultSheetAPI.result3300!.rowCount);
    debug(proposals.length);
    for (ProposalModel proposal in proposals) {
      for (Member member in proposal.members!) {
        await _resultSheetAPI.result3300?.values.appendRow([
          proposal.id,
          proposal.title,
          proposal.totalMembers,
          member.name,
          member.studentId,
          "",
          "Not Evaluated",
          "Not Evaluated",
          "Not Evaluated",
          "Not Evaluated",
          "Not Evaluated",
        ]);
      }

      await Future.delayed(const Duration(seconds: 3));
    }
    debug("DONE");
    // proposalSheetAPI.cse3300?;
  }

  generateExcelSheet({required String courseCode}) {
    if (courseCode == "CSE-3300") {
      final Worksheet cse3300 = proposalBook.worksheets.add();
      cse3300.name = courseCode;
      ResultFormatting.addAllData(marks: marks, sheet: cse3300);
    } else if (courseCode == "CSE-4800") {
      final Worksheet cse4800 = proposalBook.worksheets.add();
      cse4800.name = courseCode;
      ResultFormatting.addAllData(marks: marks, sheet: cse4800);
    } else {
      final Worksheet cse4801 = proposalBook.worksheets.add();
      cse4801.name = courseCode;
      ResultFormatting.addAllData(marks: marks, sheet: cse4801);
    }
  }


  Future<void> generateResult({
    required List<ProposalModel> proposals,
    required String courseCode,
  }) async {
    marks.clear();

    // Create a list of futures
    List<Future<OverAllMarkingModel>> futureMarks = proposals.map((proposal) async {
      List<double>? boardMark = await defenseBoardAllMarks(
        title: proposal.title!,
        teamMembers: proposal.totalMembers!,
        courseCode: courseCode,
      );

      List<double>? markSupervisor = await supervisorMark(
        title: proposal.title!,
        courseCode: courseCode,
      );

      List<IndividualGrade> grades = [];
      for (int j = 0; j < proposal.totalMembers!; j++) {
        IndividualGrade grade = IndividualGrade(
          name: proposal.members![j].name!,
          studentId: proposal.members![j].studentId!,
          boardMark: boardMark != null ? boardMark[j].toString() : "Not Evaluated",
          supervisorMark: markSupervisor != null ? markSupervisor[j].toString() : "Not Evaluated",
          total: boardMark == null || markSupervisor == null
              ? "-"
              : "${(boardMark[j] + markSupervisor[j]).ceil()}",
          grade: boardMark == null || markSupervisor == null
              ? "-"
              : getGrade(totalMark: (boardMark[j] + markSupervisor[j]).ceil()),
          point: boardMark == null || markSupervisor == null
              ? "-"
              : getPoint(totalMark: (boardMark[j] + markSupervisor[j]).ceil()),
        );
        grades.add(grade);
      }

      List<String> markedBy = await evaluatedBy(
        title: proposal.title!,
        courseCode: courseCode,
      );

      return OverAllMarkingModel(
        id: proposal.id!,
        title: proposal.title!,
        totalMembers: proposal.totalMembers!,
        evaluatedBy: markedBy.join(", "),
        grades: grades,
      );
    }).toList(); // Convert Iterable to List

    // Run all futures concurrently and wait for completion
    marks.value = await Future.wait(futureMarks);


    if (marks.isNotEmpty) {
      generateExcelSheet(courseCode: courseCode);
      BotToast.showText(text: "Result Generation Completed for $courseCode");
    }
  }


  Future<List<String>> evaluatedBy({
    required String title,
    required String courseCode,
  }) async {
    try {
      final querySnapshot = await FirebaseHandler.fireStore
          .collection(courseCode)
          .doc(title)
          .collection(CollectionName.boardMark)
          .get();

      final List<String> evaluated = querySnapshot.docs.map((doc) => doc.id).toList();
      return evaluated;
    } catch (e) {
      return [];
    }
  }

  Future<List<double>?> defenseBoardAllMarks({
    required String title,
    required int teamMembers,
    required String courseCode,
  }) async {
    try {
      final data = await FirebaseHandler.fireStore
          .collection(courseCode)
          .doc(title)
          .collection(CollectionName.boardMark)
          .get();

      if (data.docs.isNotEmpty) {
        List<double> averageMark = [];
        for (int i = 0; i < teamMembers; i++) {
          averageMark.add(0);
        }
        for (QueryDocumentSnapshot<Map<String, dynamic>> doc in data.docs) {
          MarkingModel boardMarks = MarkingModel.fromJson(doc.data());

          for (int i=0; i<boardMarks.marks.length; i++) {
            averageMark[i] += boardMarks.marks[i].total;
          }
        }
        for (int i = 0; i < teamMembers; i++) {
          averageMark[i] = (averageMark[i] / data.docs.length).toPrecision(2);
        }
        debug("Average Mark:$averageMark");
        return averageMark;
      }
    } catch (e) {
      debug("$e Not board mark found");
    }
    return null;
  }

  Future<List<double>?> supervisorMark({
    required String title,
    required String courseCode,
  }) async {
    try {
      final data = await FirebaseHandler.fireStore
          .collection(courseCode)
          .doc(title)
          .collection(CollectionName.supervisorMark)
          .get();

      if (data.docs.isNotEmpty) {
        MarkingModel supervisorMark = MarkingModel.fromJson(data.docs.first.data());
        // debug(k);
        List<double> marksObtained = [];
        for(IndividualMark mark in supervisorMark.marks){
          marksObtained.add(mark.total);
        }
        debug("Supervisor Mark $marksObtained");
        return marksObtained;
      }
    } catch (e) {
      debug("$e No supervisor mark found");
    }
    return null;
  }

  void getSheet() async {
    final List<int> bytes = proposalBook.saveAsStream();
    final Directory directory = await getApplicationDocumentsDirectory();
    final filePath = "${directory.path}/Result.xlsx";
    final file = File(filePath);
    await file.writeAsBytes(bytes);

    final xFile = XFile(file.path);

    // Share the file
    await Share.shareXFiles([xFile], text: 'Here is your Excel file!');
  }

  String getGrade({required int totalMark}) {
    if (totalMark >= 80) {
      return 'A+';
    } else if (totalMark >= 75 && totalMark <= 79) {
      return 'A';
    } else if (totalMark >= 70 && totalMark <= 74) {
      return 'A-';
    } else if (totalMark >= 65 && totalMark <= 69) {
      return 'B+';
    } else if (totalMark >= 60 && totalMark <= 64) {
      return 'B';
    } else if (totalMark >= 55 && totalMark <= 59) {
      return 'B-';
    } else if (totalMark >= 50 && totalMark <= 54) {
      return 'C+';
    } else if (totalMark >= 45 && totalMark <= 49) {
      return 'C';
    } else if (totalMark >= 40 && totalMark <= 44) {
      return 'D';
    } else {
      return 'F';
    }
  }

  String getPoint({required int totalMark}) {
    if (totalMark >= 80) {
      return '4.00';
    } else if (totalMark >= 75 && totalMark <= 79) {
      return '3.75';
    } else if (totalMark >= 70 && totalMark <= 74) {
      return '3.50';
    } else if (totalMark >= 65 && totalMark <= 69) {
      return '3.25';
    } else if (totalMark >= 60 && totalMark <= 64) {
      return '3.00';
    } else if (totalMark >= 55 && totalMark <= 59) {
      return '2.75';
    } else if (totalMark >= 50 && totalMark <= 54) {
      return '2.50';
    } else if (totalMark >= 45 && totalMark <= 49) {
      return '2.25';
    } else if (totalMark >= 40 && totalMark <= 44) {
      return '2.00';
    } else {
      return '0.00';
    }
  }

  @override
  void dispose() {
    proposalBook.dispose();
    super.dispose();
  }
}
