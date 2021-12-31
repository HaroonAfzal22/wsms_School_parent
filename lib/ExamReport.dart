import 'dart:collection';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_phoenix/flutter_phoenix.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';
import 'package:lottie/lottie.dart';
import 'package:wsms/Background.dart';
import 'package:wsms/Constants.dart';
import 'package:wsms/HttpRequest.dart';
import 'package:wsms/NavigationDrawer.dart';
import 'package:wsms/Shared_Pref.dart';

class ExamReport extends StatefulWidget {
  @override
  _ExamReportState createState() => _ExamReportState();
}

class _ExamReportState extends State<ExamReport> {
  var newColor = SharedPref.getSchoolColor();
  bool isLoading = false, isListEmpty = false;
  var token = SharedPref.getUserToken();
  var sId = SharedPref.getStudentId();
  late var db, tId, data = [], term = [];
  late Map myValue = Map();

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
  void initState() {
    super.initState();
    SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);

    isLoading = true;
    getExamTerm();
  }

  Future<void> getExamTerm() async {
    HttpRequest request = HttpRequest();
    List value = await request.getExamTerm(context, token!);
    setState(() {
      term = value;
      Map map = {"id": "0", 'term': 'Select Term'};
      term.insert(0, map);
      tId = value[0]['id'];
      isLoading = false;
    });
  }

  Future<void> getExamReport() async {
    HttpRequest request = HttpRequest();
    var value = await request.getExamReport(context, token!, sId!, '$tId');
    setState(() {
      value != null ? isListEmpty = false : isListEmpty = true;
      value != null
          ? data = value['student_marks']
          : toastShow('Data is Empty');
      myValue = value;
      isLoading = false;
    });
  }

  List<DataRow> dataRow() {
    List<DataRow> rows = [];
    for (int j = 0; j < data.length; j++) {
      var value = DataRow(cells: <DataCell>[
        DataCell(
          Container(
            width: MediaQuery.of(context).size.width / 4,
            child: Text(
              '${data[j]['subject_name']}',
              style: TextStyle(fontSize: 13.0, fontWeight: FontWeight.w700),
              textAlign: TextAlign.start,
            ),
          ),
        ),
        DataCell(Container(
          width: MediaQuery.of(context).size.width / 5,
          child: Text(
            ' ${data[j]['total_marks'].toString()}',
            textAlign: TextAlign.center,
          ),
        )),
        DataCell(Container(
          width: MediaQuery.of(context).size.width / 5,
          child: Text(
            ' ${data[j]['marks'].toString()}',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: data[j]['marks'].toString() == 'A'
                  ? Colors.red
                  : data[j]['marks'].toString() == 'N/M'
                      ? Colors.blue
                      : Colors.black,
            ),
          ),
        )),
      ]);
      rows.add(value);
    }
    return rows;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(int.parse('$newColor')),
        systemOverlayStyle: SystemUiOverlayStyle.light,
        title: Text('Exams Result'),
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
          await db.execute('DELETE FROM daily_diary ');
          await db.execute('DELETE FROM profile ');
          await db.execute('DELETE FROM test_marks ');
          await db.execute('DELETE FROM subjects ');
          await db.execute('DELETE FROM monthly_exam_report ');
          await db.execute('DELETE FROM time_table ');
          await db.execute('DELETE FROM attendance ');
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
      body: SafeArea(
        child: isLoading
            ? Center(child: spinkit)
            : BackgroundWidget(
                childView: RefreshIndicator(
                  onRefresh: getExamReport,
                  child: ListView(children: [
                    dropDownWidget('$tId', getDropDownListItem(term, 'term'),
                        (value) {
                      setState(() {
                        tId = int.parse(value!);
                        getExamReport();
                        isLoading = true;
                      });
                    }, '$newColor'),
                    Container(
                      padding: EdgeInsets.only(top: 8.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          FinalResult(
                            value: 'Name: ${myValue['name'].toString()}',
                            newColor: '$newColor',
                          ),
                          FinalResult(
                            value: 'Roll No: ${myValue['roll_no'].toString()}',
                            newColor: '$newColor',
                          ),
                        ],
                      ),
                    ),
                    Container(
                      padding: EdgeInsets.symmetric(vertical: 8.0),
                      child: Container(
                        child: Text(
                          'N/M = Not Marked  |  A = Absent',
                          style: TextStyle(
                            fontSize: 13.0,
                            fontWeight: FontWeight.w700,
                            color: Color(
                              int.parse('$newColor'),
                            ),
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),
                    Container(
                      child: isListEmpty
                          ? Container(
                              color: Colors.transparent,
                              child: Lottie.asset('assets/no_data.json',
                                  repeat: true, reverse: true, animate: true),
                            )
                          : DataTable(
                              horizontalMargin: 16.0,
                              headingRowColor: MaterialStateProperty.all(
                                  Color(int.parse('$newColor'))),
                              headingRowHeight: 50.0,
                              columns: <DataColumn>[
                                DataColumn(
                                  label: Container(
                                    width:
                                        MediaQuery.of(context).size.width / 5,
                                    child: Text(
                                      'Subject',
                                      style: TextStyle(
                                          fontStyle: FontStyle.italic,
                                          fontSize: 16.0,
                                          fontWeight: FontWeight.w700,
                                          color: Colors.white),
                                    ),
                                  ),
                                ),
                                DataColumn(
                                  label: Container(
                                    width:
                                        MediaQuery.of(context).size.width / 5,
                                    child: Text(
                                      'Total',
                                      style: TextStyle(
                                          fontStyle: FontStyle.italic,
                                          fontSize: 16.0,
                                          fontWeight: FontWeight.w700,
                                          color: Colors.white),
                                      textAlign: TextAlign.center,
                                    ),
                                  ),
                                ),
                                DataColumn(
                                  label: Container(
                                    width:
                                        MediaQuery.of(context).size.width / 5,
                                    child: Text(
                                      'Obtained',
                                      style: TextStyle(
                                          fontStyle: FontStyle.italic,
                                          fontWeight: FontWeight.w700,
                                          fontSize: 16.0,
                                          color: Colors.white),
                                      textAlign: TextAlign.center,
                                    ),
                                  ),
                                ),
                              ],
                              rows: dataRow(),
                            ),
                    ),
                    FinalResults(
                        text1:
                            'Marks:  ${myValue['total_obtained'].toString()} /${myValue['total_marks'].toString()}',
                        text2:
                            'Percentage: ${myValue['percentage'].toString()}%',
                        newColor: newColor),
                    FinalResults(
                        text1: 'Position: ${myValue['position'].toString()}',
                        text2: 'Grade: Not Issue',
                        newColor: newColor),
                    FinalResults(
                        text1: 'P.Sign: Not Yet',
                        text2: 'Remarks: Not Issue',
                        newColor: newColor),
                  ]),
                ),
              ),
      ),
    );
  }
}

