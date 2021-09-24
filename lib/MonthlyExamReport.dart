import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:flutter_html/html_parser.dart';
import 'package:flutter_html/image_render.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:jiffy/jiffy.dart';
import 'package:wsms/Constants.dart';
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
  late var result;

  var newColor = '0xff15728a';
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
    setColor();
    monthReport();
  }

  @override
  Widget build(BuildContext context) {
    setState(() {
      statusColor(newColor);
    });
    return WillPopScope(
      onWillPop: _onPopScope,
      child: Scaffold(
        appBar: AppBar(
          elevation: 0,
          title: Text('Monthly Exam Report'),
          backgroundColor: Color(int.parse('$newColor')),
          brightness: Brightness.dark,
        ),
        drawer: Drawers(
          complaint: null,
          PTM: null,
          dashboards: () {
            Navigator.pushReplacementNamed(context, '/dashboard');
          },
          Leave: null,
          onPress: () {
            setState(() {
              SharedPref.removeData();
              Navigator.pushReplacementNamed(context, '/');
              toastShow("Logout Successfully");
            });
          },
          aboutUs: null,
        ),
        body: isLoading
            ? Center(
                child: spinkit,
              )
            : SafeArea(
                child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Expanded(
                    flex: 1,
                    child: Container(
                      height: 40,
                      color: Color(int.parse('$newColor')),
                      child: SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children:
                              List.generate(result['header'].length, (index) {
                            return RichText(
                              text: TextSpan(children: [
                                TextSpan(
                                  text: '${result['header'][index]}',
                                  style: kTableStyle,
                                ),
                                TextSpan(
                                  text: ' | ',
                                  style: TextStyle(color: Colors.grey),
                                ),
                              ]),
                            );
                          }),
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    flex: 2,
                    child: Column(
                      children: List.generate(result['marks'].length, (index) {
                        return Text(showMonth(index));
                      }),
                    ),
                  ),
                  Expanded(
                    flex: 8,
                    child: ListView.builder(
                      itemBuilder: (context, index) {
                        return Container(
                          height: 100,
                          child: Column(
                            children: [
                              Text(showMonth(index)),
                              Row(
                                children: [
                                  Container(
                                    padding:
                                        EdgeInsets.symmetric(horizontal: 4.0),
                                    child: Center(
                                      child: Text(
                                        'data $index',
                                        style: kExpandStyle,
                                      ),
                                    ),
                                  ),
                                  VerticalDivider(
                                    thickness: 0.5,
                                    width: 0.5,
                                    indent: 13,
                                    endIndent: 7,
                                    color: Colors.grey,
                                  ),
                                ],
                              ),
                            ],
                          ),
                        );
                      },
                      itemCount: val,
                      scrollDirection: Axis.horizontal,
                    ),
                  ),
                ],
              )),
      ),
    );
  }

  setColor() async {
    var color = await getSchoolColor();
    setState(() {
      newColor = color;
    });
  }

  monthReport() async {
    HttpRequest req = HttpRequest();
    var html =
        await req.studentMonthlyExamReport(context, token!, sId.toString());
    setState(() {
      result = html;

      print('responser is $val');
      isLoading = false;
    });
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

  showMonth(index) {
    if (result['marks'][index]['month'] == '01') {
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
  }
}
