import 'package:shared_preferences/shared_preferences.dart';

class SharedPref {
  static late SharedPreferences _preferences;

  static Future<void> init() async =>
      _preferences = await SharedPreferences.getInstance();

  static void removeData() {
    for (String key in _preferences.getKeys()) {
      if (key != "base_url" && key != "fcm_token") {
        _preferences.remove(key);
      }
    }
  }

  static Future<void> setUserToken(String userName) =>
      _preferences.setString('token', userName);


  static Future<void> setSchoolName(String userName) =>
      _preferences.setString('school', userName);


  static Future<void> setBranchName(String userName) =>
      _preferences.setString('branch', userName);


  static Future<void> setSchoolLogo(String userName) =>
      _preferences.setString('school_logo', userName);


  static Future<void> setSchoolColor(String userName) =>
      _preferences.setString('school_color', userName);


  static Future<void> setSubjectId(String userName) =>
      _preferences.setString('subject_id', userName);


  static Future<void> setUserFcmToken(String userName) =>
      _preferences.setString('fcm_token', userName);


  static Future<void> setUserAvatar(String image) =>
      _preferences.setString('student_image', image);


  static Future<void> setUserName(String name) =>
      _preferences.setString('username', name);


  static Future<void> setRoleId(String roleId) =>
      _preferences.setString('role_id', roleId);


  static Future<void> setStudentId(String sId) =>
      _preferences.setString('s_id', sId);


  static Future<void> setStudentName(String name) =>
      _preferences.setString('s_name', name);


  static Future<void> setStudentAvatar(String image) =>
      _preferences.setString('s_image', image);


  static Future<void> setStudentRollNum(String num) =>
      _preferences.setString('student_roll_num', num);


  static Future<void> setStudentClassId(String id) =>
      _preferences.setString('student_class_id', id);


  static Future<void> setStudentClassName(String name) =>
      _preferences.setString('student_class_name', name);


  static Future<void> setStudentSectionId(String id) =>
      _preferences.setString('student_section_id', id);


  static Future<void> setStudentSectionName(String name) =>
      _preferences.setString('student_section_name', name);


  static Future<void> setChildren(List<String> name) =>
      _preferences.setStringList('children', name);


  static String? geUserName() => _preferences.getString('username');

  static String? getUserToken() => _preferences.getString('token');

  static String? getSchoolName() => _preferences.getString('school');

  static String? getBranchName() => _preferences.getString('branch');

  static String? getSchoolColor() => _preferences.getString('school_color');

  static String? getSchoolLogo() => _preferences.getString('school_logo');

  static String? getSubjectId() => _preferences.getString('subject_id');

  static String? getUserFcmToken() => _preferences.getString('fcm_token');

  static String? getUserAvatar() => _preferences.getString('student_image');

  static String? getRoleId() => _preferences.getString('role_id');

  static String? getStudentId() => _preferences.getString('s_id');

  static String? getStudentName() => _preferences.getString('s_name');

  static String? getStudentAvatar() => _preferences.getString('s_image');

  static String? getStudentRollNum() =>
      _preferences.getString('student_roll_num');

  static String? getStudentClassId() =>
      _preferences.getString('student_class_id');

  static String? getStudentClassName() =>
      _preferences.getString('student_class_name');

  static String? getStudentSectionId() =>
      _preferences.getString('student_section_id');

  static String? getStudentSectionName() =>
      _preferences.getString('student_section_name');

  static getChildren() => _preferences.get('children');
}
