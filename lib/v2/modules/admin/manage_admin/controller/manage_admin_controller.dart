import 'package:bot_toast/bot_toast.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:teamlead/v2/core/database/firebase_db/collection_name.dart';
import 'package:teamlead/v2/core/database/firebase_db/firebase_handler.dart';
import 'package:teamlead/v2/modules/authentication/model/enums.dart';
import 'package:teamlead/v2/modules/authentication/model/teacher_model.dart';

class ManageAdminController extends GetxController {
  Stream<QuerySnapshot<Map<String, dynamic>>> getAllAdmin() async* {
    yield* FirebaseHandler.fireStore
        .collection(CollectionName.teacher)
        .where('role', isEqualTo: Roles.admin.name)
        .snapshots();
  }

  Stream<QuerySnapshot<Map<String, dynamic>>> getAllTeacher() async* {
    yield* FirebaseHandler.fireStore
        .collection(CollectionName.teacher)
        .where('status', isEqualTo: RequestStatus.approved.name)
        .snapshots();
  }

  Future<void> updateRole({required TeacherModel newAdmin}) async {
    try {
      await FirebaseHandler.fireStore
          .collection(CollectionName.teacher)
          .doc(newAdmin.email)
          .set(newAdmin.toJson());
      BotToast.showText(text: "Action completed successfully");
    } catch (e) {
      rethrow;
    }
  }
}
