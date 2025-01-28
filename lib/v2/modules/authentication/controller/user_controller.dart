import 'package:bot_toast/bot_toast.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:teamlead/v2/core/database/firebase_db/collection_name.dart';
import 'package:teamlead/v2/core/database/firebase_db/firebase_handler.dart';
import 'package:teamlead/v2/core/utils/logger/logger.dart';
import 'package:teamlead/v2/modules/authentication/model/student_model.dart';
import 'package:teamlead/v2/modules/authentication/model/teacher_model.dart';

class UserController extends GetxController {
  Rx<StudentModel> student = Rx<StudentModel>(StudentModel());
  Rx<TeacherModel> teacher = Rx<TeacherModel>(TeacherModel());

  Future<bool> addUserData({required dynamic userData}) async {
    try{
      debug(userData.toJson());
      if (userData is StudentModel) {
        await FirebaseHandler.fireStore
            .collection(CollectionName.student)
            .doc(userData.email)
            .set(userData.toJson());
        student.value = userData;
      } else {
        debug(userData.toJson());
        await FirebaseHandler.fireStore
            .collection(CollectionName.teacher)
            .doc(userData.email)
            .set(userData.toJson());
        teacher.value = userData;
      }
      return true;
    } catch(e){
      BotToast.showText(text: "Something went wrong. Try again later!");
      debug("ADD USER DATA Error: $e");
    }
    return false;
  }

  Future<dynamic>? getUserData({required String email}) async {
    try {
      debug(email);
      DocumentSnapshot studentSnapshot =
          await FirebaseHandler.fireStore.collection(CollectionName.student).doc(email).get();

      if (!studentSnapshot.exists) {
        DocumentSnapshot teacherSnapshot =
            await FirebaseHandler.fireStore.collection(CollectionName.teacher).doc(email).get();

        if (teacherSnapshot.exists) {
          teacher.value = TeacherModel.fromJson(teacherSnapshot.data() as Map<String, dynamic>);
          return teacher.value;
        } else {
          return null;
        }
      } else {
        student.value = StudentModel.fromJson(studentSnapshot.data() as Map<String, dynamic>);
        debug('Student data: ${student.value.toJson()}');
        return student.value;
      }
    } catch (e) {
      debug("Get User Data Error: $e");
    }
    return null;
  }
}
