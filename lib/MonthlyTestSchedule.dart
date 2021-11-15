import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:sqflite/sqflite.dart';
import 'package:wsms/Background.dart';
import 'package:wsms/Constants.dart';
import 'package:wsms/HttpRequest.dart';
import 'package:wsms/Shared_Pref.dart';
import 'package:wsms/main.dart';

import 'NavigationDrawer.dart';

class MonthlyTestSchedule extends StatefulWidget {
  const MonthlyTestSchedule({Key? key}) : super(key: key);

  @override
  _MonthlyTestScheduleState createState() => _MonthlyTestScheduleState();
}

class _MonthlyTestScheduleState extends State<MonthlyTestSchedule> {
  var token = SharedPref.getUserToken(),sId = SharedPref.getStudentId();
  late var result = 'waiting...', newColor= SharedPref.getSchoolColor();
  late final db;
  bool isLoading = false;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    SystemChrome.setPreferredOrientations([DeviceOrientation.landscapeLeft]);
    isLoading = true;
    Future(()async{
      db= await database;
      getMonthlyTestSchedule(token!);
    });
  }


  void getMonthlyTestSchedule(String token) async {
    var value = await db.query('time_table');
    if(value.isNotEmpty){
      setState(() {
             result = jsonDecode(value[0]['data']);
        isLoading = false;
      });
    }else {
      HttpRequest httpRequest = HttpRequest();
      var classes = await httpRequest.studentMonthlyTestSchedule(context, token, sId!);
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
        Map<String,Object?> map ={
          'data':jsonEncode(classes),
        };
        await db.insert('time_table',map,conflictAlgorithm:   ConflictAlgorithm.replace);
      }
    }
  }

 Future<void>  updateTimeTable()async{
    HttpRequest httpRequest = HttpRequest();
    var classes = await httpRequest.studentMonthlyTestSchedule(context, token!, sId!);
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
      Map<String,Object?> map ={
        'data':jsonEncode(classes),
      };
      await db.insert('time_table',map,conflictAlgorithm:   ConflictAlgorithm.replace);
    }
  }

  Future<bool> _onPopScope() async {
    SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
    return true;
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
        drawer:  Drawers(),
        body: isLoading
            ? Center(
                child: spinkit,
              )
            : SafeArea(
                child: BackgroundWidget(
                  childView: RefreshIndicator(
                    onRefresh:updateTimeTable,

                    child: ListView(
                      children: [
                       Container(
                         constraints: BoxConstraints(
                           minWidth: MediaQuery.of(context).size.width,
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
              ),
      ),
    );
  }
}
