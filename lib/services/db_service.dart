import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:teamlead/services/proposal_sheets_api.dart';

class DataBaseMethods {
  FirebaseFirestore firestore = FirebaseFirestore.instance;
  FirebaseAuth auth = FirebaseAuth.instance;

  addStudent(Map<String, dynamic> studentInfo) async {
    await firestore.collection("student").doc(auth.currentUser!.email).set(studentInfo);
  }

  getStudent() async {
    dynamic getStudentData = {};
    await firestore.collection("student").doc(auth.currentUser!.email).get().then((studentData) {
      getStudentData = studentData.data();
    });
    // print("Student: $getStudentData");
    return getStudentData;
  }

  getTeamData(String collectionID, String documentID) async {
    Map<String, dynamic>? getTeamData = {};
    try {
      await firestore.collection(collectionID).doc(documentID).get().then((teamData) {
        getTeamData = teamData.data();
      });
      return getTeamData;
    } catch (e) {
      print("Backend: $e");
      return getTeamData;
    }
  }

  addTeacher(Map<String, dynamic> teacherInfo) async {
    teacherInfo['email'] = auth.currentUser!.email;
    await firestore.collection("teacher").doc(auth.currentUser!.email).set(teacherInfo);
  }

  getTeacher() async {
    dynamic getTeacherData = {};
    await firestore.collection("teacher").doc(auth.currentUser!.email).get().then((teacherData) {
      getTeacherData = teacherData.data();
    });
    return getTeacherData;
  }

  addProposal(Map<String, String> teamInfo) async {
    await firestore.collection(teamInfo["projectType"]!).doc(teamInfo["title"]).set(teamInfo);

    // firestore
    //     .collection(teamInfo["projectType"]!)
    //     .doc(teamInfo["title"])
    //     .collection("evaluationData")
    //     .doc("pointBlank");
    await firestore.collection("student").doc(auth.currentUser!.email).update(
        {"title": teamInfo["title"], "projectType": teamInfo["projectType"], "submitted": "yes"});
  }

  wipeProposal(Map<String, dynamic> teamInfo) async {
    QuerySnapshot querySnapshot = await firestore
        .collection(teamInfo["projectType"]!)
        .doc(teamInfo["title"])
        .collection("evaluatedData")
        .get();
    querySnapshot.docs.clear();
    await firestore.collection(teamInfo["projectType"]!).doc(teamInfo["title"]).delete();
    await firestore
        .collection("student")
        .doc(auth.currentUser!.email)
        .update({"title": "", "submitted": "no"});
  }

  // updateDataAfterProposalSubmission(String id, String type) async {
  //   await firestore.collection("student").doc(auth.currentUser!.email).update({
  //     "PID": id,
  //     "projectType": type,
  //     "submitted": "yes",
  //   });
  // }

  addTeamRequest(Map<String, String> teamInfo) async {
    await firestore
        .collection("${teamInfo["projectType"]!}-request")
        .doc(teamInfo["title"])
        .set(teamInfo);

    await firestore.collection("student").doc(auth.currentUser!.email).update({
      "title": teamInfo["title"],
      "projectType": "${teamInfo["projectType"]!}-request",
      "submitted": "yes"
    });
  }

  // getProject1() async {
  //   dynamic project1 = [];
  //
  //   QuerySnapshot querySnapshot = await firestore.collection("CSE-3300").get();
  //
  //   // Get data from docs and convert map to List
  //   // project1=
  //   return querySnapshot.docs.map((doc) => doc.data()).toList();
  //   //  print(project1);
  //   // return project1;
  // }
  addAdmin(dynamic adminList) async {
    await firestore.collection("adminPanel").doc('admins').update({'emails': adminList});
  }

  getAdmin() async {
    List<dynamic> admins = [];
    await firestore.collection("adminPanel").doc("admins").get().then((teacherData) {
      admins = teacherData.data()?["emails"];
    });
    return admins;
  }

