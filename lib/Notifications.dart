import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
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
      getData();
    });
  }

  getData() async {
    if (compare[10]['name']=='notification') {
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
    await db.execute('CREATE TABLE notification (data TEXT NON NULL)');

    HttpRequest request = HttpRequest();
    var list = await request.getNotification(context, token!, tok!);
    if (list == 500) {
      toastShow('Server Error!!! Try Again Later...');
      setState(() {
        isLoading = false;
      });
    } else {

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

Future<void> updateNotifications()async{
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        systemOverlayStyle: SystemUiOverlayStyle.light,
        backgroundColor: Color(int.parse('$newColor')),
        title: Text('Notifications List'),
      ),
      drawer: Drawers(),
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
