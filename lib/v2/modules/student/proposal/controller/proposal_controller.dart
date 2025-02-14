import 'package:bot_toast/bot_toast.dart';
import 'package:device_preview/device_preview.dart';
import 'package:get/get.dart';
import 'package:teamlead/v2/core/api/google_sheet_api/proposal_sheet_api.dart';
import 'package:teamlead/v2/core/database/firebase_db/collection_name.dart';
import 'package:teamlead/v2/core/database/firebase_db/document_name.dart';
import 'package:teamlead/v2/core/database/firebase_db/firebase_handler.dart';
import 'package:teamlead/v2/core/utils/logger/logger.dart';
import 'package:teamlead/v2/modules/student/proposal/model/proposal_model.dart';
import 'package:teamlead/v2/modules/student/student_home/model/proposal_credential_model.dart';

class ProposalController extends GetxController {
  Rx<ProposalModel> proposal = Rx<ProposalModel>(ProposalModel());
  RxList<ProposalModel> allProposal = RxList<ProposalModel>([]);
  Rx<bool> doesDeadlineOver = Rx<bool>(false);
  final ProposalSheetAPI proposalSheetAPI = Get.find<ProposalSheetAPI>();

  void submitProposal({required ProposalModel proposal, required bool cse3300}) async {
    try {
      if (cse3300) {
        if (proposal.totalMembers! > 2) {
          debug(proposalSheetAPI.cse4800);
          final lastRow = await proposalSheetAPI.cse3300!.values.lastRow();
          proposal.id = (int.tryParse(lastRow!.first) ?? 0) + 1;
          debug("CSE-3300: ${proposal.toColumnData()}");
          await proposalSheetAPI.cse3300?.values.map.appendRow(proposal.toColumnData());
          debug("Data Added");
        } else {
          final lastRow = await proposalSheetAPI.teamRequest3300?.values.lastRow();
          proposal.id = int.tryParse(lastRow!.first) ?? 0 + 1;
          debug("CSE-3300 tr: ${proposal.toColumnData()}");
          proposalSheetAPI.teamRequest3300?.values.map.appendRow(proposal.toColumnData());
        }
      } else {
        if (proposal.totalMembers! > 2) {
          final lastRow = await proposalSheetAPI.cse4800?.values.lastRow();
          proposal.id = int.tryParse(lastRow!.first) ?? 0 + 1;
          debug("CSE-4800: ${proposal.toColumnData()}");
          proposalSheetAPI.cse4800?.values.map.appendRow(proposal.toColumnData());
        } else {
          final lastRow = await proposalSheetAPI.teamRequest4800?.values.lastRow();
          proposal.id = int.tryParse(lastRow!.first) ?? 0 + 1;
          debug("CSE-4800 tr: ${proposal.toColumnData()}");
          proposalSheetAPI.teamRequest4800?.values.map.appendRow(proposal.toColumnData());
        }
      }
      BotToast.showText(text: "Proposal Submitted Successfully");
    } catch (e) {
      debug("Error in submitting proposal $e");
      BotToast.showText(text: "Something went wrong. Try again later.");
    }
  }

  Future<void> fetchAllProposals({
    bool cse3300 = false,
    bool cse4800 = false,
    bool cse4801 = false,
    bool request3300 = false,
    bool request4800 = false,
  }) async {
    try {
      debug("$cse3300 $cse4800 $cse4801");
      List<Map<String, String>>? rawData;
      allProposal.clear();
      if (cse3300) {
        rawData = await proposalSheetAPI.cse3300!.values.map.allRows();
        allProposal.value = rawData == null
            ? []
            : rawData.map((proposal) => ProposalModel.fromColumn(proposal)).toList();
      } else if (cse4800) {
        rawData = await proposalSheetAPI.cse4800!.values.map.allRows();
        allProposal.value = rawData == null
            ? []
            : rawData.map((proposal) => ProposalModel.fromColumn(proposal)).toList();
      } else if (cse4801) {
        debug("CSE 4801");
        rawData = await proposalSheetAPI.cse4801!.values.map.allRows();
        allProposal.value = rawData == null
            ? []
            : rawData.map((proposal) => ProposalModel.fromColumn(proposal)).toList();
      } else if (request3300) {
        debug("Request 3300");
        rawData = await proposalSheetAPI.teamRequest3300!.values.map.allRows();
        allProposal.value = rawData == null
            ? []
            : rawData.map((proposal) => ProposalModel.fromColumn(proposal)).toList();
      } else if (request4800) {
        debug("Request 4800");
        rawData = await proposalSheetAPI.teamRequest4800!.values.map.allRows();
        allProposal.value = rawData == null
            ? []
            : rawData.map((proposal) => ProposalModel.fromColumn(proposal)).toList();
      }
    } catch (e) {
      debug("Fetching all proposal error: $e");
    }
  }

  Future<bool> filterMyProposal({
    required String studentId,
    bool cse3300 = false,
    bool cse4800 = false,
    bool cse4801 = false,
    bool request3300 = false,
    bool request4800 = false,
  }) async {
    debug("Student ID $studentId");
    BotToast.showLoading();
    await fetchAllProposals(
      cse3300: cse3300,
      cse4800: cse4800,
      cse4801: cse4801,
      request3300: request3300,
      request4800: request4800,
    );
    for (ProposalModel proposalModel in allProposal) {
      for (Member member in proposalModel.members!) {
        if (member.studentId == studentId) {
          proposal.value = proposalModel;
          debug("Found ${proposal.value.toJson()}");
          BotToast.closeAllLoading();
          return true;
        }
      }
    }
    BotToast.closeAllLoading();
    return false;
  }

  checkDeadlineStatus() async {
     final credential = await FirebaseHandler.fireStore
        .collection(CollectionName.admin)
        .doc(DocumentName.credential).get();
     final credentialModel = ProposalCredentialModel.fromJson(credential.data() ?? {});
     doesDeadlineOver.value = credentialModel.deadline.isBefore(DateTime.now());
     debug("Deadline status: ${doesDeadlineOver.value}");
  }


}
