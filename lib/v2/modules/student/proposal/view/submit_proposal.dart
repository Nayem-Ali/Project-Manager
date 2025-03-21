import 'package:bot_toast/bot_toast.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_expandable_fab/flutter_expandable_fab.dart';
import 'package:get/get.dart';
import 'package:teamlead/v2/core/utils/constant/google_worksheet_titles.dart';
import 'package:teamlead/v2/core/utils/logger/logger.dart';
import 'package:teamlead/v2/core/utils/validators/validators.dart';
import 'package:teamlead/v2/modules/admin/proposal_setting/controller/proposal_setting_controller.dart';
import 'package:teamlead/v2/modules/authentication/controller/user_controller.dart';
import 'package:teamlead/v2/modules/authentication/model/teacher_model.dart';
import 'package:teamlead/v2/modules/student/proposal/controller/proposal_controller.dart';
import 'package:teamlead/v2/modules/student/proposal/model/proposal_model.dart';
import 'package:teamlead/v2/modules/student/student_home/model/proposal_credential_model.dart';
import 'package:teamlead/v2/modules/widgets/k_data_validation_info.dart';
import 'package:teamlead/v2/modules/widgets/k_text_field.dart';
import 'package:teamlead/v2/modules/widgets/k_option_button.dart';

class SubmitProposal extends StatefulWidget {
  const SubmitProposal({super.key, required this.doesRequest});

  final bool doesRequest;

  @override
  State<SubmitProposal> createState() => _SubmitProposalState();
}

class _SubmitProposalState extends State<SubmitProposal> {
  final GlobalKey<FormState> _formState = GlobalKey<FormState>();
  final RxList<TextEditingController> _name = RxList([]);
  final RxList<TextEditingController> _studentId = RxList([]);
  final RxList<TextEditingController> _cgpa = RxList([]);
  final RxList<TextEditingController> _email = RxList([]);
  final RxList<TextEditingController> _mobile = RxList([]);
  final TextEditingController _title = TextEditingController();
  final TextEditingController _proposal = TextEditingController();
  Rx<bool> cse3300 = Rx<bool>(true);
  Rx<bool> cse4800 = Rx<bool>(false);
  Rx<bool> doesFound = Rx<bool>(false);
  bool doesPreference = false;
  Rx<int> totalMembers = Rx<int>(0);
  RxList<String> teachers = RxList([]);
  RxList<String> preference = RxList(["S1", "S2", "S3"]);
  int maxTeamMember = 0;

  final _proposalController = Get.find<ProposalController>();
  final _userController = Get.find<UserController>();
  final _settingController = Get.find<ProposalSettingController>();

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
      totalMembers.value = widget.doesRequest ? 1 : 3;
      maxTeamMember = widget.doesRequest ? 2 : 4;

