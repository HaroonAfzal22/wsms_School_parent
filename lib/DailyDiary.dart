import 'dart:async';
import 'dart:convert';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_phoenix/flutter_phoenix.dart';
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
  late var result, listSubject = [], newColor = SharedPref.getSchoolColor();
  bool isLoading = false;
  late final db; // to get instance of local databsae
  List compare = [];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    isLoading = true;

    // to initialize local db
    Future(() async {
      db = await database;
      (await db.query('sqlite_master', columns: ['type', 'name']))
          .forEach((row) {
        setState(() {
          compare.add(row);
        });
      });
      createDiary();
    });
  }

// to get student diary from api
  void getStudentDiary(String token) async {
    if (compare[7]['name'] == 'daily_diary') {
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
            /*  document = parse('$classes');
            classes.isNotEmpty
                ? result = document.outerHtml
                : toastShow('No Homework Found');*/
            isLoading = false;
          });
          Map<String, Object?> map = {
            'data': jsonEncode(result),
          };
          await db.insert('daily_diary', map,
              conflictAlgorithm: ConflictAlgorithm.replace);
        }
      }
    } else {
      createDiary();
    }
  }

  //for local db in not create then it created the local db then implement it
  createDiary() async {
    //  await db.execute('CREATE TABLE daily_diary (data TEXT NON NULL)');

    HttpRequest httpRequest = HttpRequest();
    var classes = await httpRequest.studentDailyDiary(context, token!, sId!);
    if (classes == 500) {
      toastShow('Server Error!!! Try Again Later...');
      setState(() {
        isLoading = false;
      });
    } else {
      setState(() {
        listSubject = classes.toList();
        /*document = parse('$classes');
        classes.isNotEmpty
            ? result = document.outerHtml
            : toastShow('No Homework Found');*/
        isLoading = false;
      });
      /*Map<String, Object?> map = {
        'data': jsonEncode(result),
      };
      await db.insert('daily_diary', map,
          conflictAlgorithm: ConflictAlgorithm.replace);*/
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
        /*  document = parse('$classes');
        classes.isNotEmpty
            ? result = document.outerHtml
            : toastShow('No Homework Found');*/
        isLoading = false;
      });
      Map<String, Object?> map = {
        'data': jsonEncode(result),
      };
      await db.insert('daily_diary', map,
          conflictAlgorithm: ConflictAlgorithm.replace);
    }
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
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(int.parse('$newColor')),
        title: Text('Daily Diary'),
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
                childView: ListView(
                  children: [
                    Visibility(
                      visible: listSubject[0]['image'].toString().isNotEmpty
                          ? true
                          : false,
                      child: Stack(
                        children: [
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 8.0),
                            child: onlineClassTextField(
                              initValue(listSubject[0]['image'].toString()),
                              (value) {},
                              '$newColor',
                              true,
                            ),
                          ),
                          Positioned(
                            right: MediaQuery.of(context).size.width / 18,
                            top: 8.0,
                            child: Container(
                              child: IconButton(
                                onPressed: () {
                                  _settingModalBottomSheet(listSubject[0]['image'].toString(),context);
                                },
                                icon: Icon(
                                  CupertinoIcons.arrow_down_doc_fill,
                                  color: Color(int.parse('$newColor')),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      child: ListView.builder(
                        physics: ScrollPhysics(),
                        shrinkWrap: true,
                        itemBuilder: (context, index) {
                          return Card(
                            color: Color(int.parse('$newColor')),
                            margin: EdgeInsets.only(
                                bottom: 8.0, top: 4.0, right: 10.0, left: 10.0),
                            elevation: 4.0,
                            child: ListTile(
                              title: Text(
                                '${listSubject[index]['subject_name']}',
                                style: TextStyle(
                                  color: Colors.orangeAccent,
                                  fontSize: 20.0,
                                  fontWeight: FontWeight.w500,
                                ),
                                textAlign: TextAlign.center,
                              ),
                              subtitle: Container(
                                width: 101,
                                child: Row(
                                  children: [
                                    Flexible(
                                      child: Text(
                                        '${listSubject[index]['diary']}',
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 12.0,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          );
                        },
                        itemCount: listSubject.length,
                      ),
                    ),
                  ],
                ),
              ),
            ),
    );
  }

  String initValue(images) {
    if (images == null) {
      return 'No Image Captured..';
    } else
      return 'Diary image view here ->';
  }

  void _settingModalBottomSheet(image,context) {
    showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(top: Radius.circular(25))),
        builder: (BuildContext bc) => Container(
          margin: EdgeInsets.only(bottom: 4.0),
          decoration: BoxDecoration(
                  borderRadius:
                      BorderRadius.vertical(top: Radius.circular(25))),
              child: ClipRRect(
                borderRadius:BorderRadius.circular(25.0),
                child: Image.network(
                  '$image',
                  loadingBuilder: (context, child, progress) {
                    return progress == null
                        ? child
                        : LinearProgressIndicator(
                            color: Color(int.parse('$newColor')),
                          );
                  },
                ),
              ),
            ));
  }
}
