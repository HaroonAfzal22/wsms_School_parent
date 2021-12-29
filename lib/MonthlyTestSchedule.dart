import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:flutter_phoenix/flutter_phoenix.dart';
import 'package:flutter_widget_from_html/flutter_widget_from_html.dart';
import 'package:html/parser.dart';
import 'package:sqflite/sqflite.dart';
import 'package:wsms/Background.dart';
import 'package:wsms/Constants.dart';
import 'package:wsms/HttpRequest.dart';
import 'package:wsms/Shared_Pref.dart';
import 'package:wsms/main.dart';
import 'HtmlWidgets.dart';
import 'NavigationDrawer.dart';

class MonthlyTestSchedule extends StatefulWidget {
  const MonthlyTestSchedule({Key? key}) : super(key: key);

  @override
  _MonthlyTestScheduleState createState() => _MonthlyTestScheduleState();
}

//for get monthly test schedule
class _MonthlyTestScheduleState extends State<MonthlyTestSchedule> {
  var token = SharedPref.getUserToken(),
      sId = SharedPref.getStudentId();
  late var result,
      newColor = SharedPref.getSchoolColor();
  late final db;
  List compare = [];
  bool isLoading = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    // SystemChrome.setPreferredOrientations([DeviceOrientation.landscapeLeft]);
    isLoading = true;
    // to initialize db local
    Future(() async {
      db = await database;
      (await db.query('sqlite_master', columns: ['type', 'name']))
          .forEach((row) {
        setState(() {
          compare.add(row);
        });
      });
      //getMonthlyTestSchedule(token!);
      createTimeTable();
    });
  }

// to get monthly test schedule from api in html format and store in local db
  void getMonthlyTestSchedule(String token) async {
    if (compare[6]['name'] == 'time_table') {
      var value = await db.query('time_table');
      if (value.isNotEmpty) {
        setState(() {
          result = jsonDecode(value[0]['data']);
          isLoading = false;
        });
      } else {
        HttpRequest httpRequest = HttpRequest();
        var classes =
        await httpRequest.studentMonthlyTestSchedule(context, token, sId!);
        if (classes == 500) {
          toastShow('Server Error!!! Try Again Later...');
          setState(() {
            isLoading = false;
          });
        } else {
          await db.execute('DELETE FROM time_table');
          setState(() {
            result.isNotEmpty
                ? result = classes
                : toastShow('No Test Schedule Found/Data Empty');
            isLoading = false;
          });
          Map<String, Object?> map = {
            'data': jsonEncode(classes),
          };
          await db.insert('time_table', map,
              conflictAlgorithm: ConflictAlgorithm.replace);
        }
      }
    } else {
      createTimeTable();
    }
  }

  // if local db is not created then create and update in it
  createTimeTable() async {
    // await db.execute('CREATE TABLE time_table (data TEXT NON NULL)');
    HttpRequest httpRequest = HttpRequest();
    var classes =
    await httpRequest.studentMonthlyTestSchedule(context, token!, sId!);
    if (classes == 500) {
      toastShow('Server Error!!! Try Again Later...');
      setState(() {
        isLoading = false;
      });
    } else {
      setState(() {
        var document = parse('$classes');

        result = document;

        isLoading = false;
      });
      /*  Map<String,Object?> map ={
        'data':jsonEncode(classes),
      };
      await db.insert('time_table',map,conflictAlgorithm:   ConflictAlgorithm.replace);*/
    }
  }

  // update existing local db
  Future<void> updateTimeTable() async {
    HttpRequest httpRequest = HttpRequest();
    var classes =
    await httpRequest.studentMonthlyTestSchedule(context, token!, sId!);
    print('result is $classes');
    if (classes == 500) {
      toastShow('Server Error!!! Try Again Later...');
      setState(() {
        isLoading = false;
      });
    } else {
      await db.execute('DELETE FROM time_table');
      setState(() {
        var document = parse('$classes');

        result.isNotEmpty
            ? result = document
            : toastShow('No Test Schedule Found/Data Empty');
        isLoading = false;
      });
      Map<String, Object?> map = {
        'data': jsonEncode(classes),
      };
      await db.insert('time_table', map,
          conflictAlgorithm: ConflictAlgorithm.replace);
    }
  }

  Future<bool> _onPopScope() async {
    SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
    return true;
  }

  Future<void> updateApp() async {
    setState(() {
      isLoading = true;
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
        isLoading = false;
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
          title: Text('Monthly Test Schedule'),
          systemOverlayStyle: SystemUiOverlayStyle.light,
        ),
        drawer: Drawers(
          logout: () async {
            // on signout remove all local db and shared preferences
            Navigator.pop(context);

            setState(() {
              isLoading = true;
            });
            HttpRequest request = HttpRequest();
            var res = await request.postSignOut(context, token!);
            /* await db.execute('DELETE FROM daily_diary ');
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
                isLoading = false;
              } else {
                isLoading = false;
                snackShow(context, 'Logout Failed');
              }
            });
          },
          sync: () async {
            Navigator.pop(context);
            await updateApp();
            Phoenix.rebirth(context);
          },
        ),
        body: isLoading
            ? Center(
          child: spinkit,
        )
            : SafeArea(
          child: BackgroundWidget(
            // refresher indicator use to swipe down refresh using this package
            childView: RefreshIndicator(
              onRefresh: updateTimeTable,
              child: Container(
                constraints: BoxConstraints(
                  minWidth: MediaQuery
                      .of(context)
                      .size
                      .width,
                  maxWidth: double.maxFinite,
                  maxHeight: double.maxFinite,
                ),
                child: HtmlWidgets(
                  responseHtml: result,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