class FinalResults extends StatelessWidget {
  const FinalResults({
    Key? key,
    required this.newColor,
    required this.text1,
    required this.text2,
  }) : super(key: key);

  final String? newColor, text1, text2;

  @override
  Widget build(BuildContext context) {
    return DataTable(
      headingRowHeight: 30.0,
      headingTextStyle: TextStyle(
        fontStyle: FontStyle.italic,
        fontSize: 15.0,
        fontWeight: FontWeight.w700,
        color: Color(int.parse('$newColor')),
      ),
      columns: <DataColumn>[
        DataColumn(
          label: Container(
            width: MediaQuery.of(context).size.width / 3,
            child: Text(
              '$text1',
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              textAlign: TextAlign.start,
            ),
          ),
        ),
        DataColumn(
          label: Container(
            width: MediaQuery.of(context).size.width / 3,
            child: Text(
              '$text2',
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              textAlign: TextAlign.start,
            ),
          ),
        ),
      ],
      // rows: dataRow(),
      rows: [],
    );
  }
}

class FinalResult extends StatelessWidget {
  final String? value, newColor;

  const FinalResult({
    Key? key,
    required this.value,
    required this.newColor,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
        child: Text(
      '$value',
      style: TextStyle(
        fontSize: 15.0,
        fontWeight: FontWeight.w700,
        color: Color(
          int.parse('$newColor'),
        ),
      ),
      textAlign: TextAlign.start,
    ));
  }
}
