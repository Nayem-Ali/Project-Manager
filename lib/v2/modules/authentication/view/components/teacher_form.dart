import 'package:bot_toast/bot_toast.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:teamlead/v2/core/data/static_data.dart';
import 'package:teamlead/v2/core/utils/logger/logger.dart';
import 'package:teamlead/v2/core/utils/validators/validators.dart';
import 'package:teamlead/v2/modules/authentication/controller/user_controller.dart';
import 'package:teamlead/v2/modules/authentication/model/enums.dart';
import 'package:teamlead/v2/modules/authentication/model/teacher_model.dart';
import 'package:teamlead/v2/modules/widgets/k_drop_down_button.dart';
import 'package:teamlead/v2/modules/widgets/k_text_field.dart';

class TeacherForm extends StatefulWidget {
  const TeacherForm({super.key, required this.user});

  final User user;

  @override
  State<TeacherForm> createState() => _TeacherFormState();
}

class _TeacherFormState extends State<TeacherForm> {
  final GlobalKey<FormState> _formState = GlobalKey<FormState>();

  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _initialController = TextEditingController();
  final TextEditingController _designationController = TextEditingController();

  final _userController = Get.find<UserController>();

  @override
  void initState() {
    _nameController.text = widget.user.displayName ?? "";
    _designationController.text = StaticData.designation.first;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formState,
      child: Column(
        children: [
          KTextField(
            controller: _nameController,
            labelText: "Full Name",
            textInputType: TextInputType.text,
            helperText: null,
            validator: Validators.nameValidator,
          ),
          KTextField(
            controller: _initialController,
            labelText: "Initial",
            textInputType: TextInputType.text,
            helperText: null,
            validator: Validators.initialValidator,
          ),
          KDropDownButton(
            controller: _designationController,
            items: StaticData.designation,
            initialSelection: StaticData.designation.first,
          ),
          SizedBox(
            width: Get.width,
            child: ElevatedButton.icon(
              onPressed: () async {
                BotToast.showLoading();
                if (_formState.currentState!.validate()) {
                  TeacherModel teacher = TeacherModel(
                    name: _nameController.text.trim(),
                    initial: _initialController.text.trim(),
                    designation: _designationController.text,
                    email: widget.user.email!,
                    role: Roles.teacher,
                    status: RequestStatus.pending,
                    cse3300: [],
                    cse4800: [],
                    cse4801: [],
                  );
                  bool response = await _userController.addUserData(userData: teacher);
                  BotToast.closeAllLoading();
                  if(response){
                    /// Get.offAllNamed(); [Go to Teacher Home]
                  }
                  debug(teacher.toJson());
                } else {

                }
              },
              icon: const Icon(Icons.forward),
              label: const Text("Continue"),
            ),
          ),
        ],
      ),
    );
  }
}
