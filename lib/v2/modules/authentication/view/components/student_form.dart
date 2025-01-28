import 'package:bot_toast/bot_toast.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:teamlead/v2/core/data/static_data.dart';
import 'package:teamlead/v2/core/route/route_name.dart';
import 'package:teamlead/v2/core/utils/logger/logger.dart';
import 'package:teamlead/v2/core/utils/validators/validators.dart';
import 'package:teamlead/v2/modules/authentication/controller/user_controller.dart';
import 'package:teamlead/v2/modules/authentication/model/enums.dart';
import 'package:teamlead/v2/modules/authentication/model/student_model.dart';
import 'package:teamlead/v2/modules/widgets/k_drop_down_button.dart';
import 'package:teamlead/v2/modules/widgets/k_text_field.dart';

class StudentForm extends StatefulWidget {
  const StudentForm({super.key, required this.user});

  final User user;

  @override
  State<StudentForm> createState() => _StudentFormState();
}

class _StudentFormState extends State<StudentForm> {
  final GlobalKey<FormState> _formState = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _idController = TextEditingController();
  final TextEditingController _batchController = TextEditingController();
  final TextEditingController _sectionController = TextEditingController();

  final _userController = Get.find<UserController>();

  @override
  void initState() {
    _nameController.text = widget.user.displayName ?? "";
    _sectionController.text = StaticData.section.first;
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
            controller: _idController,
            labelText: "Student ID",
            textInputType: TextInputType.text,
            helperText: null,
            validator: Validators.idValidation,
          ),
          Row(
            children: [
              Flexible(
                child: KTextField(
                  controller: _batchController,
                  labelText: "Batch",
                  textInputType: TextInputType.text,
                  helperText: null,
                  validator: Validators.nonEmptyValidator,
                ),
              ),
              Flexible(
                  child: KDropDownButton(
                controller: _sectionController,
                items: StaticData.section,
                initialSelection: StaticData.section.first,
              )),
            ],
          ),
          SizedBox(
            width: Get.width,
            child: ElevatedButton.icon(
              onPressed: () async {
                BotToast.showLoading();
                if (_formState.currentState!.validate()) {
                  StudentModel student = StudentModel(
                    name: _nameController.text.trim(),
                    id: _idController.text.trim(),
                    email: widget.user.email!,
                    section: _sectionController.text,
                    batch: _batchController.text.trim(),
                    role: Roles.student,
                  );
                  bool response = await _userController.addUserData(userData: student);
                  BotToast.closeAllLoading();
                  if(response){
                     Get.offAllNamed(RouteName.studentHome, arguments: student);
                  }
                  debug(student.toJson());
                } else {}
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
