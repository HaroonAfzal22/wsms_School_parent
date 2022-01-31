import 'package:shared_preferences/shared_preferences.dart';

class SharedPref {
  static late SharedPreferences _preferences;

  static Future<void> init() async =>
      _preferences = await SharedPreferences.getInstance();

  static Future<void> removeData() async {

    for (String key in _preferences.getKeys()) {
      if (key != "base_url" && key != "fcm_token") {
       await _preferences.remove(key);
      }
    }
  }
  static void removeSchoolInfo() {
    for (String key in _preferences.getKeys()) {
      if (key == "school" && key == "branch" && key =='school_logo'&& key =='school_color') {
        _preferences.remove(key);
      }
    }
  }
  static Future setUserToken(String userName) =>
      _preferences.setString('token', userName);


  static Future setSchoolName(String userName) =>
      _preferences.setString('school', userName);

  static Future setSchoolId(String userName) =>
    _preferences.setString('school_id', userName);

  static Future setBranchName(String userName) =>
      _preferences.setString('branch', userName);


  static Future setSchoolLogo(String userName) =>
      _preferences.setString('school_logo', userName);


  static Future setSchoolColor(String userName) =>
      _preferences.setString('school_color', userName);


  static Future setSubjectId(String userName) =>
      _preferences.setString('subject_id', userName);


  static Future setUserFcmToken(String userName) =>
      _preferences.setString('fcm_token', userName);


  static Future setUserAvatar(String image) =>
      _preferences.setString('student_image', image);


  static Future setUserName(String name) =>
      _preferences.setString('username', name);


  static Future setRoleId(String roleId) =>
      _preferences.setString('role_id', roleId);


  static Future setStudentId(String sId) =>
      _preferences.setString('s_id', sId);


  static Future setStudentName(String name) =>
      _preferences.setString('s_name', name);


  static Future setStudentAvatar(String image) =>
      _preferences.setString('s_image', image);


  static Future setStudentRollNum(String num) =>
      _preferences.setString('student_roll_num', num);


  static Future setStudentClassId(String id) =>
      _preferences.setString('student_class_id', id);


  static Future setStudentClassName(String name) =>
      _preferences.setString('student_class_name', name);


  static Future setStudentSectionId(String id) =>
      _preferences.setString('student_section_id', id);


  static Future setStudentSectionName(String name) =>
      _preferences.setString('student_section_name', name);


  static Future setChildren(List<String> name) =>
      _preferences.setStringList('children', name);

  static Future setAppVersion(String userName) async {
    _preferences.setString('app_version', userName);
  }
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

  static String? getSchoolId() => _preferences.getString('school_id');


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

  static String? getAppVersion() => _preferences.getString('app_version');


}
