import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:flutter_phoenix/flutter_phoenix.dart';
import 'package:intl/intl.dart';
import 'package:lottie/lottie.dart';
import 'package:sqflite/sqflite.dart';
import 'package:wsms/Background.dart';
import 'package:wsms/Constants.dart';
import 'package:wsms/HttpRequest.dart';
import 'package:wsms/NavigationDrawer.dart';
import 'package:wsms/Shared_Pref.dart';
import 'package:wsms/main.dart';

class Notifications extends StatefulWidget {
  @override
  _NotificationsState createState() => _NotificationsState();
}


class _NotificationsState extends State<Notifications> {
  var token = SharedPref.getUserToken();
  var tok = SharedPref.getStudentId();
  double progressValue = 35;
  List listSubject = [], compare = [];
  bool isLoading = false, isListEmpty = false;
  var newColor = SharedPref.getSchoolColor();
  late final db;

  @override
  void initState() {
    super.initState();
    isLoading = true;
    Future(() async {
      db = await database;
      (await db.query('sqlite_master', columns: ['type', 'name'])).forEach((row) {
        setState(() {
          compare.add(row);
        });
      });
      createNotifications();
    });
  }

  getData() async {
    if (compare[4]['name']=='notification') {
      var value = await db.query('notification');
      if (value.isNotEmpty) {
        setState(() {
          var res = jsonDecode(value[0]['data']);
          listSubject = res;
          isLoading = false;
        });
      } else {
        HttpRequest request = HttpRequest();
        var list = await request.getNotification(context, token!, tok!);
        if (list == 500) {
          toastShow('Server Error!!! Try Again Later...');
          setState(() {
            isLoading = false;
          });
        } else {
          await db.execute('DELETE  FROM  notification');

          setState(() {
            listSubject = list;
            listSubject.isNotEmpty ? isListEmpty = false : isListEmpty = true;

            isLoading = false;
          });
          Map<String, Object?> map = {
            'data': jsonEncode(list),
          };
          await db.insert('notification', map,
              conflictAlgorithm: ConflictAlgorithm.replace);
        }
      }
    } else {
      createNotifications();
    }
  }