      for (int i = 0; i < totalMembers.value; i++) {
        _name.add(TextEditingController());
        _studentId.add(TextEditingController());
        _cgpa.add(TextEditingController());
        _email.add(TextEditingController());
        _mobile.add(TextEditingController());
      }
      teachers.value = await _proposalController.getAllTeachersInitial();
      teachers.sort();
      preference[0] = teachers.first;
      preference[1] = teachers[1];
      preference[2] = teachers[2];
      if (widget.doesRequest) {
        _proposalController.fetchAllProposals(request3300: cse3300.value);
      } else {
        _proposalController.fetchAllProposals(cse3300: cse3300.value);
      }
      Future.delayed(const Duration(seconds: 2));
      await checkProposalSubmission();
    });
    super.initState();
  }

  Future<void> checkProposalSubmission() async {
    if (widget.doesRequest) {
      doesFound.value = await _proposalController.filterMyProposal(
        studentId: _userController.student.value.id!,
        request3300: cse3300.value,
        request4800: cse4800.value,
      );
    } else {
      doesFound.value = await _proposalController.filterMyProposal(
        studentId: _userController.student.value.id!,
        cse3300: cse3300.value,
        cse4800: cse4800.value,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Submit Proposal"),
        centerTitle: true,
        actions: [
          IconButton(
            onPressed: () {
              Get.bottomSheet(
                KDataValidationInfoWidget(),
              );
            },
            icon: const Icon(Icons.info_outline),
          )
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Obx(
            () => Padding(
              padding: const EdgeInsets.all(8.0),
              child: Form(
                key: _formState,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Row(
                      children: [
                        const Text("Course Code: "),
                        OptionButton(
                          onPressed: () async {
                            cse3300.value = true;
                            cse4800.value = false;
                            if (widget.doesRequest) {
                              _proposalController.fetchAllProposals(request3300: cse3300.value);
                            } else {
                              _proposalController.fetchAllProposals(cse3300: cse3300.value);
                            }
                            Future.delayed(const Duration(seconds: 2));
                            await checkProposalSubmission();
                          },
                          optionName: WorksheetTitles.cse3300,
                          doesFocus: cse3300.value,
                        ),
                        OptionButton(
                          onPressed: () async {
                            cse4800.value = true;
                            cse3300.value = false;
                            if (widget.doesRequest) {
                              _proposalController.fetchAllProposals(request4800: cse4800.value);
                            } else {
                              _proposalController.fetchAllProposals(cse4800: cse4800.value);
                            }
                            Future.delayed(const Duration(seconds: 2));
                            await checkProposalSubmission();
                          },
                          optionName: WorksheetTitles.cse4800,
                          doesFocus: cse4800.value,
                        )
                      ],
                    ),
                    KTextField(
                      controller: _title,
                      labelText: "Project or Thesis Title",
                      textInputType: TextInputType.text,
                      helperText: null,
                      validator: Validators.nonEmptyValidator,
                    ),
                    KTextField(
                      controller: _proposal,
                      labelText: "Proposal Google Drive Link",
                      textInputType: TextInputType.text,
                      helperText: "Before share the link. Give view access to anyone with link",
                      validator: Validators.nonEmptyValidator,
                    ),
                    if (teachers.isNotEmpty)
                      StreamBuilder(
                        stream: _settingController.getProposalSetting(),
                        builder: (context, snapshot) {
                          if (snapshot.hasData) {
                            ProposalCredentialModel credential = ProposalCredentialModel.fromJson(
                              snapshot.data?.data() ?? {},
                            );
                            if (!credential.isPreference) {
                              return const SizedBox.shrink();
                            }
                            doesPreference = credential.isPreference;
                            return Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                // First Dropdown
                                Expanded(
                                  child: DropdownButtonFormField<String>(
                                    value: preference[0],
                                    decoration: const InputDecoration(
                                      border: OutlineInputBorder(),
                                    ),
                                    items: teachers.map((String value) {
                                      return DropdownMenuItem(
                                        value: value,
                                        child: Text(value),
                                      );
                                    }).toList(),
                                    onChanged: (newValue) {
                                      preference[0] = newValue!;
                                    },
                                  ),
                                ),
                                SizedBox(width: 10),

                                // Second Dropdown
                                Expanded(
                                  child: DropdownButtonFormField<String>(
                                    value: preference[1],
                                    decoration: const InputDecoration(
                                      border: OutlineInputBorder(),
                                    ),
                                    items: teachers.map((String value) {
                                      return DropdownMenuItem(
                                        value: value,
                                        child: Text(value),
                                      );
                                    }).toList(),
                                    onChanged: (newValue) {
                                      preference[0] = newValue!;
                                    },
                                  ),
                                ),
                                SizedBox(width: 10),

                                // Third Dropdown
                                Expanded(
                                  child: DropdownButtonFormField<String>(
                                    value: preference[2],
                                    decoration: const InputDecoration(
                                      border: OutlineInputBorder(),
                                    ),
                                    items: teachers.map((String value) {
                                      return DropdownMenuItem(
                                        value: value,
                                        child: Text(value),
                                      );
                                    }).toList(),
                                    onChanged: (newValue) {
                                      preference[2] = newValue!;
                                    },
                                  ),
                                ),
                              ],
                            );
                          } else {
                            return const SizedBox.shrink();
                          }
                        },
                      ),
                    ListView.builder(
                      physics: const NeverScrollableScrollPhysics(),
                      shrinkWrap: true,
                      itemCount: totalMembers.value,
                      itemBuilder: (context, index) {
                        return Card(
                          child: Padding(
                            padding: const EdgeInsets.all(4.0),
                            child: ExpansionTile(
                              title: Text("Details of Member - ${index + 1}"),
                              maintainState: true,
                              initiallyExpanded: false,
                              children: [
                                KTextField(
                                  controller: _name[index],
                                  labelText: "Name",
                                  textInputType: TextInputType.text,
                                  helperText: null,
                                  validator: Validators.nameValidator,
                                ),
                                Row(
                                  children: [
                                    Flexible(
                                      child: KTextField(
                                        controller: _studentId[index],
                                        labelText: "Student ID",
                                        textInputType: TextInputType.number,
                                        helperText: null,
                                        validator: Validators.idValidation,
                                      ),
                                    ),
                                    Flexible(
                                      child: KTextField(
                                        controller: _cgpa[index],
                                        labelText: "CGPA",
                                        textInputType: TextInputType.number,
                                        helperText: null,
                                        validator: Validators.cgpaValidator,
                                      ),
                                    ),
                                  ],
                                ),
                                KTextField(
                                  controller: _email[index],
                                  labelText: "Email",
                                  textInputType: TextInputType.text,
                                  helperText: null,
                                  validator: Validators.emailValidator,
                                ),
                                KTextField(
                                  controller: _mobile[index],
                                  labelText: "Mobile",
                                  textInputType: TextInputType.text,
                                  helperText: null,
                                  validator: Validators.numberValidator,
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                    if (doesFound.value)
                      SizedBox(
                        height: Get.height * 0.06,
                        child: Card(
                          color: Theme.of(context).colorScheme.errorContainer,
                          elevation: 3,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                "Proposal Already Submitted for "
                                "${cse3300.value ? "CSE - 3300" : "CSE - 4800"}",
                                style: Theme.of(context).textTheme.titleSmall,
                              ),
                            ],
                          ),
                        ),
                      )
                    else
                      SizedBox(
                        height: Get.height * 0.06,
                        width: Get.width,
                        child: ElevatedButton.icon(
                          onPressed: () async {
                            bool doesSameTitle = false;
                            await _proposalController.checkDeadlineStatus();
                            for (ProposalModel proposal in _proposalController.allProposal) {
                              if (proposal.title?.toLowerCase() ==
                                  _title.text.trim().toLowerCase()) {
                                doesSameTitle = true;
                                break;
                              }
                            }
                            debug(
                                "Proposal Submission: ${_proposalController.doesDeadlineOver.value}");
                            if (_proposalController.doesDeadlineOver.value) {
                              BotToast.showText(text: "Deadline is over");
                            } else if (doesSameTitle) {
                              BotToast.showText(
                                text: "Try again. Title has taken by another team.",
                                duration: const Duration(seconds: 5),
                              );
                            } else if (_formState.currentState!.validate()) {
                              List<Member> members = [];
                              for (int i = 0; i < totalMembers.value; i++) {
                                Member member = Member(
                                  name: _name[i].text.trim(),
                                  studentId: _studentId[i].text.trim(),
                                  cgpa: double.parse(_cgpa[i].text.trim()),
                                  email: _email[i].text.trim(),
                                  mobile: _mobile[i].text.trim(),
                                );
                                members.add(member);
                              }
                              if (_title.text.contains("/")) {
                                _title.text = _title.text.replaceAll("/", "|");
                              }
                              ProposalModel proposalModel = ProposalModel(
                                title: _title.text.trim(),
                                proposal: _proposal.text.trim(),
                                members: members,
                                totalMembers: totalMembers.value,
                                supervisor: "",
                                preference: doesPreference ? preference.join(",") : "",
                              );
                              await _proposalController.checkDeadlineStatus();
                              if (_proposalController.doesDeadlineOver.value) {
                                BotToast.showText(text: "Deadline is over");
                              } else {
                                _proposalController.submitProposal(
                                  proposal: proposalModel,
                                  cse3300: cse3300.value,
                                );
                                Get.back();
                              }
                            } else {
                              BotToast.showText(text: "Some data might be mal-formated");
                            }
                          },
                          icon: const Icon(CupertinoIcons.location),
                          label: Text(
                            "Submit",
                            style: Theme.of(context)
                                .textTheme
                                .headlineSmall
                                ?.copyWith(color: Colors.white),
                          ),
                        ),
                      )
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
      floatingActionButtonLocation: ExpandableFab.location,
      floatingActionButton: ExpandableFab(
        type: ExpandableFabType.fan,
        distance: 70,
        children: [
          FloatingActionButton.small(
            heroTag: null,
            onPressed: () {
              if (totalMembers.value < maxTeamMember) {
                totalMembers.value += 1;
                _name.add(TextEditingController());
                _studentId.add(TextEditingController());
                _cgpa.add(TextEditingController());
                _email.add(TextEditingController());
                _mobile.add(TextEditingController());
              } else {
                BotToast.showText(text: "No more than $maxTeamMember members allowed");
              }
            },
            backgroundColor: Colors.green,
            child: const Icon(Icons.add),
          ),
          FloatingActionButton.small(
            heroTag: null,
            onPressed: () {
              if (totalMembers.value > maxTeamMember - 1) {
                totalMembers.value -= 1;
                _name.last.dispose();
                _studentId.last.dispose();
                _cgpa.last.dispose();
                _email.last.dispose();
                _mobile.last.dispose();
                _name.removeLast();
                _studentId.removeLast();
                _cgpa.removeLast();
                _email.removeLast();
                _mobile.removeLast();
              } else {
                BotToast.showText(
                    text: "Must have ${maxTeamMember - 1} member(s) to submit proposal");
              }
            },
            backgroundColor: Colors.red,
            child: const Icon(Icons.remove),
          ),
        ],
      ),
    );
  }
}
