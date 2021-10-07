import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';
import 'package:wsms/HttpRequest.dart';
import 'package:wsms/Shared_Pref.dart';

var _newColor, newString;

getSchoolInfo(context) async {
  var token = SharedPref.getUserToken();
  HttpRequest request = HttpRequest();
  var result = await request.getLogoColor(context,token!);
  await SharedPref.setSchoolLogo(result['logo']);
  await SharedPref.setSchoolName(result['school_name']);
  await SharedPref.setBranchName(result['branch_name']);
  await SharedPref.setSchoolColor(result['accent']);
  var colr = SharedPref.getSchoolColor();
  newString = colr!.substring(colr.length - 6);
}

getSchoolColor() {
  if (newString == null) {
    _newColor = '0xff15728a';
  } else {
    _newColor = '0xff$newString';
  }
  return _newColor;
}

var kTableStyle = TextStyle(
    fontSize: 18.0,
    fontStyle: FontStyle.italic,
    color: Colors.white,
    fontWeight: FontWeight.bold);

var kExpandStyle =
    TextStyle(fontStyle: FontStyle.italic, fontWeight: FontWeight.bold);

var kCalendarStyle = CalendarHeaderStyle(
  textAlign: TextAlign.center,
  backgroundColor: Color(int.parse('$_newColor')),
  textStyle: TextStyle(
      fontSize: 20,
      fontStyle: FontStyle.normal,
      letterSpacing: 3,
      color: Color(0xFFff5eaea),
      fontWeight: FontWeight.w500),
);

var kCalMonthSetting = MonthViewSettings(
    appointmentDisplayCount: 1,
    showTrailingAndLeadingDates: false,
    dayFormat: 'EEE',
    appointmentDisplayMode: MonthAppointmentDisplayMode.appointment);

toastShow(text) {
  Fluttertoast.showToast(
      msg: text,
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.BOTTOM,
      timeInSecForIosWeb: 1,
      backgroundColor: Color(int.parse('$_newColor')),
      textColor: Colors.white,
      fontSize: 12.0);
}

var spinkit = SpinKitCircle(
  color: Color(int.parse('$_newColor')),
  size: 50.0,
);

statusColor(newColor) {
  SystemChrome.setSystemUIOverlayStyle(
    SystemUiOverlayStyle(
      statusBarColor: Color(int.parse('$newColor')),
    ),
  );
}

var kBoxDecorateStyle = BoxDecoration(
  borderRadius: BorderRadius.circular(4.0),
  border: Border.all(
    color: Color(int.parse('$_newColor')),
  ),
);

var kBoxConstraints = BoxConstraints(maxWidth: double.infinity, minWidth: 150);
var kBoxesConstraints =
    BoxConstraints(maxWidth: double.infinity, minWidth: 360);

var kMargin = EdgeInsets.symmetric(horizontal: 16.0);
var kMargins = EdgeInsets.symmetric(horizontal: 16.0,vertical: 8.0);
var kAttendPadding = EdgeInsets.symmetric(horizontal: 8.0, vertical: 16.0);
var kAttendsPadding = EdgeInsets.symmetric(horizontal: 128.0, vertical: 16.0);
var kTextStyle = TextStyle(
  color: Color(int.parse('$_newColor')),
  fontWeight: FontWeight.bold,
);
var kElevateStyle= ElevatedButton.styleFrom(
  primary:  Color(int.parse('$_newColor')),
);
var kButtonStyle = ElevatedButton.styleFrom(
  primary: Color(int.parse('$_newColor')),
  fixedSize: Size.fromHeight(50.0),
);
var kTextsFieldStyle = InputDecoration(
  hintText: 'Enter your complaints here...',
  hintStyle: TextStyle(
    color: Colors.grey.shade500,
  ),
  border: OutlineInputBorder(
    borderRadius: BorderRadius.all(Radius.circular(8.0)),
    borderSide: BorderSide(width: 1.0),
  ),
  enabledBorder:
  OutlineInputBorder(borderSide: BorderSide(color: Colors.grey.shade600)),
  disabledBorder: OutlineInputBorder(
    borderSide: BorderSide(color: Colors.grey.shade600),
  ),
  focusedBorder: OutlineInputBorder(
    borderSide: BorderSide(color: Color(int.parse('$_newColor'))),
  ),
);

var kTextFieldStyle = InputDecoration(
  hintText: 'Enter your leave reason here...',
  hintStyle: TextStyle(
    color: Colors.grey.shade500,
  ),
  border: OutlineInputBorder(
    borderRadius: BorderRadius.all(Radius.circular(8.0)),
    borderSide: BorderSide(width: 1.0),
  ),
  enabledBorder:
      OutlineInputBorder(borderSide: BorderSide(color: Colors.grey.shade600)),
  disabledBorder: OutlineInputBorder(
    borderSide: BorderSide(color: Colors.grey.shade600),
  ),
  focusedBorder: OutlineInputBorder(
    borderSide: BorderSide(color: Color(int.parse('$_newColor'))),
    ),
);
var kTStyle =TextStyle(
  fontSize: 16.0,
  fontWeight: FontWeight.w500,
  color: Color(int.parse('$_newColor')),
);