import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:teamlead/v2/core/database/firebase_db/collection_name.dart';
import 'package:teamlead/v2/core/database/firebase_db/document_name.dart';
import 'package:teamlead/v2/core/database/firebase_db/firebase_handler.dart';
import 'package:teamlead/v2/modules/admin/proposal_setting/model/proposal_setting_model.dart';

class ProposalSettingController extends GetxController {
  Stream<DocumentSnapshot<Map<String, dynamic>>> getProposalSetting() async* {
    yield* FirebaseHandler.fireStore
        .collection(CollectionName.admin)
        .doc(DocumentName.credential)
        .snapshots();
  }

  void updateSetting({required ProposalSettingModel setting}) async {
    try {
      FirebaseHandler.fireStore
          .collection(CollectionName.admin)
          .doc(DocumentName.credential)
          .set(setting.toJson());
    } catch (e) {
      rethrow;
    }
  }
}
