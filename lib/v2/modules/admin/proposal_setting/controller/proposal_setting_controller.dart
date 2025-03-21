import 'dart:io';

import 'package:bot_toast/bot_toast.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';
import 'package:syncfusion_flutter_xlsio/xlsio.dart';
import 'package:teamlead/v2/core/database/firebase_db/collection_name.dart';
import 'package:teamlead/v2/core/database/firebase_db/document_name.dart';
import 'package:teamlead/v2/core/database/firebase_db/firebase_handler.dart';
import 'package:teamlead/v2/core/utils/data_formatting/proposal_formatting.dart';
import 'package:teamlead/v2/modules/admin/proposal_setting/model/proposal_setting_model.dart';
import 'package:teamlead/v2/modules/student/proposal/controller/proposal_controller.dart';

class ProposalSettingController extends GetxController {
  final _proposalController = Get.find<ProposalController>();
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

  void formatProposal() async {
    final Workbook proposalBook = Workbook();
    final Worksheet cse3300 = proposalBook.worksheets.add(); // Adding new worksheet
    final Worksheet cse4800 = proposalBook.worksheets.add();
    final Worksheet cse4801 = proposalBook.worksheets.add();
    final Worksheet request3300 = proposalBook.worksheets.add();
    final Worksheet request4800 = proposalBook.worksheets.add();
    cse3300.name = "CSE-3300";
    cse4800.name = "CSE-4800";
    cse4801.name = "CSE-4801";
    request3300.name = "CSE-3300-team-request";
    request4800.name = "CSE-4800-team-request";
    BotToast.showLoading();
    await _proposalController.fetchAllProposals(cse3300: true);
    ProposalFormatting()
        .addAllData(proposals: _proposalController.allProposal, sheet: cse3300, workbook: proposalBook);
    await _proposalController.fetchAllProposals(cse4800: true);
    ProposalFormatting()
        .addAllData(proposals: _proposalController.allProposal, sheet: cse4800, workbook: proposalBook);
    await _proposalController.fetchAllProposals(cse4801: true);
    ProposalFormatting()
        .addAllData(proposals: _proposalController.allProposal, sheet: cse4801, workbook: proposalBook);
    await _proposalController.fetchAllProposals(request3300: true);
    ProposalFormatting()
        .addAllData(proposals: _proposalController.allProposal, sheet: request3300, workbook: proposalBook);
    await _proposalController.fetchAllProposals(request4800: true);
    ProposalFormatting()
        .addAllData(proposals: _proposalController.allProposal, sheet: request4800, workbook: proposalBook);
    BotToast.closeAllLoading();
    final List<int> bytes = proposalBook.saveAsStream();
    final Directory directory = await getApplicationDocumentsDirectory();
    final filePath = "${directory.path}/Proposal.xlsx";
    final file = File(filePath);
    await file.writeAsBytes(bytes);

    final xFile = XFile(file.path);

    // Share the file
    await Share.shareXFiles([xFile], text: 'Here is your Excel file!');

    proposalBook.dispose();


  }
}
