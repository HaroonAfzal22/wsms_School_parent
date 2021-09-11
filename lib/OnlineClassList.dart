import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:intl/intl.dart';
import 'package:syncfusion_flutter_gauges/gauges.dart';
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
  bool isLoading = false;
  late var newColor;

  @override
  void initState() {
    super.initState();
    isLoading = true;
    newColor = getSchoolColor();
    getData();
  }

  getData() async {
    HttpRequest request = HttpRequest();
    List list = await request.getOnlineClass(context, token!, tok!);
    setState(() {
      listSubject = list;
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    statusColor(newColor);
    return Scaffold(
      appBar: AppBar(
        brightness: Brightness.dark,
        backgroundColor: Color(int.parse('$newColor')),
        title: Text('OnlineClass List'),
      ),
      drawer: Drawers(
        complaint: null,
        aboutUs: null,
        PTM: null,
        dashboards: () {
          Navigator.pushReplacementNamed(context, '/dashboard');
        },
        Leave: null,
        onPress: () {
          setState(() {
            SharedPref.removeData();
            Navigator.pushReplacementNamed(context, '/');
            toastShow("Logout Successfully");
          });
        },
      ),
      body: SafeArea(
        child: BackgroundWidget(
          childView: Container(
            child: isLoading
                ? Center(child: spinkit)
                : Container(
                    margin:
                        EdgeInsets.symmetric(vertical: 8.0, horizontal: 4.0),
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
                                    backgroundColor: MaterialStateProperty.all(
                                      Colors.redAccent,
                                    ),
                                  ),
                                  child: Text(
                                    'Join Class',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 12.0,
                                    ),
                                  ),
                                  onPressed: () {},
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
                              /*  if (arg['card_type'] == 'subject') {
                                Navigator.pushNamed(context, '/subject_details');
                                var subId = '${listSubject[index]['id']}';
                                await SharedPref.setSubjectId(subId);
                              }
                              else {
                                Navigator.pushNamed(context, '/subject_result');
                                var subId = '${listSubject[index]['id']}';
                                await SharedPref.setSubjectId(subId);
                              }*/
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
  compareTime(start,end){

  }
}
