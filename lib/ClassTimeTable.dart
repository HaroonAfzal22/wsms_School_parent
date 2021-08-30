import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:wsms/Constants.dart';
import 'package:wsms/HttpRequest.dart';
import 'package:wsms/NavigationDrawer.dart';
import 'package:wsms/Shared_Pref.dart';

class ClassTimeTable extends StatefulWidget {
  const ClassTimeTable({Key? key}) : super(key: key);

  @override
  _ClassTimeTableState createState() => _ClassTimeTableState();
}

class _ClassTimeTableState extends State<ClassTimeTable> {
  DateTime selectedDate = DateTime.now();
  var token = SharedPref.getUserToken();
  var sId = SharedPref.getStudentId();
  late var result = 'waiting...';
  bool isLoading = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    SystemChrome.setPreferredOrientations([DeviceOrientation.landscapeLeft]);
   isLoading=true;
    getClasses(token!);
  }

  void getClasses(String token) async {
    HttpRequest httpRequest = HttpRequest();
    var classes = await httpRequest.studentClassTimeTable(context,token,sId!);
   setState(() {
     result.isNotEmpty? result = classes: toastShow('No Time Table Found/Data Empty');
      isLoading=false;
    });
  }

  Future<bool> _onPopScope() async {
    SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
    return true;
  }

  var spinkit = SpinKitFadingCircle(
    color: Color(0xff18728a),
    size: 50.0,
  );

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _onPopScope,
      child: Scaffold(
        appBar: AppBar(
          title: Text('Time Table'),
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
                child: ListView(
                  children: [
                    SingleChildScrollView(
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
                            backgroundColor: Color(0xff15728a),
                          ),
                          "td": Style(
                            color: Color(0xff15728a),
                            alignment: Alignment.center,
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
