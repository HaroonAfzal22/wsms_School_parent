import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';

var kTableStyle = TextStyle(
    fontSize: 18.0,
    fontStyle: FontStyle.italic,
    color: Colors.white,
    fontWeight: FontWeight.bold);
var kExpandStyle = TextStyle(fontStyle: FontStyle.italic, fontWeight: FontWeight.bold);


var kCalendarStyle = CalendarHeaderStyle(
  textAlign: TextAlign.center,
  backgroundColor: Color(0xFF15728a),
  textStyle: TextStyle(
      fontSize: 20,
      fontStyle: FontStyle.normal,
      letterSpacing: 3,
      color: Color(0xFFff5eaea),
      fontWeight: FontWeight.w500),
);

var kCalMonthSetting =  MonthViewSettings(
    showTrailingAndLeadingDates: false,
    dayFormat: 'EEE',
    appointmentDisplayMode:
    MonthAppointmentDisplayMode.appointment);

toastShow(text){
  Fluttertoast.showToast(
      msg: text,
      toastLength:
      Toast.LENGTH_SHORT,
      gravity: ToastGravity.BOTTOM,
      timeInSecForIosWeb: 1,
      backgroundColor:
      Color(0xff18726a),
      textColor: Colors.white,
      fontSize: 12.0);
}

var spinkit = SpinKitCircle(
  color: Color(0xff18728a),
  size: 50.0,
);