import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart';
import 'package:wsms/Constants.dart';
import 'package:wsms/Shared_Pref.dart';
import 'package:wsms/main.dart';
import 'HttpLinks.dart';

class HttpRequest {
  late var dbs;

  HttpRequest(){
    Future(()async{
      dbs = await database;
    });
  }

  //for login link
  Future postLogin(BuildContext context, String email, String password,
      String? tokenFcm) async {
    try {
      Uri uri = Uri.parse(HttpLinks.loginUrl);
      Response response = await post(uri, body: {
        'username': email,
        'password': password,
        'fcm_token': tokenFcm,
      });
      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      } else if (response.statusCode == 401) {
        removeAccount(context);
        toastShow('Authorization Failure');
      } else {
        print(response.statusCode);
        return response.statusCode;
      }
    } catch (e) {
      print(e);
    }
  }

  //for parent login
  Future parentLogin(BuildContext context, String email, String password,
      String? tokenFcm) async {
    try {
      Uri uri = Uri.parse(HttpLinks.parentLoginUrl);
      Response response = await post(uri, body: {
        'username': email,
        'password': password,
        'fcm_token': tokenFcm,
      });
      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      } else if (response.statusCode == 401) {
        removeAccount(context);
        toastShow('Authorization Failure');
      } else {
        print(response.statusCode);
        return response.statusCode;
      }
    } catch (e) {
      print(e);
    }
  }

  // for profile link
  Future getProfile(BuildContext context, String token, String sId) async {
    try {
      Uri uri = Uri.parse('${HttpLinks.Url}$sId${HttpLinks.profileUrl}');
      Response response = await get(uri, headers: {
        HttpHeaders.contentTypeHeader: 'application/json',
        HttpHeaders.authorizationHeader: 'Bearer $token',
      });
      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      } else if (response.statusCode == 401) {
        toastShow('Authorization Failure');
        removeAccount(context);
      } else {
        print(response.statusCode);
        return response.statusCode;
      }
    } catch (e) {
      print(e);
    }
  }

  //for get children
  Future getChildren(BuildContext context,
      String token,) async {
    try {
      Uri uri = Uri.parse('${HttpLinks.baseUrl}${HttpLinks.childrenUrl}');
      Response response = await get(uri, headers: {
        HttpHeaders.contentTypeHeader: 'application/json',
        HttpHeaders.authorizationHeader: 'Bearer $token',
      });
      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      } else if (response.statusCode == 401) {
        removeAccount(context);
        toastShow('Authorization Failure');
      } else {
        print(response.statusCode);
        return response.statusCode;
      }
    } catch (e) {
      print(e);
    }
  }

  //for get school info
  Future getLogoColor(context, String token) async {
    try {
      Uri uri = Uri.parse('${HttpLinks.baseUrl}${HttpLinks.SchoolInfoUrl}');
      Response response = await get(uri, headers: {
        HttpHeaders.contentTypeHeader: 'application/json',
        HttpHeaders.authorizationHeader: 'Bearer $token',
      });
      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      } else if (response.statusCode == 401) {
        removeAccount(context);
      } else {
        print(response.statusCode);
        return response.statusCode;
      }
    } catch (e) {
      print(e);
    }
  }

  //for join online class
  Future getOnlineClass(BuildContext context, String token, String sId) async {
    try {
      Uri uri = Uri.parse('${HttpLinks.Url}$sId${HttpLinks.OnlineClassUrl}');
      Response response = await get(uri, headers: {
        HttpHeaders.contentTypeHeader: 'application/json',
        HttpHeaders.authorizationHeader: 'Bearer $token',
      });
      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      } else if (response.statusCode == 401) {
        removeAccount(context);
        toastShow('Authorization Failure');
      } else {
        print(response.statusCode);
        return response.statusCode;
      }
    } catch (e) {
      print(e);
    }
  }

  //for subject list
  Future getSubjectsList(BuildContext context, String token, String sId) async {
    try {
      Uri uri = Uri.parse('${HttpLinks.Url}$sId${HttpLinks.subjectListUrl}');
      Response response = await get(uri, headers: {
        HttpHeaders.contentTypeHeader: 'application/json',
        HttpHeaders.authorizationHeader: 'Bearer $token',
      });
      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      } else if (response.statusCode == 401) {
        removeAccount(context);
        toastShow('Authorization Failure');
      } else {
        print(response.statusCode);
        return response.statusCode;
      }
    } catch (e) {
      print(e);
    }
  }

  // for subject results
  Future getTestResult(BuildContext context, String sId, String id,
      String token) async {
    try {
      Uri uri = Uri.parse(
          '${HttpLinks.Url}$sId${HttpLinks.subjectListUrl}/$id${HttpLinks
              .testResultUrl}');

      Response response = await get(uri, headers: {
        HttpHeaders.authorizationHeader: 'Bearer $token',
        HttpHeaders.contentTypeHeader: 'application/json',
      });

      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      } else if (response.statusCode == 401) {
        removeAccount(context);
        toastShow('Authorization Failure');
      } else {
        print(response.statusCode);
        return response.statusCode;
      }
    } catch (e) {
      print(e);
    }
  }

  //for student Attendance
  Future studentAttendance(BuildContext context, String token,
      String sId) async {
    try {
      Uri uri = Uri.parse('${HttpLinks.Url}$sId${HttpLinks.AttendanceUrl}');

      Response response = await get(uri, headers: {
        HttpHeaders.contentTypeHeader: 'application/json',
        HttpHeaders.authorizationHeader: 'Bearer $token',
      });
      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      } else if (response.statusCode == 401) {
        removeAccount(context);
        toastShow('Authorization Failure');
        return response.statusCode;
      } else {
        return response.statusCode;
      }
    } catch (e) {
      print(e);
    }
  }

  //for student time table
  Future studentClassTimeTable(BuildContext context, String token,
      String sId) async {
    try {
      Uri uri = Uri.parse('${HttpLinks.Url}$sId${HttpLinks.timeTableUrl}');

      Response response = await get(uri, headers: {
        HttpHeaders.contentTypeHeader: 'text/html',
        HttpHeaders.authorizationHeader: 'Bearer $token',
      });
      if (response.statusCode == 200) {
        return response.body;
      } else if (response.statusCode == 401) {
        removeAccount(context);
        toastShow('Authorization Failure');
        return response.statusCode;
      } else {
        return response.statusCode;
      }
    } catch (e) {
      print(e);
    }
  }

  //for student daily diary
  Future studentDailyDiary(BuildContext context, String token,
      String sId) async {
    try {
      Uri uri = Uri.parse('${HttpLinks.Url}$sId${HttpLinks.dailyDiaryUrl}');

      Response response = await get(uri, headers: {
        HttpHeaders.contentTypeHeader: 'application/json',
        HttpHeaders.authorizationHeader: 'Bearer $token',
      });
      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      } else if (response.statusCode == 401) {
        removeAccount(context);
        toastShow('Authorization Failure');
        return response.statusCode;
      } else {
        return response.statusCode;
      }
    } catch (e) {
      print(e);
    }
  }

  //for monthly test schedule
  Future studentMonthlyTestSchedule(BuildContext context, String token,
      String sId) async {
    try {
      Uri uri =
      Uri.parse('${HttpLinks.Url}$sId${HttpLinks.monthlyTestScheduleUrl}');

      Response response = await get(uri, headers: {
        HttpHeaders.contentTypeHeader: 'text/html',
        HttpHeaders.authorizationHeader: 'Bearer $token',
      });
      if (response.statusCode == 200) {
        return response.body;
      } else if (response.statusCode == 401) {
        removeAccount(context);
        toastShow('Authorization Failure');
        return response.statusCode;
      } else {
        return response.statusCode;
      }
    } catch (e) {
      print(e);
    }
  }

  //for student monthly exam report
  Future studentMonthlyExamReport(BuildContext context, String token,
      String sId) async {
    try {
      Uri uri =
      Uri.parse('${HttpLinks.Url}$sId${HttpLinks.monthlyExamReportUrl}');
      Response response = await get(uri, headers: {
        HttpHeaders.contentTypeHeader: 'text/html',
        HttpHeaders.authorizationHeader: 'Bearer $token',
      });
      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      } else if (response.statusCode == 401) {
        removeAccount(context);
        toastShow('Authorization Failure');
        return response.statusCode;
      } else {
        return response.statusCode;
      }
    } catch (e) {
      print(e);
    }
  }

  // for post leave application
  Future postLeaveData(BuildContext context, String token, String sId,
      Map bodyMap) async {
    try {
      Uri uri = Uri.parse('${HttpLinks.Url}$sId${HttpLinks.leaveAppUrl}');
      Response response = await post(
        uri,
        headers: {
          HttpHeaders.authorizationHeader: 'Bearer $token',
          HttpHeaders.contentTypeHeader: 'application/json',
        },
        body: jsonEncode(bodyMap),
      );

      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      } else if (response.statusCode == 401) {
        removeAccount(context);
        toastShow('UnAuthorized Error');
      } else {
        print(response.statusCode);
        return response.statusCode;
      }
    } catch (e) {
      print(e);
    }
  }

  //for get leave application list
  Future getLeaveData(BuildContext context, String token, String sId) async {
    try {
      Uri uri = Uri.parse('${HttpLinks.Url}$sId${HttpLinks.leaveAppUrl}');
      Response response = await get(
        uri,
        headers: {
          HttpHeaders.authorizationHeader: 'Bearer $token',
          HttpHeaders.contentTypeHeader: 'application/json',
        },
      );

      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      } else if (response.statusCode == 401) {
        removeAccount(context);
        toastShow('UnAuthorized Error');
      } else {
        print(response.statusCode);
        return response.statusCode;
      }
    } catch (e) {
      print(e);
    }
  }

  // for post complain
  Future postComplaintData(BuildContext context, String token, String sId,
      Map bodyMap) async {
    try {
      Uri uri = Uri.parse('${HttpLinks.Url}$sId${HttpLinks.complainAppUrl}');
      Response response = await post(
        uri,
        headers: {
          HttpHeaders.authorizationHeader: 'Bearer $token',
          HttpHeaders.contentTypeHeader: 'application/json',
        },
        body: jsonEncode(bodyMap),
      );

      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      } else if (response.statusCode == 401) {
        removeAccount(context);
        toastShow('UnAuthorized Error');
      } else {
        print(response.statusCode);
        return response.statusCode;
      }
    } catch (e) {
      print(e);
    }
  }

  // for update color in navigation drawer
  Future postUpdateApp(BuildContext context, String token, Map bodyMap) async {
    try {
      Uri uri = Uri.parse('${HttpLinks.updateAppUrl}');
      Response response = await post(
        uri,
        headers: {
          HttpHeaders.authorizationHeader: 'Bearer $token',
          HttpHeaders.contentTypeHeader: 'application/json',
        },
        body: jsonEncode(bodyMap),
      );

      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      } else if (response.statusCode == 401) {
        removeAccount(context);
        toastShow('UnAuthorized Error');
      } else {
        print(response.statusCode);
        return response.statusCode;
      }
    } catch (e) {
      print(e);
    }
  }

  //for signout
  Future postSignOut(BuildContext context, String token) async {
    try {
      Uri uri = Uri.parse('${HttpLinks.signOutUrl}');
      Response response = await post(
        uri,
        headers: {
          HttpHeaders.authorizationHeader: 'Bearer $token',
          HttpHeaders.contentTypeHeader: 'application/json',
        },
      );

      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      } else if (response.statusCode == 401) {
        removeAccount(context);
        toastShow('UnAuthorized Error');
      } else {
        print(response.statusCode);
        return response.statusCode;
      }
    } catch (e) {
      print(e);
    }
  }

  //for get complaint list
  Future getComplaintsData(BuildContext context, String token,
      String sId) async {
    try {
      Uri uri = Uri.parse('${HttpLinks.Url}$sId${HttpLinks.complainAppUrl}');
      Response response = await get(
        uri,
        headers: {
          HttpHeaders.authorizationHeader: 'Bearer $token',
          HttpHeaders.contentTypeHeader: 'application/json',
        },
      );

      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      } else if (response.statusCode == 401) {
        removeAccount(context);
        toastShow('UnAuthorized Error');
      } else {
        print(response.statusCode);
        return response.statusCode;
      }
    } catch (e) {
      print(e);
    }
  }


  //for get exam term
  Future getExamTerm(BuildContext context, String token) async {
    try {
      Uri uri = Uri.parse('${HttpLinks.classTermUrl}');
      Response response = await get(uri, headers: {
        HttpHeaders.authorizationHeader: 'Bearer $token',
        HttpHeaders.contentTypeHeader: 'application/json',
      },
      );
      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      } else if (response.statusCode == 401) {
        removeAccount(context);
        toastShow('UnAuthorized Error');
      } else {
        print(response.statusCode);
        return response.statusCode;
      }
    } catch (e) {
      print(e);
    }
  }


  //for get exam term
  Future getExamReport(BuildContext context, String token,String sId,String tId) async {
    try {
      Uri uri = Uri.parse('${HttpLinks.Url}$sId${HttpLinks.examTermUrl}$tId');
      Response response = await get(uri, headers: {
        HttpHeaders.authorizationHeader: 'Bearer $token',
        HttpHeaders.contentTypeHeader: 'application/json',
      },
      );
      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      } else if (response.statusCode == 401) {
        removeAccount(context);
        toastShow('UnAuthorized Error');
      } else {
        print(response.statusCode);
        return response.statusCode;
      }
    } catch (e) {
      print(e);
    }
  }

  //for get notification
  Future getNotification(BuildContext context, String token, String sId) async {
    try {
      Uri uri =
      Uri.parse('${HttpLinks.ParentsUrl}$sId${HttpLinks.notificationUrl}');
      Response response = await get(
        uri,
        headers: {
          HttpHeaders.authorizationHeader: 'Bearer $token',
          HttpHeaders.contentTypeHeader: 'application/json',
        },
      );

      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      } else if (response.statusCode == 401) {
        removeAccount(context);
        toastShow('UnAuthorized Error');
      } else {
        print(response.statusCode);
        return response.statusCode;
      }
    } catch (e) {
      print(e);
    }
  }

  //for get fee module
  Future getFeeChallan(BuildContext context, String token, String sId) async {
    try {
      Uri uri =
      Uri.parse('${HttpLinks.Url}$sId${HttpLinks.feeModuleUrl}');
      Response response = await get(
        uri,
        headers: {
          HttpHeaders.authorizationHeader: 'Bearer $token',
          HttpHeaders.contentTypeHeader: 'application/json',
        },
      );

      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      } else if (response.statusCode == 401) {
        removeAccount(context);
        toastShow('UnAuthorized Error');
      } else {
        print(response.statusCode);
        return response.statusCode;
      }
    } catch (e) {
      print(e);
    }
  }

  //for remove shared_Pref error 401:
  void removeAccount(context) async {
    SharedPref.removeData();
    Navigator.pushNamedAndRemoveUntil(context, '/', ModalRoute.withName('/'));
    await dbs.execute('DELETE FROM daily_diary ');
    await dbs.execute('DELETE FROM profile ');
    await dbs.execute('DELETE FROM test_marks ');
    await dbs.execute('DELETE FROM subjects ');
    await dbs.execute('DELETE FROM monthly_exam_report ');
    await dbs.execute('DELETE FROM time_table ');
    await dbs.execute('DELETE FROM attendance ');
    SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
  }
}
