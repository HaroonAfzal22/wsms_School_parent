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
import 'package:wsms/Background.dart';
import 'package:wsms/Constants.dart';
import 'package:wsms/HtmlWidgets.dart';
import 'package:wsms/HttpRequest.dart';
import 'package:wsms/NavigationDrawer.dart';
import 'package:wsms/Shared_Pref.dart';

class MonthlyExamReport extends StatefulWidget {
  const MonthlyExamReport({Key? key}) : super(key: key);

  @override
  _MonthlyExamReportState createState() => _MonthlyExamReportState();
}

class _MonthlyExamReportState extends State<MonthlyExamReport> {
  var token = SharedPref.getUserToken();
  var sId = SharedPref.getStudentId();
  var textId, sectId, format = 'select date';
  late var result1, result2;

  var newColor=SharedPref.getSchoolColor();
  List classValue = [], sectionValue = [];
  DateTime selectedDate = DateTime.now();
  bool isLoading = false;
  late var val = 3;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    SystemChrome.setPreferredOrientations([DeviceOrientation.landscapeLeft]);
    isLoading = true;
    monthReport();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
        onWillPop: _onPopScope,
        child: Scaffold(
          appBar: AppBar(
            elevation: 0,
            title: Text('Monthly Exam Report'),
            backgroundColor: Color(int.parse('$newColor')),
            systemOverlayStyle: SystemUiOverlayStyle.light,
          ),
          drawer: Drawers(),
          body: isLoading
              ? Center(
                  child: spinkit,
                )
              : SafeArea(
                  child: BackgroundWidget(
                  childView: Column(
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
                )),
        ));
  }

  late List textValue = [];



  monthReport() async {
    HttpRequest req = HttpRequest();
    var html =
        await req.studentMonthlyExamReport(context, token!, sId.toString());
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
