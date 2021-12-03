import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:flutter_phoenix/flutter_phoenix.dart';
import 'package:intl/intl.dart';
import 'package:lottie/lottie.dart';
import 'package:wsms/Background.dart';
import 'package:wsms/Constants.dart';
import 'package:wsms/HttpRequest.dart';
import 'package:wsms/NavigationDrawer.dart';
import 'package:wsms/Shared_Pref.dart';

class OnlineClassList extends StatefulWidget {
  @override
  _OnlineClassListState createState() => _OnlineClassListState();
}

class _OnlineClassListState extends State<OnlineClassList> {
  var token = SharedPref.getUserToken();
  var tok = SharedPref.getStudentId();
  double progressValue = 35;
  List listSubject = [];
  bool isLoading = false, isListEmpty = false;
  var newColor = SharedPref.getSchoolColor();

  @override
  void initState() {
    super.initState();
    isLoading = true;
    getData();
  }

  Future<void> getData() async {
    HttpRequest request = HttpRequest();
    var list = await request.getOnlineClass(context, token!, tok!);
    if (list == 500) {
      toastShow('Server Error!!! Try Again Later...');
      setState(() {
        isLoading = false;
      });
    } else {
      setState(() {
        listSubject = list;
        print('list $list');
        listSubject.isNotEmpty ? isListEmpty = false : isListEmpty = true;
        isLoading = false;
      });
    }
  }

  module(index) {
    if (listSubject[index]['module'] == 'jitsi') {
      return true;
    }
    return false;
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
        systemOverlayStyle: SystemUiOverlayStyle.light,
        backgroundColor: Color(int.parse('$newColor')),
        title: Text('OnlineClass List'),
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
                          onRefresh: getData,
                          child: ListView.builder(
                            itemBuilder: (context, index) {
                              return Card(
                                color: Color(int.parse('$newColor')),
                                elevation: 4.0,
                                child: InkWell(
                                  child: ListTile(
                                    title: Padding(
                                      padding: EdgeInsets.only(left: 75.0),
                                      child: Text(
                                        '${listSubject[index]['subject_name']}',
                                        style: TextStyle(
                                          color: Colors.orangeAccent,
                                          fontSize: 24.0,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                    trailing: Container(
                                      child: ElevatedButton(
                                        style: ButtonStyle(
                                          backgroundColor:
                                              MaterialStateProperty.all(
                                            listSubject[index]['is_time'] == false
                                                ? Colors.grey
                                                : Colors.redAccent,
                                          ),
                                        ),
                                        child: Text(
                                          '${listSubject[index]['is_time'] == true ? 'Join Class' : 'Wait/End Class'}',
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 12.0,
                                          ),
                                        ),
                                        onPressed:
                                        listSubject[index]['is_time']==true ?
                                        module(index) ? () {
                                                    Navigator.pushNamed(context,
                                                        '/jitsi_classes',
                                                        arguments: {
                                                          'subject_name':
                                                              '${listSubject[index]['subject_name']} class',
                                                          'meeting_id':
                                                              '${listSubject[index]['meeting_id']}',
                                                        });
                                                  } : () {
                                                    Navigator.pushNamed(context,
                                                        '/online_classes',
                                                        arguments: {
                                                          'password':
                                                              '${listSubject[index]['password']}',
                                                          'meeting_id':
                                                              '${listSubject[index]['meeting_id']}',
                                                        });
                                                  }
                                            : null,
                                      ),
                                    ),
                                    subtitle: Container(
                                      width: 150,
                                      margin: EdgeInsets.only(top: 12.0),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Expanded(
                                            child: Text(
                                              'Start: ${setTime(listSubject[index]['start'])}',
                                              style: TextStyle(
                                                color: Colors.white,
                                                fontSize: 14.0,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                          ),
                                          Expanded(
                                            child: Text(
                                              'End: ${setTime(listSubject[index]['end'])}',
                                              style: TextStyle(
                                                color: Colors.white,
                                                fontSize: 14.0,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                  onTap: () async {
                                    setState(() {
                                      isLoading = false;
                                    });
                                  },
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
    var set = DateFormat.jm().format(DateFormat("HH:mm").parse("$time"));
    return set;
  }
  /*
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
      return true;
    } else {
      return false;
    }
  }*/
}
