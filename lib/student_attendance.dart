import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sqflite/sqflite.dart';
import 'package:wsms/Background.dart';
import 'package:wsms/Constants.dart';
import 'package:wsms/HttpRequest.dart';
import 'package:wsms/NavigationDrawer.dart';
import 'package:wsms/Shared_Pref.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';
import 'package:wsms/main.dart';

class StudentAttendance extends StatefulWidget {
  @override
  _StudentAttendanceState createState() => _StudentAttendanceState();
}

class _StudentAttendanceState extends State<StudentAttendance> {
  var token = SharedPref.getUserToken();
  var tok = SharedPref.getStudentId();
  var newColor = SharedPref.getSchoolColor(), overView;
  List result = [];
  bool isLoading = false;
  late final db;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    isLoading = true;

    Future(() async {
      db = await database;
      getEAttendance();
    });
  }

  void getEAttendance() async {
    var value = await db.query('attendance');

    if (value.isNotEmpty) {
      setState(() {
        var res = jsonDecode(value[0]['data']);
        result = res['data'];
        overView = res['overview'];
        isLoading = false;
      });
    } else {
      HttpRequest request = HttpRequest();
      var res = await request.studentAttendance(context, token!, tok!);
      if (res == 500) {
        toastShow('Server Error!!! Try Again Later...');
        setState(() {
          isLoading = false;
        });
      } else {
        await db.execute('DELETE  FROM  attendance');
        setState(() {
          if (res != null) {
            result = res['data'];
            overView = res['overview'];
          } else
            toastShow('No Attendance Found/List Empty');
          isLoading = false;
        });
        Map<String, Object?> map = {
          'data': jsonEncode(res),
        };
        await db.insert('attendance', map,
            conflictAlgorithm: ConflictAlgorithm.replace);
      }
    }
  }

 Future<void> updateAttendance() async {
    HttpRequest request = HttpRequest();
    var res = await request.studentAttendance(context, token!, tok!);
    if (res == 500) {
      toastShow('Server Error!!! Try Again Later...');
      setState(() {
        isLoading = false;
      });
    } else {
      await db.execute('DELETE  FROM  attendance');
      setState(() {
        if (res != null) {
          result = res['data'];
          overView = res['overview'];
        } else
          toastShow('No Attendance Found/List Empty');
        isLoading = false;
      });
      Map<String, Object?> map = {
        'data': jsonEncode(res),
      };
      await db.insert('attendance', map,
          conflictAlgorithm: ConflictAlgorithm.replace);
    }

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Student Attendance'),
        backgroundColor: Color(int.parse('$newColor')),
        systemOverlayStyle: SystemUiOverlayStyle.light,
        actions: <Widget>[
          Container(
            child: TextButton(
              onPressed: () {
                setState(() {
                  isLoading = true;
                  updateAttendance();
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
        ],
      ),
      drawer: Drawers(),
      body: BackgroundWidget(
        childView: isLoading
            ? Center(
                child: spinkit,
              )
            : Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Expanded(
                      flex: 4,
                      child: SfCalendar(
                        view: CalendarView.month,
                        headerHeight: 50,
                        showDatePickerButton: true,
                        headerStyle: CalendarHeaderStyle(
                          textAlign: TextAlign.center,
                          backgroundColor: Color(int.parse('$newColor')),
                          textStyle:kCalendarStyle,),
                        dataSource: _getCalendarDataSource(result),
                        monthViewSettings: kCalMonthSetting,
                      ),
                    ),
                    Expanded(
                      child: Container(
                        margin: EdgeInsets.only(top: 8.0),
                        child: Row(
                          children: [
                            Expanded(
                              child: Container(
                                height: 80,
                                child: Card(
                                  color: Color(0xff459d76),
                                  child: Container(
                                    alignment: Alignment.center,
                                    child: ListTile(
                                      leading: Icon(
                                        CupertinoIcons.calendar,
                                        color: Colors.white,
                                      ),
                                      title: Text(
                                        'Total Presents: ${overView['presents']}',
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 16.0,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            Expanded(
                              child: Container(
                                height: 80,
                                child: Card(
                                  color: Color(0xffFFc517),
                                  child: Container(
                                    alignment: Alignment.center,
                                    child: ListTile(
                                      leading: Icon(
                                        CupertinoIcons.calendar,
                                        color: Colors.white,
                                      ),
                                      title: Text(
                                        'Total Leaves: ${overView['leaves']}',
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 16.0,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    Expanded(
                      child: Container(
                        margin: EdgeInsets.only(bottom: 16.0),
                        child: Row(
                          children: [
                            Expanded(
                              child: Container(
                                height: 80,
                                child: Card(
                                  color: Color(0xffdd1747),
                                  child: Container(
                                    alignment: Alignment.center,
                                    child: ListTile(
                                      leading: Icon(
                                        CupertinoIcons.calendar,
                                        color: Colors.white,
                                      ),
                                      title: Text(
                                        'Total Absents: ${overView['absents']}',
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 16.0,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            Expanded(
                              child: Container(
                                height: 80,
                                child: Card(
                                  color: Color(0xffFD8a2b),
                                  child: Container(
                                    alignment: Alignment.center,
                                    child: ListTile(
                                      leading: Icon(
                                        CupertinoIcons.calendar,
                                        color: Colors.white,
                                      ),
                                      title: Text(
                                        'Percentage: ${overView['percentage']}%',
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 16.0,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
      ),
    );
  }
}

class DataSource extends CalendarDataSource {
  DataSource(List source) {
    appointments = source;
  }
}

DataSource _getCalendarDataSource(List listValue) {
  List appointments = [];
  String value = '';
  Color colors;
  for (int i = 0; i < listValue.length; i++) {
    if (listValue[i]['attendance'] == 1) {
      value = '    Present';
      colors = Color(0xff459d76);
    } else if (listValue[i]['attendance'] == 2) {
      value = '    Absent';
      colors = Colors.red;
    } else if (listValue[i]['attendance'] == 3) {
      value = '     Leave';
      colors = Color(0xffFFc517);
    } else {
      value = '    Holidays';
      colors = Colors.cyan;
    }
    var appoint = Appointment(
      startTime: DateTime.parse(listValue[i]['attendance_date']),
      endTime: DateTime.parse(listValue[i]['attendance_date']),
      isAllDay: true,
      subject: value,
      color: colors,
      startTimeZone: 'Pakistan Standard Time',
      endTimeZone: 'Pakistan Standard Time',
    );
    appointments.add(appoint);
  }
  return DataSource(appointments);
}