  createNotifications()async{
 //   await db.execute('CREATE TABLE notification (data TEXT NON NULL)');

    HttpRequest request = HttpRequest();
    var list = await request.getNotification(context, token!, tok!);
    setState(() {

      if(list==null ||list.isEmpty){
        toastShow('Data record not found...');
        isLoading=false;
        isListEmpty=true;
      }else if (list.toString().contains('Error')){
        toastShow('$list...');
        isLoading=false;
      }else{
        listSubject=list;
        isLoading=false;
      }
    });
   /* if (list == 500) {
      toastShow('Server Error!!! Try Again Later...');
      setState(() {
        isLoading = false;
      });
    }
    else {

      setState(() {
        listSubject = list;
        listSubject.isNotEmpty ? isListEmpty = false : isListEmpty = true;

        isLoading = false;
      });
      *//*Map<String, Object?> map = {
        'data': jsonEncode(list),
      };
      await db.insert('notification', map,
          conflictAlgorithm: ConflictAlgorithm.replace);*//*
    }*/
  }

Future<void> updateNotifications()async{
  HttpRequest request = HttpRequest();
  var list = await request.getNotification(context, token!, tok!);

  setState(() {

    if(list==null ||list.isEmpty){
      toastShow('Data record not found...');
      isLoading=false;
      isListEmpty=true;
    }else if (list.toString().contains('Error')){
      toastShow('$list...');
      isLoading=false;
    }else{
      listSubject=list;
      isLoading=false;
    }
  });
  /*if (list == 500) {
    toastShow('Server Error!!! Try Again Later...');
    setState(() {
      isLoading = false;
    });
  }
  else {
    await db.execute('DELETE  FROM  notification');

    setState(() {
      listSubject = list;
      listSubject.isNotEmpty ? isListEmpty = false : isListEmpty = true;

      isLoading = false;
    });
    Map<String, Object?> map = {
      'data': jsonEncode(list),
    };
    await db.insert('notification', map,
        conflictAlgorithm: ConflictAlgorithm.replace);
  }*/
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
    return Scaffold(
      appBar: AppBar(
        systemOverlayStyle: SystemUiOverlayStyle.light,
        backgroundColor: Color(int.parse('$newColor')),
        title: Text('Notifications List'),
      ),
      /*drawer: Drawers(logout:  () async {
        // on signout remove all local db and shared preferences
        Navigator.pop(context);

        setState(() {
          isLoading=true;
        });
        HttpRequest request = HttpRequest();
        var res =
        await request.postSignOut(context, token!);
        *//* await db.execute('DELETE FROM daily_diary ');
        await db.execute('DELETE FROM profile ');
        await db.execute('DELETE FROM test_marks ');
        await db.execute('DELETE FROM subjects ');
        await db.execute('DELETE FROM monthly_exam_report ');
        await db.execute('DELETE FROM time_table ');
        await db.execute('DELETE FROM attendance ');*//*
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

      }, sync: () async {
        Navigator.pop(context);
        await updateApp();
        Phoenix.rebirth(context);
      },),*/
      body: SafeArea(
        child: BackgroundWidget(
          childView: Container(
            child: isLoading
                ? Center(child: spinkit)
                : isListEmpty
                    ? Container(
                        color: Colors.transparent,
                        child: Lottie.asset('assets/no_data.json',
                            repeat: true, reverse: true, animate: true),
                      )
                    : Container(
                        margin: EdgeInsets.symmetric(
                            vertical: 8.0, horizontal: 4.0),
                        child: RefreshIndicator(
                          onRefresh: updateNotifications,
                          child: ListView.builder(
                            itemBuilder: (context, index) {
                              return Card(
                                color: Color(int.parse('$newColor')),
                                elevation: 4.0,
                                child: ListTile(
                                  title: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Expanded(
                                        child: Text(
                                          ' ${listSubject[index]['title']}',
                                          style: TextStyle(
                                            color: Colors.orangeAccent,
                                            fontSize: 16.0,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ),
                                      Expanded(
                                        child: Text(
                                          'Date: ${listSubject[index]['created_at']}',
                                          textAlign: TextAlign.end,
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 11.0,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                  subtitle: Container(
                                    margin: EdgeInsets.only(top: 12.0),
                                    child: Text(
                                      ' ${listSubject[index]['body']}',
                                      textAlign: TextAlign.justify,
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 11.0,
                                        fontWeight: FontWeight.normal,
                                      ),
                                    ),
                                  ),
                                ),
                              );
                            },
                            itemCount: listSubject.length,
                          ),
                        ),
                      ),
          ),
        ),
      ),
    );
  }

  setTime(time) {
    var set = DateFormat.jm().format(DateFormat("hh:mm").parse("$time"));
    return set;
  }

  setButtonColor(starts, ends) {
    if (compareTime(starts, ends)) {
      return Colors.redAccent;
    }
    return Colors.grey;
  }

  setButtonText(starts, ends) {
    if (compareTime(starts, ends)) {
      return 'Join Class';
    }
    return 'Wait/End Class';
  }

  compareTime(starts, ends) {
    var start = "$starts".split(":");
    var end = "$ends".split(":");

    DateTime currentDateTime = DateTime.now();

    DateTime initDateTime = DateTime(
        currentDateTime.year, currentDateTime.month, currentDateTime.day);

    var startDate = (initDateTime.add(Duration(hours: int.parse(start[0]))))
        .add(Duration(minutes: int.parse(start[1])));
    var endDate = (initDateTime.add(Duration(hours: int.parse(end[0]))))
        .add(Duration(minutes: int.parse(end[1])));

    if (currentDateTime.isBefore(endDate) &&
        currentDateTime.isAfter(startDate)) {
      print("CURRENT datetime is between START and END datetime");
      return true;
    } else {
      print("NOT BETWEEN");
      return false;
    }
  }
}
