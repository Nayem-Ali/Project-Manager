import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:teamlead/v2/core/utils/logger/logger.dart';
import 'package:teamlead/v2/core/utils/validators/validators.dart';
import 'package:teamlead/v2/modules/admin/generate_schedule/controller/generate_schedule_controller.dart';
import 'package:teamlead/v2/modules/admin/generate_schedule/model/scheule_model.dart';

class GenerateSchedule extends StatefulWidget {
  const GenerateSchedule({super.key});

  @override
  State<GenerateSchedule> createState() => _GenerateScheduleState();
}

class _GenerateScheduleState extends State<GenerateSchedule> {
  Rx<TextEditingController> startDateController = Rx(TextEditingController());
  Rx<TextEditingController> startTimeController = Rx(TextEditingController());
  Rx<TextEditingController> endTimeController = Rx(TextEditingController());
  Rx<TextEditingController> breakDurationController = Rx(TextEditingController());
  Rx<TextEditingController> breakTimeController = Rx(TextEditingController());
  Rx<TextEditingController> slotDurationController1 = Rx(TextEditingController());
  Rx<TextEditingController> slotDurationController2 = Rx(TextEditingController());
  Rx<TextEditingController> slotDurationController3 = Rx(TextEditingController());
  Rx<TextEditingController> courseCodeController1 = Rx(TextEditingController());
  Rx<TextEditingController> courseCodeController2 = Rx(TextEditingController());
  Rx<TextEditingController> courseCodeController3 = Rx(TextEditingController());
  RxList<String> courses = RxList(['CSE-3300', 'CSE-4800', 'CSE-4801']);
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  DateTime? startDate;
  TimeOfDay? startTime;
  TimeOfDay? endTime;
  TimeOfDay? breakTime;
  List<int> slotsDuration = [];
  List<String> listedCourse = ["", "", ""];
  int? breakDuration;

