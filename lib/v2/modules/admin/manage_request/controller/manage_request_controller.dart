
import 'package:bot_toast/bot_toast.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:teamlead/v2/core/database/firebase_db/collection_name.dart';
import 'package:teamlead/v2/core/database/firebase_db/firebase_handler.dart';
import 'package:teamlead/v2/modules/authentication/model/enums.dart';
import 'package:teamlead/v2/modules/authentication/model/teacher_model.dart';

class ManageRequestController extends GetxController {
  Stream<QuerySnapshot<Map<String, dynamic>>> getAllRequestedTeacher() async* {
    yield* FirebaseHandler.fireStore
        .collection(CollectionName.teacher)
        .where('status', isEqualTo: RequestStatus.pending.name)
        .snapshots();
  }

  Stream<QuerySnapshot<Map<String, dynamic>>> getAllRejectedTeacher() async* {
    yield* FirebaseHandler.fireStore
        .collection(CollectionName.teacher)
        .where('status', isEqualTo: RequestStatus.rejected.name)
        .snapshots();
  }

  Future<void> updateStatus({required TeacherModel newTeacher}) async {
    try {
      await FirebaseHandler.fireStore
          .collection(CollectionName.teacher)
          .doc(newTeacher.email)
          .set(newTeacher.toJson());
      BotToast.showText(text: "Request Status Updated Successfully");
    } catch (e) {
      rethrow;
    }
  }

  Future<void> deleteRequest({required TeacherModel newTeacher}) async {
    try {
      await FirebaseHandler.fireStore
          .collection(CollectionName.teacher)
          .doc(newTeacher.email)
          .delete();
      BotToast.showText(text: "Request Deletion is Successfully Done");
    } catch (e) {
      rethrow;
    }
  }
}