  submitEvaluation(List<Map<String, dynamic>> studentEvaluationData) async {
    print(studentEvaluationData);
    await firestore
        .collection(studentEvaluationData[0]['projectType'])
        .doc(studentEvaluationData[0]['title'])
        .collection("evaluationData")
        .doc(studentEvaluationData[0]['evaluatedBy'])
        .set({"data": studentEvaluationData});
  }

  getEvaluationID(String collectionName1, String documentName, String collectionName2) async {
    dynamic teachersID = [];
    try {
      QuerySnapshot querySnapshot = await firestore
          .collection(collectionName1)
          .doc(documentName)
          .collection(collectionName2)
          .get();

      // Get data from docs and convert map to List
      // project1=
      // print(querySnapshot.docs.map((doc) => doc.id).toList());
      teachersID = querySnapshot.docs.map((doc) => doc.id).toList();
      return teachersID;
    } catch (e) {
      return teachersID;
    }
    //  print(project1);
    // return project1;
  }

  getIndividualEvaluationData(String collectionName1, String documentName, String collectionName2,
      String documentName2) async {
    dynamic evaluatedData = {};

    await firestore
        .collection(collectionName1)
        .doc(documentName)
        .collection(collectionName2)
        .doc(documentName2)
        .get()
        .then((value) {
      evaluatedData = value.data();
    });
    return evaluatedData;
  }

  getEvaluationData(String collection1, String document1, String collection2) async {
    try {
      QuerySnapshot querySnapshot =
      await firestore.collection(collection1).doc(document1).collection(collection2).get();
      return querySnapshot.docs.map((doc) => doc.data()).toList();
    } catch (e) {
      return [];
    }
  }

  getAllSupervisorInitial() async {
    dynamic teacherList = [];
    List<String> initials = [];

    QuerySnapshot querySnapshot = await firestore.collection('teacher').get();

    // Get data from docs and convert map to List
    // project1=
    teacherList = querySnapshot.docs.map((doc) => doc.data()).toList();

    for (var teacher in teacherList) {
      if (teacher['status'] == 'approved') initials.add(teacher['initial']);
    }
    return initials;
  }

  assignSupervisor(String collectionName, String documentName, String supervisor) async {
    await firestore
        .collection(collectionName)
        .doc(documentName)
        .update({"isAssigned": supervisor});
    // dynamic teacherList = [];
    //
    //
    // QuerySnapshot querySnapshot = await firestore.collection('teacher').get();
    //
    // // Get data from docs and convert map to List
    // // project1=
    // teacherList = querySnapshot.docs.map((doc) => doc.data()).toList();
    //
    // for(var teacher in teacherList){
    //   if(teacher['initial'] == supervisor){
    //     await firestore.collection('teacher').doc(teacher['email']).collection(collectionName)
    //         .doc(documentName).update({
    //
    //     });
    //   }
    // }
  }

  // getMyTeams(String collectionName) async {
  //   dynamic myData = await getTeacher();
  //   String myInitial = myData['initial'];
  //   dynamic teamList = [];
  //   dynamic myTeams = [];
  //   QuerySnapshot querySnapshot = await firestore.collection(collectionName).get();
  //   teamList = querySnapshot.docs.map((doc) => doc.data());
  //
  //   for (var team in teamList) {
  //     if (team['isAssigned'] == myInitial) {
  //       myTeams.add(team);
  //     }
  //   }
  //   return myTeams;
  // }

  getTeamMark(String collectionName, String docName) async {
    dynamic allMarks = [];

    QuerySnapshot querySnapshot =
    await firestore.collection(collectionName).doc(docName).collection("evaluationData").get();
    allMarks = querySnapshot.docs.map((doc) => doc.data()).toList();
    return allMarks;
  }

  getAllTeacherData() async {
    dynamic allTeacherData = [];
    QuerySnapshot querySnapshot = await firestore.collection("teacher").get();
    allTeacherData = querySnapshot.docs.map((doc) => doc.data()).toList();
    return allTeacherData;
  }

  approveTeacher(String docName, String updatedData) async {
    await firestore.collection('teacher').doc("$docName").update({"status": updatedData});
  }