  final _scheduleController = Get.find<GenerateScheduleController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Schedule Generation"),
        centerTitle: true,
      ),
      body: Obx(
        () => SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const SizedBox(height: 5),
                  TextFormField(
                    controller: startDateController.value,
                    decoration: InputDecoration(
                      labelText: "Pick the defense starting date",
                      border: const OutlineInputBorder(),
                      suffixIcon: IconButton(
                        onPressed: () async {
                          DateTime? pickedDate = await showDatePicker(
                            context: context,
                            firstDate: DateTime.now(),
                            lastDate: DateTime(2100),
                          );
                          if (pickedDate != null) {
                            startDate = pickedDate;
                            startDateController.value.text =
                                DateFormat.yMMMMEEEEd().format(pickedDate);
                          }
                        },
                        icon: const Icon(Icons.calendar_month),
                      ),
                    ),
                    readOnly: true,
                    validator: Validators.nonEmptyValidator,
                  ),
                  const SizedBox(height: 5),
                  Row(
                    children: [
                      Flexible(
                        child: TextFormField(
                          controller: startTimeController.value,
                          decoration: InputDecoration(
                            labelText: "Starting Time",
                            border: const OutlineInputBorder(),
                            suffixIcon: IconButton(
                              onPressed: () async {
                                TimeOfDay? pickedTime = await showTimePicker(
                                  context: context,
                                  initialTime: TimeOfDay.now(),
                                );
                                if (pickedTime != null) {
                                  startTime = pickedTime;
                                  startTimeController.value.text = DateFormat.jm().format(
                                    DateTime(2012, 1, 1, pickedTime.hour, pickedTime.minute),
                                  );
                                }
                              },
                              icon: const Icon(Icons.timelapse),
                            ),
                          ),
                          readOnly: true,
                          validator: Validators.nonEmptyValidator,
                        ),
                      ),
                      const SizedBox(width: 10),
                      Flexible(
                        child: TextFormField(
                          controller: endTimeController.value,
                          decoration: InputDecoration(
                            labelText: "Ending Time",
                            border: const OutlineInputBorder(),
                            suffixIcon: IconButton(
                              onPressed: () async {
                                TimeOfDay? pickedTime = await showTimePicker(
                                  context: context,
                                  initialTime: TimeOfDay.now(),
                                );
                                if (pickedTime != null) {
                                  endTime = pickedTime;
                                  endTimeController.value.text = DateFormat.jm().format(
                                    DateTime(2012, 1, 1, pickedTime.hour, pickedTime.minute),
                                  );
                                }
                              },
                              icon: const Icon(Icons.timelapse_outlined),
                            ),
                          ),
                          readOnly: true,
                          validator: Validators.nonEmptyValidator,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 5),
                  Row(
                    children: [
                      Flexible(
                        child: TextFormField(
                          controller: breakTimeController.value,
                          decoration: InputDecoration(
                            labelText: "Break Time Start At",
                            border: const OutlineInputBorder(),
                            suffixIcon: IconButton(
                              onPressed: () async {
                                TimeOfDay? pickedTime = await showTimePicker(
                                  context: context,
                                  initialTime: TimeOfDay.now(),
                                );
                                if (pickedTime != null) {
                                  breakTime = pickedTime;
                                  breakTimeController.value.text = DateFormat.jm().format(
                                    DateTime(2012, 1, 1, pickedTime.hour, pickedTime.minute),
                                  );
                                }
                              },
                              icon: const Icon(Icons.timelapse),
                            ),
                          ),
                          readOnly: true,
                          validator: Validators.nonEmptyValidator,
                        ),
                      ),
                      const SizedBox(width: 10),
                      Flexible(
                        child: TextFormField(
                          controller: breakDurationController.value,
                          decoration: const InputDecoration(
                            labelText: "Break Duration",
                            border: OutlineInputBorder(),
                          ),
                          keyboardType: TextInputType.number,
                          validator: Validators.nonEmptyValidator,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 5),
                  Row(
                    children: [
                      Flexible(
                        child: DropdownButtonFormField(
                          decoration: const InputDecoration(
                            labelText: "Select Course",
                            border: OutlineInputBorder(),
                          ),
                          onChanged: (value) {
                            courseCodeController1.value.text = value!;
                            listedCourse[0] = value;
                          },
                          items: courses
                              .map(
                                (e) => DropdownMenuItem(
                                  value: e,
                                  child: Text(e),
                                ),
                              )
                              .toList(),
                        ),
                      ),
                      const SizedBox(width: 10),
                      Flexible(
                        child: TextFormField(
                          controller: slotDurationController1.value,
                          decoration: const InputDecoration(
                            labelText: "Slot Duration",
                            border: OutlineInputBorder(),
                          ),
                          keyboardType: TextInputType.number,
                          validator: Validators.nonEmptyValidator,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 5),
                  Row(
                    children: [
                      Flexible(
                        child: DropdownButtonFormField(
                          decoration: const InputDecoration(
                            labelText: "Select Course",
                            border: OutlineInputBorder(),
                          ),
                          onChanged: (value) {
                            courseCodeController2.value.text = value!;
                            listedCourse[1] = value;
                          },
                          items: courses
                              .map(
                                (e) => DropdownMenuItem(
                                  value: e,
                                  child: Text(e),
                                ),
                              )
                              .toList(),
                        ),
                      ),
                      const SizedBox(width: 10),
                      Flexible(
                        child: TextFormField(
                          controller: slotDurationController2.value,
                          decoration: const InputDecoration(
                            labelText: "Slot Duration",
                            border: OutlineInputBorder(),
                          ),
                          keyboardType: TextInputType.number,
                          validator: Validators.nonEmptyValidator,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 5),
                  Row(
                    children: [
                      Flexible(
                        child: DropdownButtonFormField(
                          decoration: const InputDecoration(
                            labelText: "Select Course",
                            border: OutlineInputBorder(),
                          ),
                          onChanged: (value) {
                            courseCodeController3.value.text = value!;
                            listedCourse[2] = value;
                          },
                          items: courses
                              .map(
                                (e) => DropdownMenuItem(
                                  value: e,
                                  child: Text(e),
                                ),
                              )
                              .toList(),
                        ),
                      ),
                      const SizedBox(width: 10),
                      Flexible(
                        child: TextFormField(
                          controller: slotDurationController3.value,
                          decoration: const InputDecoration(
                            labelText: "Slot Duration",
                            border: OutlineInputBorder(),
                          ),
                          keyboardType: TextInputType.number,
                          validator: Validators.nonEmptyValidator,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 5),
                  SizedBox(
                    height: Get.height * 0.06,
                    width: Get.width ,
                    child: ElevatedButton(
                      onPressed: () async {
                        if (_formKey.currentState!.validate()) {
                          breakDuration = int.parse(breakDurationController.value.text.trim());
                          slotsDuration = [
                            int.parse(slotDurationController1.value.text.trim()),
                            int.parse(slotDurationController2.value.text.trim()),
                            int.parse(slotDurationController3.value.text.trim()),
                          ];
                          // debug(startDate);
                         await _scheduleController.testSlotTimeAllocation(
                            startDate: startDate!,
                            startTime: startTime!,
                            endTime: endTime!,
                            breakTime: breakTime!,
                            slotsDuration: slotsDuration,
                            breakDuration: breakDuration!,
                            courses: listedCourse,
                          );
                         // startDate = null;
                         // startTime = null;
                         // endTime = null;
                         // breakTime = null;
                         // breakDuration = null;
                         // slotsDuration.clear();
                         // listedCourse.clear();
                         // startDateController.value.clear();
                         // startTimeController.value.clear();
                         // endTimeController.value.clear();
                         // breakTimeController.value.clear();
                         // breakDurationController.value.clear();
                         // slotDurationController1.value.clear();
                         // slotDurationController2.value.clear();
                         // slotDurationController3.value.clear();
                         // courseCodeController1.value.clear();
                         // courseCodeController2.value.clear();
                         // courseCodeController3.value.clear();

                        }
                      },
                      child: Text(
                        "Start Generating",
                        style: Theme.of(context)
                            .textTheme
                            .titleLarge
                            ?.copyWith(color: Colors.white),
                      ),
                    ),
                  ),
                  const SizedBox(height: 5),
                  // SizedBox(
                  //   height: Get.height * 0.06,
                  //   width: Get.width,
                  //   child: ElevatedButton(
                  //     onPressed: () async {
                  //       await _scheduleController.getSheet();
                  //     },
                  //     child: Text(
                  //       "Get Schedule Sheet",
                  //       style: Theme.of(context)
                  //           .textTheme
                  //           .titleLarge
                  //           ?.copyWith(color: Colors.white),
                  //     ),
                  //   ),
                  // ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
