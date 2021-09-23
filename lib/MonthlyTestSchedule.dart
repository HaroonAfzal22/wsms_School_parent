import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:wsms/Background.dart';
import 'package:wsms/Constants.dart';
import 'package:wsms/HttpRequest.dart';
import 'package:wsms/Shared_Pref.dart';

import 'NavigationDrawer.dart';

class MonthlyTestSchedule extends StatefulWidget {
  const MonthlyTestSchedule({Key? key}) : super(key: key);

  @override
  _MonthlyTestScheduleState createState() => _MonthlyTestScheduleState();
}

class _MonthlyTestScheduleState extends State<MonthlyTestSchedule> {
  var token = SharedPref.getUserToken();
  var sId = SharedPref.getStudentId();
  late var result = 'waiting...', newColor;
  bool isLoading = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    Future(()async{
      return await   getSchoolInfo();
    });
    newColor= getSchoolColor();
   // SystemChrome.setPreferredOrientations([DeviceOrientation.landscapeLeft]);
    isLoading = true;
    getMonthlyTestSchedule(token!);
  }
  setColor()async{
    var color =await getSchoolColor();
    setState(() {
      newColor = color;
    });
  }

  void getMonthlyTestSchedule(String token) async {
    HttpRequest httpRequest = HttpRequest();
    var classes =
        await httpRequest.studentMonthlyTestSchedule(context, token, sId!);
    setState(() {
      result.isNotEmpty
          ? result = classes
          : toastShow('No Test Schedule Found/Data Empty');
      isLoading = false;
    });
  }

  Future<bool> _onPopScope() async {
    SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
    return true;
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
          backgroundColor: Color(int.parse('$newColor')),
          title: Text('Monthly Test Schedule'),
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
                child: ListView(
                  scrollDirection: Axis.horizontal,
                  children: [
                   Container(
                     constraints: BoxConstraints(
                       maxWidth: double.maxFinite,
                       maxHeight: double.maxFinite
                     ),
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
                              padding: EdgeInsets.all(6),
                              backgroundColor: Color(int.parse('$newColor')),
                            ),
                            "td": Style(
                              color: Color(int.parse('$newColor')),
                              alignment: Alignment.center,
                              padding: EdgeInsets.all(6),
                            ),
                          },
                          customRender: {
                            "table": (context, child) {
                              return SingleChildScrollView(
                                scrollDirection: Axis.vertical,
                                child: (context.tree as TableLayoutElement)
                                    .toWidget(context),
                              );
                            },
                          },
                          onImageError: (exception, stackTrace) {
                            print(exception);
                          },
                          onCssParseError: (css, messages) {
                            print("css that error: $css");
                            print("error messages:");
                            messages.forEach((element) {
                              print(element);
                            });
                          },
                        ),
                   ),
                  ],
                ),
              ),
      ),
    );
  }
}
