import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
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

  getData() async {
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        systemOverlayStyle: SystemUiOverlayStyle.light,
        backgroundColor: Color(int.parse('$newColor')),
        title: Text('OnlineClass List'),
      ),
      drawer:  Drawers(result: (res){
        print('v $res ');
      },),
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
                                          setButtonColor(
                                              listSubject[index]['start'],
                                              listSubject[index]['end']),
                                        ),
                                      ),
                                      child: Text(
                                        setButtonText(
                                            listSubject[index]['start'],
                                            listSubject[index]['end']),
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 12.0,
                                        ),
                                      ),
                                      onPressed: compareTime(
                                              listSubject[index]['start'],
                                              listSubject[index]['end'])
                                          ? module(index)
                                              ? () {
                                                  Navigator.pushNamed(
                                                      context, '/jitsi_classes',
                                                      arguments: {
                                                        'subject_name':
                                                            '${listSubject[index]['subject_name']} class',
                                                      });
                                                }
                                              : () {
                                                  Navigator.pushNamed(context,
                                                      '/online_classes');
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
