import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:lottie/lottie.dart';
import 'package:sqflite/sqflite.dart';
import 'package:syncfusion_flutter_gauges/gauges.dart';
import 'package:wsms/Background.dart';
import 'package:wsms/Constants.dart';
import 'package:wsms/HttpRequest.dart';
import 'package:wsms/NavigationDrawer.dart';
import 'package:wsms/Shared_Pref.dart';
import 'package:wsms/main.dart';

class Subjects extends StatefulWidget {
  @override
  _SubjectsState createState() => _SubjectsState();
}

class _SubjectsState extends State<Subjects> {
  var token = SharedPref.getUserToken();
  var tok = SharedPref.getStudentId();
  double progressValue = 35;
  List listSubject = [];
  bool isLoading = false, isListEmpty = false;
  var newColor = SharedPref.getSchoolColor();
  late final db;

  @override
  void initState() {
    super.initState();

    isLoading = true;
    Future(() async {
      db = await database;
      getData();
    });
  }

  getData() async {
    var value = await db.query('subjects');
    if (value.isNotEmpty) {
      setState(() {
        listSubject = jsonDecode(value[0]['data']);
        isLoading = false;
      });
    } else {
      HttpRequest request = HttpRequest();
      var list = await request.getSubjectsList(context, token!, tok!);
      if (list == 500) {
        toastShow('Server Error!!! Try Again Later ...');
        setState(() {
          isLoading = false;
        });
      } else {
        await db.execute('DELETE  FROM  subjects');

        setState(() {
          listSubject = list;
          isLoading = false;
        });

        Map<String, Object?> map = {
          'data': jsonEncode(listSubject),
        };
        await db.insert('subjects', map,
            conflictAlgorithm: ConflictAlgorithm.replace);
      }
    }
  }

  Future<void> updateSubject() async {
    HttpRequest request = HttpRequest();
    var list = await request.getSubjectsList(context, token!, tok!);
    if (list == 500) {
      toastShow('Server Error!!! Try Again Later ...');
      setState(() {
        isLoading = false;
      });
    } else {
      await db.execute('DELETE  FROM  subjects');
      setState(() {
        listSubject = list;
        isLoading = false;
      });

      Map<String, Object?> map = {
        'data': jsonEncode(listSubject),
      };
      await db.insert('subjects', map,
          conflictAlgorithm: ConflictAlgorithm.replace);
    }
  }

  @override
  Widget build(BuildContext context) {
    final arg = ModalRoute.of(context)!.settings.arguments as Map;
    return Scaffold(
      appBar: AppBar(
        systemOverlayStyle: SystemUiOverlayStyle.light,
        backgroundColor: Color(int.parse('$newColor')),
        title: Text('Subjects List'),
      ),
      drawer: Drawers(),
      body: SafeArea(
        child: BackgroundWidget(
          childView: isLoading
              ? Center(child: spinkit)
              : isListEmpty
                  ? Container(
                      color: Colors.transparent,
                      child: Lottie.asset('assets/no_data.json',
                          repeat: true, reverse: true, animate: true),
                    )
                  : RefreshIndicator(
                      onRefresh: updateSubject,
                      child: ListView.builder(
                        itemExtent: 70.0,
                        itemBuilder: (context, index) {
                          return InkWell(
                            onTap: () async {
                              setState(() {
                                isLoading = false;
                              });
                              if (arg['card_type'] == 'subject') {
                                Navigator.pushNamed(
                                    context, '/subject_details');
                                var subId = '${listSubject[index]['id']}';
                                await SharedPref.setSubjectId(subId);
                              } else {
                                Navigator.pushNamed(context, '/subject_result');
                                var subId = '${listSubject[index]['id']}';
                                await SharedPref.setSubjectId(subId);
                              }
                            },
                            child: Card(
                              color: Color(int.parse('$newColor')),
                              margin: EdgeInsets.symmetric(
                                  vertical: 4.0, horizontal: 10.0),
                              elevation: 4.0,
                              child: ListTile(
                                title: Text(
                                  '${listSubject[index]['subject_name']}',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 20.0,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                                trailing: Container(
                                  width: 101,
                                  child: Row(
                                    children: [
                                      Flexible(
                                        child: Text(
                                          'Avg Marks:',
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 12.0,
                                          ),
                                        ),
                                      ),
                                      Flexible(
                                        child: Container(
                                          width: 50,
                                          height: 80,
                                          padding: EdgeInsets.zero,
                                          child: sfRadialGauges(
                                              '${listSubject[index]['percentage']}'),
                                        ),
                                      ),
                                    ],
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
    );
  }
}
