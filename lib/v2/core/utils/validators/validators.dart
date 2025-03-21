class Validators {
  static final fullNameRegex = RegExp(r"^([A-Za-z]{2,16}\.?)( [A-Za-z]{2,16}\.?){0,3}$");
  static final studentIdRegex = RegExp(r"^\d{10}|\d{16}$");
  static final teacherInitialRegex = RegExp(r"^[A-Z]{3,5}$");
  static final emailRegex = RegExp(r"^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$");
  static final numberRegex = RegExp(r"^(?:\+?88)?01[3-9]\d{8}$");
  static final cgpaRegex = RegExp(r"^(4\.00|[1-3]\.\d{2}|1\.00)$");

  // Name Validator
  static String? nameValidator(String? name) {
    if (name!.trim().isEmpty) {
      return "Enter Name";
    } else if (!fullNameRegex.hasMatch(name)) {
      return "Invalid Format. Name must be between 2-16 characters, only letters and optional periods.";
    } else {
      return null;
    }
  }

  // Student ID Validator
  static String? idValidation(String? id) {
    if (id!.trim().isEmpty) {
      return "Enter Student ID";
    } else if (!studentIdRegex.hasMatch(id)) {
      return "Invalid Format. Student ID must be 10 or 16 digits.";
    } else {
      return null;
    }
  }

  // Teacher Initial Validator
  static String? initialValidator(String? initial) {
    if (initial!.trim().isEmpty) {
      return "Enter Initial";
    } else if (!teacherInitialRegex.hasMatch(initial)) {
      return "Invalid Format. Initials should be 3-5 uppercase letters.";
    } else {
      return null;
    }
  }

  // Email Validator
  static String? emailValidator(String? email) {
    if (email!.trim().isEmpty) {
      return "Enter Email";
    } else if (!emailRegex.hasMatch(email)) {
      return "Invalid Email Format";
    } else {
      return null;
    }
  }

  // Bangladeshi Mobile Number Validator
  static String? numberValidator(String? number) {
    if (number!.trim().isEmpty) {
      return "Enter Mobile Number";
    } else if (!numberRegex.hasMatch(number)) {
      return "Invalid Mobile Number Format";
    } else {
      return null;
    }
  }

  // CGPA Validator (Scale 1.00 to 4.00)
  static String? cgpaValidator(String? cgpa) {
    if (cgpa!.trim().isEmpty) {
      return "Enter CGPA";
    } else if (!cgpaRegex.hasMatch(cgpa)) {
      return "Invalid CGPA. Enter a value between 1.00 and 4.00.";
    } else {
      return null;
    }
  }

  static String? nonEmptyValidator(String? value){
    if(value!.trim().isEmpty){
      return "Cannot be empty";
    }
    return null;
  }

  static String? defenseMarkValidator(String? value){
    if(value!.trim().isEmpty){
      return "Enter Mark";
    } else {
      double mark = double.tryParse(value) ?? 0;
      if(mark.abs() > 30) return "Exceed marking limit 30";
    }
    return null;
  }

  static String? supervisorMarkValidator(String? value){
    if(value!.trim().isEmpty){
      return "Enter Mark";
    } else {
      double mark = double.tryParse(value) ?? 0;
      if(mark.abs() > 20) return "Exceed marking limit 20";
    }
    return null;
  }
}
