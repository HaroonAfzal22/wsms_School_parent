import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';
import 'package:wsms/Shared_Pref.dart';

getSchoolColor() {
  var newString = color!.substring(color!.length - 6);
  _newColor = '0xff$newString';

  return _newColor;
}

var _colors = getSchoolColor();

var kTableStyle = TextStyle(
    fontSize: 18.0,
    fontStyle: FontStyle.italic,
    color: Colors.white,
    fontWeight: FontWeight.bold);

var kExpandStyle =
    TextStyle(fontStyle: FontStyle.italic, fontWeight: FontWeight.bold);

var kCalendarStyle = CalendarHeaderStyle(
  textAlign: TextAlign.center,
  backgroundColor: Color(int.parse('$_colors')),
  textStyle: TextStyle(
      fontSize: 20,
      fontStyle: FontStyle.normal,
      letterSpacing: 3,
      color: Color(0xFFff5eaea),
      fontWeight: FontWeight.w500),
);

var kCalMonthSetting = MonthViewSettings(
    showTrailingAndLeadingDates: false,
    dayFormat: 'EEE',
    appointmentDisplayMode: MonthAppointmentDisplayMode.appointment);

toastShow(text) {
  Fluttertoast.showToast(
      msg: text,
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.BOTTOM,
      timeInSecForIosWeb: 1,
      backgroundColor: Color(int.parse('$_colors')),
      textColor: Colors.white,
      fontSize: 12.0);
}

var color = SharedPref.getSchoolColor(), _newColor;

var spinkit = SpinKitCircle(
  color: Color(int.parse('$_colors')),
  size: 50.0,
);

statusColor(newColor) {
  SystemChrome.setSystemUIOverlayStyle(
    SystemUiOverlayStyle(
      statusBarColor: Color(int.parse('$newColor')),
    ),
  );
}
