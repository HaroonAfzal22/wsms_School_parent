import 'dart:async';
import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_widget_from_html/flutter_widget_from_html.dart';
import 'package:html/parser.dart';
import 'package:sqflite/sqlite_api.dart';
import 'package:wsms/Background.dart';
import 'package:wsms/Constants.dart';
import 'package:wsms/HttpRequest.dart';
import 'package:wsms/NavigationDrawer.dart';
import 'package:wsms/Shared_Pref.dart';
import 'package:wsms/main.dart';

class DailyDiary extends StatefulWidget {
  const DailyDiary({Key? key}) : super(key: key);

  @override
  _DailyDiaryState createState() => _DailyDiaryState();
}


// ot get daily diary of students in html form
class _DailyDiaryState extends State<DailyDiary> {
  var token = SharedPref.getUserToken(), sId = SharedPref.getStudentId();
  late var result, newColor =SharedPref.getSchoolColor(), document;
  bool isLoading = false;
  late final db;// to get instance of local databsae
  List compare=[];
  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    // to initialize local db
    Future(() async {
      db = await database;
      (await db.query('sqlite_master', columns: ['type', 'name'])).forEach((row) {
        setState(() {
          compare.add(row);
        });
      });
      getStudentDiary(token!);
    });
    SystemChrome.setPreferredOrientations([DeviceOrientation.landscapeLeft]);
    isLoading = true;

  }
// to get student diary from api
  void getStudentDiary(String token) async {
    if(compare[7]['name']=='daily_diary') {
      var value = await db.query('daily_diary');
      if (value.isNotEmpty) {
        setState(() {
          result = jsonDecode(value[0]['data']);
          isLoading = false;
        });
      }
      else {
        HttpRequest httpRequest = HttpRequest();
        var classes = await httpRequest.studentDailyDiary(context, token, sId!);
        if (classes == 500) {
          toastShow('Server Error!!! Try Again Later ...');
          setState(() {
            isLoading = false;
          });
        } else {
          await db.execute('DELETE  FROM  daily_diary');
          setState(() {
            document = parse('$classes');
            classes.isNotEmpty
                ? result = document.outerHtml
                : toastShow('No Homework Found');
            isLoading = false;
          });
          Map<String, Object?> map = {
            'data': jsonEncode(result),
          };
          await db.insert('daily_diary', map,
              conflictAlgorithm: ConflictAlgorithm.replace);
        }
      }
    }else{
      createDiary();
    }
  }

  //for local db in not create then it created the local db then implement it
  createDiary()async{
    await db.execute('CREATE TABLE daily_diary (data TEXT NON NULL)');

    HttpRequest httpRequest = HttpRequest();
    var classes = await httpRequest.studentDailyDiary(context, token!, sId!);

    if (classes == 500) {
      toastShow('Server Error!!! Try Again Later...');
      setState(() {
        isLoading = false;
      });
    } else {
      setState(() {
        document = parse('$classes');
        classes.isNotEmpty
            ? result = document.outerHtml
            : toastShow('No Homework Found');
        isLoading = false;
      });
      Map<String, Object?> map = {
        'data': jsonEncode(result),
      };
      await db.insert('daily_diary', map,
          conflictAlgorithm: ConflictAlgorithm.replace);
    }
  }

  //for swipe down refresh api called to get latest data
  Future<void> updateDiary() async {
    HttpRequest httpRequest = HttpRequest();
    var classes = await httpRequest.studentDailyDiary(context, token!, sId!);

    if (classes == 500) {
      toastShow('Server Error!!! Try Again Later...');
      setState(() {
        isLoading = false;
      });
    } else {
      await db.execute('DELETE  FROM  daily_diary');
      setState(() {
        document = parse('$classes');
        classes.isNotEmpty
            ? result = document.outerHtml
            : toastShow('No Homework Found');
        isLoading = false;
      });
      Map<String, Object?> map = {
        'data': jsonEncode(result),
      };
      await db.insert('daily_diary', map,
          conflictAlgorithm: ConflictAlgorithm.replace);
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
            title: Text('Daily Diary'),
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
                      onRefresh:updateDiary,
                      child: HtmlWidget(
                        '$result',
                        customStylesBuilder: (element) {
                          if (element.id == ('homework-table')) {
                            return {
                              'color': '#${newColor!.substring(newColor!.length - 6)}',
                              'text-align': 'center',
                              'font-weight': 'bold',
                              'font-size': '16px',
                              'padding': '12px',
                              'align': 'center'
                            };
                          }
                          if (element.localName == 'th') {
                            return {
                              'color': '#ffffff',
                              'font-weight': 'bold',
                              'background-color': '#${newColor!.substring(newColor!.length - 6)}',
                              'font-size': '20px',
                              'text-align': 'center',
                              'padding': '8px',
                              'valign': 'center',
                              'Sizing': '${MediaQuery.of(context).size.width}px'
                            };
                          }
                          if (element.localName == 'td') {
                            return {
                              'color': '#ffffff',
                              'background-color': '#${newColor!.substring(newColor!.length - 6)}',
                              'font-size': '15px',
                              'text-align': 'center',
                              'padding': '8px',
                            };
                          }

                          return null;
                        },
                        onErrorBuilder: (context, element, error) =>
                            Text('$element error: $error'),
                        onLoadingBuilder: (context, element, loadingProgress) =>
                            CircularProgressIndicator(),
                        renderMode: RenderMode.listView,
                        textStyle: TextStyle(
                          fontSize: 15,
                        ),
                      ),
                    ),
                  ),
                ),
        ));
  }
}
