import 'package:bot_toast/bot_toast.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:teamlead/v2/core/database/firebase_db/collection_name.dart';
import 'package:teamlead/v2/core/database/firebase_db/firebase_handler.dart';
import 'package:teamlead/v2/modules/authentication/controller/user_controller.dart';
import 'package:teamlead/v2/modules/shared/marking/model/marking_model.dart';

class MarkingController extends GetxController {
  final UserController _userController = Get.find<UserController>();
  Future<void> addMark({
    required MarkingModel markingModel,
    required bool doesBoard,
    required String courseCode,
  }) async {
    try {
      String collectionName = doesBoard ? CollectionName.boardMark : CollectionName.supervisorMark;
      await FirebaseHandler.fireStore
          .collection(courseCode)
          .doc(markingModel.proposalTitle)
          .collection(collectionName)
          .doc(markingModel.evaluatedBy)
          .set(markingModel.toJson());
    } catch (e) {
      BotToast.showText(text: "Something went wrong");
    }
  }

  Stream<QuerySnapshot<Map<String, dynamic>>> getMarking({
    required bool doesBoard,
    required String title,
    required String courseCode,
  }) async* {

    // debug(title + " ${_userController.teacher.value.initial}");
    yield* FirebaseHandler.fireStore
        .collection(courseCode)
        .doc(title)
        .collection(doesBoard ? CollectionName.boardMark : CollectionName.supervisorMark)
        .where(FieldPath.documentId, isEqualTo: _userController.teacher.value.initial)
        .snapshots();
  }
}
