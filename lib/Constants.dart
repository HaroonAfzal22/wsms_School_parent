import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';
import 'package:wsms/HttpRequest.dart';
import 'package:wsms/Shared_Pref.dart';


var  _newColor,newString;

getSchoolInfo()async{
  var token = SharedPref.getUserToken();
  HttpRequest request= HttpRequest();
  var result = await request.getLogoColor(token!);
  await SharedPref.setSchoolLogo(result['logo']);
  await SharedPref.setSchoolColor(result['accent']);
  var colr = SharedPref.getSchoolColor();
   newString = colr!.substring(colr.length - 6);
}
getSchoolColor() {

  if(newString==null){
    _newColor = '0xff15728a';
  }else{
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
    showAgenda: true,
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
