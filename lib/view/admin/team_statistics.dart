import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:teamlead/services/db_service.dart';

// import 'package:teamlead/services/google_sheets_api.dart';

import '../../services/proposal_sheets_api.dart';

class TeamStatistics extends StatefulWidget {
  const TeamStatistics({Key? key}) : super(key: key);

  @override
  State<TeamStatistics> createState() => _TeamStatisticsState();
}

class _TeamStatisticsState extends State<TeamStatistics> {
  DataBaseMethods dataBaseMethods = DataBaseMethods();
  Map<String, List<int>> teamAllocated = {};
  List<String> initials = [];
  dynamic cse3300 = [];
  dynamic cse4800 = [];
  dynamic cse4801 = [];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getData();
  }

  getData() async {
    initials = await dataBaseMethods.getAllSupervisorInitial();
    cse3300 = await ProjectSheetApi.getAllRows('CSE-3300');
    cse4800 = await ProjectSheetApi.getAllRows('CSE-4800');
    cse4801 = await ProjectSheetApi.getAllRows('CSE-4801');

    for (int i = 0; i < cse3300.length; i++) {
      if (cse3300[i]['Supervisor'] != "") {
        teamAllocated[cse3300[i]['Supervisor']] = [0, 0, 0];
      }
    }
    for (int i = 0; i < cse4800.length; i++) {
      if (cse4800[i]['Supervisor'] != "") {
        teamAllocated[cse4800[i]['Supervisor']] = [0, 0, 0];
      }
    }
    for (int i = 0; i < cse4801.length; i++) {
      if (cse4801[i]['Supervisor'] != "") {
        teamAllocated[cse4801[i]['Supervisor']] = [0, 0, 0];
      }
    }
    if (cse3300 != null) {
      for (int i = 0; i < cse3300.length; i++) {
        if (cse3300[i]['Supervisor'] != "") {
          // print(cse3300[i]['Supervisor']);
          teamAllocated[cse3300[i]['Supervisor']]![0] += 1;
        }
      }
    }
    if (cse4800 != null) {
      for (int i = 0; i < cse4800.length; i++) {
        if (cse4800[i]['Supervisor'] != "") {
          // print(cse4800[i]['Supervisor']);
          teamAllocated[cse4800[i]['Supervisor']]![1] += 1;
        }
      }
    }

    if (cse4801 != null) {
      for (int i = 0; i < cse4801.length; i++) {
        if (cse4801[i]['Supervisor'] != "") {
          // print(cse4800[i]['Supervisor']);
          teamAllocated[cse4801[i]['Supervisor']]![2] += 1;
        }
      }
    }

    List<dynamic> keys = teamAllocated.keys.toList();
    await ProjectSheetApi.clearStatistics();
    for (var key in keys) {
      await ProjectSheetApi.addStatistics({
        "INITIAL": key,
        "CSE-3300": teamAllocated[key]?[0],
        "CSE-4800": teamAllocated[key]?[1],
        "CSE-4801": teamAllocated[key]?[2],
        "Total": teamAllocated[key]![0] + teamAllocated[key]![2] + teamAllocated[key]![1],
      });
    }

    teamAllocated.keys.toList().sort();
    // print(teamAllocated);
    setState(() {});
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: const Text("Charts"),
          centerTitle: true,
        ),
        body: teamAllocated.isNotEmpty
            ? Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "Total allocated team of each supervisor",
                    style:
                        TextStyle(fontSize: 14.sp, fontWeight: FontWeight.bold),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: 20.h),
                  Table(
                    // defaultVerticalAlignment: TableCellVerticalAlignment.middle,

                    border: TableBorder.all(),
                    children: [
                      TableRow(
                        children: [
                          Text(
                            "Initial",
                            style: TextStyle(
                                fontSize: 12.sp, fontWeight: FontWeight.bold),
                            textAlign: TextAlign.center,
                          ),
                          Text(
                            "CSE-3300",
                            style: TextStyle(
                                fontSize: 12.sp, fontWeight: FontWeight.bold),
                            textAlign: TextAlign.center,
                          ),
                          Text(
                            "CSE-4800",
                            style: TextStyle(
                                fontSize: 12.sp, fontWeight: FontWeight.bold),
                            textAlign: TextAlign.center,
                          ),
                          Text(
                            "CSE-4801",
                            style: TextStyle(
                                fontSize: 12.sp, fontWeight: FontWeight.bold),
                            textAlign: TextAlign.center,
                          ),
                          Text(
                            "Total",
                            style: TextStyle(
                                fontSize: 12.sp, fontWeight: FontWeight.bold),
                            textAlign: TextAlign.center,
                          ),
                        ],
                      ),
                      for (String initial in teamAllocated.keys.toList())
                        TableRow(children: [
                          Text(
                            initial,
                            style: TextStyle(
                                fontSize: 12.sp, fontWeight: FontWeight.bold),
                            textAlign: TextAlign.center,
                          ),
                          Text(
                            teamAllocated[initial]![0].toString(),
                            style: TextStyle(
                              fontSize: 12.sp,
                            ),
                            textAlign: TextAlign.center,
                          ),
                          Text(
                            teamAllocated[initial]![1].toString(),
                            style: TextStyle(
                              fontSize: 12.sp,
                            ),
                            textAlign: TextAlign.center,
                          ),
                          Text(
                            teamAllocated[initial]![2].toString(),
                            style: TextStyle(
                              fontSize: 12.sp,
                            ),
                            textAlign: TextAlign.center,
                          ),
                          Text(
                            "${teamAllocated[initial]![1] + teamAllocated[initial]![0] + teamAllocated[initial]![2]}",
                            style: TextStyle(
                              fontSize: 12.sp,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ]),
                    ],
                  ),
                ],
              )
            : const Center(
                child: CircularProgressIndicator(),
              ),
      ),
    );
  }
}
