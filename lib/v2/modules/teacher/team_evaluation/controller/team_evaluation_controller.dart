// //
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:teamlead/v2/core/database/firebase_db/collection_name.dart';
import 'package:teamlead/v2/core/database/firebase_db/firebase_handler.dart';
import 'package:teamlead/v2/core/utils/logger/logger.dart';
import 'package:teamlead/v2/modules/authentication/controller/user_controller.dart';
import 'package:teamlead/v2/modules/student/proposal/model/proposal_model.dart';

class TeamEvaluationController extends GetxController {
  final UserController _userController = Get.find<UserController>();

  List<ProposalModel> searchTeams({
    required List<ProposalModel> allProposals,
    required searchKey,
  }) {
    List<ProposalModel> searchResult = [];
    for (ProposalModel proposal in allProposals) {
      if (proposal.title!.toLowerCase().contains(searchKey.toLowerCase())) {
        searchResult.add(proposal);
      } else if (proposal.supervisor!
          .toLowerCase()
          .contains(searchKey.text.trim().toLowerCase())) {
        searchResult.add(proposal);
      } else {
        for (Member member in proposal.members!) {
          if (member.studentId!.contains(searchKey)) {
            searchResult.add(proposal);
          } else if (member.name!.toLowerCase().contains(searchKey.toLowerCase())) {
            searchResult.add(proposal);
          }
        }
      }
    }
    return searchResult;
  }

  Stream<QuerySnapshot<Map<String, dynamic>>> getMarkedTeamsList({
    bool cse3300 = false,
    bool cse4800 = false,
    bool cse4801 = false,
    required bool doesEvaluation,
    required String title,
  }) async* {
    String collectionReference;
    if (cse3300) {
      collectionReference = CollectionName.cse3300;
    } else if (cse4800) {
      collectionReference = CollectionName.cse4800;
    } else {
      collectionReference = CollectionName.cse4801;
    }
    // debug(title + " ${_userController.teacher.value.initial}");
    yield* FirebaseHandler.fireStore
        .collection(collectionReference)
        .doc(title)
        .collection(doesEvaluation ? CollectionName.evaluationData : CollectionName.supervisorMark)
        .where(FieldPath.documentId, isEqualTo: _userController.teacher.value.initial)
        .snapshots();
  }
}
