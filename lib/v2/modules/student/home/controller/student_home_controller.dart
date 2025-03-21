import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:teamlead/v2/core/database/firebase_db/collection_name.dart';
import 'package:teamlead/v2/core/database/firebase_db/document_name.dart';
import 'package:teamlead/v2/core/database/firebase_db/firebase_handler.dart';

class StudentHomeController {
  static Stream<DocumentSnapshot<Map<String, dynamic>>> getProposalCredential() async* {
    yield* FirebaseHandler.fireStore
        .collection(CollectionName.admin)
        .doc(DocumentName.credential)
        .snapshots();
  }
}
