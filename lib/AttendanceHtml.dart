import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:flutter_html/html_parser.dart';
import 'package:flutter_html/image_render.dart';
import 'package:flutter_phoenix/flutter_phoenix.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:jiffy/jiffy.dart';
import 'package:wsms/Constants.dart';
import 'package:wsms/HttpRequest.dart';
import 'package:wsms/NavigationDrawer.dart';
import 'package:wsms/Shared_Pref.dart';

class AttendanceHtml extends StatefulWidget {
  const AttendanceHtml({Key? key}) : super(key: key);

  @override
  _AttendanceHtmlState createState() => _AttendanceHtmlState();
}

class _AttendanceHtmlState extends State<AttendanceHtml> {
  var token = SharedPref.getUserToken();
  var sId = SharedPref.getStudentId();
  var textId, sectId, format = 'select date';
  late var result = 'waiting...', newColor = SharedPref.getSchoolColor();
  List classValue = [], sectionValue = [];
  DateTime selectedDate = DateTime.now();
  bool isLoading = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    //  SystemChrome.setPreferredOrientations([DeviceOrientation.landscapeLeft]);
    isLoading = true;
    monthReport();
  }

  // for take student attendance html where api call httplinks class where links set and httprequest class where integrate api.

  monthReport() async {
    HttpRequest req = HttpRequest();
    var html = await req.studentAttendance(context, token!, sId.toString());
    if (html == 500) {
      toastShow('Server Error!!! Try Again Later...');
      setState(() {
        isLoading = false;
      });
    } else {
      setState(() {
        if (html != null) {
          result = html.toString();
          isLoading = false;
        }
      });
    }
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
        context: context,
        initialDate: selectedDate,
        firstDate: DateTime(2021),
        lastDate: DateTime(2101));
    if (picked != null && picked != selectedDate)
      setState(() {
        var dateString = picked;
        format = Jiffy(dateString).format("dd-MMM-yyyy");
        selectedDate = picked;
      });
  }

  Future<bool> _onPopScope() async {
    SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
    return true;
  }

  Future<void> updateApp() async {
    setState(() {
      isLoading = true;
    });
    Map map = {
      'fcm_token': SharedPref.getUserFcmToken(),
    };
    HttpRequest request = HttpRequest();
    var results = await request.postUpdateApp(context, token!, map);
    if (results == 500) {
      toastShow('Server Error!!! Try Again Later...');
    } else {
      SharedPref.removeSchoolInfo();
      await getSchoolInfo(context);
      await getSchoolColor();
      setState(() {
        newColor = SharedPref.getSchoolColor()!;
        isLoading = false;
      });

      results['status'] == 200
          ? snackShow(context, 'Sync Successfully')
          : snackShow(context, 'Sync Failed');
    }
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _onPopScope,
      child: Scaffold(
        appBar: AppBar(
          title: Text('Student Attendance'),
          backgroundColor: Color(int.parse('$newColor')),
          systemOverlayStyle: SystemUiOverlayStyle.light,
        ),
        drawer: Drawers(
          logout: () async {
            // on signout remove all local db and shared preferences
            Navigator.pop(context);

            setState(() {
              isLoading = true;
            });
            HttpRequest request = HttpRequest();
            var res = await request.postSignOut(context, token!);
            /*  await db.execute('DELETE FROM daily_diary ');
          await db.execute('DELETE FROM profile ');
          await db.execute('DELETE FROM test_marks ');
          await db.execute('DELETE FROM subjects ');
          await db.execute('DELETE FROM monthly_exam_report ');
          await db.execute('DELETE FROM time_table ');
          await db.execute('DELETE FROM attendance ');*/
            Navigator.pushReplacementNamed(context, '/');
            setState(() {
              if (res['status'] == 200) {
                SharedPref.removeData();
                snackShow(context, 'Logout Successfully');
                isLoading = false;
              } else {
                isLoading = false;
                snackShow(context, 'Logout Failed');
              }
            });
          },
          sync: () async {
            Navigator.pop(context);
            await updateApp();
            Phoenix.rebirth(context);
          },
        ),
        body: isLoading
            ? Center(
                child: spinkit,
              )
            : SafeArea(
                child: Html(
                  data: result,
                  style: {
                    "table": Style(
                        backgroundColor: Color.fromARGB(0x50, 0xee, 0xee, 0xee),
                        margin: EdgeInsets.all(0.0),
                        padding: EdgeInsets.all(0.0),
                        width: double.minPositive),
                    "tr": Style(
                      border: Border(bottom: BorderSide(color: Colors.grey)),
                    ),
                    "th": Style(
                      color: Colors.white,
                      alignment: Alignment.center,
                      textAlign: TextAlign.center,
                      padding: EdgeInsets.all(6),
                      backgroundColor: Color(int.parse('$newColor')),
                    ),
                    "td": Style(
                      color: Color(int.parse('$newColor')),
                      alignment: Alignment.center,
                      textAlign: TextAlign.center,
                      padding: EdgeInsets.all(6),
                    ),
                  },
                  customRender: {
                    "table": (context, child) {
                      return SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: (context.tree as TableLayoutElement)
                            .toWidget(context),
                      );
                    },
                  },
                  onImageError: (exception, stackTrace) {
                    print(exception);
                  },
                  onCssParseError: (css, messages) {
                    print("css that errored: $css");
                    print("error messages:");
                    messages.forEach((element) {
                      print(element);
                    });
                  },
                ),
              ),
      ),
    );
  }
}
