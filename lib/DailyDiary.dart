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

class _DailyDiaryState extends State<DailyDiary> {
  DateTime selectedDate = DateTime.now();
  var token = SharedPref.getUserToken();
  var sId = SharedPref.getStudentId();
  late var result, newColor =SharedPref.getSchoolColor(), document;
  bool isLoading = false;
  late final db;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    Future(() async {
      db = await database;
    });
    SystemChrome.setPreferredOrientations([DeviceOrientation.landscapeLeft]);
    isLoading = true;
    Timer(Duration(seconds: 2), () {
      getStudentDiary(token!);
    });
  }

  void getStudentDiary(String token) async {
    var value = await db.query('daily_diary');
    if (value.isNotEmpty) {
      setState(() {
        result = jsonDecode(value[0]['data']);
        isLoading = false;
      });
    } else {
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
  }

  void updateDiary() async {
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
            actions: <Widget>[
              Container(
                child: TextButton(
                  onPressed: () {
                    setState(() {
                      isLoading = true;

                      updateDiary();
                    });
                  },
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Flexible(
                        child: Text(
                          'Refresh',
                          style: TextStyle(
                            color: Colors.white,
                          ),
                        ),
                      ),
                      SizedBox(width: 3),
                      Icon(
                        CupertinoIcons.refresh_bold,
                        color: Colors.white,
                        size: 16.0,
                      ),
                      SizedBox(width: 8),
                    ],
                  ),
                ),
              ),
            ],
          ),
          drawer: Drawers(),
          body: isLoading
              ? Center(
                  child: spinkit,
                )
              : SafeArea(
                  child: BackgroundWidget(
                    childView: HtmlWidget(
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
        ));
  }
}
