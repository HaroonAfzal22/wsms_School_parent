import 'package:flutter/material.dart';
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
  late var newColor;
  List result = [];
  bool isLoading = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    Future(()async{
      return await   getSchoolInfo();
    });
    newColor= getSchoolColor();
    isLoading = true;

    getEAttendance();
  }
  setColor()async{
    var color =await getSchoolColor();
    setState(() {
      newColor = color;
    });
  }
  void getEAttendance() async {
    HttpRequest request = HttpRequest();
    var res = await request.studentAttendance(context, token!, tok!);
    setState(() {
      if (res != null) {
        result = res;
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
        brightness: Brightness.dark,
      ),
      drawer: Drawers(
        complaint: null,
        aboutUs: () {
          Navigator.pop(context);
          Navigator.pushNamed(context, '/list_attendance');
        },
        PTM: null,
        dashboards: () {
          Navigator.pushReplacementNamed(context, '/dashboard');
        },
        Leave: null,
        onPress: () {
          setState(() {
            SharedPref.removeData();
            Navigator.pop(context);
            Navigator.pushReplacementNamed(context, '/');
            toastShow("Logout Successfully");
          });
        },
      ),
      body: BackgroundWidget(
        childView: isLoading
            ? Center(
                child: spinkit,
              )
            : SafeArea(
                child: Container(
                  child: SfCalendar(
                    view: CalendarView.month,
                    headerHeight: 50,
                    showDatePickerButton: true,
                    headerStyle: kCalendarStyle,
                    dataSource: _getCalendarDataSource(result),
                    monthViewSettings: kCalMonthSetting,
                  ),
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
  late var newColor=getSchoolColor();
  for (int i = 0; i < listValue.length; i++) {
    if (listValue[i]['attendance'] == 1) {
      value = '    Present';
      colors = Color(int.parse('$newColor'));
    } else if (listValue[i]['attendance'] == 2) {
      value = '    Absent';
      colors = Colors.red;
    } else if (listValue[i]['attendance'] == 3) {
      value = '     Leave';
      colors = Colors.black45;
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
