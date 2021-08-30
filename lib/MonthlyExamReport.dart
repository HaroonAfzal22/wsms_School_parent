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
  late var result = 'waiting...';
  List classValue = [], sectionValue = [];
  DateTime selectedDate = DateTime.now();
  bool isLoading = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    //SystemChrome.setPreferredOrientations([DeviceOrientation.landscapeLeft]);
    isLoading=true;
    monthReport();
  }

   monthReport()async{
    HttpRequest req = HttpRequest();
    var html = await req.studentMonthlyExamReport(context, token!, sId.toString());
    setState(() {
      if (html != null) {
        result = html.toString();
        isLoading = false;
      }
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
    Navigator.pushReplacementNamed(context, '/result_category');
    return false;
  }

  var spinkit = SpinKitFadingCircle(
    color: Color(0xff18728a),
    size: 50.0,
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Monthly Exam Report'),
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
            Fluttertoast.showToast(
                msg: "Logout Successfully",
                toastLength: Toast.LENGTH_SHORT,
                gravity: ToastGravity.BOTTOM,
                timeInSecForIosWeb: 1,
                backgroundColor: Color(0xff18726a),
                textColor: Colors.white,
                fontSize: 12.0);
          });
        }, aboutUs: null,
      ),
      body: isLoading
          ? Center(
              child: spinkit,
            )
          : SafeArea(
              child: Html(
                data: result,
                style: {
                  "table": Style(
                    backgroundColor:
                    Color.fromARGB(0x50, 0xee, 0xee, 0xee),
                  ),
                  "tr": Style(
                    border:
                    Border(bottom: BorderSide(color: Colors.grey)),
                  ),
                  "th": Style(
                    color: Colors.white,
                    alignment: Alignment.center,
                    textAlign:TextAlign.center,
                    padding: EdgeInsets.all(6),
                    backgroundColor: Color(0xff15728a),
                  ),
                  "td": Style(
                    color: Color(0xff15728a),
                    alignment: Alignment.center,
                    textAlign:TextAlign.center,
                    padding: EdgeInsets.all(6),
                  ),
                },
                customRender: {
                  "table": (context, child) {
                    return SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: (context.tree as TableLayoutElement)
                          .toWidget(context),
                    );
                  },

                },
                onImageError: (exception, stackTrace) {
                  print(exception);
                },
                onCssParseError: (css, messages) {
                  print("css that errored: $css");
                  print("error messages:");
                  messages.forEach((element) {
                    print(element);
                  });
                },
              ),
        /* ListView(
                children: [
                  Container(
                    margin: EdgeInsets.only(top: 8.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Stack(
                          children: [
                            Container(
                              constraints: BoxConstraints(
                                  maxWidth: double.maxFinite, minWidth: 200),
                              decoration: BoxDecoration(
                                border: Border.all(
                                  color: Color(0xff15728a),
                                ),
                                borderRadius: BorderRadius.circular(4.0),
                              ),
                              margin: EdgeInsets.only(right: 16.0),
                              child: Padding(
                                padding: EdgeInsets.symmetric(
                                    vertical: 16.0, horizontal: 8.0),
                                child: Text(
                                  '$format',
                                  style: TextStyle(
                                    color: Color(0xff15728a),
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ),
                            Positioned(
                              right: 10.0,
                              child: Container(
                                child: IconButton(
                                  onPressed: () => _selectDate(context),
                                  icon: Icon(
                                    CupertinoIcons.calendar,
                                    color: Color(0xff15728a),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                        Container(
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              fixedSize: Size.fromHeight(50.0),
                              primary: Color(0xff15728a),
                            ),
                            child: Text('Monthly Report'),
                            onPressed: () async {
                              setState(() {
                                isLoading = true;
                              });

                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                  Html(
                    data: result,
                    style: {
                      "table": Style(
                        backgroundColor:
                            Color.fromARGB(0x50, 0xee, 0xee, 0xee),
                      ),
                      "tr": Style(
                        border:
                            Border(bottom: BorderSide(color: Colors.grey)),
                      ),
                      "th": Style(
                        color: Colors.white,
                        alignment: Alignment.center,
                        textAlign:TextAlign.center,
                        padding: EdgeInsets.all(6),
                        backgroundColor: Color(0xff15728a),
                      ),
                      "td": Style(
                        color: Color(0xff15728a),
                        alignment: Alignment.center,
                        textAlign:TextAlign.center,
                        padding: EdgeInsets.all(6),
                      ),
                    },
                    customRender: {
                      "table": (context, child) {
                        return SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          child: (context.tree as TableLayoutElement)
                              .toWidget(context),
                        );
                      },

                    },
                    onImageError: (exception, stackTrace) {
                      print(exception);
                    },
                    onCssParseError: (css, messages) {
                      print("css that errored: $css");
                      print("error messages:");
                      messages.forEach((element) {
                        print(element);
                      });
                    },
                  ),
                ],
              ),*/
            ),
    );
  }
}