  getAllTeacherEmail() async {
    dynamic emails = [];
    QuerySnapshot querySnapshot = await firestore.collection('teacher').get();
    emails = querySnapshot.docs.map((doc) => doc.id).toList();
    return emails;
  }

  moveData() async {
    dynamic all4800data = [];
    QuerySnapshot querySnapshot = await firestore.collection('CSE-4800').get();
    await deleteProposal('CSE-4801');
    all4800data = querySnapshot.docs.map((e) => e.data()).toList();

    for (var data in all4800data) {
      await firestore.collection('CSE-4801').doc(data['title']).set(data);
      // await firestore
      //     .collection('CSE-4801')
      //     .doc(data['title'])
      //     .collection('evaluationData')
      //     .doc()
      //     .set({"data": []});
      print(data);
    }
    // querySnapshot.docs.map((document) async {
    //   print(document.data());
    //   // final temp = docoument.data();
    //   // await firestore.collection('CSE-4801').doc(docoument.id).set(temp[0]);
    // });
  }

  deleteProposal(String type) async {
    final cse4801 = await ProjectSheetApi.getAllRows(type);
    print(cse4801);
    if(cse4801 != null){
      for (var team in cse4801) {
        await firestore
            .collection(type)
            .doc(team['Title'])
            .collection('evaluationData')
            .get()
            .then((snapshot) {
          for (DocumentSnapshot ds in snapshot.docs) {
            ds.reference.delete();
          }
        });
        await firestore.collection(type).doc(team['Title']).delete();
      }
    }
  }

  addProposalCredential(Map<String, dynamic> credentials) async {
    await firestore.collection('adminPanel').doc('credentials').set(credentials);
  }

  updateProposalCredential(Map<String, dynamic> data) async {
    await firestore.collection('adminPanel').doc('credentials').update(data);
  }

  getProposalCredential() async {
    dynamic data = {};
    await firestore.collection('adminPanel').doc('credentials').get().then((value) {
      data = value.data();
    });
    return data;
  }

  getAllProposalData(String collectionName) async {
    QuerySnapshot querySnapshot = await firestore.collection(collectionName).get();
    return querySnapshot.docs.map((e) => e.id).toList();
  }

  addMergedTeamData(String collectionName, String docName, Map<String, dynamic> teamInfo) async {
    await firestore.collection(collectionName).doc(docName).set(teamInfo);
  }

  publishAnnouncement(Map<String, String> announcement) async {
    await firestore.collection("Announcement").doc(announcement['subject']).set(announcement);
  }

  getAnnouncement() async {
    dynamic announcement = [];
    try {
      QuerySnapshot querySnapshot = await firestore.collection("Announcement").get();
      announcement = querySnapshot.docs.map((doc) => doc.data()).toList();
      return announcement;
    } catch (e) {
      return announcement;
    }
  }

  deleteAnnouncement() async {}

  getAllStudentEmail() async {
    QuerySnapshot querySnapshot = await firestore.collection("student").get();
    return querySnapshot.docs.map((doc) => doc.id).toList();
  }

  addSupervisorMark(String projectType,Map<String, dynamic> teamInfo, List<dynamic> marks) async {
    dynamic teacherData = await getTeacher();
    firestore
        .collection(projectType)
        .doc(teamInfo['Title'])
        .collection("supervisorMark")
        .doc(teacherData['initial'])
        .set({"data": marks});
  }

  updateSupervisorMark() async {}

  getSupervisorMark(String projectType,Map<String, dynamic> teamInfo) async {
    dynamic marks = [];
    dynamic teacherData = await getTeacher();
    try {
      await firestore.collection(projectType).doc(teamInfo['Title']).collection
        ('supervisorMark').doc(teacherData['initial']).get().then((value) {
        marks = value['data'];
      });
      return marks;
    } catch (e){
      return [];
    }
  }

  getSupervisorMarkForGenerateResult(String projectType, String title) async{
    dynamic marks = [];
    try {
      QuerySnapshot querySnapshot = await firestore.collection(projectType).doc(title).collection
        ('supervisorMark').get();
      marks = querySnapshot.docs[0].get('data');
      return marks;
    } catch (e){
      return [];
    }
  }
}
