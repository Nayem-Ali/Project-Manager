import '../../services/db_service.dart';
import '../../services/proposal_sheets_api.dart';
import '../../services/result_sheet_api.dart';

generateResult(String type) async {
  DataBaseMethods dataBaseMethods = DataBaseMethods();
  dynamic teams = [];
  teams = await ProjectSheetApi.getAllRows(type);
  await ResultSheetApi.deleteResult(type);
  if (teams == null) return 'failed';
  try {
    for (var data in teams) {
      bool markedBySupervisor = false;
      bool markedByBoard = false;
      dynamic marks = await dataBaseMethods.getEvaluationData(
        type,
        data['Title']!,
        'evaluationData',
      );
      dynamic supervisorMark =
          await dataBaseMethods.getSupervisorMarkForGenerateResult(type, data['Title']);
      List<double> sup = [0, 0, 0, 0];
      List<double> avg = [0, 0, 0, 0];
      int count = 0;
      if (supervisorMark.length > 0) {
        for (int i = 0; i < supervisorMark.length; i++) {
          sup[i] = supervisorMark[i]['total'] * 1.0;
        }
        markedBySupervisor = true;
      }

      // if (marks.length != 0) {

      for (var mark in marks) {
        // print(mark['data'][0]['evaluatedBy']);
        // print(mark['data'][0]['title']);
        // print(mark);
        if (mark['data'].length != 0) {
          avg[0] += (double.tryParse(mark['data'][1]['criteria1']) ?? 0) +
              (double.tryParse(mark['data'][1]['criteria2']) ?? 0);

          avg[1] += (double.tryParse(mark['data'][2]['criteria1']) ?? 0) +
              (double.tryParse(mark['data'][2]['criteria2']) ?? 0);

          avg[2] += (double.tryParse(mark['data'][3]['criteria1']) ?? 0) +
              (double.tryParse(mark['data'][3]['criteria2']) ?? 0);

          avg[3] += (double.tryParse(mark['data'][4]['criteria1']) ?? 0) +
              (double.tryParse(mark['data'][4]['criteria2']) ?? 0);
          markedByBoard = true;
        }
        count++;
      }

      if (count != 0) {
        avg[0] = avg[0] / count;
        avg[1] = avg[1] / count;
        avg[2] = avg[2] / count;
        avg[3] = avg[3] / count;
      }


      final resultData = {
        "ID": "",
        "Title": data['Title'],
        "Name": data['Name'],
        "Team Members": data["Team Members"],
        "Student ID": data['Student ID'],
        "Defense Board Mark Average":
            markedByBoard ? "${avg[0]}\n${avg[1]}\n${avg[2]}\n${avg[3]}" : "Not Evaluated",
        "Supervisor Mark": markedBySupervisor
            ? "${sup[0]}\n${sup[1]}\n${sup[2]}"
                "\n${sup[3]}"
            : "Not Evaluated",
        "Total": markedBySupervisor || markedByBoard
            ? "${sup[0] + avg[0]}\n${sup[1] + avg[1]}"
                "\n${sup[2] + avg[2]}\n${sup[3] + avg[3]}"
            : "Not Evaluated",
      };

      await ResultSheetApi.addResult(resultData, type);
      markedBySupervisor = false;
      markedByBoard = false;

    }
  } catch (e) {
    print(e);
    return 'failed';
  }

  // cse4800 = await ProjectSheetApi.getAllRows("CSE-4800");
  // cse4801 = await ProjectSheetApi.getAllRows("CSE-4801");
  teams.clear();
  return '';
}
