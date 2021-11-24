import 'dart:convert';
import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:flutter_html/html_parser.dart';
import 'package:flutter_html/image_render.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter_widget_from_html/flutter_widget_from_html.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:html/parser.dart';
import 'package:jiffy/jiffy.dart';
import 'package:sqflite/sqflite.dart';
import 'package:wsms/Background.dart';
import 'package:wsms/Constants.dart';
import 'package:wsms/HtmlWidgets.dart';
import 'package:wsms/HttpRequest.dart';
import 'package:wsms/NavigationDrawer.dart';
import 'package:wsms/Shared_Pref.dart';

import 'main.dart';

class MonthlyExamReport extends StatefulWidget {
  const MonthlyExamReport({Key? key}) : super(key: key);

  @override
  _MonthlyExamReportState createState() => _MonthlyExamReportState();
}

// for get monthly exam report html form
class _MonthlyExamReportState extends State<MonthlyExamReport> {
  var token = SharedPref.getUserToken(),sId = SharedPref.getStudentId(),textId, sectId, format = 'select date',newColor=SharedPref.getSchoolColor();
  late var result1, result2,val = 3,db;
  List classValue = [], sectionValue = [],textValue = [],compare=[];
  DateTime selectedDate = DateTime.now();
  bool isLoading = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    SystemChrome.setPreferredOrientations([DeviceOrientation.landscapeLeft]);
    isLoading = true;

    Future(()async{
      db= await database;
      (await db.query('sqlite_master', columns: ['type', 'name'])).forEach((row) {
        setState(() {
          compare.add(row);
        });
      });
      createExamReport();
    });
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
        onWillPop: _onPopScope,
        child: Scaffold(
          appBar: AppBar(
            title: Text('Monthly Exam Report'),
            backgroundColor: Color(int.parse('$newColor')),
            systemOverlayStyle: SystemUiOverlayStyle.light,
           /* actions: <Widget>[
              Container(
                child: TextButton(
                  onPressed: () {
                    setState(() {
                      isLoading = true;

                      updateExamReport();
                    });
                  },
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Flexible(
                        child: Text(
                          'Refresh',
                          style: TextStyle(
                            color: Colors.white,
                          ),
                        ),
                      ),
                      SizedBox(width: 3),
                      Icon(
                        CupertinoIcons.refresh_bold,
                        color: Colors.white,
                        size: 16.0,
                      ),
                      SizedBox(width: 8),
                    ],
                  ),
                ),
              ),
            ],*/
          ),
          drawer:  Drawers(),
          body: isLoading
              ? Center(
                  child: spinkit,
                )
              : SafeArea(
                  child: BackgroundWidget(
                  childView: RefreshIndicator(
                    onRefresh:updateExamReport,

                    child: Column(
                      children: [
                        Flexible(
                            child: HtmlWidgets(
                          responseHtml: result1,
                        )),
                        Flexible(
                          flex: 2,
                          fit: FlexFit.tight,
                          child:
                              HtmlWidgets(responseHtml: result2,),
                        ),
                      ],
                    ),
                  ),
                )),
        ));
  }

// set monthly exam report and check if it available in local storage
  monthReport() async {
    if(compare[10]['name']=='monthly_exam_report') {
      var value = await db.query('monthly_exam_report');

      if (value.isNotEmpty) {
        var html = jsonDecode(value[0]['data']);

        setState(() {
          var document1 = parse('${html[0]}');
          var document2 = parse('${html[1]}');
          result1 = document1;
          result2 = document2;
          isLoading = false;
        });
      }
      else {
        await db.execute('DELETE FROM monthly_exam_report');
        HttpRequest req = HttpRequest();
        var html = await req.studentMonthlyExamReport(
            context, token!, sId.toString());
        if (html == 500) {
          toastShow('Server Error!!! Try Again Later...');
          setState(() {
            isLoading = false;
          });
        } else {
          setState(() {
            var document1 = parse('${html[0]}');
            var document2 = parse('${html[1]}');
            result1 = document1;
            result2 = document2;
            isLoading = false;
          });
          Map<String, Object?> map = {
            'data': jsonEncode(html),
          };
          await db.insert('monthly_exam_report', map,
              conflictAlgorithm: ConflictAlgorithm.replace);
        }
      }
    }else{
      createExamReport();
    }
  }

  // if not local db available table then create and upload data in it
  createExamReport()async{
  //  await db.execute('CREATE TABLE monthly_exam_report (data TEXT NON NULL)');
    HttpRequest req = HttpRequest();
    var html = await req.studentMonthlyExamReport(context, token!, sId.toString());
    if (html == 500) {
      toastShow('Server Error!!! Try Again Later...');
      setState(() {
        isLoading = false;
      });
    } else {
      setState(() {
        var document1 = parse('${html[0]}');
        var document2 = parse('${html[1]}');
        result1 = document1;
        result2 = document2;
        isLoading = false;
      });
    /*  Map<String, Object?> map = {
        'data': jsonEncode(html),
      };
      await db.insert('monthly_exam_report', map,
          conflictAlgorithm: ConflictAlgorithm.replace);*/
    }
  }

  // to update local db get data from api
 Future<void> updateExamReport()async{
    await db.execute('DELETE FROM monthly_exam_report');
    HttpRequest req = HttpRequest();
    var html = await req.studentMonthlyExamReport(context, token!, sId.toString());
    if (html == 500) {
      toastShow('Server Error!!! Try Again Later...');
      setState(() {
        isLoading = false;
      });
    } else {
      setState(() {
        var document1 = parse('${html[0]}');
        var document2 = parse('${html[1]}');
        result1 = document1;
        result2 = document2;
        isLoading = false;
      });
      Map<String, Object?> map = {
        'data': jsonEncode(html),
      };
      await db.insert('monthly_exam_report', map,
          conflictAlgorithm: ConflictAlgorithm.replace);
    }
  }

// to show screen landscape to portrait mode

  Future<bool> _onPopScope() async {
    SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
    return true;
  }

/* showMonth(index) {
    if (result1['marks'][index]['month'] == '01') {
      return 'January';
    } else if (result['marks'][index]['month'] == '02') {
      return 'February';
    } else if (result['marks'][index]['month'] == '03') {
      return 'March';
    } else if (result['marks'][index]['month'] == '04') {
      return 'April';
    } else if (result['marks'][index]['month'] == '05') {
      return 'May';
    } else if (result['marks'][index]['month'] == '06') {
      return 'June';
    } else if (result['marks'][index]['month'] == '07') {
      return 'July';
    } else if (result['marks'][index]['month'] == '08') {
      return 'August';
    } else if (result['marks'][index]['month'] == '09') {
      return 'September';
    } else if (result['marks'][index]['month'] == '10') {
      return 'October';
    } else if (result['marks'][index]['month'] == '11') {
      return 'November';
    } else if (result['marks'][index]['month'] == '12') {
      return 'December';
    }
  }*/
}
