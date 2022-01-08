import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:flutter_phoenix/flutter_phoenix.dart';
import 'package:html/parser.dart' as htmlParse;
import 'package:wsms/Background.dart';
import 'package:wsms/Constants.dart';
import 'package:wsms/HttpRequest.dart';
import 'package:wsms/NavigationDrawer.dart';
import 'package:wsms/Shared_Pref.dart';

class ClassTimeTable extends StatefulWidget {
  const ClassTimeTable({Key? key}) : super(key: key);

  @override
  _ClassTimeTableState createState() => _ClassTimeTableState();
}
// here class time table is displayed from api in html form
class _ClassTimeTableState extends State<ClassTimeTable> {
  DateTime selectedDate = DateTime.now();
  var token = SharedPref.getUserToken();
  var sId = SharedPref.getStudentId();
  late var result='waiting' ,newColor= SharedPref.getSchoolColor();
  bool isLoading = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    //SystemChrome.setPreferredOrientations([DeviceOrientation.landscapeLeft]);
     isLoading=true;
     getClasses();
  }

// for get data from api about student attendance
 Future<void> getClasses() async {
    HttpRequest httpRequest = HttpRequest();
    var classes = await httpRequest.studentClassTimeTable(context,token!,sId!);
    if (classes == 500) {
      toastShow('Server Error!!! Try Again Later...');
      setState(() {
        isLoading = false;
      });
    }else {
      setState(() {
        var document = htmlParse.parse('$classes');

        result.isNotEmpty ? result = classes : toastShow('No Time Table Found/Data Empty');

        isLoading = false;

        print('result ${classes}');
      });
    }
  }

  // to set rotate screen
  Future<bool> _onPopScope() async {
    SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
    return true;
  }

  Future<void> updateApp() async {
    setState(() {
      isLoading=true;
    });
    Map map = {
      'fcm_token': SharedPref.getUserFcmToken(),
    };
    HttpRequest request = HttpRequest();
    var results = await request.postUpdateApp(context, token!, map);
    if (results == 500) {
      toastShow('Server Error!!! Try Again Later...');
    } else {
      SharedPref.removeSchoolInfo();
      await getSchoolInfo(context);
      await getSchoolColor();
      setState(() {
        newColor = SharedPref.getSchoolColor()!;
        isLoading=false;
      });

      results['status'] == 200
          ? snackShow(context, 'Sync Successfully')
          : snackShow(context, 'Sync Failed');
    }
  }


  @override
  Widget build(BuildContext context) {

    return WillPopScope(
      onWillPop: _onPopScope,
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Color(int.parse('$newColor')),
          title: Text('Time Table'),
          systemOverlayStyle: SystemUiOverlayStyle.light,
        ),
        drawer:  Drawers(logout:  () async {
          // on signout remove all local db and shared preferences
          Navigator.pop(context);

          setState(() {
            isLoading=true;
          });
          HttpRequest request = HttpRequest();
          var res =
          await request.postSignOut(context, token!);
        /*  await db.execute('DELETE FROM daily_diary ');
          await db.execute('DELETE FROM profile ');
          await db.execute('DELETE FROM test_marks ');
          await db.execute('DELETE FROM subjects ');
          await db.execute('DELETE FROM monthly_exam_report ');
          await db.execute('DELETE FROM time_table ');
          await db.execute('DELETE FROM attendance ');*/
          Navigator.pushReplacementNamed(context, '/');
          setState(() {
            if (res['status'] == 200) {
              SharedPref.removeData();
              snackShow(context, 'Logout Successfully');
              isLoading=false;
            } else {
              isLoading=false;
              snackShow(context, 'Logout Failed');
            }
          });

        },sync: () async {
          Navigator.pop(context);
          await updateApp();
          Phoenix.rebirth(context);
        },),
        body: isLoading
            ? Center(
                child: spinkit,
              )
            : SafeArea(
                child: BackgroundWidget(
                  childView: RefreshIndicator(
                    onRefresh: getClasses,
                    child: ListView(
                      children: [
                        Html(
                          // to show html data using flutter_html package
                          data: result,
                          style: {
                            "table": Style(
                              backgroundColor: Color.fromARGB(0x50, 0xee, 0xee, 0xee),
                              margin: EdgeInsets.symmetric(horizontal: 2.0,vertical: 12.0),

                            ),
                            "tr": Style(
                              border: Border(bottom: BorderSide(color: Colors.grey)),
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
                            "div": Style(
                              color: Colors.white,
                              fontSize: FontSize.large,
                              fontWeight: FontWeight.w700,
                              backgroundColor: Color(int.parse('$newColor')),
                              textAlign: TextAlign.center,
                              padding: EdgeInsets.only(top: 4,bottom: 4),
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
                      ],
                    ),
                  ),
                ),
              ),
      ),
    );
  }
}
