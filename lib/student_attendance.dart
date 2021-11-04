import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:wsms/Background.dart';
import 'package:wsms/Constants.dart';
import 'package:wsms/HttpRequest.dart';
import 'package:wsms/NavigationDrawer.dart';
import 'package:wsms/Shared_Pref.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';

class StudentAttendance extends StatefulWidget {
  @override
  _StudentAttendanceState createState() => _StudentAttendanceState();
}

class _StudentAttendanceState extends State<StudentAttendance> {
  var token = SharedPref.getUserToken();
  var tok = SharedPref.getStudentId();
  late var newColor, overView;
  List result = [];
  bool isLoading = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    isLoading = true;
    setColor();
    getEAttendance();
  }

  setColor() async {
    var color = await getSchoolColor();
    setState(() {
      newColor = color;
    });
  }

  void getEAttendance() async {
    HttpRequest request = HttpRequest();
    var res = await request.studentAttendance(context, token!, tok!);
    setState(() {
      if (res != null) {
        result = res['data'];
        overView = res['overview'];
      } else
        toastShow('No Attendance Found/List Empty');
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Student Attendance'),
        backgroundColor: Color(int.parse('$newColor')),
        systemOverlayStyle: SystemUiOverlayStyle.light,
      ),
      drawer: Drawers(),
      body: BackgroundWidget(
        childView: isLoading
            ? Center(
                child: spinkit,
              )
            : SafeArea(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Expanded(
                      flex: 4,
                      child: SfCalendar(
                        view: CalendarView.month,
                        headerHeight: 50,
                        showDatePickerButton: true,
                        headerStyle: kCalendarStyle,
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
